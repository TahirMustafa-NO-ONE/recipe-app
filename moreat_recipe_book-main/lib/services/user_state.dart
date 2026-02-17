import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Constructor to initialize the current user based on FirebaseAuth state
  UserState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();  // Notify listeners when the user state changes
    });
  }

  Future<void> setCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners(); // Update listeners when the current user is set
  }
}
