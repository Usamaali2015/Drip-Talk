import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AIStyleInsightsCard extends StatelessWidget {
  const AIStyleInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  text: l10n.aiStyleInsightsTitle,
                  variant: AppTextVariant.ts18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.cyan,
                ),
              ],
            ),
            const AppGap(AppSizes.s16),
            _buildInsightRow(
              "🎯",
              l10n.aiStyleInsightsPerfectPairing,
              l10n.aiStyleInsightsPerfectPairingDescription,
            ),
            const AppGap(AppSizes.s12),
            _buildInsightRow(
              "✨",
              l10n.aiStyleInsightsStyleTip,
              l10n.aiStyleInsightsStyleTipDescription,
            ),
            const AppGap(AppSizes.s12),
            _buildInsightRow(
              "📈",
              l10n.aiStyleInsightsTrendAlert,
              l10n.aiStyleInsightsTrendAlertDescription,
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
        color: AppColors.pureWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.1)),
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
                  color: AppColors.pureWhite,
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
                      color: AppColors.pureWhite.withValues(alpha: 0.8),
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
