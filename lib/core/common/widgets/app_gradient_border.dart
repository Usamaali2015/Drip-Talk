import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';

class GradientBorder extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  final double borderWidth;
  final double borderRadius;

  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  final Color backgroundColor;
  final BoxShape shape;
  final EdgeInsetsGeometry padding;

  /// Shadow controls
  final bool enableShadow;
  final double shadowBlur;
  final Offset shadowOffset;
  final double shadowOpacity;

  const GradientBorder({
    super.key,
    required this.child,
    required this.colors,
    this.onTap,
    this.borderWidth = 2,
    this.borderRadius = 16,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.backgroundColor = AppColors.pureWhite,
    this.shape = BoxShape.rectangle,
    this.padding = const EdgeInsets.all(12),
    this.enableShadow = true,
    this.shadowBlur = 18,
    this.shadowOffset = const Offset(0, 6),
    this.shadowOpacity = 0.35,
  }) : assert(
         shape == BoxShape.circle || borderRadius >= borderWidth,
         'borderRadius must be >= borderWidth',
       );

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: AppColors.transparent,
      shape: shape == BoxShape.rectangle
          ? RoundedRectangleBorder(borderRadius: radius)
          : const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: shape == BoxShape.rectangle
            ? RoundedRectangleBorder(borderRadius: radius)
            : const CircleBorder(),

        borderRadius: shape == BoxShape.rectangle ? radius : null,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: begin, end: end),
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? radius : null,

            /// 🔥 Gradient Shadow
            boxShadow: enableShadow
                ? [
                    BoxShadow(
                      color: colors.first.withValues(alpha: shadowOpacity),
                      blurRadius: shadowBlur,
                      offset: shadowOffset,
                    ),
                    BoxShadow(
                      color: colors.last.withValues(alpha: shadowOpacity * 0.7),
                      blurRadius: shadowBlur,
                      offset: shadowOffset,
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(borderWidth),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: shape,
              borderRadius: shape == BoxShape.rectangle
                  ? BorderRadius.circular(borderRadius - borderWidth)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
