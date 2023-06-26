import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/classes/listings.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.allListings});

  //Declaring a list that holds all of the Listings
  final List<Listings> allListings;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //defining database:
  final database = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    //accessing listings from allListings
    List<Listings> allListings = widget.allListings;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          'Listings',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      Text(allListings[index].description),
                      //spacer
                      const SizedBox(height: 10),
                      //Listing price
                      Text(
                        'Price: \$${allListings[index].price}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
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
                      child: CachedNetworkImage(
                        imageUrl: allListings[index].imgUrl,
                        progressIndicatorBuilder: (context, url, downloadProgress) => 
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image.asset('assets/images/404.jpg'),
                      )
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
