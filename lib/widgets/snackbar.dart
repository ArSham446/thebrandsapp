import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackBar(var scaffoldKey, String message) {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.hideCurrentSnackBar();
      scaffoldKey.currentState!.showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey.shade200.withOpacity(0.8),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          )));
    }
  }
}
