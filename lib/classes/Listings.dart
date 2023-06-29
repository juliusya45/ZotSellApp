//specifies what a Listing is. Modeled after what is stored in our db

// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Listings
{
  late String docId;
  late String time;
  late String description;
  late String imgUrl;
    //tags for each listing. Maybe there's a better way to do this??
  late bool isAcceptable;
  late bool isAthletics;
  late bool isClothing;
  late bool isElectronics;
  late bool isGood;
  late bool isJewelry;
  late bool isNew;
  late bool isShoes;
  late String itemTitle;
  late String meetingSpot;
  late String phoneNum;
  late String price;
  late String quantity;
  //not too sure if we need this time stamp, items should be sorted based
  //on how they are gotten from the db in order.
  //Should be able to get them from db based on asc timestamp
  //late String time;

  //constructor for the class. Requires all of the attributes stored in the listing db
  Listings({
    required this.docId,
    required this.time,
    required this.description,
    required this.imgUrl,
    required this.isAcceptable,
    required this.isAthletics,
    required this.isClothing,
    required this.isElectronics,
    required this.isGood,
    required this.isJewelry,
    required this.isNew,
    required this.isShoes,
    required this.itemTitle,
    required this.meetingSpot,
    required this.phoneNum,
    required this.price,
    required this.quantity,
    //required this.time,
  });

  //add methods for a listing down here:

  //method to turn firestore data into a listing
  factory Listings.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,)
  {
    final data = snapshot.data();

    String date = DateFormat("MMMM d, y  h:mm a").format(data!['time'].toDate());
    //we don't know docId so leaving blank for now
    return Listings(
    docId: '', 
    time: date, 
    description: data?['description'], 
    imgUrl: data?['imgUrl'], 
    isAcceptable: data?['isAcceptable'], 
    isAthletics: data?['isAthletics'], 
    isClothing: data?['isClothing'], 
    isElectronics: data?['isElectronics'], 
    isGood: data?['isGood'], 
    isJewelry: data?['isJewelry'], 
    isNew: data?['isNew'], 
    isShoes: data?['isShoes'], 
    itemTitle: data?['itemTitle'], 
    meetingSpot: data?['meetingSpot'], 
    phoneNum: data?['phoneNum'], 
    price: data?['price'], 
    quantity: data?['quantity']);
  }

  //method to turn a listing into FireStore data
  //docId attribute is not needed
  //TODO: check to see if I need to remove null check
  Map<String, dynamic> toFirestore()
  {
    return {
      if (time != null) 'time' : time,
      if (description != null) 'description' : description,
      if (imgUrl != null) 'imgUrl' : imgUrl,
      if (isAcceptable != null) 'isAcceptable' : isAcceptable,
      if (isAthletics != null) 'isAthletics' : isAthletics,
      if (isClothing != null) 'isClothing' : isClothing,
      if (isElectronics != null) 'isElectronics' : isElectronics,
      if (isGood != null) 'isGood' : isGood,
      if (isJewelry != null) 'isJewelry' : isJewelry,
      if (isNew != null) 'isNew' : isNew,
      if (isShoes != null) 'isShoes' : isShoes,
      if (itemTitle != null) 'itemTitle' : itemTitle,
      if (meetingSpot != null) 'meetingSpot' : meetingSpot,
      if (phoneNum != null) 'phoneNum' : phoneNum,
      if (price != null) 'price' : price,
      if (quantity != null) 'quantity' : quantity,
    };
  }
}