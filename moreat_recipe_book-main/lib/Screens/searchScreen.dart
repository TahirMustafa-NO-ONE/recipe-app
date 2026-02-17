import 'package:flutter/material.dart';
import 'package:moreat_recipe_book/modules/recipeCardsearch.dart';
import '../services/search_api_service.dart';
import '../modules/filter_bottom_sheet.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key}) : super(key: key);

  @override
  _SearchBarScreenState createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = false;

  // Filters
  List<String> _selectedIngredients = [];
  String? _selectedCategory;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty) {
      _searchRecipes(query: _controller.text);
    } else {
      setState(() {
        _recipes = []; // Clear results if search text is empty
      });
    }
  }

  Future<void> _searchRecipes({String? query}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      ApiService apiService = ApiService();
      List<Map<String, dynamic>> results = await apiService.searchRecipes(
        query: query,
        ingredients: _selectedIngredients,
        category: _selectedCategory,
        country: _selectedCountry,
      );
      setState(() {
        _recipes = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show an error message if necessary
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          onFilterApplied: (selectedIngredients, selectedCategory, selectedCountry) {
            setState(() {
              _selectedIngredients = selectedIngredients;
              _selectedCategory = selectedCategory;
              _selectedCountry = selectedCountry;
            });
            _searchRecipes();  // Re-fetch recipes with the applied filters
          },
          ingredients: [
            "Tomato", "Cheese", "Garlic", "Chicken", "Onion", "Cucumber",
            "Carrot", "Spice", "Milk", "Egg", "Flour", "Sugar", "Salt",
            "Pepper", "Apple", "Banana", "Pasta", "Rice", "Bread", "Butter"
          ],
          categories: ["Dessert", "Main Course", "Appetizer", "Side Dish"],
          countries: ["India", "USA", "Italy", "Mexico"],
        );
      },
    );
  }

  Widget _buildRecipeGrid(List<Map<String, dynamic>> recipes) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.52,
          crossAxisSpacing: 30,
          mainAxisSpacing: 15,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCardSearch(
            recipeId: recipe['id'].toString(),  // Pass recipeId here
            title: recipe['title'],
            imageUrl: recipe['image'],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 249, 227, 235), // Lightest purple shade as background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Search Bar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Search Bar Container
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(color: Color.fromARGB(255, 255, 64, 129), width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.search, color: Color.fromARGB(255, 255, 64, 129)),
                      ],
                    ),
                  ),
                  // "RECIPE" Label
                  Positioned(
                    left: 16,
                    top: -8,
                    child: Container(
                      color: const Color.fromARGB(255, 249, 227, 235),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const Text(
                        "RECIPE",
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 64, 129),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      _showFilterBottomSheet(context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.filter_alt_rounded, color: Color.fromARGB(255, 255, 64, 129)),
                          SizedBox(width: 4),
                          Text("Filter", style: TextStyle(fontFamily: 'Ubuntu', color: Color.fromARGB(255, 255, 64, 129), fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Search Result Text
              const Text("Search Result", style: TextStyle( fontFamily: 'Ubuntu',fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(
                color: Color.fromARGB(255, 255, 64, 129),
              ))
                  : _recipes.isEmpty
                  ? Center(child: const Text("No Results :( ", style: TextStyle(fontFamily: 'Ubuntu',fontSize: 16, color: Colors.black45)))
                  : Expanded(
                child: _buildRecipeGrid(_recipes), // Show the recipes in a grid
              ),
            ],
          ),
        ),
      ),
    );
  }
}
