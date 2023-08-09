import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'app_listings.dart';

class HomeListingCard extends StatelessWidget {
  const HomeListingCard({
    super.key,
    required this.listingItem
    });

    final AppListings listingItem;

  @override
  Widget build(BuildContext context) {

    List<Widget> createChips(AppListings listingItem)
    {
      List<Widget> chips = [];
      for(int i = 0; i < 3; i++)
      {
        var chip = Chip(label: Text(listingItem.tags[i]));
        chips.add(chip);
      }
      return chips;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child:
                    Center(
                      child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: SizedBox(
                              height: 145,
                              width: 145,
                              //Shows an image based on the link of the image passed into this class
                              child: CachedNetworkImage(
                                //Image is now shown as a square with 1:1 ratio. The full image is still uploaded
                                fit: BoxFit.cover,
                                imageUrl: listingItem.imgUrl[0],
                                progressIndicatorBuilder: (context, url, downloadProgress) => 
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Image.asset('assets/images/404.jpg'),
                              )
                            ),
                      ),
                    ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          listingItem.itemTitle,
                          style: const TextStyle(
                            fontSize: 22,
                          fontWeight: FontWeight.bold
                          ),
                          ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            listingItem.description,
                            style: const TextStyle(
                              fontSize: 14
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Price: \$${listingItem.price}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                            ),
                          )
                      ],
                    ),
                  )
                  )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: createChips(listingItem),
            )
          ],
        ),
      ),
    );
  }
}