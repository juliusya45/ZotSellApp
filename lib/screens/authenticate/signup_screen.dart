import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpScreen({super.key, required this.showLoginPage});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //string to force users to use uci email
  final String _userPostfix = '@uci.edu';

  //String that displays error messages
  String errorMsg = '';

  @override
  void dispose()
  {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future signUp() async
  {
    try 
    {
      if (passwordConfirmed())
      {
        setState(() {
        errorMsg = '';
        });
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
        );
      }
      else
      {
        //here we can add/show a text widget above the email field of any errors
        //implement with try/catch block above?
        print('Passwords do not match');
        setState(() {
        errorMsg = 'Passwords do not match';
      });
      }
    } 
    on Exception catch (e) 
    {
      setState(() {
        String exceptionMsg = e.toString();
        errorMsg = exceptionMsg.replaceAll(RegExp('\\[.*?\\]'), '');
      });
    }
  }

  bool passwordConfirmed()
  {
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim())
    {
      return true;
    }
    else
    {
      return false;
    }
  }

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
              //Header text to welcome user
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Please provide your @uci email and a password to sign up!',
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              //error text
              Text(errorMsg,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),
          
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

              //confirm password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Confirm Password',
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
                  onTap: signUp,
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text(
                      'Sign Up',
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
                  Text('Already have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      ' Login Here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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