import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rive/rive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zot_sell/classes/app_listings.dart';
import 'package:zot_sell/classes/zotuser.dart';
import 'package:zot_sell/screens/loading_screens/loading_home.dart';

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

  final pageController = PageController(viewportFraction: 1, keepPage: true, );
  //these valuenotifiers allow the scren to listen to these variables so the
  //listing btn can be replaced with the loading indicator
  ValueNotifier<bool> showLoading = ValueNotifier(false);
  ValueNotifier<String> animation = ValueNotifier("Loading");
  @override
  initState()
  {
    super.initState();
  }

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
    
    //for the loading animation
    //gives 2 seconds before going back to home screen
    Timer? sendHomeTime;

//This is derived from EX code from: https://github.com/bluefireteam/photo_view/blob/main/example/lib/screens/examples/gallery/gallery_example.dart
//This sends an index to build a Photo View Gallery that displays the image stored at that index
//Shouldn't be using imgUrls as images aren't uploaded until the List button is pressed
  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: images,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

    Future uploadImagesToFirebase(BuildContext context) async
    {
      final firebaseStorage = FirebaseStorage.instance.ref();
      for(int i = 0; i < images.length; i++)
      {
        File image = File(images[i].path);
        String filePath = image.path;
        //Creates a fileName that matches listingID on Firestore
        String fileName = "${docRef.id}-$i${p.extension(filePath)}";
        var fileRef = firebaseStorage.child("images/$fileName");
        await fileRef.putFile(image);
        //getting the file download URL and storing it in a list:
        imgUrls.add(await fileRef.getDownloadURL());
        print(fileName);
      }
    }

    //creates the tag chips
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

    //navigates back to the home and removes the timer
    //destroys previous paths as well
    void sendToHome()
    {
      Navigator.of(context)
      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoadingHome()), (route) => false);
      sendHomeTime?.cancel();
    }

    Widget loadingIndicator()
    {
      print("show indicator");
      return Center(
              child: SizedBox(
                height: 110,
                width: 110,
                //animation editor: https://editor.rive.app/file/loading/477204
                //docs: https://help.rive.app/runtimes/playback
                child: RiveAnimation.asset('assets/loading.riv',
                animations: [animation.value],)
              )
            );
    }

    //This widget is for the button that allows the user to list the item
    Widget listButton()
    {
      return ElevatedButton(
                  //here is where the listing is uploaded
                  onPressed: () async {
                    setState(() {
                      showLoading.value = true;
                      print("set True");
                      //print(showLoading);
                    });
                    //need to first complete filling out some data before uploading:
                    listingItem.time = Timestamp.now();
                    listingItem.docId = docRef.id;
                    //need to upload images:
                    await uploadImagesToFirebase(context);
                    //once uploaded put the urls in the listingItem:
                    listingItem.imgUrl = imgUrls;
                    await docRef.set(listingItem);
                    setState(() {
                      animation.value= "Success";
                      print("set animation");
                    });
                    //TODO: ADD LOADING CIRCLE HERE TO INDICATE BUTTON WAS CLICKED
                    //MAYBE HAVE IT REPLACE THE BUTTON OR SOMETHING SO IT CAN'T BE PRESSED TWICE
                    sendHomeTime = Timer.periodic(const Duration(seconds: 2), (timer) => sendToHome());
                    
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(90, 50),
                    elevation: 5,
                  ), 
                  child: const Text(
                    'List Item!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                );
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
                  height: 375,
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
                            return GestureDetector(
                              onTap: () {
                                open(context, index);
                              },
                              child: Image.file(
                              File(images[index % images.length].path),
                              fit: BoxFit.contain
                              )
                            );
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
                            activeDotColor: const Color.fromARGB(255, 221, 158, 64)
                          ),
                        ),
            const SizedBox(height: 20),
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
                              Row(
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
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  const Text(
                                    'Posted By: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  Text(zotuser.username,
                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
                                ],
                              ),
                              const Divider(
                                thickness: 3,
                                height: 20,
                                indent: 20,
                                endIndent: 20,
                              ),
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
                                child: Wrap(
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
            const SizedBox(height: 10,),
            showLoading.value ? loadingIndicator() : listButton(),
            const SizedBox(height: 50)
          ],
        ),
      ),
      
    );
  }
}

//This class is from the API docs provided by the photo_view package
class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({super.key, 
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  //galleryItems is a list of urls that are then parsed as images
  final List<XFile> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          //might need to change alignment to center?
          alignment: Alignment.center,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              alignment: Alignment.topLeft,
              child: const BackButton(
                color: Colors.white,
              )
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    //The item is an XFile
    final XFile item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(item.path)),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.8),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
  }
}



