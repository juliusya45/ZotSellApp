import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 190, 236, 192),
      body: SafeArea(
        child: Column(children: [
          //Header text to welcome user
          Text('Welcome!'),
          //username/email textfield
      
          //password textfield
      
          //sign in button
      
          //new user? register now
        ]),
      )
    );
  }
}