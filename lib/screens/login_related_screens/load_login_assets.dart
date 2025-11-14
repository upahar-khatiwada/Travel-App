import 'package:cloud_firestore/cloud_firestore.dart';

class AppAssets {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> fetchAuthAssets() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('app_assets')
          .doc('login_screen')
          .get();

      if (!doc.exists || doc.data() == null) {
        return <String, String>{};
      }

      final Map<String, dynamic> data = doc.data()!;
      return <String, String>{
        'google_logo': data['google_logo']?.toString() ?? '',
        'login_logo': data['login_logo']?.toString() ?? '',
        'sign_up_logo': data['sign_up_logo']?.toString() ?? '',
        'forgot_password_logo': data['forgot_password_logo']?.toString() ?? '',
      };
    } catch (e) {
      print('Error fetching auth assets: $e');
      return <String, String>{};
    }
  }
}
