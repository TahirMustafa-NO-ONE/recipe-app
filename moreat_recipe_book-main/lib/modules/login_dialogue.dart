import 'package:flutter/material.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Login Required", style: TextStyle(fontFamily: 'Ubuntu')),
        content: const Text("You must be logged in to perform this action.", style: TextStyle(fontFamily: 'Ubuntu')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 255, 64, 129)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, 'login'); // Navigate to the login page
            },
            child: const Text(
              "Log In",
              style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 255, 64, 129)),
            ),
          ),
        ],
      );
    },
  );
}
