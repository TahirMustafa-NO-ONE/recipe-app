import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeCardSearch extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String recipeId;  // Accept recipeId as a parameter

  const RecipeCardSearch({
    required this.title,
    required this.imageUrl,
    required this.recipeId,  // Initialize recipeId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate and pass recipeId
        Navigator.pushNamed(
          context,
          'arecipe',  // Adjust this to the appropriate route name
          arguments: {
            'recipeId': recipeId,  // Pass the recipeId to the next screen
            'recipeName': title,
            'recipeImage': imageUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 190,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
