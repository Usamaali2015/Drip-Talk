import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProminentDisclosureDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String dataCollected;
  final String purpose;
  final String usage;
  final String storageInfo;
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const ProminentDisclosureDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.dataCollected,
    required this.purpose,
    required this.usage,
    required this.storageInfo,
    required this.onAccept,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSizes.s20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.28),
          width: 1.5,
        ),
      ),
      elevation: 0,
      backgroundColor: AppColors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.supportHeaderBackground,
                AppColors.lightBg,
                AppColors.darkBg2,
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with glowing circle
              Container(
                width: AppSizes.s72,
                height: AppSizes.s72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.24),
                      AppColors.primary.withValues(alpha: 0.22),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.pureWhite.withValues(alpha: 0.16),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pureWhite,
                  size: AppSizes.s32,
                ),
              ),
              const AppGap(AppSizes.s16),

              // Title
              AppText(
                text: title.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const AppGap(AppSizes.s20),

              // Disclosure Items in a beautiful card
              Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  border: Border.all(
                    color: AppColors.pureWhite.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDisclosureRow(
                      context,
                      Icons.info_outline_rounded,
                      dataCollected,
                    ),
                    const AppGap(AppSizes.s12),
                    _buildDisclosureRow(
                      context,
                      Icons.help_outline_rounded,
                      purpose,
                    ),
                    const AppGap(AppSizes.s12),
                    _buildDisclosureRow(
                      context,
                      Icons.settings_suggest_rounded,
                      usage,
                    ),
                    const AppGap(AppSizes.s12),
                    _buildDisclosureRow(
                      context,
                      Icons.security_rounded,
                      storageInfo,
                    ),
                  ],
                ),
              ),

              const AppGap(AppSizes.s24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: l10n.permissionDeny,
                      onPressed: onDeny,
                      borderRadius: AppRadius.r20,
                      backgroundColor: AppColors.pureWhite.withValues(
                        alpha: 0.04,
                      ),
                      borderColor: AppColors.pureWhite.withValues(alpha: 0.12),
                      textColor: AppColors.pureWhite.withValues(alpha: 0.8),
                      height: AppSizes.s48,
                      fontSize: AppSizes.s14,
                    ),
                  ),
                  const AppGap(AppSizes.s12, axis: Axis.horizontal),
                  Expanded(
                    child: AppButton(
                      text: l10n.permissionAccept,
                      onPressed: onAccept,
                      borderRadius: AppRadius.r20,
                      gradientColors: const [
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                      height: AppSizes.s48,
                      fontSize: AppSizes.s14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisclosureRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.cyan, size: AppSizes.s18),
        const AppGap(AppSizes.s10, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: text,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ).copyWith(height: 1.35),
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
