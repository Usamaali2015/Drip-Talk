import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ShopFilterSectionCard extends StatelessWidget {
  const ShopFilterSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.isExpanded = true,
    this.onToggle,
  });

  final String title;
  final Widget child;
  final bool isExpanded;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final canToggle = onToggle != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.r12),
                    topRight: Radius.circular(AppRadius.r12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s14,
                    AppSizes.s14,
                    AppSizes.s14,
                    AppSizes.s12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: title,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (canToggle)
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: AppColors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.r16),
            ),
            child: AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s14,
                  0,
                  AppSizes.s14,
                  AppSizes.s14,
                ),
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.white.withValues(alpha: 0.08),
                    ),
                    const AppGap(AppSizes.s12, axis: Axis.vertical),
                    child,
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
              sizeCurve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}
