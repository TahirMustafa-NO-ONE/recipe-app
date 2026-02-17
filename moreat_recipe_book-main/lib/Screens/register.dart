import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/DBmethod.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  String email = "",
      password = "",
      name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // To track loading state

  bool _validateForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      return true;
    }
    return false;
  }

  Future<void> _saveUserToFirestore(User user) async {
    try {
      Map<String, dynamic> userInfoMap = {
        "email": user.email,
        "name": user.displayName,
        "imgUrl": user.photoURL ?? '',
        "id": user.uid
      };

      await DatabaseMethods().addUser(user.uid, userInfoMap);
    } catch (e) {
      print(e.toString()); // Handle any errors here
    }
  }

  Future<void> registration() async {
    if (passwordcontroller.text.isNotEmpty &&
        namecontroller.text.isNotEmpty &&
        emailcontroller.text.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailcontroller.text, password: passwordcontroller.text);

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Update user display name
          await user.updateProfile(displayName: namecontroller.text);
          await user.reload(); // Reload user to reflect updated info
          user = FirebaseAuth.instance.currentUser;

          // Save user info to Firestore
          await _saveUserToFirestore(user!);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 20.0),
              )));

          Navigator.pushNamed(context, 'settingPage');
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "";
        if (e.code == 'weak-password') {
          errorMessage = "Password Provided is too Weak";
        } else if (e.code == "email-already-in-use") {
          errorMessage = "Account Already exists";
        } else {
          errorMessage = "Something went wrong. Please try again.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF6DBB9),
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF6DBB9),
          content: Text(
            "Please fill in all fields",
            style: TextStyle(fontSize: 18.0),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/new_bg_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 56,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 64, 129),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: namecontroller,
                      icon: Icons.person,
                      hintText: 'Username',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '   Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailcontroller,
                      icon: Icons.email,
                      hintText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '   Please enter your email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return '   Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: passwordcontroller,
                      icon: Icons.lock,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '   Please enter your password';
                        } else if (value.length < 6) {
                          return '   Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: confirmPasswordcontroller,
                      icon: Icons.lock,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '   Please confirm your password';
                        } else if (value != passwordcontroller.text) {
                          return '   Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_validateForm()) {
                            registration();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Color.fromARGB(255, 255, 64, 129),
                          shadowColor: Colors.pinkAccent.withOpacity(0.5),
                          elevation: 10,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontFamily: 'Ubuntu', color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color: Color.fromARGB(255, 255, 64, 129),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ),
            ),
          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Color.fromARGB(255, 255, 64, 129),
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,  // The obscureText will be set only for password fields
    String? Function(String?)? validator,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 241, 177, 233),
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(0, 5.0),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,  // Apply only to password fields
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.only(top: 10),
              border: InputBorder.none,
              suffixIcon: (hintText == 'Password' || hintText == 'Confirm Password')
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
                  : null,  // No eye icon for other fields
            ),
            validator: validator,
          ),
        );
      },
    );
  }

}
