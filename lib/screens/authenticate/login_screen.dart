import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //from https://stackoverflow.com/questions/67768950/how-to-add-specific-fixed-value-to-textfield
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //string to force users to use uci email
  final String _userPostfix = '@uci.edu';

  Future signIn() async
  {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      );
    Navigator.pushReplacementNamed(context, '/loading_home');
  }

  @override
  //helps with memory usage
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  //followed this tutorial: https://www.youtube.com/watch?v=aJdIkRipgSk&list=PLlvRDpXh1Se4wZWOWs8yapI8AS_fwDHzf&index=3
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //logo would go here
              Icon(Icons.shopping_basket_outlined, size: 100),
              SizedBox(height: 75),
              //Header text to welcome user
              Text(
                'Welcome!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please login or register below',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 50),
          
              //username/email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  //forces users to use @uci.edu email
                  //from: https://stackoverflow.com/questions/67768950/how-to-add-specific-fixed-value-to-textfield
                  controller: _emailController,
                  onChanged: (value) {
                    if (value == _userPostfix) {
                      _emailController.text = "";
                      return;
                    }
                    value.endsWith(_userPostfix)
                        ? _emailController.text = value
                        : _emailController.text = value + _userPostfix;
                    _emailController.selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: _emailController.text.length -
                                _userPostfix.length));
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email@uci.edu',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
              SizedBox(height: 10),

              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  obscureText: true,
                  ),
                ),
              SizedBox(height: 10),

              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      )),
                  ),
                ),
              ),
              SizedBox(height: 25),
          
              //new user? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(
                    ' Register Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      )
                    )
                ],
              ),
            ]),
          ),
        ),
      )
    );
  }
}