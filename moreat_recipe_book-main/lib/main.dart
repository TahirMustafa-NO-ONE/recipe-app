import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';  // Don't forget to import provider

import '../services/user_state.dart';  // Import UserState
import 'API_key.dart';               // Runtime validation of required keys

import 'Screens/arecipe.dart';
import 'Screens/bmi.dart';
import 'Screens/forgotpass.dart';
import 'Screens/home1.dart';
import 'Screens/list.dart';
import 'Screens/login.dart';
import 'Screens/mainscreen.dart';
import 'Screens/register.dart';
import 'Screens/searchScreen.dart';
import 'Screens/settingPage.dart';
import 'Screens/shoppingList.dart';
import 'Screens/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate that all required secrets were provided via --dart-define.
  // Fails fast in debug builds with a clear developer-facing message.
  ApiKey.validate();

  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserState(),  // Provide the UserState to the app
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
      routes: {
        'Start': (context) => StartPage(),
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'home1': (context) => RecipeScreen(),
        'searchScreen': (context) => SearchBarScreen(),
        'list': (context) => ListScreen(),
        'bmi': (context) => BMIScreen(),
        'mainscreen': (context) => MainScreen(),
        'shoppingList': (context) => Shoppinglist(),
        'settingPage': (context) => SettingsPage(),
        'arecipe': (context) => RecipePage(),
        'forgotpass': (context) => ForgotPasswordPage(),
      },
    );
  }
}
