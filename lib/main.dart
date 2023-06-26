import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zot_sell/screens/authenticate/login_screen.dart';
import 'package:zot_sell/screens/home/home.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';
import 'firebase_options.dart';

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
      //changed to loginscreen to debug it
      //TODO: change back to '/'
      initialRoute: kReleaseMode == false ? '/login' : '/',
      routes: {
        //TODO: remove comment when testing full app. commented out og path to debug login screen
        //'/': (context) => const Loading_Home(),
        '/home': (context) => const Home(allListings: [],),
        //TODO: will need to change routes to account for authentication
        //temporary routes on the bottom:
        '/login': (context) => const LoginScreen(),
        //TODO: change to signup screen when that is created
        '/signup': (context) => const LoginScreen(),
      },
    );
  }
}
