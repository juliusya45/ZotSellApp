//specifies what a Listing is. Modeled after what is stored in our db

class Listings
{
  late String datePosted;
  late String description;
  late String imgUrl;
    //tags for each listing. Maybe there's a better way to do this??
  late String isAcceptable;
  late String isAthletics;
  late String isClothing;
  late String isElectronics;
  late String isGood;
  late String isJewelry;
  late String isNew;
  late String isShoes;
  late String itemTitle;
  late String meetingSpot;
  late String phoneNum;
  late String price;
  late String quantity;
  late String time;

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
    required this.time,
  });

  //add methods for a listing down here:
}