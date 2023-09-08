import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/classes/zotuser.dart';

import '../authenticate/auth_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.zotuser});

  final Zotuser zotuser;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            ),
        ),
        centerTitle: true,
      ),
      body: ListView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              ListTile(
                title: Text('${widget.zotuser.username} is signed in'),
                onTap: () {},
              ),
              ElevatedButton(
                child: const Text('Log Out'),
                onPressed: () {
                  //signs user out
                  FirebaseAuth.instance.signOut();
                  //Animation that puts the user back onto the login screen
                  //from: https://stackoverflow.com/questions/55586189/flutter-log-out-replace-stack-beautifully
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                          //switch to Authpage?
                      return const AuthPage();
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                    (route) => false
                    );
                },
              )
            ],
          ),
    );
  }
}