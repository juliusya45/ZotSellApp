
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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

  final pageController = PageController(viewportFraction: 1, keepPage: true, );

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

//This is derived from EX code from: https://github.com/bluefireteam/photo_view/blob/main/example/lib/screens/examples/gallery/gallery_example.dart
//This sends an index to build a Photo View Gallery that displays the image stored at that index
  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: imageUrls,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
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
                          itemCount: imageUrls.length,
                          itemBuilder: (_, index)
                          {
                            return GestureDetector(
                              onTap: () {
                                //old code for just showing an enlarged version of one image
                                // showDialog(context: context, 
                                // builder: (BuildContext context)
                                // {
                                //   return PhotoView(
                                //     imageProvider: NetworkImage(imageUrls[index]),
                                //     backgroundDecoration: BoxDecoration(color: Color.fromARGB(157, 0, 0, 0)),
                                //     minScale: PhotoViewComputedScale.contained,
                                //     );
                                // }
                                // );
                                open(context, index);
                              },
                              child: CachedNetworkImage(
                                                    imageUrl: imageUrls[index],
                                                    progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                                    errorWidget: (context, url, error) =>
                              Image.asset('assets/images/404.jpg'),
                                                  ),
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
            const SizedBox(
              height: 10,
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
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                minimumSize: Size(90, 50)
                ), 
              child: const Text(
                'Buy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                ),
            ),
            SizedBox(height: 30)
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
  final List<String> galleryItems;
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
              child: BackButton(
                color: Colors.white,
              )
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    //The "item" is a url that is then parsed as an image
    final String item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(item),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.8),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
  }
}
