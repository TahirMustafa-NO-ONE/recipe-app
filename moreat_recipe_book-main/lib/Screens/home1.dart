import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API_key.dart';
import '../modules/CategoryButton.dart';
import '../modules/RecipeMinicard.dart';
import '../modules/RecipeSlider.dart';
import '../services/user_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> recipeSliderData = [];
  List<dynamic> categories = [];
  List<dynamic> categoryRecipes = [];
  String selectedCategory = 'main course'; // Default category

  bool isDataLoaded = false; // Flag to check if data has been loaded
  bool isLoading = true; // Flag for loading
  bool isCategoryLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Fetch the cached slider data
      final cachedSliderData = prefs.getString('recipeSliderData');

      if (cachedSliderData != null) {
        setState(() {
          recipeSliderData = json.decode(cachedSliderData);
          isDataLoaded = true;
          isLoading = false;
        });
      } else {
        await fetchRandomRecipes();
      }

      // Fetch the cached category-specific data
      final cachedCategoryRecipes = prefs.getString('categoryRecipes_$selectedCategory');
      if (cachedCategoryRecipes != null) {
        // If cached data for the selected category exists, use it
        setState(() {
          categoryRecipes = json.decode(cachedCategoryRecipes);
          isCategoryLoading = false;
        });
      } else {
        // If no cached data for the selected category, fetch from the API
        await fetchRecipesByCategory(selectedCategory);
      }

      // Fetch categories regardless of cache
      await fetchCategories(); // Ensure categories are loaded
    } catch (e) {
      print("Error loading data from shared preferences: $e");
    }
  }

  Future<void> fetchRandomRecipes() async {
    final url =
        "https://api.spoonacular.com/recipes/random?number=5&apiKey=${ApiKey.spoonacularApiKey}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        recipeSliderData = data['recipes'];
        isDataLoaded = true;
        isLoading = false;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('recipeSliderData', json.encode(recipeSliderData));
    } else {
      print("Failed to load random recipes");
    }
  }

  Future<void> fetchCategories() async {
    setState(() {
      categories = [
        "main course",
        "side dish",
        "dessert",
        "appetizer",
        "salad",
        "breakfast"
      ];
    });
  }

  Future<void> fetchRecipesByCategory(String category) async {
    setState(() {
      isCategoryLoading = true; // Show loading indicator when loading new category
    });

    final url =
        "https://api.spoonacular.com/recipes/complexSearch?type=$category&number=10&apiKey=${ApiKey.spoonacularApiKey}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categoryRecipes = data['results'];
        isCategoryLoading = false; // Hide loading indicator once the recipes are fetched
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('categoryRecipes_$category', json.encode(categoryRecipes)); // Cache category-specific recipes
    } else {
      print("Failed to load category recipes");
    }
  }

  Future<void> _refreshRecipes() async {
    setState(() {
      isDataLoaded = false; // Reset data loaded flag
      isLoading = true; // Show loading indicator
    });
    await fetchRandomRecipes();
    await fetchRecipesByCategory(selectedCategory);
    setState(() {
      isDataLoaded = true; // Mark data as loaded again
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserState>().currentUser;
    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'searchScreen');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 64, 129),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " RECIPE",
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.search,size: 30, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'settingPage');
                },
                child: CircleAvatar(
                  radius: 29,
                  backgroundColor: Colors.transparent,
                  child: currentUser != null && currentUser.photoURL != null
                      ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(currentUser.photoURL!),
                  )
                      : ClipOval(
                    child: Image.asset(
                      'assets/new_logo_3.png', // Replace with your asset image path
                      fit: BoxFit.cover,
                      width: 58, // Adjust dimensions as needed
                      height: 58,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_home1.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 64, 129).withOpacity(0.7),
                    Colors.white.withOpacity(0.7),
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: _refreshRecipes,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: appBarHeight + 70),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Slider section with loading indicator
                      if (isLoading)
                        Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 64, 129),)),
                      if (recipeSliderData.isNotEmpty && !isLoading)
                        RecipeSlider(
                          content: recipeSliderData
                              .map((recipe) {
                            final imageUrl = recipe['image'] ?? '';
                            final title = recipe['title'] ?? '';
                            final id = recipe['id']; // Assuming 'id' is available
                            return {
                              'imageUrl': imageUrl.toString(),
                              'title': title.toString(),
                              'id': id.toString(),
                            };
                          })
                              .toList()
                              .cast<Map<String, String>>(),
                        ),

                      // Category section
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 0, top: 40, bottom: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categories
                                .map(
                                  (category) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: CategoryButton(
                                  title: category,
                                  isSelected: selectedCategory == category,
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                    fetchRecipesByCategory(category);
                                  },
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ),

                      // Loading indicator for category recipes
                      if (isCategoryLoading)
                        Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 64, 129),)),

                      // Display category recipes after loading
                      if (categoryRecipes.isNotEmpty && !isCategoryLoading)
                        ...categoryRecipes.map(
                              (recipe) => RecipeMiniCard(
                            imageUrl: recipe['image'],
                            title: recipe['title'],
                            id: recipe['id'].toString(),
                          ),
                        ).toList(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
