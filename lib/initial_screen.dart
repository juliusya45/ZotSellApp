import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/screens/authenticate/auth_page.dart';
import 'package:zot_sell/screens/authenticate/verification_page.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData)
          {
            if(FirebaseAuth.instance.currentUser!.emailVerified)
            {
              print('to home screen');
              //if the user successfully signed in we show a loading spinner and do everything else
              return const Loading_Home();
            }
            else{
              print('to verification page');
              return const VerificationScreen();
            }

          }
          else
          {
            print('back to login');
            //auth page is another inbetween that switches between login and register page
            return AuthPage();
          }
        },
      ),
    );
  }
}