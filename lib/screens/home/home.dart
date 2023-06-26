import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/classes/listings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //defining database:
  final database = FirebaseFirestore.instance;

  //list for all the Listing items to be displayed
  
  //TODO: there needs to be a method beforehand that gets all the Listings (docs)
  //and puts them into this list
  //YAYA IT WORKS :)
  void getAllListings() async
  {
      await database.collection('listings').get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });
  }

  @override
  void initState()
  {
    super.initState();
    getAllListings();
  }


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
      description: 'Fleece tan sweater -- super cozy!',
      imgUrl: 'https://firebasestorage.googleapis.com/v0/b/zot-list.appspot.com/o/images%2F1GXUCfu9trXFUYTmnpIK.png?alt=media&token=f45b6864-ad5e-4f12-b335-ae50289c6a99',
      isAcceptable: false,
      isAthletics: false,
      isClothing: true,
      isElectronics: false,
      isGood: false,
      isJewelry: false,
      isNew: true,
      isShoes: false,
      itemTitle: 'Winter Sweater',
      meetingSpot: 'Middle Earth',
      phoneNum: '(320) 928-2830',
      price: '50',
      quantity: '1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          'Listings',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
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
              elevation: 3,
              child: ListTile(
                onTap: () {
                  //method to view that listing;
                },
                //Putting the title, descirption, and price of listings in a column
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Listing title
                    Text(
                      allListings[index].itemTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //spacer
                    const SizedBox(height: 15),
                    //Listing description
                    Text(
                      allListings[index].description
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    //Listing price
                    Text(
                      'Price: \$${allListings[index].price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                //Avatar that shows picture of the item
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    height: 70,
                    width: 70,
                    //Shows an image based on the link of the image
                    child: Image.network(allListings[index].imgUrl),
                    ),
                ),
              ),
            ),
          );
        }
        ),
    );
  }
}