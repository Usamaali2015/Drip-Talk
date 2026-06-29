import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ContactSupportSectionHeading extends StatelessWidget {
  const ContactSupportSectionHeading({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppSizes.s18),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: title,
            style: AppTextStyles.ts24(
              context,
              color: AppColors.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
