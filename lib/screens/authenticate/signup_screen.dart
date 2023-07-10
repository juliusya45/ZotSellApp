import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

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
  final _userNameController = TextEditingController();

  //string to force users to use uci email
  final String _userPostfix = '@uci.edu';

  //String that displays error messages
  String errorMsg = '';

  //Profanity checker for username:
  final filter = ProfanityFilter();

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
      //only go to next page if all the checks pass
      if (passwordConfirmed() && userNameCheck() && emptyCheck())
      {
        setState(() {
        errorMsg = '';
        });
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
        );
        //TODO: need to create a user object here that associates id with username:
        await addUserDetails(_userNameController.text, FirebaseAuth.instance.currentUser!.uid, _emailController.text.trim());
        //pushes the next screen
        if (context.mounted) Navigator.pushReplacementNamed(context, '/verification');
      }
    } 
    on Exception catch (e) 
    {
      if (kDebugMode) {
          print(e);
        }
    }
  }

  //adds user data into a users collection
  Future addUserDetails(String userName, String uid, String email) async
  {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username' : userName,
      'email' : email
    });
  }

  bool passwordConfirmed()
  {
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim())
    {

      return true;
      
    }
    else
    {
      if(_confirmPasswordController.text.trim().isNotEmpty)
      {
        setState(() {
        errorMsg = 'Passwords do not match';
      });
      }
      else
      {
        setState(() {
          errorMsg = 'Please confirm your password';
        });
      }
      return false;
    }
  }

  bool userNameCheck()
  {
    //if this statement returns true then there is profanity in the username
    //This check only works if words are separated by a space in the string -> might need to implement another thing or just keep it
    if(filter.hasProfanity(_userNameController.text.trim()))
    {
      if (kDebugMode) {
          print('has profanity');
        }
      setState(() {
        errorMsg = 'Your username contains profanity. Please change it';
      });
      return false;
    }
    else
    {
      if (kDebugMode) {
          print('no profanity');
        }
      return true;
    }
  }

  //checks that the user has filled out text fields
  //returns false if any field is empty
  bool emptyCheck()
  {
    if(_emailController.text.trim().isEmpty)
    {
      setState(() {
        errorMsg = 'Please type in your email';
      });
      return false;
    }
    else if(_userNameController.text.trim().isEmpty)
    {
      setState(() {
        errorMsg = 'Please type in a username';
      });
      return false;
    }
    else if(_passwordController.text.trim().isEmpty)
    {
      setState(() {
        errorMsg = 'Please type in a password';
      });
      return false;
    }
    else
    {
      return true;
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
              const SizedBox(height: 20),

              //error text
              Text(errorMsg,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
          
              //email textfield
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

              //userName textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Username',
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

              //confirm password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Confirm Password',
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
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(25),
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
                  const Text('Already have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: const Text(
                      ' Login Here',
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