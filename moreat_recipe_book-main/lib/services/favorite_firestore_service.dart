import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Check if the recipe is in favorites
  Future<bool> checkFavoriteStatus({
    required String userId,
    required String recipeId,
  }) async {
    try {
      final doc = await _db.collection('recipe_lists').doc(userId).get();

      if (doc.exists) {
        final favorites = List<Map<String, dynamic>>.from(doc['favorites'] ?? []);
        return favorites.any((recipe) => recipe['id'] == recipeId);
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
    return false;
  }

  // Toggle favorite status
  Future<bool> toggleFavorite({
    required String userId,
    required Map<String, dynamic> recipe,
  }) async {
    try {
      final docRef = _db.collection('recipe_lists').doc(userId);
      final doc = await docRef.get();

      List<Map<String, dynamic>> favorites = [];

      if (doc.exists) {
        favorites = List<Map<String, dynamic>>.from(doc['favorites'] ?? []);
      }

      final isFavorite = favorites.any((fav) => fav['id'] == recipe['id']);

      if (isFavorite) {
        favorites.removeWhere((fav) => fav['id'] == recipe['id']);
      } else {
        favorites.add(recipe);
      }

      await docRef.set({'favorites': favorites}, SetOptions(merge: true));

      return !isFavorite; // Return the new favorite status
    } catch (e) {
      print('Error toggling favorite status: $e');
    }
    return false;
  }

  // Method to get the status of a recipe (Add To List, Cooking, etc.)
  Future<String> getRecipeStatus({
    required String userId,
    required String recipeId,
  }) async {
    try {
      // Reference to the user's recipe list document in the 'recipe_lists' collection
      DocumentReference userListRef = FirebaseFirestore.instance.collection('recipe_lists').doc(userId);

      // Fetch the user's list document
      DocumentSnapshot userListDoc = await userListRef.get();

      if (userListDoc.exists) {
        // Fetch the lists for the user (planning, cooking, cooked)
        List<dynamic> planningList = userListDoc['planning'] ?? [];
        List<dynamic> cookingList = userListDoc['cooking'] ?? [];
        List<dynamic> cookedList = userListDoc['cooked'] ?? [];

        // Helper function to check if a list contains a recipeId
        bool containsRecipe(List<dynamic> list, String recipeId) {
          return list.any((recipe) => recipe['id'] == recipeId);
        }

        // Check which list contains the recipeId
        if (containsRecipe(planningList, recipeId)) {
          return 'Planning';
        } else if (containsRecipe(cookingList, recipeId)) {
          return 'Cooking';
        } else if (containsRecipe(cookedList, recipeId)) {
          return 'Cooked';
        } else {
          return 'Add To List'; // If the recipeId is not found in any of the lists
        }
      } else {
        print('No user recipe list found for userId: $userId');
        return 'Add To List'; // Default if user document does not exist
      }
    } catch (e) {
      print('Error fetching recipe status: $e');
      return 'Add To List'; // Return default status in case of an error
    }
  }

}
