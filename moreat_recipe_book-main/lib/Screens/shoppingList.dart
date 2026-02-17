import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/user_state.dart';

class Shoppinglist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<UserState>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.displayName ?? "Guest",
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Shopping List",
              style: TextStyle(
                fontFamily: 'Ubuntu',
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 64, 129), // Pink color
      ),
      body: user == null
          ? _buildNotLoggedInMessage(context)
          : _buildShoppingList(context, user), // Build the shopping list for the logged-in user
    );
  }

  Widget _buildNotLoggedInMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You are not logged in!",
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'login'); // Replace with your login page route
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 64, 129),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Text(
                "Login Now",
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingList(BuildContext context, User user) {
    final String userId = user.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user_shopping_list')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 64, 129),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildEmptyListMessage();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final ingredients = List<String>.from(data['ingredients'] ?? []);

        if (ingredients.isEmpty) {
          return _buildEmptyListMessage();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: ingredients.length + 1, // Include extra item for the SizedBox
          itemBuilder: (context, index) {
            if (index == ingredients.length) {
              // Add a SizedBox as the last item
              return const SizedBox(height: 70); // Adjust height as needed
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.arrow_right_alt_rounded),
                title: Text(
                  ingredients[index],
                  style: const TextStyle(fontFamily: 'Ubuntu', fontSize: 16),
                ),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.deleteLeft, color: Color.fromARGB(255, 255, 64, 129)),
                  onPressed: () =>
                      _removeFromShoppingList(userId, ingredients[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyListMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.shoppingBag,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "Your shopping list is empty.",
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFromShoppingList(String userId, String ingredient) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_shopping_list')
          .doc(userId)
          .update({
        'ingredients': FieldValue.arrayRemove([ingredient]),
      });
      print('Removed from shopping list: $ingredient');
    } catch (e) {
      print('Error removing ingredient: $e');
    }
  }
}
