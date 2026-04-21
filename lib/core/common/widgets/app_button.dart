import 'package:drip_talk/core/common/widgets/app_text.dart' show AppText;
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double? height;
  final double? width;
  final List<Color>? gradientColors;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? leadingIcon;
  final double? iconGap;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.height,
    this.width,
    this.gradientColors,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.leadingIcon,
    this.iconGap = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppSizes.s12;

    return SizedBox(
      height: height ?? AppSizes.s48,
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.all(AppColors.transparent),
              shadowColor: WidgetStateProperty.all(AppColors.transparent),
            ),
        onPressed: isLoading ? null : onPressed,
        child: Container(
          padding: borderColor != null ? EdgeInsets.all(borderWidth) : null,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null,
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: gradientColors != null
                  ? LinearGradient(
                      colors: gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: gradientColors == null
                  ? (backgroundColor ?? AppColors.primary)
                  : null,
              borderRadius: BorderRadius.circular(
                borderColor != null
                    ? (radius - borderWidth).clamp(0, radius)
                    : radius,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: AppSizes.s20,
                    width: AppSizes.s20,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSizes.s2,
                      color: AppColors.pureWhite,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) ...[
                        leadingIcon!,
                        SizedBox(width: iconGap),
                      ],
                      AppText(
                        text: text,
                        style: AppTextStyles.ts18(
                          context,
                          color: textColor ?? AppColors.pureWhite,
                          fontWeight: fontWeight ?? FontWeight.w700,
                        ).copyWith(fontSize: fontSize),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
