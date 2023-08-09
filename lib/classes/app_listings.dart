import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppListings
{
  late String docId;
  late Timestamp time; 
  late String description;
  late List<dynamic> imgUrl;
  late List tags;
  late String itemTitle;
  late String meetingSpot;
  //TODO: It would make sense for these variables to be numbers, but console complains that int is not a subtype of double. Is firebase storing a number as an int? not a double?
  late String price;
  late String quantity;
  late String user; //this will hold the uid associated with the item

  //time is a timestamp that can be used to get posting date & time
  //Should be able to get them from db based on asc timestamp
  //late String time;

  //constructor for the class. Requires all of the attributes stored in the listing db
  AppListings({
    required this.docId,
    required this.time,
    required this.description,
    required this.imgUrl,
    required this.tags,
    required this.itemTitle,
    required this.meetingSpot,
    required this.price,
    required this.quantity,
    required this.user
    //required this.time,
  });

  //add methods for a listing down here:

  //method to turn firestore data into a listing
  factory AppListings.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,)
  {
    final data = snapshot.data();
    var f = NumberFormat("###.00", "en_US");
    var money = f.format(double.parse(data?['price']));
    //WARNING: SHOULD NOT DO THIS CONVERSION HERE. ONLY DO IT IN OTHER FILES TO DISPLAY
    //Turns the timestamp object stored in Firebase into a readable date and time
    //doc: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
    //String date = DateFormat("MMM d, y  h:mm a").format(data!['time'].toDate());
    //we don't know docId so leaving blank for now
    return AppListings(
    docId: '', 
    time: data!['time'], 
    description: data['description'], 
    imgUrl: data['imgUrl'], 
    tags: data['tags'],
    itemTitle: data['itemTitle'], 
    meetingSpot: data['meetingSpot'],  
    price: money, 
    quantity: data['quantity'],
    user: data['user']);
  }

  //method to turn a listing into FireStore data
  //docId attribute is not needed
  Map<String, dynamic> toFirestore()
  {
    return {
      'description' : description,
      'imgUrl' : imgUrl,
      'tags' : tags,
      'itemTitle' : itemTitle,
      'meetingSpot' : meetingSpot,
      'price' : price,
      'quantity' : quantity,
      'time' : time,
      'user' : user
    };
  }
}