import 'package:drip_talk/features/dashboard/profile/data/models/profile_update_response_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

enum TwoFactorSetupSheetResult { next, cancelled }

class TwoFactorSetupSheet extends StatelessWidget {
  const TwoFactorSetupSheet({super.key, required this.setup});

  final TwoFactorSetupData setup;

  static Future<TwoFactorSetupSheetResult?> show(
    BuildContext context, {
    required TwoFactorSetupData setup,
  }) {
    return showModalBottomSheet<TwoFactorSetupSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => TwoFactorSetupSheet(setup: setup),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final qrBytes = setup.qrCodeBytes;

    return Container(
      padding: const EdgeInsets.only(top: AppSizes.s4),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s24,
          AppSizes.s28,
          AppSizes.s24,
          AppSizes.s28,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: l10n.twoFactorSetupTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts24(
                context,
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const AppGap(AppSizes.s12),
            AppText(
              text: l10n.twoFactorSetupSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.82),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
            ),
            const AppGap(AppSizes.s24),
            Container(
              padding: const EdgeInsets.all(AppSizes.s6),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(AppRadius.r28),
                border: Border.all(color: AppColors.secondary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r24),
                child: SizedBox(
                  width: AppSizes.s200,
                  height: AppSizes.s200,
                  child: qrBytes == null
                      ? const ColoredBox(
                          color: AppColors.pureWhite,
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            color: AppColors.pureBlack,
                            size: AppSizes.s80,
                          ),
                        )
                      : Image.memory(qrBytes, fit: BoxFit.cover),
                ),
              ),
            ),
            const AppGap(AppSizes.s24),
            AppText(
              text: l10n.twoFactorManualKeyLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            const AppGap(AppSizes.s12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s16,
                vertical: AppSizes.s16,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.9),
                ),
              ),
              child: AppText(
                text: setup.formattedSecret,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts10(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const AppGap(AppSizes.s28),
            AppButton(
              text: l10n.twoFactorNextVerifyAction,
              onPressed: () =>
                  Navigator.of(context).pop(TwoFactorSetupSheetResult.next),
              height: AppSizes.s56,
              borderRadius: AppRadius.r16,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              fontSize: AppSizes.s16,
            ),
            const AppGap(AppSizes.s16),
            AppButton(
              text: l10n.cancel,
              onPressed: () => Navigator.of(
                context,
              ).pop(TwoFactorSetupSheetResult.cancelled),
              height: AppSizes.s56,
              borderRadius: AppRadius.r16,
              backgroundColor: AppColors.lightBg.withValues(alpha: 0.85),
              borderColor: AppColors.secondary,
              textColor: AppColors.pureWhite,
              fontSize: AppSizes.s16,
            ),
          ],
        ),
      ),
    );
  }
}
