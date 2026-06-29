import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ContactSupportQuickContactCard extends StatelessWidget {
  const ContactSupportQuickContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s18),
          decoration: BoxDecoration(
            color: AppColors.supportCardBackground,
            borderRadius: BorderRadius.circular(AppRadius.r20),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.s48,
                height: AppSizes.s48,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pureWhite,
                  size: AppSizes.s24,
                ),
              ),
              const AppGap(AppSizes.s14, axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const AppGap(AppSizes.s4),
                    AppText(
                      text: subtitle,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),
              const AppGap(AppSizes.s12, axis: Axis.horizontal),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.pureWhite.withValues(alpha: 0.82),
                size: AppSizes.s24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
