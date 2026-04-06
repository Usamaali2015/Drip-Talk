import 'package:flutter/material.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';

class AuthGuard {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    final token = await SecureStorage.instance.getAuthToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  static void login() {
    isLoggedIn.value = true;
  }

  static void logout() {
    isLoggedIn.value = false;
  }
}