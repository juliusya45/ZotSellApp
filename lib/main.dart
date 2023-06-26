import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading_Home(),
        '/home': (context) => const Home(allListings: [],),
      },
    );
  }
}
