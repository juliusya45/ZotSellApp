import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zot_sell/classes/listings.dart';
import 'package:zot_sell/screens/home/home.dart';

class Loading_Home extends StatefulWidget {
  const Loading_Home({super.key});

  @override
  State<Loading_Home> createState() => _Loading_HomeState();
}

//going to be:
//getting all listings from database
//mapping each listing
//putting each listing into a list
//passing the list to home
class _Loading_HomeState extends State<Loading_Home> {

  //defining database:
  final database = FirebaseFirestore.instance;

  void setupDatabase() async
  {
    List<Listings> allListings = [];

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
          print('did not get data');
        }
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: '/home'),
          builder: (context) => Home(allListings: allListings)
          ),
      );
    });
  }

    //function that runs before the object is created. But does not run everytime it is rebuilt
  @override
  void initState() {
    super.initState();
    setupDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.blue,
          size: 80.0,
        ),
      )
    );
  }
}