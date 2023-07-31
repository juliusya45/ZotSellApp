import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zot_sell/screens/authenticate/verification_page.dart';
import 'package:zot_sell/screens/home/home.dart';
import 'package:zot_sell/screens/listing/add_listing.dart';
import 'package:zot_sell/screens/listing/listing_screen.dart';
import 'package:zot_sell/screens/listing/preview_listing_screen.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';
import 'classes/app_listings.dart';
import 'classes/zotuser.dart';
import 'firebase_options.dart';
import 'screens/loading_screens/initial_screen.dart';

/// The above code initializes Firebase and sets up the routes for different screens in a Flutter
/// application.
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    //random Listings object to pass into a constructor
    AppListings blank = AppListings(
      docId: 'docId', 
      time: Timestamp.now(), 
      description: 'description', 
      imgUrl: [], 
      tags: [],
      itemTitle: 'itemTitle', 
      meetingSpot: 'meetingSpot', 
      price: '0', 
      quantity: '0',
      user: 'uid');
    Zotuser blankUser = Zotuser(email: '', uid: '', username: '');

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter',),
      initialRoute: '/',
      routes: {
        //now goes to initialscreen and this checks to see if a user was logged in or not
        '/': (context) => const InitialScreen(),
        //then go to the verification screen to get verified if the user has not been
        '/verification': (context) => const VerificationScreen(),
        //go to the loading screen to get all the listings from the db
        '/loading_home': (context) => const LoadingHome(),
        //display all of the listings in the homepage
        '/home': (context) => Home(allListings: const [], zotuser: blankUser),
        //show each listing seperately
        '/listing': (context) => ListingScreen(listingItem: blank, zotuser: blankUser),
        //screen for addding a listing
        '/add_listing' : (context) => AddListing(user: blankUser,),
        //screen for previewing a listing before adding one
        '/preview_listing' : (context) => PreviewListingScreen(listingItem: blank, zotuser: blankUser, images: [],),
      },
    );
  }
}
