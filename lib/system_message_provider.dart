import 'package:flutter/material.dart';

class SystemMessageProvider extends ChangeNotifier {
  String _systemMessage = 'You are a helpful assistant.';

  String get systemMessage => _systemMessage;

  void updateSystemMessage(String newMessage) {
    _systemMessage = newMessage;
  }
}
