import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

//using this as reference:
//https://medium.flutterdevs.com/email-verification-with-flutter-firebase-e127aad393c3

/// The `VerificationScreen` class is a StatefulWidget that displays a verification screen with a
/// message, loading indicator, and a button to resend the verification email.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  //boolean that determines whether or not email was verified
    bool isEmailVerified = false;
    bool checked = false;
    Timer? timer;
    Timer? sendHomeTime;
    String verificationText = 'Waiting for Verification...';
    String animation = 'Loading';


    checkEmailVerified() async
    {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      
      /// The code block is checking if the email is successfully verified. If it is, it updates the
      /// `verificationText` variable to display the message "Email Successfully Verified". It also
      /// cancels the timer that checks for email verification and starts a new timer that navigates to
      /// the home screen after 3 seconds.
      if(isEmailVerified)
      {
        setState(() {
        verificationText = 'Email Successfully Verified';
        animation = 'Success';
        });
        timer?.cancel();
        sendHomeTime = Timer.periodic(const Duration(seconds: 2), (timer) => sendToHome());
      }
    }

    void sendToHome()
    {
      Navigator.pushReplacementNamed(context, '/loading_home');
      sendHomeTime?.cancel();
    }

    @override
    void initState()
    {
      super.initState();
      try {
        if (kDebugMode) {
          print('sent');
        }
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } on Exception catch (e) {
          // TODO
          if (kDebugMode) {
            print(e);
          }
        }
      timer = Timer.periodic(const Duration(seconds: 3), (timer) => checkEmailVerified());
    }

    @override
    void dispose()
    {
      timer?.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 80),
            Text('A verification email was sent to ${FirebaseAuth.instance.currentUser?.email}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Please check your @uci.edu email for a link, hit the resend button if the email was not recieved',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 110,
                width: 110,
                //animation editor: https://editor.rive.app/file/loading/477204
                //docs: https://help.rive.app/runtimes/playback
                child: RiveAnimation.asset('assets/loading.riv',
                animations: [animation],)
              )
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    verificationText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                child: const Text('Resend'),
                onPressed: () {
                  try{
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  }
                  catch (e)
                  {
                    debugPrint('$e');
                  }
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}