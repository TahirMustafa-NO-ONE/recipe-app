import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected; // Track whether the category is selected
  final VoidCallback onTap; // Add onTap for dynamic filtering

  const CategoryButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger parent action
      child: Container(
        width: 150,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromARGB(255, 255, 64, 129),
            width: 3
          ),
        ),
        child: Stack(
          children: [
            // Background color based on selection state
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isSelected
                      ? Colors.white.withOpacity(0.5) // Light background for selected
                      : Colors.black.withOpacity(0.5), // Dark background for unselected
                ),
              ),
            ),
            // Button content (Text and underline)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isSelected ? Colors.black : Colors.white, // Text color
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    width: 90,
                    height: 3,
                    color: Color.fromARGB(255, 255, 64, 129),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
