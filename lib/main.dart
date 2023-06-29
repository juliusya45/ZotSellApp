import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zot_sell/screens/authenticate/verification_page.dart';
import 'package:zot_sell/screens/home/home.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';
import 'firebase_options.dart';
import 'initial_screen.dart';

/// The above code initializes Firebase and sets up the routes for different screens in a Flutter
/// application.
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      initialRoute: '/',
      routes: {
        //now goes to initialscreen and this checks to see if a user was logged in or not
        '/': (context) => const InitialScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/loading_home': (context) => const LoadingHome(),
        '/home': (context) => const Home(allListings: [],),
        
      },
    );
  }
}
