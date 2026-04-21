import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/l10n/app_localizations.dart';

class AppForgotPasswordButton extends StatelessWidget {
  final VoidCallback onTap;
  final Alignment alignment;

  const AppForgotPasswordButton({
    super.key,
    required this.onTap,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.s6),
        child: Padding(
          padding: AppPadding.horizontalSmall,
          child: Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
