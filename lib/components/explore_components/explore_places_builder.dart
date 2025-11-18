import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/screens/screens.dart';

class ExplorePlacesBuilder extends StatefulWidget {
  const ExplorePlacesBuilder({super.key});

  @override
  State<ExplorePlacesBuilder> createState() => _ExplorePlacesBuilderState();
}

class _ExplorePlacesBuilderState extends State<ExplorePlacesBuilder> {
  // Collection Reference for the list of places
  final CollectionReference<Map<String, dynamic>> placesCollection =
      FirebaseFirestore.instance.collection('CollectionOfPlaces');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: placesCollection.snapshots(),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              itemBuilder: (BuildContext context, int index) {
                // final QueryDocumentSnapshot<Map<String, dynamic>> place =
                //     snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (_) => ExploreDetailPage(
                            currentSelectedPlaceData:
                                snapshot.data!.docs[index],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 367,
                                width: 400,
                                child: AnotherCarousel(
                                  images:
                                      (snapshot.data!.docs[index]['imageUrls']
                                              as List<dynamic>)
                                          .map<Widget>((dynamic url) {
                                            return CachedNetworkImage(
                                              imageUrl: url.toString(),
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  (
                                                    BuildContext context,
                                                    String url,
                                                  ) => const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                              errorWidget:
                                                  (
                                                    BuildContext context,
                                                    String url,
                                                    Object error,
                                                  ) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                            );
                                          })
                                          .toList(),
                                  indicatorBgPadding: 10,
                                  dotBgColor: Colors.transparent,
                                  dotSize: 4,
                                  dotColor: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 15,
                              left: 10,
                              child: Row(
                                children: <Widget>[
                                  snapshot.data!.docs[index]['isActive']
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.inversePrimary,
                                            border: Border.all(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3,
                                            ),
                                            child: Text(
                                              'Guest favorite',
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),

                            Positioned(
                              top: 5,
                              right: 10,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 15,
                              left: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!
                                      .docs[index]['vendorProfile'],
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          const Center(
                                            child: Text('Loading..'),
                                          ),
                                  errorWidget:
                                      (
                                        BuildContext context,
                                        String url,
                                        Object error,
                                      ) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data!.docs[index]['address'],
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Stay with ${snapshot.data!.docs[index]['vendor']} - ${snapshot.data!.docs[index]['vendorProfession']}',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d').format(
                                    DateTime.parse(
                                      snapshot.data!.docs[index]['date'],
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),

                                Text(
                                  '\$${snapshot.data!.docs[index]['price']} per night',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              spacing: 3,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                Text(
                                  snapshot.data!.docs[index]['rating']
                                      .toString(),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
    );
  }
}
