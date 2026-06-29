import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/helpers_utils.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/barrels/reset_password_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/mobile_reset_password_view_widgets.dart';

class MobileResetPasswordView extends StatelessWidget {
  final String email;
  final String resetToken;
  final PasswordResetSource source;

  const MobileResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<ResetPasswordBloc>(),
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listenWhen: (previous, current) =>
            previous.submissionStatus != current.submissionStatus ||
            previous.feedbackMessage != current.feedbackMessage,
        listener: (context, state) {
          final feedback = state.feedbackMessage?.trim();
          if (state.isFailure) {
            String? message;
            if (state.failureReason ==
                ResetPasswordFailureReason.missingSession) {
              message = l10n.changePasswordSessionExpired;
            } else if (state.failureReason == ResetPasswordFailureReason.api &&
                feedback != null &&
                feedback.isNotEmpty) {
              message = feedback;
            }

            if (message != null && message.isNotEmpty) {
              ToastUtils.show(context, message, type: ToastType.error);
            }
          }

          if (state.isSuccess) {
            final pageContext = context;
            AppHelpersUtils.showCustomDialog(
              pageContext,
              AppDialog(
                title: l10n.passwordResetSuccess,
                description: source == PasswordResetSource.profile
                    ? l10n.changePasswordProfileSuccessDescription
                    : l10n.youCanNowLogin,
                assetPath: Assets.forgotIcon,
                content: const SizedBox.shrink(),
                primaryButtonText: source == PasswordResetSource.profile
                    ? l10n.continueText
                    : l10n.login,
                onPrimaryPressed: () {
                  Navigator.of(pageContext, rootNavigator: true).pop();
                  if (source == PasswordResetSource.profile) {
                    pageContext.pop(true);
                    return;
                  }
                  pageContext.goNamed(AppRoutes.login);
                },
              ),
            );
          }
        },
        child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s24,
                  AppSizes.s28,
                  AppSizes.s24,
                  AppSizes.s32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PinkBackButton(onPressed: () => context.pop()),
                    const AppGap(AppSizes.s40),
                    AppText(
                      text: l10n.changePasswordScreenTitle,
                      style: AppTextStyles.ts24(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const AppGap(AppSizes.s12),
                    AppText(
                      text: l10n.changePasswordScreenSubtitle,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                    ),
                    const AppGap(AppSizes.s36),
                    AppText(
                      text: l10n.newPassword,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const AppGap(AppSizes.s10),
                    AppTextField(
                      initialValue: state.password,
                      hintText: l10n.changePasswordNewPasswordHint,
                      obscureText: true,
                      borderRadius: AppRadius.r24,
                      errorText: _passwordErrorText(l10n, state),
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetPasswordPasswordChanged(value)),
                    ),
                    const AppGap(AppSizes.s20),
                    AppText(
                      text: l10n.confirmNewPassword,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const AppGap(AppSizes.s10),
                    AppTextField(
                      initialValue: state.passwordConfirmation,
                      hintText: l10n.changePasswordConfirmPasswordHint,
                      obscureText: true,
                      borderRadius: AppRadius.r24,
                      errorText: _confirmationErrorText(l10n, state),
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetPasswordConfirmationChanged(value)),
                    ),
                    const AppGap(AppSizes.s24),
                    const _PasswordRequirementsCard(),
                    const AppGap(AppSizes.s36),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: l10n.changePasswordUpdateAction,
                            isLoading: state.isLoading,
                            fontSize: 14,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.read<ResetPasswordBloc>().add(
                                ResetPasswordSubmitted(
                                  email: email,
                                  resetToken: resetToken,
                                  source: source,
                                ),
                              );
                            },
                            height: AppSizes.s56,
                            borderRadius: AppRadius.r20,
                            gradientColors: const [
                              AppColors.secondary,
                              AppColors.primary,
                            ],
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.horizontal),
                        Expanded(
                          child: AppButton(
                            text: l10n.cancel,
                            onPressed: state.isLoading
                                ? null
                                : () => context.pop(),
                            height: AppSizes.s56,
                            fontSize: 14,
                            borderRadius: AppRadius.r20,
                            backgroundColor: AppColors.lightBg.withValues(
                              alpha: 0.72,
                            ),
                            borderColor: AppColors.secondary,
                            textColor: AppColors.pureWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _passwordErrorText(AppLocalizations l10n, ResetPasswordState state) {
    if (!state.hasAttemptedSubmit) {
      return null;
    }

    if (state.password.trim().isEmpty) {
      return l10n.changePasswordPasswordRequired;
    }

    if (!state.isPasswordValid) {
      return l10n.changePasswordRequirementsMessage;
    }

    return null;
  }

  String? _confirmationErrorText(
    AppLocalizations l10n,
    ResetPasswordState state,
  ) {
    if (!state.hasAttemptedSubmit) {
      return null;
    }

    if (state.passwordConfirmation.trim().isEmpty) {
      return l10n.changePasswordConfirmationRequired;
    }

    if (!state.passwordsMatch) {
      return l10n.passwordsDoNotMatch;
    }

    return null;
  }
}
