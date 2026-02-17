import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 40, right: 40),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.list_alt_rounded,
              label: 'List',
              index: 0,
              isSelected: currentIndex == 0,
              onItemTapped: onItemTapped,
            ),
            _buildNavItem(
              icon: Icons.home,
              label: 'Home',
              index: 1,
              isSelected: currentIndex == 1,
              onItemTapped: onItemTapped,
            ),
            _buildNavItem(
              icon: Icons.shopping_cart,
              label: 'SL',
              index: 2,
              isSelected: currentIndex == 2,
              onItemTapped: onItemTapped,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required Function(int) onItemTapped,
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 9),
          if(!isSelected)
            Icon(
              icon,
              size: isSelected ? 40 : 30, // Increase icon size if selected
              color: isSelected
                  ? Color.fromARGB(255, 255, 64, 129) // Selected color
                  : Colors.black54, // Unselected color
            ),
          if(isSelected)
            Text(label, style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 255, 64, 129), fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 9),
          if (isSelected)
            Container(
              width: 45,
              height: 3,
              color: Color.fromARGB(255, 255, 64, 129), // Underline color
            ),
        ],
      ),
    );
  }
}