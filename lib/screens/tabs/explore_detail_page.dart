// ignore_for_file: always_specify_types

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/components/components.dart';
import 'package:travel_app/models/message_model.dart';
import 'package:travel_app/provider/favorite_provider.dart';
import 'package:travel_app/provider/messages_provider.dart';
import 'package:travel_app/provider/tabs_selected_provider.dart';

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
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // this is the top carousel sliding image section
              topSlidingImageSection(context),

              // this is the details and rating section
              widget.currentSelectedPlaceData['isActive']
                  ? placeDetailsAlongWithRating(context)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            '${widget.currentSelectedPlaceData['rating'].toString()} . ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          GestureDetector(
                            child: Text(
                              '${widget.currentSelectedPlaceData['review'].toString()} reviews',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),
                    InfoRowCard(
                      leading: const Icon(
                        Icons.diamond,
                        size: 50,
                        color: Colors.purple,
                      ),
                      title: 'This is a rare find',
                      subtitle:
                          '${widget.currentSelectedPlaceData['vendor'].split(' ')[0]}\'s place is usually fully booked.',
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),
                    InfoRowCard(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          widget.currentSelectedPlaceData['vendorProfile'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title:
                          'Stay with ${widget.currentSelectedPlaceData['vendor'].split(' ')[0]}',
                      subtitle:
                          '${widget.currentSelectedPlaceData['vendorProfession']}. 10 years hosting',
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),

                    InfoRowCard(
                      leading: Icon(
                        Icons.room_service,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: 'Room in a rental unit',
                      subtitle:
                          'Your own room in a home, and access to shared spaces.',
                    ),

                    InfoRowCard(
                      leading: Icon(
                        Icons.people_outline,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: 'Shared common spaces',
                      subtitle: "You'll share parts of the home with the host.",
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'About this place',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'This place offers a warm and welcoming stay designed for comfort and convenience. Set in a peaceful neighborhood, it provides easy access to nearby attractions, local markets, and transportation. Guests can enjoy well-maintained rooms, thoughtfully curated amenities, and inviting shared spaces. The host is known for exceptional hospitality and attention to detail, ensuring a smooth and pleasant visit. Whether you\'re here for a short getaway or a longer stay, this home provides a perfect balance of relaxation and exploration.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Where you\'ll be',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            widget.currentSelectedPlaceData['address'],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: LocationInMap(
                                place: widget.currentSelectedPlaceData,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: const Border(
              top: BorderSide(color: Colors.black12, width: 1),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '\$${widget.currentSelectedPlaceData['price']} per night',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d').format(
                      DateTime.parse(widget.currentSelectedPlaceData['date']),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  final provider = context.read<MessagesProvider>();
                  final placeId = widget.currentSelectedPlaceData.id;

                  final message = MessageModel(
                    placeId: placeId,
                    vendor: widget.currentSelectedPlaceData['vendor'],
                    vendorProfile:
                        widget.currentSelectedPlaceData['vendorProfile'],
                    image: widget.currentSelectedPlaceData['image'],
                    message: 'Your reservation has been confirmed',
                    time: DateTime.now(),
                  );

                  provider.addMessage(message);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reservation confirmed')),
                  );

                  Future.delayed(const Duration(milliseconds: 300), () {
                    // ignore: use_build_context_synchronously
                    TabsSelectedProvider.of(context, listen: false).setIndex(3);
                  });
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color:
                        // context.read<MessagesProvider>().isReserved(
                        //   widget.currentSelectedPlaceData.id,
                        // )
                        // ? const Color.fromARGB(255, 247, 186, 206)
                        Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Reserve',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
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

                  Consumer<FavoriteProvider>(
                    builder:
                        (
                          BuildContext context,
                          FavoriteProvider provider,
                          Widget? child,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              provider.toggleFavoritePlaces(
                                widget.currentSelectedPlaceData,
                              );
                            },
                            child: RoundIconButton(
                              icon:
                                  provider.doesFavoritePlaceExist(
                                    widget.currentSelectedPlaceData,
                                  )
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_outlined,
                              iconColor:
                                  provider.doesFavoritePlaceExist(
                                    widget.currentSelectedPlaceData,
                                  )
                                  ? Colors.red
                                  : Colors.white,
                              iconSize: 24,
                            ),
                          );
                        },
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
