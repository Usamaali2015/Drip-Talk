import 'package:flutter/material.dart';

import '../../utils/responsive/responsive_text.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamilyPrimary = 'RedHatDisplay';
  static const String fontFamilyArabic = 'Tajawal';
  static const List<String> fontFamilyFallback = [fontFamilyArabic];

  static bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static TextStyle _base(
    BuildContext context,
    double baseSize,
    FontWeight weight, {
    Color? color,
    String? customFontFamily,
    TextDecoration? decoration,
  }) {
    final arabic = _isArabic(context);
    final String effectiveFamily =
        customFontFamily ?? (arabic ? fontFamilyArabic : fontFamilyPrimary);

    return TextStyle(
      fontSize: ResponsiveFont.scale(context, baseSize),
      fontWeight: weight,
      color: color,
      fontFamily: effectiveFamily,
      fontFamilyFallback: arabic ? null : fontFamilyFallback,
      decoration: decoration,
    );
  }

  static TextStyle ts8(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    8,
    fontWeight ?? FontWeight.w400,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts10(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    10,
    fontWeight ?? FontWeight.w400,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts12(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    12,
    fontWeight ?? FontWeight.w400,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts14(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    14,
    fontWeight ?? FontWeight.w400,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts15(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    15,
    fontWeight ?? FontWeight.w500,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts16(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    16,
    fontWeight ?? FontWeight.w500,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts18(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    18,
    fontWeight ?? FontWeight.w600,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts20(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    20,
    fontWeight ?? FontWeight.w600,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts22(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    22,
    fontWeight ?? FontWeight.w700,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts24(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    24,
    fontWeight ?? FontWeight.w700,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts28(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    28,
    fontWeight ?? FontWeight.w800,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts32(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    32,
    fontWeight ?? FontWeight.w800,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts36(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    36,
    fontWeight ?? FontWeight.w800,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );

  static TextStyle ts40(
    BuildContext c, {
    Color? color,
    FontWeight? fontWeight,
    String? customFontFamily,
    TextDecoration? decoration,
  }) => _base(
    c,
    40,
    fontWeight ?? FontWeight.w800,
    color: color,
    customFontFamily: customFontFamily,
    decoration: decoration,
  );
}
