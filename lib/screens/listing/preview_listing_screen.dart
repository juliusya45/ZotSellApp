import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/zotuser.dart';

class PreviewListingScreen extends StatefulWidget {
  final AppListings listingItem;
  final Zotuser zotuser;
  final List<XFile> images;
  const PreviewListingScreen({super.key, required this.listingItem, required this.zotuser, required this.images});

  @override
  State<PreviewListingScreen> createState() => _PreviewListingScreenState();
}

class _PreviewListingScreenState extends State<PreviewListingScreen> {

  final db = FirebaseFirestore.instance;

  final pageController = PageController(viewportFraction: 0.8, keepPage: true, );


  @override
  Widget build(BuildContext context) {

    final docRef = db
                .collection("appListings")
                .withConverter(
                  fromFirestore: AppListings.fromFirestore, 
                  toFirestore: (AppListings appListing, _) => appListing.toFirestore()
                ).doc();
    List<XFile> images = widget.images;
    AppListings listingItem = widget.listingItem;
    Zotuser zotuser = widget.zotuser;

    List<String> imgUrls = [];

    Future uploadImagesToFirebase(BuildContext context) async
    {
      final _firebaseStorage = FirebaseStorage.instance.ref();
      for(int i = 0; i < images.length; i++)
      {
        File image = File(images[i].path);
        String filePath = image.path;
        //Creates a fileName that matches listingID on Firestore
        String fileName = docRef.id + "-" + i.toString() + p.extension(filePath);
        var fileRef = _firebaseStorage.child("images/$fileName");
        await fileRef.putFile(image);
        //getting the file download URL and storing it in a list:
        imgUrls.add(await fileRef.getDownloadURL());
        print(fileName);
      }
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
                          itemCount: images.length,
                          itemBuilder: (_, index)
                          {
                            return Image.file(File(images[index % images.length].path));
                          }
                        ),
                      ),
                    )
                  ),
            ),
            SmoothPageIndicator(
                          controller: pageController,
                          count: images.length,
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
              //here is where the listing is uploaded
              onPressed: () async {
                //need to first complete filling out some data before uploading:
                listingItem.time = Timestamp.now();
                listingItem.docId = docRef.id;
                //need to upload images:
                await uploadImagesToFirebase(context);
                //once uploaded put the urls in the listingItem:
                listingItem.imgUrl = imgUrls[0];
                await docRef.set(listingItem);
              },
              style: const ButtonStyle(elevation: MaterialStatePropertyAll(5)), 
              child: const Text('List Item!'),
            ),
          ],
        ),
      ),
      
    );
  }
}
