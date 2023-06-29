import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/screens/authenticate/auth_page.dart';
import 'package:zot_sell/screens/authenticate/verification_page.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';

/// The InitialScreen class is a stateless widget that determines which screen to display based on the
/// user's authentication state.
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
              if (kDebugMode) {
                print('to home screen');
              }
              //if the user successfully signed in we show a loading spinner and do everything else
              return const LoadingHome();
            }
            //if the user has not been verified
            else
            {
              //else we send the user to the verification page to be verified
              if (kDebugMode) {
                print('to verification page');
              }
              return const VerificationScreen();
            }
            //in the future a check to make sure a user isn't blacklisted should also occur, but for now that's not important to implement
          }
          else
          {
            if (kDebugMode) {
              print('back to login');
            }
            //auth page is another inbetween that switches between login and register page
            return const AuthPage();
          }
        },
      ),
    );
  }
}