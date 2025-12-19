class MessageModel {
  final String vendor;
  final String vendorProfile;
  final String message;
  final String image;
  final DateTime time;

  MessageModel({
    required this.vendor,
    required this.image,
    required this.vendorProfile,
    required this.message,
    required this.time,
  });
}
