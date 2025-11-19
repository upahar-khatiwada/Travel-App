import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoritePlacesIds = <String>[];
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  
  List<String> get favorites => _favoritePlacesIds;

  FavoriteProvider() {
    loadFavoritePlaces();
  }

  void toggleFavoritePlaces(DocumentSnapshot<Map<String, dynamic>> place) async {
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
    await firebaseFirestore.collection('userFavorites').doc(placeId).set(
      <String, bool>{'isFavorite': true},
    );
  }

  Future<void> _removeFavoritePlace(String placeId) async {
    await firebaseFirestore.collection('userFavorites').doc(placeId).delete();
  }

  Future<void> loadFavoritePlaces() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection('userFavorites')
        .get();

    _favoritePlacesIds = querySnapshot.docs
        .map((QueryDocumentSnapshot<Object?> doc) => doc.id)
        .toList();

    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
