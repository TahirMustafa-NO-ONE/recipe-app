import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../API_key.dart';
import '../modules/recipeCardsearch.dart';

class MoreRecipesPage extends StatefulWidget {
  final int recipeId; // Pass the current recipe's ID

  const MoreRecipesPage({required this.recipeId, Key? key}) : super(key: key);

  @override
  _MoreRecipesPageState createState() => _MoreRecipesPageState();
}

class _MoreRecipesPageState extends State<MoreRecipesPage> {
  List<dynamic> similarRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSimilarRecipes();
  }

  Future<void> fetchSimilarRecipes() async {
    final url =
        'https://api.spoonacular.com/recipes/${widget.recipeId}/similar?apiKey=${ApiKey.spoonacularApiKey}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          similarRecipes = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch similar recipes');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildRecipeGrid(List<dynamic> recipes) {
    if (recipes.isEmpty) {
      return const Center(
        child: Text(
          "No similar recipes found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.59,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          // Extract values safely
          final recipeId = recipe['id']?.toString() ?? '0';
          final title = recipe['title'] ?? 'Unknown Recipe';

          // Check for image validity and provide a fallback
          final imageUrl = (recipe['id'] != null && recipe['imageType'] != null)
              ? 'https://spoonacular.com/recipeImages/${recipe['id']}-556x370.${recipe['imageType']}'
              : 'https://via.placeholder.com/150?text=Image+Not+Found';

          return RecipeCardSearch(
            recipeId: recipeId,
            title: title,
            imageUrl: imageUrl,
          );
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Similar Recipes", style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 255, 64, 129),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 64, 129),))
          : _buildRecipeGrid(similarRecipes),
    );
  }
}
