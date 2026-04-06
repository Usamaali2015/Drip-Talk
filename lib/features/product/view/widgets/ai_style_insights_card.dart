import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AIStyleInsightsCard extends StatelessWidget {
  const AIStyleInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r24),
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
        ),
      ),
      child: Container(
        padding: AppPadding.allMedium,
        decoration: BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: AppColors.cyan, size: 24),
                const AppGap(AppSizes.s8, axis: Axis.horizontal),
                AppText(
                  text: "AI Style Insights",
                  variant: AppTextVariant.ts18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.cyan,
                ),
              ],
            ),
            const AppGap(AppSizes.s16),
            _buildInsightRow(
              "🎯",
              "Perfect Pairing:",
              "Wear with black cargo pants and high-top sneakers",
            ),
            const AppGap(AppSizes.s12),
            _buildInsightRow(
              "✨",
              "Style Tip:",
              "Roll up sleeves for a more casual look",
            ),
            const AppGap(AppSizes.s12),
            _buildInsightRow(
              "📈",
              "Trend Alert:",
              "85% of your style matches this item",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(String emoji, String title, String description) {
    return Container(
      padding: AppPadding.allSmall,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "$title ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
