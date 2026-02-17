import 'package:flutter/material.dart';

class InstructionsSection extends StatelessWidget {
  final String instructions;

  InstructionsSection({required this.instructions});

  @override
  Widget build(BuildContext context) {
    // Clean the instructions by removing HTML-like tags and parse them into steps
    final List<String> steps = _parseInstructions(instructions);

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
                  Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Instructions',
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
            // Instructions List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps
                    .map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      // Bullet point for each step
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 64, 129),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Instruction text for each step
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to remove HTML tags and convert instructions into individual steps
  List<String> _parseInstructions(String instructions) {
    // Remove HTML tags (e.g., <li>, <br>) using a regular expression
    final cleanInstructions = instructions.replaceAll(RegExp(r'<[^>]*>'), '');

    // Split instructions by the period followed by space, and trim whitespace
    final steps = cleanInstructions
        .split(RegExp(r'(?<=\.)\s+')) // Split by period followed by space
        .map((step) => step.trim()) // Remove extra whitespace
        .where((step) => step.isNotEmpty) // Remove any empty steps
        .toList();

    return steps;
  }
}
