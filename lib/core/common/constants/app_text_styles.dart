import 'package:drip_talk/features/splash/view/responsive_view/splash_barrels.dart';
import '../../utils/responsive/responsive_text.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamilyPrimary = Assets.fontsRedHatDisplayRegular;
  static const String fontFamilyArabic = Assets.fontsTajawal;
  static const List<String> fontFamilyFallback = [fontFamilyArabic];

  static TextStyle _base(
    BuildContext context,
    double baseSize,
    FontWeight weight, {
    Color? color,
    String? customFontFamily,
    TextDecoration? decoration,
  }) {
    String effectiveFamily = customFontFamily ?? fontFamilyPrimary;

    return TextStyle(
      fontSize: ResponsiveFont.scale(context, baseSize),
      fontWeight: weight,
      color: color,
      fontFamily: effectiveFamily,
      fontFamilyFallback: fontFamilyFallback,
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
