import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/classes/listings.dart';

class ListingScreen extends StatefulWidget {
  final Listings listingItem;
  const ListingScreen({super.key, required this.listingItem});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {


  @override
  Widget build(BuildContext context) {
    Listings listingItem = widget.listingItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(listingItem.itemTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 158, 64),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('Posted On: ${listingItem.time}'),
          SizedBox(height: 25),
          Center(
            child: Container(
              height: 250,
              width: 380,
              child: Card(
                elevation: 4,
                child: CachedNetworkImage(
                  imageUrl: listingItem.imgUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) => 
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Image.asset('assets/images/404.jpg'),
                  ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  
                  )
                ),
                ),
              //shape: add in details here to make a border
        ],
      ),
    );
  }
}