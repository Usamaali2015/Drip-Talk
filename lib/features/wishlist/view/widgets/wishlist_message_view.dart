import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class WishlistMessageView extends StatelessWidget {
  const WishlistMessageView({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.s20,
        AppSizes.s40,
        AppSizes.s20,
        AppSizes.s40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: AppPadding.allLarge,
            decoration: BoxDecoration(
              color: AppColors.lightBg.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.s10),
                AppText(
                  text: description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: AppSizes.s20),
                AppButton(
                  text: actionLabel,
                  onPressed: onAction,
                  height: AppSizes.s48,
                  fontSize: AppSizes.s14,
                  fontWeight: FontWeight.w700,
                  gradientColors: const [AppColors.secondary, AppColors.primary],
                  borderRadius: AppRadius.circular,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
