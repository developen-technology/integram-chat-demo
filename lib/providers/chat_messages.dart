import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:integram_chat_demo/models/message_model.dart';

class ChatMessages with ChangeNotifier {
  List<Message> _chats = [];

  List<Message> get chats {
    return [..._chats];
  }

  void addChatMessage(Message message) {
    _chats.insert(0, message);
    notifyListeners();
  }
}
