import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add user information to Firestore
  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    try {
      // Save user information in the "users" collection using the userId as the document ID
      await _firestore.collection('users').doc(userId).set(userInfoMap);
      print("User information added to Firestore successfully.");
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }
}
