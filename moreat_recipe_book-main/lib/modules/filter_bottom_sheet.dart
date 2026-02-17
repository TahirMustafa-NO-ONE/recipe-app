import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(List<String> selectedIngredients, String? selectedCategory, String? selectedCountry) onFilterApplied;
  final List<String> ingredients;
  final List<String> categories;
  final List<String> countries;

  const FilterBottomSheet({
    Key? key,
    required this.onFilterApplied,
    required this.ingredients,
    required this.categories,
    required this.countries,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedIngredients = [];
  String? selectedCategory;
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Added for scrolling when content is long
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.filter_alt_rounded, color: Color.fromARGB(255, 255, 64, 129)),
                SizedBox(width: 5),
                Text("Filter", style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 255, 64, 129), fontSize: 24)),
              ],
            ),
            SizedBox(height: 10),
            // Ingredients Filter
            const Text("Ingredients", style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.ingredients.map((ingredient) {
                return ChoiceChip(
                  label: Text(ingredient, style: TextStyle(fontFamily: 'Ubuntu')),
                  selected: selectedIngredients.contains(ingredient),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedIngredients.add(ingredient);
                      } else {
                        selectedIngredients.remove(ingredient);
                      }
                    });
                  },
                  selectedColor: Color.fromARGB(255, 255, 64, 129),
                  labelStyle: const TextStyle(color: Colors.black),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Category Filter
            const Text("Categories", style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.categories.map((category) {
                return ChoiceChip(
                  label: Text(category, style: TextStyle(fontFamily: 'Ubuntu')),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = selected ? category : null;
                    });
                  },
                  selectedColor: Color.fromARGB(255, 255, 64, 129),
                  labelStyle: const TextStyle(color: Colors.black),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet without applying filters
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(148, 60),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Color.fromARGB(255, 255, 64, 129),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Apply filter logic here
                    widget.onFilterApplied(selectedIngredients, selectedCategory, selectedCountry);
                    Navigator.pop(context); // Close the bottom sheet after applying filters
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(148, 60),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Color.fromARGB(255, 255, 64, 129),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
