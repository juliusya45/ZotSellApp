import 'package:flutter/material.dart';
import 'package:zot_sell/classes/listings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //list for all the Listing items to be displayed
  
  //TODO: there needs to be a method beforehand that gets all the Listings (docs)
  //and puts them into this list

  //for now going to put two listings manually to test with
  List<Listings> allListings = [
    Listings(
      datePosted: '2023-02-12',
      description: 'A lightly used Wilson basketball -- use on any of the on-campus courts!',
      imgUrl: 'https://firebasestorage.googleapis.com/v0/b/zot-list.appspot.com/o/images%2F0ggZKemWVFZV5CrujRJq.png?alt=media&token=3841e906-08dd-48b8-8683-b3c1a0e136e0',
      isAcceptable: false,
      isAthletics: true,
      isClothing: false,
      isElectronics: false,
      isGood: true,
      isJewelry: false,
      isNew: false,
      isShoes: false,
      itemTitle: 'Basketball',
      meetingSpot: 'Student Health Center near Middle Earth',
      phoneNum: '(402) 910-4820',
      price: '10',
      quantity: '1',
    ),
    Listings(
      datePosted: '2023-02-15',
      description: 'A high-quality silver bracelet from Kate Spade',
      imgUrl: 'https://firebasestorage.googleapis.com/v0/b/zot-list.appspot.com/o/images%2F1GXUCfu9trXFUYTmnpIK.png?alt=media&token=f45b6864-ad5e-4f12-b335-ae50289c6a99',
      isAcceptable: false,
      isAthletics: false,
      isClothing: true,
      isElectronics: false,
      isGood: true,
      isJewelry: true,
      isNew: false,
      isShoes: false,
      itemTitle: 'Silver Bracelet',
      meetingSpot: 'Mesa Court',
      phoneNum: '(204) 904-1042',
      price: '10',
      quantity: '1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text('Listings'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //what to do after button is pressed
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
              child: ListTile(
                onTap: () {
                  //method to view that listing;
                },
                title: Text(allListings[index].itemTitle),
                leading: CircleAvatar(
                  //squiggly lines required for square brakets
                  backgroundImage: Image.network(allListings[index].imgUrl).image,
                ),
              ),
            ),
          );
        }
        ),
    );
  }
}