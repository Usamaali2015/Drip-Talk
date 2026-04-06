import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CartCheckoutBar extends StatelessWidget {
  const CartCheckoutBar({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.s24,
        AppSizes.s12,
        AppSizes.s24,
        AppSizes.s16,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.r24),
          child: Ink(
            height: AppSizes.s56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r24),
              gradient: LinearGradient(
                colors: enabled
                    ? const [AppColors.secondary, AppColors.primary]
                    : [
                        AppColors.white.withValues(alpha: 0.16),
                        AppColors.white.withValues(alpha: 0.12),
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: AppText(
                text: label,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ).copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
