import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
        chips.add(const SizedBox(width: 5));
      }
      return chips;
    }

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child:
                  ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          //Shows an image based on the link of the image passed into this class
                          child: CachedNetworkImage(
                            imageUrl: listingItem.imgUrl,
                            progressIndicatorBuilder: (context, url, downloadProgress) => 
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) => Image.asset('assets/images/404.jpg'),
                          )
                        ),
                  ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(listingItem.itemTitle),
                    SizedBox(height: 10),
                    Text(listingItem.description),
                  ],
                )
                )
            ],
          ),
          Row(
            children: createChips(listingItem),
          )
        ],
      ),
    );
  }
}