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
