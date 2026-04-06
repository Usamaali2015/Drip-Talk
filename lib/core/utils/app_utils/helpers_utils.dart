import 'package:flutter/material.dart';

class AppHelpersUtils {
  static void showCustomDialog(BuildContext context, Widget dialog) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog,
    );
  }
}
