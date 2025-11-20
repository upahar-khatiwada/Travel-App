import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/components/components.dart';
import 'package:travel_app/provider/favorite_provider.dart';

class ExploreMapWidget extends StatefulWidget {
  const ExploreMapWidget({super.key});

  @override
  State<ExploreMapWidget> createState() => _ExploreMapWidgetState();
}

class _ExploreMapWidgetState extends State<ExploreMapWidget> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 100,
      ),
    );
    if (!mounted) return;
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _openMap() async {
    final CollectionReference<Map<String, dynamic>> placesCollection =
        FirebaseFirestore.instance.collection('CollectionOfPlaces');

    if (!mounted) return;

    final ValueNotifier<QueryDocumentSnapshot<Map<String, dynamic>>?>
    selectedDocNotifier =
        ValueNotifier<QueryDocumentSnapshot<Map<String, dynamic>>?>(null);

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: placesCollection.snapshots(),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Icon(Icons.error, size: 80, color: Colors.red),
                    );
                  }

                  final List<Marker> markers = snapshot.data!.docs.map((
                    QueryDocumentSnapshot<Map<String, dynamic>> doc,
                  ) {
                    final Map<String, dynamic> data = doc.data();

                    return Marker(
                      point: LatLng(data['latitude'], data['longitude']),
                      child: GestureDetector(
                        onTap: () {
                          selectedDocNotifier.value = doc;
                        },
                        child: const Icon(
                          Icons.location_pin,
                          size: 35,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }).toList();

                  return Stack(
                    children: <Widget>[
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentLocation,
                          initialZoom: 2,
                          minZoom: 0,
                          maxZoom: 19,
                          onTap: (TapPosition tapPosition, LatLng latLng) {
                            selectedDocNotifier.value = null;
                          },
                        ),
                        children: <Widget>[
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            fallbackUrl:
                                'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png',
                          ),
                          CurrentLocationLayer(
                            alignPositionOnUpdate: AlignOnUpdate.always,
                            alignDirectionOnUpdate: AlignOnUpdate.never,
                            style: const LocationMarkerStyle(
                              marker: DefaultLocationMarker(
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.black38,
                                ),
                              ),
                              markerSize: Size(30, 30),
                              markerDirection: MarkerDirection.heading,
                            ),
                          ),
                          MarkerLayer(markers: markers),
                        ],
                      ),

                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: () {
                            _mapController.move(_currentLocation, 2);
                          },
                          elevation: 5,
                          child: const Icon(Icons.my_location),
                        ),
                      ),

                      // The container that is displayed when tapped on the marker
                      ValueListenableBuilder<QueryDocumentSnapshot<Map<String, dynamic>>?>(
                        valueListenable: selectedDocNotifier,
                        builder:
                            (
                              BuildContext context,
                              QueryDocumentSnapshot<Map<String, dynamic>>? selectedDoc,
                              Widget? child,
                            ) {
                              if (selectedDoc == null) {
                                return const SizedBox.shrink();
                              }

                              final List<dynamic> imageUrls = selectedDoc['imageUrls'];

                              return Positioned(
                                top: 50,
                                left: 50,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.2,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      25,
                                                    ),
                                                    topRight: Radius.circular(
                                                      25,
                                                    ),
                                                  ),
                                              child: AnotherCarousel(
                                                images: imageUrls.map<Widget>((
                                                  dynamic url,
                                                ) {
                                                  return CachedNetworkImage(
                                                    imageUrl: url.toString(),
                                                    fit: BoxFit.cover,
                                                  );
                                                }).toList(),
                                                indicatorBgPadding: 10,
                                                dotBgColor: Colors.transparent,
                                                dotSize: 4,
                                                dotColor: Theme.of(
                                                  context,
                                                ).colorScheme.inversePrimary,
                                              ),
                                            ),
                                          ),

                                          selectedDoc['isActive']
                                              ? Positioned(
                                                  top: 8,
                                                  left: 8,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      color: Colors.white,
                                                    ),
                                                    child: const Text(
                                                      'Guest Favorite',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),

                                          Positioned(
                                            top: 8,
                                            right: 50,
                                            child: GestureDetector(
                                              onTap: () {
                                                Provider.of<FavoriteProvider>(
                                                  context,
                                                  listen: false,
                                                ).toggleFavoritePlaces(selectedDoc);
                                              },
                                              child: RoundIconButton(
                                                icon: Icons.favorite,
                                                iconSize: 20,
                                                iconColor:
                                                    Provider.of<
                                                          FavoriteProvider
                                                        >(context)
                                                        .doesFavoritePlaceExist(
                                                          selectedDoc,
                                                        )
                                                    ? Colors.red
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: 8,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectedDocNotifier.value =
                                                    null;
                                              },
                                              child: const RoundIconButton(
                                                icon: Icons.close,
                                                iconSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          top: 4,
                                          right: 10,
                                          bottom: 2,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              selectedDoc['title'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  selectedDoc['rating'].toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        child: Text(selectedDoc['date']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          '\$${selectedDoc['price']} night',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                      ),
                    ],
                  );
                },
          ),
        ),
      ),
    ).whenComplete(() {
      selectedDocNotifier.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: _openMap,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary,
              blurRadius: 5,
            ),
          ],
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          spacing: 3,
          children: <Widget>[
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 20,
            ),
            Text(
              'Map',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
