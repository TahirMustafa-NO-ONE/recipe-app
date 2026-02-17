import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 233, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            Column(
              children: [
                // Slide-in animation for the image
                SlideTransition(
                  position: _imageSlideAnimation,
                  child: Image.asset('assets/new_logo_3.png', height: 250),
                ),
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Text(
                    'Welcome to the',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 26,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Text(
                    'MOREAT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      height: 0,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 64, 129),
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.grey,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Discover recipes that inspire, indulge, and nourish your soul. '
                          'From everyday favorites to exotic dishes, Moreat is your ultimate recipe companion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        color: Color.fromARGB(255, 85, 85, 85),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Slide-in animation for the "Get Started" button
            SlideTransition(
              position: _buttonSlideAnimation,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 255, 64, 129),
                    ),
                  ),
                  color: Color.fromARGB(255, 252, 210, 224),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'mainscreen');
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Color.fromARGB(255, 255, 64, 129),
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
