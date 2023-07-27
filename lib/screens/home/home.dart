import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/screens/add_listing.dart';
import 'package:zot_sell/screens/authenticate/auth_page.dart';
import 'package:zot_sell/screens/listing_screen.dart';

import '../../classes/app_listings.dart';
import '../../classes/home_listing_card.dart';
import '../../classes/zotuser.dart';

/// The `Home` class is a `StatefulWidget` that displays a list of Applistings and provides a drawer with
/// options for the user, such as signing out.
class Home extends StatefulWidget {
  const Home({super.key, required this.allListings, required this.zotuser});

  //Declaring a list that holds all of the AppListings
  final List<AppListings> allListings;
  final Zotuser zotuser;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //defining database:
  final database = FirebaseFirestore.instance;

  

  @override
  Widget build(BuildContext context) {

    //accessing Applistings from allListings
    List<AppListings> allListings = widget.allListings;

    //accessing zotuser from the zotuser passed in from the loading screen:
    Zotuser zotuser = widget.zotuser;
    print(zotuser.username);

    List<Widget> createChips(AppListings listingItem)
    {
      List<Widget> chips = [];
      for(int i = 0; i < 3; i++)
      {
        var chip = Chip(label: Text(listingItem.tags[i]));
        chips.add(chip);
        chips.add(const SizedBox(width: 5));
      }
      return chips;
    }


    //method to go to a page with the listing displayed:
    void viewListing(int index)
    {
      Navigator.push(
        context, MaterialPageRoute(
          settings: const RouteSettings(name: '/listing'),
          builder: (context) => ListingScreen(listingItem: allListings[index], zotuser: zotuser,)
          )
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      //added drawer to hold different buttons/actions
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                )
            ),
            ListTile(
              title: Text('${zotuser.username} is signed in'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
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
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          'Listings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //what to do after button is pressed
          //going to AddListing screen when it is pressed
          //need to use Navigator pushreplace here:
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context,
              MaterialPageRoute(
                settings: const RouteSettings(name: '/add_listing'),
                builder: (context) => AddListing())
            );
          });
        },
        backgroundColor: Colors.blue[300],
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: allListings.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              child: Card(
                elevation: 3,
                child: HomeListingCard(listingItem: allListings[index],)
              ),
            );
          }),
    );
  }
}
