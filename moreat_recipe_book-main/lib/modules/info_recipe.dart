import 'package:flutter/material.dart';

class RecipeInfo extends StatelessWidget {
  final int servings;
  final int readyInMinutes;
  final int cookingMinutes;
  final int preparationMinutes;
  final double healthScore;
  final double spoonacularScore;
  // final double pricePerServing;

  RecipeInfo({
    required this.servings,
    required this.readyInMinutes,
    required this.cookingMinutes,
    required this.preparationMinutes,
    required this.healthScore,
    required this.spoonacularScore,
    // required this.pricePerServing,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 64, 129),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Info',
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
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(Icons.group, 'Servings', servings.toString()),
                  _buildInfoRow(Icons.timer, 'Ready in', '$readyInMinutes mins'),
                  _buildInfoRow(Icons.kitchen, 'Cooking Time', '$cookingMinutes mins'),
                  _buildInfoRow(Icons.local_dining, 'Preparation Time', '$preparationMinutes mins'),
                  _buildInfoRow(Icons.favorite, 'Health Score', healthScore.toStringAsFixed(0)), // No decimals
                  _buildInfoRow(Icons.star, 'Spoonacular Score', spoonacularScore.toStringAsFixed(0)), // No decimals
                  // _buildInfoRow(Icons.attach_money, 'Price/Serving', '\$${pricePerServing.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each row with icon, label, and value.
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 255, 64, 129), size: 28), // Larger icon size
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
