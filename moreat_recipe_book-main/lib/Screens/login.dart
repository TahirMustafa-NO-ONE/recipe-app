import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/authent.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // Tracks loading state

  Future<void> userLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, 'settingPage'); // Navigate to Home screen
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No User Found for that Email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong Password Provided by User";
      } else {
        message = "An error occurred. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: e.code == 'user-not-found' || e.code == 'wrong-password'
              ? const Color(0xFFF6DBB9)
              : Colors.redAccent,
          content: Text(
            message,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
  Future<void> signwithGoogle() async {
    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      await AuthMethods().signInWithGoogle(context);
    } catch (error) {
      // Handle any potential errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in failed. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
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
                image: AssetImage('assets/new_bg_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent[200],
                    ),
                  ),
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email TextFormField
                        _buildTextFormField(
                          controller: emailController,
                          hintText: 'Email',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '   Please enter your email';
                            } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return '   Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password TextFormField
                        _buildTextFormField(
                          controller: passwordController,
                          hintText: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '   Please enter your password';
                            } else if (value.length < 6) {
                              return '   Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'forgotpass');
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign in Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          userLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.pinkAccent[200],
                        shadowColor: Colors.pinkAccent.withOpacity(0.5),
                        elevation: 10,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Sign in', style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white)),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(fontFamily: 'Ubuntu', color: Colors.black)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'register');
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Color.fromARGB(255, 255, 64, 129),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 255, 64, 129),
                    thickness: 2.0,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(height: 10),
                  Center(child: _buildGoogleSignInButton()),
                ],
              ),
            ),
          ),
          // Back Arrow
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
          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.pinkAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
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


  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTap: () {
        signwithGoogle();
      },
      child: Column(
        children: [
          const Text("Sign with Google!!!", style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16)),
          const FaIcon(
            FontAwesomeIcons.google,
            color: Color.fromARGB(255, 255, 64, 129),
            size: 35,
          ),
        ],
      ),
    );
  }
}
