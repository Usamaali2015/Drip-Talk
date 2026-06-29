import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class DeleteAddressSheet extends StatelessWidget {
  const DeleteAddressSheet({super.key, required this.address});

  final AddressListItem address;

  static Future<bool?> show(
    BuildContext context, {
    required AddressListItem address,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => DeleteAddressSheet(address: address),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s24,
          AppSizes.s18,
          AppSizes.s24,
          AppSizes.s24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 54,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
            ),
            const AppGap(AppSizes.s20),
            Center(
              child: Container(
                width: AppSizes.s56,
                height: AppSizes.s56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.16),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.44),
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.secondary,
                  size: AppSizes.s28,
                ),
              ),
            ),
            const AppGap(AppSizes.s18),
            Center(
              child: AppText(
                text: l10n.deleteAddressSheetTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts22(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const AppGap(AppSizes.s8),
            Center(
              child: AppText(
                text: l10n.deleteAddressSheetSubtitle,
                textAlign: TextAlign.center,
                maxLines: 2,

                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.78),
                ),
              ),
            ),

            const AppGap(22),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: l10n.cancel,
                    onPressed: () => Navigator.of(context).pop(false),
                    height: 52,
                    borderRadius: AppRadius.r16,
                    backgroundColor: AppColors.lightBg.withValues(alpha: 0.82),
                    borderColor: AppColors.pureWhite.withValues(alpha: 0.16),
                    fontSize: 16,
                    textColor: AppColors.pureWhite,
                  ),
                ),
                const AppGap(AppSizes.s12, axis: Axis.horizontal),
                Expanded(
                  child: AppButton(
                    text: l10n.deleteAddressConfirmAction,
                    onPressed: () => Navigator.of(context).pop(true),
                    height: 52,
                    borderRadius: AppRadius.r16,
                    fontSize: 16,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
