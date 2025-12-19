import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  List<MessageModel> _messages = <MessageModel>[];

  List<MessageModel> get messages => _messages;

  MessagesProvider() {
    loadMessages();
  }

  Future<bool> hasActiveReservation(String placeId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .doc(placeId)
        .get();

    if (!doc.exists) return false;

    return doc.data()?['status'] == 'active';
  }

  Future<void> reservePlace({
    required String placeId,
    required MessageModel message,
  }) async {
    final DocumentReference<Map<String, dynamic>> reservationRef =
        firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('reservations')
            .doc(placeId);

    final DocumentSnapshot<Map<String, dynamic>> reservationSnapshot =
        await reservationRef.get();

    if (reservationSnapshot.exists &&
        reservationSnapshot.data()?['status'] == 'active') {
      return;
    }

    await reservationRef.set(<String, dynamic>{
      'status': 'active',
      'reservedAt': Timestamp.now(),
    });

    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<void> completeReservation(String placeId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .doc(placeId)
        .update(<Object, Object?>{
          'status': 'completed',
          'completedAt': Timestamp.now(),
        });
  }

  void addMessage(MessageModel message) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<void> loadMessages() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('time', descending: true)
        .get();

    _messages = snapshot.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              MessageModel.fromMap(doc.data()),
        )
        .toList();

    notifyListeners();
  }

  static MessagesProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<MessagesProvider>(context, listen: listen);
  }
}
