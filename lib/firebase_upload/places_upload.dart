import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> savePlacesToFirebase() async {
  final CollectionReference<Map<String, dynamic>> reference = FirebaseFirestore
      .instance
      .collection('CollectionOfPlaces');

  for (final Place place in places) {
    final String id =
        DateTime.now().toIso8601String() + Random().nextInt(1000).toString();
    // reference.doc('das');
    await reference.doc(id).set(place.convertToMap());
  }
}

String randomDate2025() {
  final Random rnd = Random();
  final int month = rnd.nextInt(12) + 1;
  final int day = rnd.nextInt(28) + 1;
  return '2025-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

class Place {
  final String title;
  bool isActive;
  final String image;
  final double rating;
  final String date;
  final int price;
  final String address;
  final String vendor;
  final String vendorProfession;
  final String vendorProfile;
  final int review;
  final String bedAndBathroom;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final String category;

  Place({
    required this.title,
    this.isActive = true,
    required this.image,
    required this.rating,
    required this.date,
    required this.price,
    required this.address,
    required this.vendor,
    required this.vendorProfession,
    required this.vendorProfile,
    required this.review,
    required this.bedAndBathroom,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.category,
  });

  Map<String, dynamic> convertToMap() {
    return <String, dynamic>{
      'title': title,
      'isActive': isActive,
      'image': image,
      'rating': rating,
      'date': date,
      'price': price,
      'address': address,
      'vendor': vendor,
      'vendorProfession': vendorProfession,
      'vendorProfile': vendorProfile,
      'review': review,
      'bedAndBathroom': bedAndBathroom,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'category': category,
    };
  }
}

final List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
  <String, dynamic>{'icon': Icons.bed, 'label': 'Room'},
  <String, dynamic>{'icon': Icons.house, 'label': 'Home'},
  <String, dynamic>{'icon': Icons.apartment, 'label': 'Apartment'},
  <String, dynamic>{'icon': Icons.directions_car, 'label': 'Transport'},
  <String, dynamic>{'icon': Icons.park, 'label': 'Outdoor'},
  <String, dynamic>{'icon': Icons.restaurant, 'label': 'Food'},
];

List<Place> places = <Place>[
  Place(
    title: 'Seaside Serenity Resort',
    isActive: false,
    image: 'https://picsum.photos/id/1018/400/300',
    rating: 4.9,
    date: randomDate2025(),
    price: 320,
    address: '12 Ocean View Dr, Malibu, CA 90265',
    vendor: 'Olivia Waters',
    vendorProfession: 'Resort Owner',
    vendorProfile: 'https://randomuser.me/api/portraits/women/45.jpg',
    review: 150,
    bedAndBathroom: '2 beds, 2 bathrooms',
    latitude: 34.0259,
    longitude: -118.7798,
    imageUrls: <String>[
      'https://picsum.photos/id/1025/400/300',
      'https://picsum.photos/id/1024/400/300',
      'https://picsum.photos/id/1019/400/300',
    ],
    category: categories[0 % categories.length]['label']!, // Room
  ),
  Place(
    title: 'Alpine Mountain Lodge',
    isActive: true,
    image: 'https://picsum.photos/id/103/400/300',
    rating: 4.7,
    date: randomDate2025(),
    price: 220,
    address: '77 Pine Ridge Rd, Aspen, CO 81611',
    vendor: 'Ethan Frost',
    vendorProfession: 'Mountain Host',
    vendorProfile: 'https://randomuser.me/api/portraits/men/32.jpg',
    review: 89,
    bedAndBathroom: '3 beds, 1 bathroom',
    latitude: 39.1911,
    longitude: -106.8175,
    imageUrls: <String>[
      'https://picsum.photos/id/104/400/300',
      'https://picsum.photos/id/105/400/300',
      'https://picsum.photos/id/106/400/300',
    ],
    category: categories[1 % categories.length]['label']!, // Home
  ),
  Place(
    title: 'Urban Boutique Hotel',
    isActive: false,
    image: 'https://picsum.photos/id/107/400/300',
    rating: 4.5,
    date: randomDate2025(),
    price: 180,
    address: '250 City Center Blvd, Chicago, IL 60601',
    vendor: 'Maya Brooks',
    vendorProfession: 'Hotel Manager',
    vendorProfile: 'https://randomuser.me/api/portraits/women/22.jpg',
    review: 120,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 41.8837,
    longitude: -87.6289,
    imageUrls: <String>[
      'https://picsum.photos/id/108/400/300',
      'https://picsum.photos/id/109/400/300',
      'https://picsum.photos/id/110/400/300',
    ],
    category: categories[2 % categories.length]['label']!, // Apartment
  ),
  Place(
    title: 'Tropical Rainforest Eco‑Lodge',
    isActive: true,
    image: 'https://picsum.photos/id/111/400/300',
    rating: 4.8,
    date: randomDate2025(),
    price: 150,
    address: 'Rainforest Way, Costa Rica',
    vendor: 'Luis Hernandez',
    vendorProfession: 'Eco Host',
    vendorProfile: 'https://randomuser.me/api/portraits/men/47.jpg',
    review: 98,
    bedAndBathroom: '2 beds, 1 bathroom',
    latitude: 9.7489,
    longitude: -83.7534,
    imageUrls: <String>[
      'https://picsum.photos/id/112/400/300',
      'https://picsum.photos/id/113/400/300',
      'https://picsum.photos/id/114/400/300',
    ],
    category: categories[3 % categories.length]['label']!, // Transport
  ),
  Place(
    title: 'Historic Castle Stay',
    isActive: false,
    image: 'https://picsum.photos/id/115/400/300',
    rating: 4.9,
    date: randomDate2025(),
    price: 500,
    address: 'Old Castle Rd, Edinburgh, UK',
    vendor: 'Fiona MacLeod',
    vendorProfession: 'Castle Owner',
    vendorProfile: 'https://randomuser.me/api/portraits/women/59.jpg',
    review: 200,
    bedAndBathroom: '4 beds, 3 bathrooms',
    latitude: 55.9486,
    longitude: -3.1999,
    imageUrls: <String>[
      'https://picsum.photos/id/116/400/300',
      'https://picsum.photos/id/117/400/300',
      'https://picsum.photos/id/118/400/300',
    ],
    category: categories[4 % categories.length]['label']!, // Outdoor
  ),
  Place(
    title: 'Desert Oasis Camp',
    isActive: true,
    image: 'https://picsum.photos/id/119/400/300',
    rating: 4.6,
    date: randomDate2025(),
    price: 140,
    address: 'Sahara Desert, Merzouga, Morocco',
    vendor: 'Rachid Nouiri',
    vendorProfession: 'Camp Host',
    vendorProfile: 'https://randomuser.me/api/portraits/men/65.jpg',
    review: 76,
    bedAndBathroom: '1 bed (tent), shared bathroom',
    latitude: 31.1086,
    longitude: -4.0110,
    imageUrls: <String>[
      'https://picsum.photos/id/120/400/300',
      'https://picsum.photos/id/121/400/300',
      'https://picsum.photos/id/122/400/300',
    ],
    category: categories[5 % categories.length]['label']!, // Food
  ),
  Place(
    title: 'Lakeside Wooden Cabin',
    isActive: false,
    image: 'https://picsum.photos/id/123/400/300',
    rating: 4.7,
    date: randomDate2025(),
    price: 200,
    address: 'Lakeview Drive, Lake Tahoe, CA',
    vendor: 'Grace Miller',
    vendorProfession: 'Cabin Host',
    vendorProfile: 'https://randomuser.me/api/portraits/women/11.jpg',
    review: 110,
    bedAndBathroom: '2 beds, 1 bathroom',
    latitude: 39.0968,
    longitude: -120.0324,
    imageUrls: <String>[
      'https://picsum.photos/id/124/400/300',
      'https://picsum.photos/id/125/400/300',
      'https://picsum.photos/id/126/400/300',
    ],
    category: categories[0 % categories.length]['label']!, // Room
  ),
  Place(
    title: 'Skyline Rooftop Hotel',
    isActive: true,
    image: 'https://picsum.photos/id/127/400/300',
    rating: 4.4,
    date: randomDate2025(),
    price: 210,
    address: '500 Rooftop St, New York, NY',
    vendor: 'James Parker',
    vendorProfession: 'Hotelier',
    vendorProfile: 'https://randomuser.me/api/portraits/men/25.jpg',
    review: 95,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 40.7128,
    longitude: -74.0060,
    imageUrls: <String>[
      'https://picsum.photos/id/128/400/300',
      'https://picsum.photos/id/129/400/300',
      'https://picsum.photos/id/130/400/300',
    ],
    category: categories[1 % categories.length]['label']!, // Home
  ),
  Place(
    title: 'Forest Treehouse Retreat',
    isActive: false,
    image: 'https://picsum.photos/id/131/400/300',
    rating: 4.8,
    date: randomDate2025(),
    price: 260,
    address: 'Whispering Pines, Oregon, USA',
    vendor: 'Sophie Green',
    vendorProfession: 'Nature Guide',
    vendorProfile: 'https://randomuser.me/api/portraits/women/76.jpg',
    review: 130,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 44.0582,
    longitude: -121.3153,
    imageUrls: <String>[
      'https://picsum.photos/id/132/400/300',
      'https://picsum.photos/id/133/400/300',
      'https://picsum.photos/id/134/400/300',
    ],
    category: categories[2 % categories.length]['label']!, // Apartment
  ),
  Place(
    title: 'Modern Minimalist Apartment',
    isActive: true,
    image: 'https://picsum.photos/id/135/400/300',
    rating: 4.3,
    date: randomDate2025(),
    price: 130,
    address: 'Downtown, Berlin, Germany',
    vendor: 'Lukas Schmidt',
    vendorProfession: 'Airbnb Host',
    vendorProfile: 'https://randomuser.me/api/portraits/men/52.jpg',
    review: 80,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 52.5200,
    longitude: 13.4050,
    imageUrls: <String>[
      'https://picsum.photos/id/136/400/300',
      'https://picsum.photos/id/137/400/300',
      'https://picsum.photos/id/138/400/300',
    ],
    category: categories[3 % categories.length]['label']!, // Transport
  ),
];
