import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/models/message_model.dart';

class MessagesProvider extends ChangeNotifier {
  final List<MessageModel> _messages = <MessageModel>[];
  final Set<String> _reservedPlaceIds = <String>{};

  List<MessageModel> get messages => _messages;

  bool isReserved(String placeId) {
    return _reservedPlaceIds.contains(placeId);
  }

  void reservePlace(String placeId, MessageModel message) {
    if (_reservedPlaceIds.contains(placeId)) return;

    _reservedPlaceIds.add(placeId);
    _messages.insert(0, message);
    notifyListeners();
  }

  static MessagesProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<MessagesProvider>(context, listen: listen);
  }
}
