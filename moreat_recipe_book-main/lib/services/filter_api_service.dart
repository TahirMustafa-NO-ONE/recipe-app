import 'dart:convert';
import 'package:http/http.dart' as http;

import '../API_key.dart';

class ApiService {
  Future<List<Map<String, dynamic>>> searchRecipes(
      String query,
      List<String> ingredients,
      String? category,
      String? country,
      ) async {
    final url = Uri.https(
      'api.spoonacular.com',
      '/recipes/complexSearch',
      {
        'query': query,
        'includeIngredients': ingredients.join(','),
        'category': category,
        'country': country,
        'apiKey': '${ApiKey.spoonacularApiKey}',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
