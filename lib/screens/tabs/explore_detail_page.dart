import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/components/components.dart';

class ExploreDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> currentSelectedPlaceData;
  const ExploreDetailPage({super.key, required this.currentSelectedPlaceData});

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage> {
  int _currentIndex =
      0; // this holds the index of the current image on another carousel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // this is the top carousel sliding image section
            topSlidingImageSection(context),

            // this is the details and rating section
            placeDetailsAlongWithRating(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      spacing: 12,
                      children: <Widget>[
                        const Icon(Icons.diamond, size: 50),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'This is a rare find',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '${widget.currentSelectedPlaceData['vendor'].split(' ')[0]}\'s place is usually fully booked.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),

                    Row(
                      spacing: 12,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(32),
                          child: Image.network(
                            widget.currentSelectedPlaceData['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Stay with ${widget.currentSelectedPlaceData['vendor'].split(' ')[0]}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              '${widget.currentSelectedPlaceData['vendorProfession']}. 10 years hosting',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding placeDetailsAlongWithRating(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.currentSelectedPlaceData['title'],
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 12),

          Text(
            'Room in ${widget.currentSelectedPlaceData['address']}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),

          Text(
            widget.currentSelectedPlaceData['bedAndBathroom'],
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      widget.currentSelectedPlaceData['rating'].toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    StarRating(
                      rating: widget.currentSelectedPlaceData['rating'],
                    ),
                  ],
                ),

                Text(
                  'Guest\nFavorite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Column(
                  children: <Widget>[
                    Text(
                      widget.currentSelectedPlaceData['review'].toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Reviews',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 0.8,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack topSlidingImageSection(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: AnotherCarousel(
            images:
                (widget.currentSelectedPlaceData['imageUrls'] as List<dynamic>)
                    .map((dynamic url) {
                      return CachedNetworkImage(
                        imageUrl: url.toString(),
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget:
                            (BuildContext context, String url, Object error) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                      );
                    })
                    .toList(),
            showIndicator: false,
            onImageChange: (int prev, int next) {
              setState(() {
                _currentIndex = next;
              });
            },
            boxFit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black45,
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.currentSelectedPlaceData['imageUrls'].length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Positioned(
          top: 30,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const RoundIconButton(
                  icon: Icons.arrow_back_ios_new,
                  iconSize: 24,
                ),
              ),

              Row(
                spacing: 10,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: const RoundIconButton(
                      icon: Icons.share,
                      iconSize: 24,
                    ),
                  ),

                  GestureDetector(
                    child: const RoundIconButton(
                      icon: Icons.favorite_border,
                      iconSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
