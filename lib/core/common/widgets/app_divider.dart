import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'app_gap.dart';
import 'app_text.dart';

class AppDivider extends StatelessWidget {
  final Axis axis;
  final double thickness;
  final double length;
  final Color? color;
  final EdgeInsetsGeometry margin;
  final String? text;

  final Color? textColor;

  const AppDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.thickness = 1,
    this.length = double.infinity,
    this.color,
    this.margin = EdgeInsets.zero,
    this.text,

    this.textColor,
  });

  const AppDivider.horizontal({
    super.key,
    this.thickness = 1,
    this.color,
    this.margin = EdgeInsets.zero,
    this.text,

    this.textColor,
  }) : axis = Axis.horizontal,
       length = double.infinity;

  const AppDivider.vertical({
    super.key,
    this.thickness = 1,
    this.color,
    this.margin = EdgeInsets.zero,
    this.length = double.infinity,
  }) : axis = Axis.vertical,
       text = null,

       textColor = null;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dividerColor = color ?? scheme.onSecondaryContainer;

    if (axis == Axis.vertical) {
      return Padding(
        padding: margin,
        child: SizedBox(
          width: thickness,
          height: length,
          child: DecoratedBox(decoration: BoxDecoration(color: dividerColor)),
        ),
      );
    }

    return Padding(
      padding: margin,
      child: Row(
        children: [
          _line(dividerColor),
          if (text != null) ...[
            const AppGap(AppSizes.s8, axis: Axis.horizontal),
            AppText(
              text: text!,

              style: AppTextStyles.ts14(
                context,
                color: textColor ?? scheme.onSecondaryContainer,
              ),
            ),
            const AppGap(AppSizes.s8, axis: Axis.horizontal),
          ],
          _line(dividerColor),
        ],
      ),
    );
  }

  Widget _line(Color color) {
    return Expanded(
      child: SizedBox(
        height: thickness,
        child: DecoratedBox(decoration: BoxDecoration(color: color)),
      ),
    );
  }
}
