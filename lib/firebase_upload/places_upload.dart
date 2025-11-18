import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> savePlacesToFirebase() async {
  final CollectionReference reference = FirebaseFirestore.instance.collection(
    'CollectionOfPlaces',
  );

  for (final Place place in places) {
    final String id =
        DateTime.now().toIso8601String() + Random().nextInt(1000).toString();
    // reference.doc('das');
    await reference.doc(id).set(place.convertToMap());
  }
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
    };
  }
}

List<Place> places = <Place>[
  Place(
    title: 'Cozy Downtown Apartment',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=1',
    rating: 4.8,
    date: '2025-11-20',
    price: 120,
    address: '123 Main St, New York, NY 10001',
    vendor: 'Alice Johnson',
    vendorProfession: 'Professional Host',
    vendorProfile: 'https://picsum.photos/100/100?random=10',
    review: 45,
    bedAndBathroom: '2 beds, 1 bathroom',
    latitude: 40.7128,
    longitude: -74.0060,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=1',
      'https://picsum.photos/400/300?random=2',
      'https://picsum.photos/400/300?random=3',
    ],
  ),
  Place(
    title: 'Sunny Beach House',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=4',
    rating: 4.6,
    date: '2025-11-22',
    price: 250,
    address: '456 Ocean Dr, Miami, FL 33139',
    vendor: 'Bob Smith',
    vendorProfession: 'Real Estate Expert',
    vendorProfile: 'https://picsum.photos/100/100?random=11',
    review: 32,
    bedAndBathroom: '3 beds, 2 bathrooms',
    latitude: 25.7617,
    longitude: -80.1918,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=4',
      'https://picsum.photos/400/300?random=5',
      'https://picsum.photos/400/300?random=6',
    ],
  ),
  Place(
    title: 'Rustic Mountain Cabin',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=7',
    rating: 4.9,
    date: '2025-11-25',
    price: 180,
    address: '789 Pine Rd, Aspen, CO 81611',
    vendor: 'Carol Davis',
    vendorProfession: 'Adventure Guide',
    vendorProfile: 'https://picsum.photos/100/100?random=12',
    review: 67,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 39.1911,
    longitude: -106.8175,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=7',
      'https://picsum.photos/400/300?random=8',
      'https://picsum.photos/400/300?random=9',
    ],
  ),
  Place(
    title: 'Luxury Villa Retreat',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=10',
    rating: 4.7,
    date: '2025-11-28',
    price: 400,
    address: '101 Palm Ave, Los Angeles, CA 90210',
    vendor: 'David Wilson',
    vendorProfession: 'Luxury Property Manager',
    vendorProfile: 'https://picsum.photos/100/100?random=13',
    review: 28,
    bedAndBathroom: '4 beds, 3 bathrooms',
    latitude: 34.0522,
    longitude: -118.2437,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=10',
      'https://picsum.photos/400/300?random=11',
      'https://picsum.photos/400/300?random=12',
      'https://picsum.photos/400/300?random=13',
    ],
  ),
  Place(
    title: 'Modern City Loft',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=14',
    rating: 4.5,
    date: '2025-12-01',
    price: 95,
    address: '321 Urban Blvd, Chicago, IL 60601',
    vendor: 'Eva Martinez',
    vendorProfession: 'Urban Designer',
    vendorProfile: 'https://picsum.photos/100/100?random=14',
    review: 51,
    bedAndBathroom: '1 bed, 1 bathroom',
    latitude: 41.8781,
    longitude: -87.6298,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=14',
      'https://picsum.photos/400/300?random=15',
      'https://picsum.photos/400/300?random=16',
    ],
  ),
  Place(
    title: 'Charming Suburban Home',
    isActive: true,
    image: 'https://picsum.photos/400/300?random=17',
    rating: 4.4,
    date: '2025-12-05',
    price: 150,
    address: '654 Elm St, Seattle, WA 98101',
    vendor: 'Frank Lee',
    vendorProfession: 'Home Stager',
    vendorProfile: 'https://picsum.photos/100/100?random=15',
    review: 39,
    bedAndBathroom: '2 beds, 2 bathrooms',
    latitude: 47.6062,
    longitude: -122.3321,
    imageUrls: <String>[
      'https://picsum.photos/400/300?random=17',
      'https://picsum.photos/400/300?random=18',
      'https://picsum.photos/400/300?random=19',
    ],
  ),
];
