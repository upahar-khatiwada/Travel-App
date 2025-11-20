import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _openMap() async {
  final CollectionReference<Map<String, dynamic>> placesCollection =
      FirebaseFirestore.instance.collection('CollectionOfPlaces');

  if (!mounted) return;

  final ValueNotifier<LatLng?> selectedMarkerNotifier = ValueNotifier<LatLng?>(null);

  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: placesCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Icon(Icons.error, size: 80, color: Colors.red),
              );
            }

            final List<Marker> markers = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              final Map<String, dynamic> data = doc.data();
              final double lat = data['latitude'];
              final double lng = data['longitude'];

              return Marker(
                point: LatLng(lat, lng),
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerNotifier.value = LatLng(lat, lng);
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
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      fallbackUrl: 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png',
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

                ValueListenableBuilder<LatLng?>(
                  valueListenable: selectedMarkerNotifier,
                  builder: (BuildContext context, LatLng? selectedMarker, Widget? child) {
                    if (selectedMarker == null) return const SizedBox.shrink(); // Invisible when null.

                    return Positioned(
                      top: 50,
                      left: 50,
                      child: Container(
                        width: 150,
                        height: 80,
                        color: Colors.white,
                        child: const Center(child: Text('Marker Info')),
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
    selectedMarkerNotifier.dispose();
  });
}

  // Future<void> _openMap() async {
  //   final CollectionReference<Map<String, dynamic>> placesCollection =
  //       FirebaseFirestore.instance.collection('CollectionOfPlaces');

  //   if (!mounted) return;

  //   showModalBottomSheet(
  //     useSafeArea: true,
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) => SafeArea(
  //       child: SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.8,
  //         child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  //           stream: placesCollection.snapshots(),
  //           builder:
  //               (
  //                 BuildContext context,
  //                 AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
  //               ) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 }

  //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                   return const Center(
  //                     child: Icon(Icons.error, size: 80, color: Colors.red),
  //                   );
  //                 }

  //                 final List<Marker> markers = snapshot.data!.docs.map((
  //                   QueryDocumentSnapshot<Map<String, dynamic>> doc,
  //                 ) {
  //                   final Map<String, dynamic> data = doc.data();
  //                   final double lat = data['latitude'];
  //                   final double lng = data['longitude'];
  //                   // final String title = data['title'];

  //                   return Marker(
  //                     point: LatLng(lat, lng),
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           _selectedMarker = LatLng(lat, lng);
  //                         });
  //                       },
  //                       child: const Icon(
  //                         Icons.location_pin,
  //                         size: 35,
  //                         color: Colors.red,
  //                       ),
  //                     ),
  //                   );
  //                 }).toList();

  //                 return Stack(
  //                   children: <Widget>[
  //                     FlutterMap(
  //                       mapController: _mapController,
  //                       options: MapOptions(
  //                         initialCenter: _currentLocation,
  //                         initialZoom: 2,
  //                         minZoom: 0,
  //                         maxZoom: 19,
  //                       ),
  //                       children: <Widget>[
  //                         TileLayer(
  //                           urlTemplate:
  //                               'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //                           fallbackUrl:
  //                               'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png',
  //                           // userAgentPackageName: 'com.example.app',
  //                         ),
  //                         CurrentLocationLayer(
  //                           alignPositionOnUpdate: AlignOnUpdate.always,
  //                           alignDirectionOnUpdate: AlignOnUpdate.never,
  //                           style: const LocationMarkerStyle(
  //                             marker: DefaultLocationMarker(
  //                               child: Icon(
  //                                 Icons.location_pin,
  //                                 color: Colors.black38,
  //                               ),
  //                             ),
  //                             markerSize: Size(30, 30),
  //                             markerDirection: MarkerDirection.heading,
  //                           ),
  //                           // moveAnimationDuration: Duration.zero,
  //                         ),
  //                         MarkerLayer(markers: markers),
  //                       ],
  //                     ),

  //                     Positioned(
  //                       bottom: 20,
  //                       right: 20,
  //                       child: FloatingActionButton(
  //                         onPressed: () {
  //                           _mapController.move(_currentLocation, 2);
  //                         },
  //                         elevation: 5,
  //                         child: const Icon(Icons.my_location),
  //                       ),
  //                     ),

  //                     if (_selectedMarker != null)
  //                       Positioned(
  //                         top: 50, // 50 pixels from top of Stack
  //                         left: 50, // 50 pixels from left of Stack
  //                         child: Container(
  //                           width: 150,
  //                           height: 80, // give it some height
  //                           color: Colors.white,
  //                           child: const Center(child: Text("Marker Info")),
  //                         ),
  //                       ),
  //                   ],
  //                 );
  //               },
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
