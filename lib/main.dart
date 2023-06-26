import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zot_sell/screens/authenticate/login_screen.dart';
import 'package:zot_sell/screens/home/home.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';
import 'firebase_options.dart';
import 'initial_screen.dart';

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
        '/loading_home': (context) => const Loading_Home(),
        '/home': (context) => const Home(allListings: [],),
        //TODO: will need to change routes to account for authentication
        //temporary routes on the bottom:

        //TODO: change to signup screen when that is created
        '/signup': (context) => const LoginScreen(),
      },
    );
  }
}
