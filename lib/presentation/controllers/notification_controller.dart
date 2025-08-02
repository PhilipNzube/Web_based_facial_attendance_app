import 'package:flutter/material.dart';

class NotificationController extends ChangeNotifier {
  final List<bool> _hasNotification = [false, false, false, false];

  bool hasNotification(int index) => _hasNotification[index];

  void setNotification(int index, bool value) {
    _hasNotification[index] = value;
    notifyListeners();
  }
}
