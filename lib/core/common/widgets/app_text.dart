import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';

enum AppTextVariant {
  ts8,
  ts10,
  ts12,
  ts14,
  ts16,
  ts18,
  ts20,
  ts22,
  ts24,
  ts28,
  ts32,
  ts36,
  ts40,
}

class AppText extends StatefulWidget {
  final String text;
  final AppTextVariant variant;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isSelectable;
  final bool isBold;
  final bool isItalic;
  final bool enableReadMore;
  final int readMoreMaxLines;
  final String readMoreText;
  final String readLessText;
  final Color? textColor;
  final String? customFontFamily;
  final Gradient? gradient;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;

  const AppText({
    super.key,
    required this.text,
    this.variant = AppTextVariant.ts16,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isSelectable = false,
    this.isBold = false,
    this.isItalic = false,
    this.enableReadMore = false,
    this.readMoreMaxLines = 3,
    this.readMoreText = 'Read more',
    this.readLessText = 'Read less',
    this.textColor,
    this.customFontFamily,
    this.gradient,
    this.fontWeight,
    this.textDecoration,
  });

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  bool _expanded = false;

  TextStyle _resolveVariantStyle(
    BuildContext context, {
    String? fontFamily,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
  }) {
    switch (widget.variant) {
      case AppTextVariant.ts8:
        return AppTextStyles.ts8(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts10:
        return AppTextStyles.ts10(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts12:
        return AppTextStyles.ts12(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts14:
        return AppTextStyles.ts14(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts16:
        return AppTextStyles.ts16(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts18:
        return AppTextStyles.ts18(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts20:
        return AppTextStyles.ts20(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts22:
        return AppTextStyles.ts22(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts24:
        return AppTextStyles.ts24(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts28:
        return AppTextStyles.ts28(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts32:
        return AppTextStyles.ts32(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts36:
        return AppTextStyles.ts36(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
      case AppTextVariant.ts40:
        return AppTextStyles.ts40(
          context,
          color: color,
          customFontFamily: fontFamily,
          fontWeight: fontWeight,
          decoration: textDecoration,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseStyle =
        widget.style ??
        _resolveVariantStyle(
          context,
          color: widget.textColor ?? colorScheme.onSecondary,
          fontFamily: widget.customFontFamily,
          fontWeight: widget.fontWeight,
          textDecoration: widget.textDecoration,
        );

    final textStyle = baseStyle.copyWith(
      fontWeight: widget.isBold ? FontWeight.bold : baseStyle.fontWeight,
      fontStyle: widget.isItalic ? FontStyle.italic : baseStyle.fontStyle,

      color: widget.gradient != null
          ? AppColors.pureWhite
          : (widget.textColor ?? baseStyle.color),
    );

    final maxLines = widget.enableReadMore
        ? (_expanded ? null : widget.readMoreMaxLines)
        : widget.maxLines;

    Widget content = widget.isSelectable
        ? SelectableText(
            widget.text,
            textAlign: widget.textAlign,
            style: textStyle,
            maxLines: maxLines,
          )
        : Text(
            widget.text,
            textAlign: widget.textAlign,
            style: textStyle,
            maxLines: maxLines,
            overflow: _expanded ? TextOverflow.visible : widget.overflow,
          );

    if (widget.gradient != null) {
      content = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => widget.gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: content,
      );
    }

    if (!widget.enableReadMore) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        const AppGap(AppSizes.s4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? widget.readLessText : widget.readMoreText,
            style: textStyle.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
