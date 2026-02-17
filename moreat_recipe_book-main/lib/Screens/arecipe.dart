import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../modules/add_to_list_btn.dart';
import '../modules/add_to_list_dialog.dart';
import '../modules/info_recipe.dart';
import '../modules/ingredients_recipe.dart';
import '../modules/instructions_recipe.dart';
import '../modules/login_dialogue.dart';
import '../services/favorite_firestore_service.dart';
import '../services/recipe_detail_service.dart';
import '../services/user_state.dart';
import 'moreRecipes.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, dynamic>? recipeDetails;
  bool isLoading = true;
  bool isFavorite = false; // State to manage favorite icon
  int? recipeId;
  String currentStatus = 'Add To List'; // Default status

  @override
  void initState() {
    super.initState();
    // Initialize any state here (if needed)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    print("Received arguments: $arguments"); // Check what's actually passed

    final recipeIdString = arguments['recipeId'];
    print("Extracted recipeId: $recipeIdString"); // Validate the recipeId format

    if (recipeIdString is String) {
      recipeId = int.tryParse(recipeIdString);
    } else if (recipeIdString is int) {
      recipeId = recipeIdString;
    }

    if (recipeId == null) {
      print("Error: Recipe ID is null");
    }

    if (recipeId != null && recipeDetails == null) {
      fetchRecipeDetails(recipeId!).then((details) async {
        final userState = Provider.of<UserState>(context, listen: false);
        final currentUser = userState.currentUser;

        String status = 'Add To List';
        bool favoriteStatus = false;

        if (currentUser != null) {
          // Fetch recipe status
          status = await FirestoreService().getRecipeStatus(
            userId: currentUser.uid,
            recipeId: recipeId.toString(),
          );

          // Fetch favorite status
          final userRecipeListDoc = await FirebaseFirestore.instance
              .collection('recipe_lists')
              .doc(currentUser.uid)
              .get();

          if (userRecipeListDoc.exists) {
            final data = userRecipeListDoc.data();
            final favorites = (data?['favorites'] as List<dynamic>? ?? [])
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            favoriteStatus = favorites.any((fav) => fav['id'] == recipeId.toString());
          }
        }

        setState(() {
          recipeDetails = details;
          isLoading = false;
          currentStatus = status;
          isFavorite = favoriteStatus;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final currentUser = userState.currentUser;

    print("recipe ID in arecipe: ${recipeId}");

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 64, 129),)),
      );
    }

    final image = recipeDetails!['image'] ?? '';
    final title = recipeDetails!['title'] ?? '';
    final ingredients = recipeDetails!['extendedIngredients'] ?? [];
    final instructions = recipeDetails!['instructions'] ?? 'No instructions provided.';

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      image,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        color: Color.fromARGB(255, 255, 64, 129).withOpacity(0.6),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: SizedBox(
                        height: 30,
                        child: Marquee(
                          text: title,
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          scrollAxis: Axis.horizontal,
                          blankSpace: 50.0,
                          velocity: 40.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AddToListButton(
                  onTap: () {
                    if (currentUser == null) {
                      showLoginDialog(context);
                    } else if (recipeDetails != null) {
                      BottomDialogBox.showAddToListDialog(context, currentUser, recipeDetails!);
                    }
                  },
                  currentStatus: currentStatus, // Pass dynamic currentStatus
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: isFavorite
                                ? Icon(Icons.favorite, size: 35, color: Color.fromARGB(255, 255, 64, 129))
                                : Icon(Icons.favorite_border, size: 35, color: Color.fromARGB(255, 255, 64, 129)),
                            onPressed: currentUser == null
                                ? () => showLoginDialog(context)
                                : () async {
                              if (recipeDetails != null) {
                                final toggledStatus = await FirestoreService().toggleFavorite(
                                  userId: currentUser.uid,
                                  recipe: {
                                    'id': recipeDetails!['id'].toString(),
                                    'title': recipeDetails!['title'],
                                    'image': recipeDetails!['image'],
                                  },
                                );
                                setState(() {
                                  isFavorite = toggledStatus;
                                });
                              }
                            },
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            icon: Icon(Icons.share, size: 35, color: Color.fromARGB(255, 255, 64, 129)),
                            onPressed: () async {
                              if (currentUser == null) {
                                showLoginDialog(context); // Prompt the user to log in if they aren't logged in
                              } else {
                                final shareContent = '''
Hello! 👋

I wanted to share this awesome recipe with you ☺️:

🍽️ Recipe Title: $title

Ingredients: ${ingredients.map((ingredient) => ingredient['original'] ?? 'Unknown').join(', ')}

Instructions: $instructions

Image: $image
''';

                                Share.share(
                                  shareContent,
                                  subject: 'Check out this recipe!', // Optional: You can add a subject for the shared content
                                );
                              }
                            },
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                RecipeInfo(
                  servings: recipeDetails!['servings'] ?? 0,
                  readyInMinutes: recipeDetails!['readyInMinutes'] ?? 0,
                  cookingMinutes: recipeDetails!['cookingMinutes'] ?? 0,
                  preparationMinutes: recipeDetails!['preparationMinutes'] ?? 0,
                  healthScore: (recipeDetails!['healthScore'] ?? 0).toDouble(),
                  spoonacularScore: (recipeDetails!['spoonacularScore'] ?? 0).toDouble(),
                  // pricePerServing: (recipeDetails!['pricePerServing'] ?? 0).toDouble(),
                ),
                SizedBox(height: 20),
                IngredientsSection(ingredients: ingredients),
                SizedBox(height: 20),
                InstructionsSection(instructions: instructions),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (recipeId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreRecipesPage(recipeId: recipeId!),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromARGB(255, 255, 64, 129),
                      shadowColor: Colors.pinkAccent.withOpacity(0.5),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Get more like this one 🍽️',
                      style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}