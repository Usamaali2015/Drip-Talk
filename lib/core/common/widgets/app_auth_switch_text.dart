import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';

class AppAuthSwitchText extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final void Function()? onTap;

  const AppAuthSwitchText({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leadingText,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSizes.s6),
            Text(
              actionText,
              style: AppTextStyles.ts16(
                context,
                color: AppColors.cyan,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
