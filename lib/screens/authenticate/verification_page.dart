import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//using this as reference:
//https://medium.flutterdevs.com/email-verification-with-flutter-firebase-e127aad393c3

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  //boolean that determines whether or not email was verified
    bool isEmailVerified = false;
    Timer? timer;
    String verificationText = 'Verifying email...';

    checkEmailVerified() async
    {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if(isEmailVerified)
      {
        setState(() {
        verificationText = 'Email Successfully Verified';

        timer?.cancel();
        });
      }
    }

    @override
    void initState()
    {
      super.initState();
      try {
        print('sent');
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } on Exception catch (e) {
          // TODO
          print(e);
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
            SizedBox(height: 50),
            Text('A verification email was sent to ${FirebaseAuth.instance.currentUser?.email}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            const Center(
              child: CircularProgressIndicator()
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    verificationText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        )
      ),
    );
  }
}