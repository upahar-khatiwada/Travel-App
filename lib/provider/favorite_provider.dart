import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoritePlacesIds = <String>[];
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  List<String> get favorites => _favoritePlacesIds;

  FavoriteProvider() {
    loadFavoritePlaces();
  }

  void toggleFavoritePlaces(
    DocumentSnapshot<Map<String, dynamic>> place,
  ) async {
    String placeId = place.id;

    if (_favoritePlacesIds.contains(placeId)) {
      _favoritePlacesIds.remove(placeId);
      await _removeFavoritePlace(placeId);
    } else {
      _favoritePlacesIds.add(placeId);
      await _addFavoritePlace(placeId);
    }

    notifyListeners();
  }

  bool doesFavoritePlaceExist(DocumentSnapshot<Map<String, dynamic>> place) {
    return _favoritePlacesIds.contains(place.id);
  }

  Future<void> _addFavoritePlace(String placeId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(placeId)
        .set(<String, dynamic>{'isFavorite': true});
  }

  Future<void> _removeFavoritePlace(String placeId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(placeId)
        .delete();
  }

  Future<void> loadFavoritePlaces() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .get();

    _favoritePlacesIds = querySnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.id)
        .toList();

    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
