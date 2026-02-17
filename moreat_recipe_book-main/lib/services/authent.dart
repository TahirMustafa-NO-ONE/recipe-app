import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../Screens/settingPage.dart';
import 'DBmethod.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Ensure the user is signed out of Google before initiating a new sign-in
      await googleSignIn.signOut();

      // Step 1: Trigger the Google sign-in flow
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Google Sign-In canceled"),
        ));
        return;
      }

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      // Step 3: Create Firebase credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      // Step 4: Sign in with Firebase using the credentials
      UserCredential result = await firebaseAuth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        // Step 5: Save user information in Firestore (optional)
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid
        };
        await DatabaseMethods().addUser(userDetails.uid, userInfoMap).then((value) {
          // Navigate to home screen after successful sign-in
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        });
      } else {
        // If userDetails is null, show error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to sign in with Google"),
        ));
      }
    } catch (e) {
      // Catch any errors during the sign-in process
      print("Error during Google Sign-In: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error during Google Sign-In: $e"),
      ));
    }
  }
}
