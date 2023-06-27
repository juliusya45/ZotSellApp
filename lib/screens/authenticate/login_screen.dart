import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginScreen({super.key, required this.showRegisterPage});

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

  //String that displays error messages
  String errorMsg = '';

  Future signIn() async
  {
    try 
    {
      setState(() {
        errorMsg = '';
        });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/loading_home');
    } 
    on Exception catch (e) 
    {
      setState(() {
        String exceptionMsg = e.toString();
        errorMsg = exceptionMsg.replaceAll(RegExp('\\[.*?\\]'), '');
      });
    }
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
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              //logo would go here
              const Text(
                'ZotSell',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 54,
                )
                ),
              Icon(Icons.shopping_cart, size: 100, color: Colors.green[300]),
              const SizedBox(height: 45),
              //Header text to welcome user
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please login to your account:',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),

              //displays error text
              Text(errorMsg,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),
          
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
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email@uci.edu',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  ),
                ),
              const SizedBox(height: 10),

              //password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true
                  ),
                  obscureText: true,
                  ),
                ),
              const SizedBox(height: 10),

              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text(
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
              const SizedBox(height: 25),
          
              //new user? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: const Text(
                      ' Sign Up Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
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