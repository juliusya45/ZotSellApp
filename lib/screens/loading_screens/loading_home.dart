// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zot_sell/classes/listings.dart';
import 'package:zot_sell/classes/zotuser.dart';
import 'package:zot_sell/screens/home/home.dart';

class LoadingHome extends StatefulWidget {
  const LoadingHome({super.key});

  @override
  State<LoadingHome> createState() => _LoadingHomeState();
}

//going to be:
//getting a Zotuser from data in the db
//getting all listings from database
//mapping each listing
//putting each listing into a list
//passing the list to home
class _LoadingHomeState extends State<LoadingHome> {

  //defining database:
  final database = FirebaseFirestore.instance;
  List<Listings> allListings = [];
  Zotuser sendZotuser = Zotuser(uid: '', email: '', username: '');

  void setupDatabase() async
  {
    //defining db reference:
    final ref = database.collection('listings').withConverter(
    fromFirestore:  Listings.fromFirestore,
    toFirestore: (Listings listing, _) => listing.toFirestore(),
    );
    
    await ref.get().then((event) {
      for (var doc in event.docs) {
        final listing = doc.data(); //Converts each listing into a Listings obj.
        if(listing != null)
        {
          listing.docId = doc.id; //setting the docId attribute that was left blank
          allListings.add(listing); //adds each listing into a list of Listings
        }
        else
        {
          if (kDebugMode) {
            print('did not get data');
          }
        }
      }
    });
  }

  void getUserData() async
  {
    final docName = FirebaseAuth.instance.currentUser?.uid;
    final userRef = database.collection('users').doc(docName).withConverter(
      fromFirestore: Zotuser.fromFirestore, 
      toFirestore: (Zotuser zotuser, _) => zotuser.toFirestore()
      );

    final docSnap = await userRef.get();
    sendZotuser = docSnap.data()!;
    print('got zotuser');
    //this prints out data from the db correctly
    print(sendZotuser.username);
  }

  //function that runs before the object is created. But does not run everytime it is rebuilt
  @override
  void initState(){
    super.initState();
    setupDatabase();
    getUserData();
    //there seems to be an error here where zotuser is not being updated correctly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: '/home'),
          builder: (context) => Home(allListings: allListings, zotuser : sendZotuser),
          ),
      );
}
    });
  }

//did this wrong, this should be a loading page, first thing to pop up
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey[200],
      body: const SpinKitSquareCircle(
            color: Colors.blue,
            size: 80.0,
          ),
        );
  }
}