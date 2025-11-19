import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/provider/favorite_provider.dart';
import 'package:travel_app/provider/tabs_selected_provider.dart';
import 'package:travel_app/components/components.dart';
import 'package:travel_app/screens/screens.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteProvider provider = FavoriteProvider.of(context);
    final List<String> favoritePlacesList = provider.favorites;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Favorites',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 20),
              favoritePlacesList.isEmpty
                  ? Center(
                      child: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'No Favorites yet...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Colors.blueAccent,
                                  Colors.purpleAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 32,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary,
                              ),
                              onPressed: () {
                                Provider.of<TabsSelectedProvider>(
                                  context,
                                  listen: false,
                                ).setIndex(0);
                              },
                              child: const Text(
                                'Start browsing places',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemCount: favoritePlacesList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('CollectionOfPlaces')
                              .doc(favoritePlacesList[index])
                              .get(),
                          builder:
                              (
                                BuildContext context,
                                AsyncSnapshot<
                                  DocumentSnapshot<Map<String, dynamic>>
                                >
                                snapshot,
                              ) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    final QuerySnapshot<Map<String, dynamic>>
                                    querySnapshot = await FirebaseFirestore
                                        .instance
                                        .collection('CollectionOfPlaces')
                                        .where(
                                          FieldPath.documentId,
                                          isEqualTo: favoritePlacesList[index],
                                        )
                                        .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      final QueryDocumentSnapshot<
                                        Map<String, dynamic>
                                      >
                                      placeDoc = querySnapshot.docs.first;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<Widget>(
                                          builder: (_) => ExploreDetailPage(
                                            currentSelectedPlaceData: placeDoc,
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              snapshot.data!['image'],
                                            ),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            Provider.of<FavoriteProvider>(
                                              context,
                                              listen: false,
                                            ).toggleFavoritePlaces(
                                              snapshot.data!,
                                            );
                                          },
                                          child: const RoundIconButton(
                                            icon: Icons.favorite,
                                            iconColor: Colors.red,
                                            iconSize: 30,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            snapshot.data!['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
