import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class LocationInMap extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> place; // the current place
  const LocationInMap({super.key, required this.place});

  @override
  State<LocationInMap> createState() => _LocationInMapState();
}

class _LocationInMapState extends State<LocationInMap> {
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(
          widget.place['latitude'],
          widget.place['longitude'],
        ),
        initialZoom: 7,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          fallbackUrl:
              'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png',
        ),
        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.never,
          alignDirectionOnUpdate: AlignOnUpdate.never,
          style: const LocationMarkerStyle(
            marker: DefaultLocationMarker(
              child: Icon(Icons.location_pin, color: Colors.black38),
            ),
            markerSize: Size(30, 30),
            markerDirection: MarkerDirection.heading,
          ),
        ),
        MarkerLayer(
          markers: <Marker>[
            Marker(
              point: LatLng(
                widget.place['latitude'],
                widget.place['longitude'],
              ),
              child: const Icon(
                Icons.location_pin,
                size: 35,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
