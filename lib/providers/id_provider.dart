// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static String _deviceToken = '';

  static String _supplierId = '';
  String get getData {
    return _supplierId;
  }

  setSupplierId(User user) async {
    final SharedPreferences pref = await _prefs;
    pref
        .setString('supplierid', user.uid)
        .whenComplete(() => _supplierId = user.uid);
    print('supplierid was saved into shared preferences');
    notifyListeners();
  }

  clearSupplierId() async {
    final SharedPreferences pref = await _prefs;
    pref.setString('supplierid', '').whenComplete(() => _supplierId = '');
    print('supplierid was removed from shared preferences');
    notifyListeners();
  }

  Future<String> getDocumnetId() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString('supplierid') ?? '';
    });
  }

  getDocId() async {
    await getDocumnetId().then((value) => _supplierId = value);
    print('supplierid was updated into provider');
    notifyListeners();
  }

  getDeviceToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => _deviceToken = value!);
    print('device token was updated into provider');
    notifyListeners();
  }
}
