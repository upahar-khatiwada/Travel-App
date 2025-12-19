import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String placeId;
  final String vendor;
  final String vendorProfile;
  final String message;
  final String image;
  final DateTime time;

  MessageModel({
    required this.placeId,
    required this.vendor,
    required this.image,
    required this.vendorProfile,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeId': placeId,
      'vendor': vendor,
      'vendorProfile': vendorProfile,
      'message': message,
      'image': image,
      'time': Timestamp.fromDate(time),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      placeId: map['placeId'] ?? '',
      vendor: map['vendor'] ?? '',
      vendorProfile: map['vendorProfile'] ?? '',
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      time: (map['time'] as Timestamp).toDate(),
    );
  }
}
