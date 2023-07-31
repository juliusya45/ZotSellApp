import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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

  final pageController = PageController(viewportFraction: 0.8, keepPage: true, );

  @override
  Widget build(BuildContext context) {
    AppListings listingItem = widget.listingItem;
    Zotuser zotuser = widget.zotuser;
    List<String> imageUrls = [];

    //This for loop adds multiple images to the list of strings
    for(int i = 0; i < listingItem.imgUrl.length; i++)
    {
      imageUrls.add(listingItem.imgUrl[i]);
    }

    List<Widget> createChips()
    {
      List<Widget> chips = [];
      for(int i = 0; i < listingItem.tags.length; i++)
      {
        var chip = Chip(label: Text(listingItem.tags[i]));
        chips.add(chip);
        chips.add(const SizedBox(width: 5));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Center(
              child: SizedBox(
                  height: 250,
                  width: 375,
      
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green[300]!, width: 3),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: imageUrls.length,
                          itemBuilder: (_, index)
                          {
                            return CachedNetworkImage(
                        imageUrl: imageUrls[index],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/404.jpg'),
                      );
                          }
                        ),
                      ),
                    ),
              ),
            ),
                  
            
            SmoothPageIndicator(
                          controller: pageController,
                          count: imageUrls.length,
                          effect: ExpandingDotsEffect(
                            
                            dotHeight: 16,
                            dotWidth: 16,
                            dotColor: Colors.green[300]!,
                            activeDotColor: Color.fromARGB(255, 221, 158, 64)
                          ),
                        ),
            const SizedBox(height: 15),
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
                    //Turns the timestamp object stored in Firebase into a readable date and time
                    Text(DateFormat("MMM d, y  h:mm a").format(listingItem.time.toDate()),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
                  ],
                ),
              ),
            ),
            const SizedBox(
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
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 375,
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green[300]!, width: 3),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Description:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20)),
                              const SizedBox(height: 10),
                              Text(
                                listingItem.description,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10,),
                              const Text('Meeting Spot:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20)),
                              const SizedBox(height: 10),
                              Text(
                                listingItem.meetingSpot,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              const Text('Tags:',
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
            const SizedBox(height: 10),
            //TODO: add price and quantity underneath the description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text(
                    'Price: \$',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      listingItem.price,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text(
                    'Quantity: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      listingItem.quantity,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(elevation: MaterialStatePropertyAll(5)), 
              child: const Text('Buy'),
            )
          ],
        ),
      ),
    );
  }
}
