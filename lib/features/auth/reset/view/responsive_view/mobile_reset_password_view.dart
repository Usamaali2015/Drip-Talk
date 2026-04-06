import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_back_button.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_dialog_box.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/common/widgets/app_text_field.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/helpers_utils.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/routes_barrels.dart';
import 'package:drip_talk/features/auth/reset/bloc/reset_password_bloc.dart';
import 'package:drip_talk/features/auth/reset/bloc/reset_password_event.dart';
import 'package:drip_talk/features/auth/reset/bloc/reset_password_state.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileResetPasswordView extends StatefulWidget {
  final String email;
  final String resetToken;

  const MobileResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<MobileResetPasswordView> createState() =>
      _MobileResetPasswordViewState();
}

class _MobileResetPasswordViewState extends State<MobileResetPasswordView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResetPasswordBloc>(),
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            AppHelpersUtils.showCustomDialog(
              context,
              AppDialog(
                title: AppLocalizations.of(context)!.passwordResetSuccess,
                description: AppLocalizations.of(context)!.youCanNowLogin,

                assetPath: Assets.forgotIcon,
                content: const SizedBox.shrink(),
                primaryButtonText: AppLocalizations.of(context)!.login,
                onPrimaryPressed: () => context.goNamed(AppRoutes.login),
              ),
            );
          } else if (state is ResetPasswordError) {
            ToastUtils.show(context, state.message, type: ToastType.error);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: AppPadding.horizontalLarge,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppGap(AppSizes.s32),
                  const AppBackButton(),
                  const AppGap(AppSizes.s100),
                  Center(
                    child: Container(
                      height: AppSizes.s80,
                      width: AppSizes.s80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const AppAssetImage(
                        assetPath: Assets.iconsLock,
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s32),
                  Center(
                    child: AppText(
                      text: AppLocalizations.of(
                        context,
                      )!.resetPassword.toUpperCase(),
                      style: AppTextStyles.ts24(
                        context,
                        color:AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s16),
                  AppText(
                    text: AppLocalizations.of(context)!.resetPasswordDes,
                    style: AppTextStyles.ts14(
                      context,
                      color:AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const AppGap(AppSizes.s48),
                  AppTextField(
                    controller: _passwordController,
                    hintText: AppLocalizations.of(context)!.password,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s24),
                  AppTextField(
                    controller: _confirmPasswordController,
                    hintText: AppLocalizations.of(context)!.confirmPassword,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s48),
                  BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                    builder: (context, state) {
                      return AppButton(
                        height: AppSizes.s48,
                        text: state is ResetPasswordLoading
                            ? 'Resetting...'
                            : AppLocalizations.of(context)!.resetPassword,
                        borderRadius: AppRadius.circular,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        onPressed: state is ResetPasswordLoading
                            ? null
                            : () {
                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  ToastUtils.show(
                                    context,
                                    "Passwords do not match",
                                    type: ToastType.error,
                                  );
                                  return;
                                }
                                context.read<ResetPasswordBloc>().add(
                                  ResetPasswordSubmitted(
                                    email: widget.email,
                                    resetToken: widget.resetToken,
                                    password: _passwordController.text,
                                    passwordConfirmation:
                                        _confirmPasswordController.text,
                                  ),
                                );
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
