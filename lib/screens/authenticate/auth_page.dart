import 'package:flutter/material.dart';
import 'package:zot_sell/screens/authenticate/login_screen.dart';
import 'package:zot_sell/screens/authenticate/signup_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  //want to initially show the login page
  bool showLoginPage = true;

  void toggleScreens()
  {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage)
    {
      return LoginScreen(showRegisterPage: toggleScreens);
    }
    else
    {
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}