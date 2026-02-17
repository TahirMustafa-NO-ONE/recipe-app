import 'dart:convert';
import 'package:http/http.dart' as http;

import '../API_key.dart';

class ApiService {
  static const String apiKey = '${ApiKey.spoonacularApiKey}';
  static const String baseUrl = 'https://api.spoonacular.com/recipes/';

  // Method to search recipes based on filters only
  Future<List<Map<String, dynamic>>> searchRecipes({
    String? query,
    List<String>? ingredients,
    String? category,
    String? country,
  }) async {
    String url = '$baseUrl/complexSearch?apiKey=$apiKey';

    if (query != null && query.isNotEmpty) {
      url += '&query=$query';  // Search query added only when not null
    }

    if (ingredients != null && ingredients.isNotEmpty) {
      final encodedIngredients = ingredients.map((e) => Uri.encodeComponent(e)).join(",");
      url += '&includeIngredients=$encodedIngredients';
    }

    if (category != null) {
      url += '&type=$category';
    }

    if (country != null) {
      url += '&cuisine=$country';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['results'] is List) {
        final List<dynamic> recipes = data['results'];
        return recipes.map((recipe) => Map<String, dynamic>.from(recipe)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode} ${response.body}');
    }
  }
}
