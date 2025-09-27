import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
