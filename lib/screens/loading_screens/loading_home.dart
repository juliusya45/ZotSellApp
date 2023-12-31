// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/zotuser.dart';
import 'package:zot_sell/screens/navigation_screens/nav.dart';

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

//7-18 changing the Listing objects to AppListing objects
class _LoadingHomeState extends State<LoadingHome> {

  //defining database:
  final database = FirebaseFirestore.instance;
  List<AppListings> allListings = [];
  late Zotuser sendZotuser;

  //needed to change Listings to AppListings
  Future<void> setup() async
  {
    //defining db reference:
    final ref = database.collection('appListings').orderBy('time').withConverter(
    fromFirestore:  AppListings.fromFirestore,
    toFirestore: (AppListings appListings, _) => appListings.toFirestore(),
    );
    
    await ref.get().then((event) {
      for (var doc in event.docs) {
        final appListings = doc.data(); //Converts each listing into a Listings obj.
        if(appListings != null)
        {
          appListings.docId = doc.id; //setting the docId attribute that was left blank
          allListings.add(appListings); //adds each listing into a list of Listings
        }
        else
        {
          if (kDebugMode) {
            print('did not get data');
          }
        }
      }
    });
    await getUserData();
  }

  Future<void> getUserData() async
  {
    final docName = FirebaseAuth.instance.currentUser?.uid;
    final userRef = database.collection('users').doc(docName).withConverter(
      fromFirestore: Zotuser.fromFirestore, 
      toFirestore: (Zotuser zotuser, _) => zotuser.toFirestore()
      );

    await userRef.get().then((value) {
      sendZotuser = value.data()!;
      print('got zotuser');
      //this prints out data from the db correctly
      print(sendZotuser.username);
    });
    
  }

  //function that runs before the object is created. But does not run everytime it is rebuilt
  @override
  void initState(){
    super.initState();
    setup().then((result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      if (sendZotuser != null) {
  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: '/nav'),
          builder: (context) => Nav(allListings: allListings, zotuser : sendZotuser),
          ),
      );
}
    });
    });
    //there seems to be an error here where zotuser is not being updated correctly
    
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