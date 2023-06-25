//specifies what a Listing is. Modeled after what is stored in our db

class Listings
{
  late String datePosted;
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
    required this.datePosted,
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
}