import 'package:drip_talk/features/return_policy/data/models/return_policy_model.dart';
import 'package:drip_talk/features/return_policy/view/widgets/return_policy_backend_icon.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ReturnPolicySectionCard extends StatelessWidget {
  const ReturnPolicySectionCard({super.key, required this.items});

  final List<ReturnPolicyItem> items;

  @override
  Widget build(BuildContext context) {
    return GradientBorder(
      enableShadow: false,
      borderWidth: 1,
      borderRadius: AppRadius.r20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s18,
      ),
      backgroundColor: AppColors.lightBg,
      colors: [
        AppColors.secondary.withValues(alpha: 0.92),
        AppColors.secondary.withValues(alpha: 0.92),
      ],
      child: Column(
        children: List.generate(
          items.length,
          (index) => _ReturnPolicyItemTile(
            item: items[index],
            isLast: index == items.length - 1,
          ),
        ),
      ),
    );
  }
}

class _ReturnPolicyItemTile extends StatelessWidget {
  const _ReturnPolicyItemTile({required this.item, required this.isLast});

  final ReturnPolicyItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final heading = item.heading?.trim() ?? '';
    final subheading = item.subheading?.trim() ?? '';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.s4),
              child: ReturnPolicyBackendIcon(iconName: item.icon),
            ),
            const AppGap(AppSizes.s12, axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heading.isNotEmpty)
                    AppText(
                      text: heading,
                      maxLines: 2,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (subheading.isNotEmpty) ...[
                    if (heading.isNotEmpty) const AppGap(AppSizes.s4),
                    AppText(
                      text: subheading,
                      maxLines: 3,
                      style: AppTextStyles.ts10(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const AppGap(AppSizes.s12),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.pureWhite.withValues(alpha: 0.16),
          ),
          const AppGap(AppSizes.s12),
        ],
      ],
    );
  }
}
