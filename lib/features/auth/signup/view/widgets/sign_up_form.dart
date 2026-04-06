import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text_field.dart';
import 'package:drip_talk/l10n/app_localizations.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppLocalizations.of(context)!.enterYourName,
          style: AppTextStyles.ts14(
            context,
            color:AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const AppGap(AppSizes.s10),
        AppTextField(
          controller: nameController,
          prefixIcon: Icons.person_outline,
          hintText: AppLocalizations.of(context)!.name,
          borderRadius: AppRadius.circular,
        ),
        const AppGap(AppSizes.s20),
        AppText(
          text: AppLocalizations.of(context)!.enterYourEmail,
          style: AppTextStyles.ts14(
            context,
            color:  AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const AppGap(AppSizes.s10),
        AppTextField(
          controller: emailController,
          prefixIcon: Icons.email_outlined,
          hintText: AppLocalizations.of(context)!.email,
          borderRadius: AppRadius.circular,
        ),
        const AppGap(AppSizes.s20),
        AppText(
          text: AppLocalizations.of(context)!.enterYourPassword,
          style: AppTextStyles.ts14(
            context,
            color:  AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const AppGap(AppSizes.s10),
        AppTextField(
          controller: passwordController,
          prefixIcon: Icons.lock_outline,
          hintText: AppLocalizations.of(context)!.password,
          obscureText: true,
          borderRadius: AppRadius.circular,
        ),
        const AppGap(AppSizes.s20),
        AppText(
          text: AppLocalizations.of(context)!.confirmYourPassword,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const AppGap(AppSizes.s10),
        AppTextField(
          controller: confirmPasswordController,
          prefixIcon: Icons.lock_outline,
          hintText: AppLocalizations.of(context)!.confirmPassword,
          obscureText: true,
          borderRadius: AppRadius.circular,
        ),
        const AppGap(AppSizes.s32),
      ],
    );
  }
}