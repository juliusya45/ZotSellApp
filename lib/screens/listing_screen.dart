import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/zotuser.dart';

class ListingScreen extends StatefulWidget {
  final AppListings listingItem;
  final Zotuser zotuser;
  const ListingScreen({super.key, required this.listingItem, required this.zotuser});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  Widget build(BuildContext context) {
    AppListings listingItem = widget.listingItem;
    Zotuser zotuser = widget.zotuser;

    List<Widget> createChips()
    {
      List<Widget> chips = [];
      for(int i = 0; i < listingItem.tags.length; i++)
      {
        var chip = Chip(label: Text(listingItem.tags[i]));
        chips.add(chip);
        chips.add(SizedBox(width: 5));
      }
      return chips;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          listingItem.itemTitle,
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 158, 64),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Center(
            child: Container(
                height: 250,
                width: 375,

                child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green[300]!, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: CachedNetworkImage(
                      imageUrl: listingItem.imgUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/404.jpg'),
                    ))),
          ),
          SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Posted On: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(listingItem.time,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Posted By: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(zotuser.username,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 375,
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green[300]!, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 10),
                            Text(
                              listingItem.description,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10,),
                            Text('Meeting Spot:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 10),
                            Text(
                              listingItem.meetingSpot,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text('Tags:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            //Trying to add a row of tags with the tag name on them
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Row(
                                children: createChips(),
                              ),
                            ),
                          ],
                        ),
                      ))),
            ),
          ),
          SizedBox(height: 10),
          //TODO: add price and quantity underneath the description
          
        ],
      ),
    );
  }
}
