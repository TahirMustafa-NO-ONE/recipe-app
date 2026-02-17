import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // For accessing UserState
import '../services/user_state.dart'; // For Firebase authentication
import 'bottomnav.dart';
import 'list.dart';
import 'home1.dart';
import 'shoppingList.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default to Home
  User? _currentUser;

  // Screens for navigation
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _screens = [
    ListScreen(), // Your List screen
    RecipeScreen(), // Your Recipe screen
    Shoppinglist(), // Your BMI screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Check if the user is logged in
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Get the current user when the screen is loaded
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserState>().currentUser;
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
