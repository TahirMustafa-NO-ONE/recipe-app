import 'dart:convert';
import 'package:http/http.dart' as http;

import '../API_key.dart';

// Fetch recipe details from Spoonacular
Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
  final url = 'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=${ApiKey.spoonacularApiKey}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load recipe details');
  }
}
