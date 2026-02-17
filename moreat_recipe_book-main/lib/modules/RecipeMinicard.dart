import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeMiniCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id; // Add id as a required parameter

  const RecipeMiniCard({
    required this.imageUrl,
    required this.title,
    required this.id,  // Pass the id to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          'arecipe', // Navigate to the ARecipeScreen
          arguments: {
            'recipeImage': imageUrl,
            'recipeName': title,
            'recipeId': id,  // Pass the recipeId along with other details
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 64, 129).withOpacity(0.8),
                Colors.white.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: 110, // Adjust as needed
                    height: 160, // Adjust as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              VerticalDivider(
                color: Color.fromARGB(255, 255, 64, 129),
                thickness: 3,
                width: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, right: 13),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          )
        ),
      ),
    );
  }
}
