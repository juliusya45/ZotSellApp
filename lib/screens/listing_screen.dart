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
        title: Text(listingItem.itemTitle),
      ),
    );
  }
}