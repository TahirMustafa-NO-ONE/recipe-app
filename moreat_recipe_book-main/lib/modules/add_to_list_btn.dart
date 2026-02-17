import 'dart:ui';
import 'package:flutter/material.dart';

class AddToListButton extends StatelessWidget {
  final VoidCallback onTap;
  final String currentStatus; // Accepts current status of the recipe

  AddToListButton({required this.onTap, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    // Print the status to confirm it's passed correctly
    print('Received Status: $currentStatus');

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 330,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color.fromARGB(255, 255, 64, 129),
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.pinkAccent.withOpacity(0.3),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentStatus.isNotEmpty ? currentStatus : 'Add To List',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
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
      ),
    );
  }
}
