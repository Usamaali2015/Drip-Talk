import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// -----------------------------
  /// BASE
  /// -----------------------------
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFAF7F2);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111111);
  static const Color pureBlack = Color(0xFF000000);
  static const Color grey = Color(0xFF8F8A83);
  static const Color materialGrey = Color(0xFF9E9E9E);
  static const Color materialGrey400 = Color(0xFFBDBDBD);
  static const Color materialGrey700 = Color(0xFF616161);
  static const Color materialBlue = Color(0xFF2196F3);
  static const Color materialGreen = Color(0xFF4CAF50);
  static const Color materialAmber = Color(0xFFFFC107);
  static const Color materialPinkAccent = Color(0xFFFF4081);
  static const Color materialRedAccent = Color(0xFFFF5252);

  static const Color pureWhite10 = Color(0x1AFFFFFF);
  static const Color pureWhite12 = Color(0x1FFFFFFF);
  static const Color pureWhite24 = Color(0x3DFFFFFF);
  static const Color pureWhite30 = Color(0x4DFFFFFF);
  static const Color pureWhite38 = Color(0x61FFFFFF);
  static const Color pureWhite54 = Color(0x8AFFFFFF);
  static const Color pureWhite70 = Color(0xB3FFFFFF);
  static const Color pureBlack26 = Color(0x42000000);

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

  static const Color shimmerBase = Color(0x1F7E5EFF);
  static const Color shimmerHighlight = Color(0x26FF499E);

  /// -----------------------------
  /// FEATURE COLORS
  /// -----------------------------
  static const Color responsiveGradientTop = Color(0xFF4A173F);
  static const Color responsiveGradientMiddle = Color(0xFF28133F);
  static const Color responsiveGradientBottom = Color(0xFF130C24);

  static const Color otpFieldBackground = Color(0xFF0F0F1A);

  static const Color berryOverlayTop = Color(0xE6261845);
  static const Color berryOverlayBottom = Color(0xF3140D25);

  static const Color supportGradientTop = Color(0xFF30194A);
  static const Color supportGradientMiddle = Color(0xFF1F1337);
  static const Color supportGradientBottom = Color(0xFF171028);
  static const Color supportHeaderBackground = Color(0xFF261646);
  static const Color supportCardBackground = Color(0xFF321D4E);

  static const Color sectionCardBackground = Color(0xFF2B1F47);
  static const Color productSheetBackground = Color(0xFF2B1B55);
  static const Color chatBubbleBackground = Color(0xFF2A2346);
  static const Color paymentActionBackground = Color(0xFF2C1E46);
  static const Color paymentPanelBackground = Color(0xFF31214E);
  static const Color reviewsPanelBackground = Color(0xFF311847);
  static const Color paymentHeaderBackground = Color(0xFF311A56);
  static const Color paymentSelectedBackground = Color(0xFF394A72);
  static const Color paymentBadgeBackground = Color(0xFF3B6988);
  static const Color reviewTagBackground = Color(0xFF3C255D);
  static const Color chatPreferenceTileBackground = Color(0xFF473966);
  static const Color modalGradientStart = Color(0xFF18122B);
  static const Color modalGradientEnd = Color(0xFF3A163C);

  static const Color paymentSelection = Color(0xFF22C8FF);
  static const Color infoCardBackground = Color(0xFF4C98A6);
  static const Color infoCardBorder = Color(0xFF81D8E6);
  static const Color paymentBadgeText = Color(0xFF7CF3FF);
  static const Color deleteAccent = Color(0xFFFF2D95);
  static const Color paymentChipBackground = Color(0xFFFF469E);
  static const Color paymentBorderAccent = Color(0xFFFF4AA2);
  static const Color hotPink = Color(0xFFFF1E87);
  static const Color softPink = Color(0xFFFF6CAD);
  static const Color starGold = Color(0xFFFFC857);
  static const Color roseSurface = Color(0xFFFFF7FB);
  static const Color ratingBackground = Color(0xFF5E4722);

  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
