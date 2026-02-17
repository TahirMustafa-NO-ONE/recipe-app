import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/user_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserState>().currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Custom back action
          },
        ),
        title: const Text("MOREAT  🍽️", style: TextStyle(fontFamily: 'Pacifico', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
        backgroundColor: const Color.fromARGB(255, 255, 64, 129),
      ),
      body: currentUser != null
          ? _buildUserProfile(currentUser)
          : _buildLoggedOutContent(context),
    );
  }

  // Display user profile information
  Widget _buildUserProfile(User currentUser) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Section
          CircleAvatar(
            radius: 70,
            backgroundImage: currentUser.photoURL != null
                ? NetworkImage(currentUser.photoURL!)
                : const AssetImage('assets/new_logo_3.png') as ImageProvider,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          Text(
            currentUser.displayName ?? "User Name",
            style: const TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentUser.email ?? "Email",
            style: const TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const Divider(height: 30, thickness: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 255, 64, 129)),
            title: const Text(
              "Logout",
              style: TextStyle(color: Color.fromARGB(255, 255, 64, 129)),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
          const Divider(height: 30, thickness: 1),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'bmi');
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_home1.jpeg'), // Your image asset
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color.fromARGB(255, 255, 64, 129),
                  width: 3,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Button text and underline
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Calculate your BMI!', // Button title
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          width: 180,
                          height: 3,
                          color: Color.fromARGB(255, 255, 64, 129), // Pink underline
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Content displayed when the user is not logged in
  Widget _buildLoggedOutContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "You are not logged in.",
            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login'); // Navigate to login screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 64, 129),
            ),
            child: const Text("Log In", style: TextStyle(fontFamily: 'Ubuntu',color: Colors.white)),
          ),
        ],
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 255, 64, 129)),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                // UserState will automatically update on sign out
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Color.fromARGB(255, 255, 64, 129)),
              ),
            ),
          ],
        );
      },
    );
  }
}
