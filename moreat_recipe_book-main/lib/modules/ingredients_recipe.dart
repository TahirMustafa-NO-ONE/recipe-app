import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_state.dart';
import 'login_dialogue.dart';

class IngredientsSection extends StatefulWidget {
  final List<dynamic> ingredients;

  IngredientsSection({required this.ingredients});

  @override
  _IngredientsSectionState createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {
  final Set<String> _addedIngredients = {}; // Track added ingredients

  Future<void> _addToShoppingList(String ingredient, dynamic currentUser) async {
    try {
      final userId = currentUser?.uid; // Assuming you have a user ID in `currentUser`

      if (userId != null) {
        // Add to Firestore
        await FirebaseFirestore.instance
            .collection('user_shopping_list')
            .doc(userId)
            .set({
          'ingredients': FieldValue.arrayUnion([ingredient]),
          'userId': userId,
        }, SetOptions(merge: true));

        setState(() {
          _addedIngredients.add(ingredient); // Update UI for toggle
        });
        print('Added to shopping list: $ingredient');
      }
    } catch (e) {
      print('Error adding to shopping list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final currentUser = userState.currentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Section
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 64, 129),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Ingredients List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: List.generate(widget.ingredients.length, (index) {
                  final ingredient = widget.ingredients[index];
                  return _buildIngredientRow(
                    context,
                    currentUser,
                    index + 1,
                    ingredient['original'],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientRow(
      BuildContext context, dynamic currentUser, int number, String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Numbering
          Text(
            '$number.',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 64, 129),
            ),
          ),
          SizedBox(width: 10),
          // Ingredient Name
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          // "Add to Shopping List" Icon
          IconButton(
            icon: Icon(
              _addedIngredients.contains(ingredient)
                  ? Icons.check_circle
                  : Icons.add_shopping_cart,
              color: Color.fromARGB(255, 255, 64, 129),
              size: 28,
            ),
            onPressed: () {
              if (currentUser == null) {
                showLoginDialog(context); // Show login dialog
              } else {
                _addToShoppingList(ingredient, currentUser);
              }
            },
          ),
        ],
      ),
    );
  }
}
