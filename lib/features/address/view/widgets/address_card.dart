import 'package:drip_talk/features/address/barrels/address_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  final AddressListItem address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.16),
            blurRadius: AppSizes.s24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.lightBg.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSizes.s8,
              runSpacing: AppSizes.s8,
              children: [
                if (address.displayLabel != null)
                  _AddressBadge(
                    label: address.displayLabel!,
                    colors: const [AppColors.primaryLight, AppColors.primary],
                  ),
                if (address.isDefaultAddress)
                  _AddressBadge(
                    label: l10n.myAddressesDefaultBadge,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.24),
                      AppColors.secondary.withValues(alpha: 0.18),
                    ],
                    borderColor: AppColors.secondary.withValues(alpha: 0.44),
                  ),
              ],
            ),
            const AppGap(AppSizes.s14),
            ...address.detailLines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.s4),
                child: AppText(
                  text: line,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (address.phone?.trim().isNotEmpty == true) ...[
              const AppGap(AppSizes.s10),
              Row(
                children: [
                  Icon(
                    Icons.phone_in_talk_rounded,
                    size: AppSizes.s16,
                    color: AppColors.secondary,
                  ),
                  const AppGap(AppSizes.s8, axis: Axis.horizontal),
                  Expanded(
                    child: AppText(
                      text: address.phone!.trim(),
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const AppGap(AppSizes.s18),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: l10n.myAddressesEditAction,
                    onPressed: isDeleting ? null : onEdit,
                    height: 44,
                    fontSize: AppSizes.s14,
                    borderRadius: AppRadius.r15,
                    iconGap: AppSizes.s6,
                    leadingIcon: const Icon(
                      Icons.edit_outlined,
                      size: AppSizes.s16,
                      color: AppColors.pureWhite,
                    ),
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                  ),
                ),
                const AppGap(AppSizes.s12, axis: Axis.horizontal),
                Expanded(
                  child: AppButton(
                    text: isDeleting
                        ? l10n.myAddressesDeletingAction
                        : l10n.myAddressesDeleteAction,
                    onPressed: isDeleting ? null : onDelete,
                    height: 44,
                    fontSize: AppSizes.s14,
                    borderRadius: AppRadius.r15,
                    iconGap: AppSizes.s6,
                    leadingIcon: const Icon(
                      Icons.delete_outline_rounded,
                      size: AppSizes.s16,
                      color: AppColors.secondary,
                    ),
                    backgroundColor: AppColors.lightBg.withValues(alpha: 0.65),
                    borderColor: AppColors.secondary,
                    textColor: AppColors.secondary,
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

class _AddressBadge extends StatelessWidget {
  const _AddressBadge({
    required this.label,
    required this.colors,
    this.borderColor,
  });

  final String label;
  final List<Color> colors;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(AppRadius.circular),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: AppText(
        text: label,
        style: AppTextStyles.ts12(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
