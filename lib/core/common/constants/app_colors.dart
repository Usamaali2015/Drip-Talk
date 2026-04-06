import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// -----------------------------
  /// BASE
  /// -----------------------------
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFAF7F2);
  static const Color black = Color(0xFF111111);
  static const Color grey = Color(0xFF8F8A83);

  static const Color red = Color(0xFFFF0A0A);

  static const Color cyan = Color(0xFF72E8EA);

  static const Color darkBg = Color(0xFF171228);

  static const Color darkBg2 = Color(0xFF1C1435);

  static const Color lightBg = Color(0xFF251B48);

  static const Color green = Color(0xFF38D33E);

  /// -----------------------------
  /// PRIMARY
  /// -----------------------------
  static const Color primary = Color(0xFF7E5EFF);

  /// Cocoa
  static const Color primaryLight = Color(0xFF856EE4);

  /// Warm
  static const Color primaryDark = Color(0xFF6E44FF);

  /// Deep

  /// -----------------------------
  /// SECONDARY (Gold Accent)
  /// -----------------------------
  static const Color secondary = Color(0xFFFF499E);

  /// Desert
  static const Color secondaryLight = Color(0xFF856EE4);

  /// Light
  static const Color secondaryDark = Color(0xFF5532E0);

  /// -----------------------------
  /// SCAFFOLD / BACKGROUND
  /// -----------------------------
  static const Color darkScaffold = Color(0xFF121212);

  /// Luxury Dark
  static const Color lightScaffold = Color(0xFFFAF7F2);

  /// Pearl

  static const Color background = Color(0xFFFAF7F2);

  /// Main BG
  static const Color surface = Color(0xFFFFFFFF);

  /// Cards / Sheets

  /// -----------------------------
  /// BORDERS & DIVIDERS
  /// -----------------------------
  static const Color border = Color(0xFFE0D6C8);

  /// Soft Sand
  static const Color divider = Color(0xFFD1C4B2);

  /// -----------------------------
  /// TEXT COLORS
  /// -----------------------------
  static const Color textPrimary = Color(0xFF1C1A17);

  /// Almost Black
  static const Color textSecondary = Color(0xFF6E655A);

  /// Cocoa Grey
  static const Color textHint = Color(0xFF9C948A);
  static const Color textDisabled = Color(0xFFB8B1A8);

  /// -----------------------------
  /// STATUS COLORS (Muted Luxury)
  /// -----------------------------
  static const Color success = Color(0xFF4F8A5B);

  /// Olive Green
  static const Color warning = Color(0xFFC9A24D);

  /// Gold
  static const Color error = Color(0xFF9E3F3F);

  /// Muted Red
  static const Color info = Color(0xFF6B7A8F);

  /// Steel Blue

  /// -----------------------------
  /// EFFECTS
  /// -----------------------------
  static const Color overlay = Color(0x99000000);

  /// Dark overlay
  static const Color shadow = Color(0x1A000000);

  /// Soft shadow

  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
