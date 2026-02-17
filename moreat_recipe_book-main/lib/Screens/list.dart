import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moreat_recipe_book/modules/recipeCardsearch.dart';
import 'package:provider/provider.dart';
import '../services/user_state.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<UserState>().currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.displayName ?? "Guest",
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Recipe List",
              style: TextStyle(
                fontFamily: 'Ubuntu',
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 64, 129),
        bottom: TabBar(
          controller: _tabController, // Use the manually created TabController
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Favorite"),
            Tab(text: "Planned"),
            Tab(text: "Cooking"),
            Tab(text: "Cooked"),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: user == null
            ? _buildNotLoggedInMessage(context)
            : _buildRecipeList(context, user),
      ),
    );
  }

  Widget _buildNotLoggedInMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You are not logged in!!!",
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'login');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 64, 129),
                  width: 2,
                ),
              ),
              child: const Text(
                "Login now",
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Color.fromARGB(255, 255, 64, 129),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('recipe_lists')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 64, 129),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No recipe data found."));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        // Extract recipes from Firestore
        List<Map<String, dynamic>> favoriteRecipes =
        List<Map<String, dynamic>>.from(userData['favorites'] ?? []);
        List<Map<String, dynamic>> plannedRecipes =
        List<Map<String, dynamic>>.from(userData['planning'] ?? []);
        List<Map<String, dynamic>> cookingRecipes =
        List<Map<String, dynamic>>.from(userData['cooking'] ?? []);
        List<Map<String, dynamic>> cookedRecipes =
        List<Map<String, dynamic>>.from(userData['cooked'] ?? []);

        // Combine all recipes into one list for the "All" tab, ensuring no duplicates
        Set<String> uniqueRecipeIds = Set<String>();
        List<Map<String, dynamic>> allRecipes = [];

        void addUniqueRecipes(List<Map<String, dynamic>> recipes) {
          for (var recipe in recipes) {
            if (!uniqueRecipeIds.contains(recipe['id'].toString())) {
              uniqueRecipeIds.add(recipe['id'].toString());
              allRecipes.add(recipe);
            }
          }
        }

        // Add recipes from all categories
        addUniqueRecipes(favoriteRecipes);
        addUniqueRecipes(plannedRecipes);
        addUniqueRecipes(cookingRecipes);
        addUniqueRecipes(cookedRecipes);

        return TabBarView(
          controller: _tabController, // Use the manually created TabController
          children: [
            _buildRecipeGrid(allRecipes), // Display all recipes without duplicates
            _buildRecipeGrid(favoriteRecipes),
            _buildRecipeGrid(plannedRecipes),
            _buildRecipeGrid(cookingRecipes),
            _buildRecipeGrid(cookedRecipes),
          ],
        );
      },
    );
  }

  Widget _buildRecipeGrid(List<Map<String, dynamic>> recipes) {
    if (recipes.isEmpty) {
      return const Center(child: Text("No recipes found in this category."));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.57,
          crossAxisSpacing: 30,
          mainAxisSpacing: 20,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCardSearch(
            recipeId: recipe['id'].toString(),
            title: recipe['title'],
            imageUrl: recipe['image'],
          );
        },
      ),
    );
  }
}
