import 'package:flutter/material.dart';

class AppKeys {
  AppKeys._();

  /// -------------------------------
  /// GLOBAL KEYS (State Access)
  /// -------------------------------

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  /// -------------------------------
  /// NAVIGATION KEYS
  /// -------------------------------

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// ------------------------
  /// FORM KEYS
  /// ------------------------
  static final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  static final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  static final GlobalKey<FormState> forgotPasswordFormKey =
      GlobalKey<FormState>();

  /// -------------------------------
  /// DRAWER KEYS
  /// -------------------------------
  static final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<NavigatorState> drawerNavigatorKey =
      GlobalKey<NavigatorState>();
}
