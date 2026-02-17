import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeSlider extends StatefulWidget {
  final List<Map<String, String>> content;

  const RecipeSlider({required this.content});

  @override
  _RecipeSliderState createState() => _RecipeSliderState();
}

class _RecipeSliderState extends State<RecipeSlider> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.content.isNotEmpty) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < widget.content.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: widget.content.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        itemCount: widget.content.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = widget.content[index];
          final imageUrl = item['imageUrl'];
          final isImageAvailable = imageUrl != null && imageUrl.isNotEmpty;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'arecipe',
                arguments: {
                  'recipeImage': item['imageUrl'],
                  'recipeName': item['title'],
                  'recipeId': item['id'],
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      isImageAvailable
                          ? imageUrl!
                          : 'https://via.placeholder.com/150?text=Image+Not+Found',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if even the "Image Not Found" URL fails
                        return Container(
                          color: Colors.grey,
                          width: 100,
                          height: 150,
                          alignment: Alignment.center,
                          child: const Text(
                            'Image Not Found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 30),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0, right: 13),
                        child: Text(
                          item['title'] ?? 'Untitled', // Fallback for missing title
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
