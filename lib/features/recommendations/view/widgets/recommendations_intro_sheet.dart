import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future<bool> showRecommendationsIntroSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => const RecommendationsIntroSheet(),
  );

  return result ?? false;
}

class RecommendationsIntroSheet extends StatelessWidget {
  const RecommendationsIntroSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r30),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.recommendationsIntroGradientTop,
                AppColors.recommendationsIntroGradientBottom,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),
                AppGap(AppSizes.s12),
                Container(
                  width: AppSizes.s50,
                  height: AppSizes.s50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.secondary, AppColors.primary],
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.pureWhite,
                    size: AppSizes.s24,
                  ),
                ),
                const SizedBox(height: AppSizes.s18),
                AppText(
                  text: l10n.profileSetupDialogTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts28(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s10),
                AppText(
                  text: l10n.profileSetupDialogDescription,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.45),
                ),
                const SizedBox(height: AppSizes.s20),
                AppButton(
                  text: l10n.profileSetupDialogAction,
                  height: AppSizes.s56,
                  borderRadius: AppRadius.circular,
                  gradientColors: const [
                    AppColors.secondary,
                    AppColors.primary,
                  ],
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
