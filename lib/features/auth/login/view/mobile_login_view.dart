import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/api/api_barrels.dart';
import 'package:drip_talk/core/utils/routes/routes_barrels.dart';
import 'package:drip_talk/features/auth/barrels/auth_barrels.dart';
import 'package:drip_talk/features/cart/barrels/cart_barrels.dart';
import 'package:drip_talk/features/wishlist/barrels/wishlist_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileLoginView extends StatefulWidget {
  const MobileLoginView({super.key});

  @override
  State<MobileLoginView> createState() => _MobileLoginViewState();
}

class _MobileLoginViewState extends State<MobileLoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ToastUtils.show(
                context,
                state.message ?? AppLocalizations.of(context)!.loginSuccess,
              );
              context.go(RoutePaths.wardrobes);
            } else if (state is LoginVerificationRequired) {
              if (state.message?.trim().isNotEmpty ?? false) {
                ToastUtils.show(context, state.message!, type: ToastType.info);
              }
              context.pushNamed(
                AppRoutes.otp,
                queryParameters: {
                  'email': state.email,
                  'type': AuthOtpPurpose.signupVerification.queryValue,
                },
              );
            } else if (state is LoginTwoFactorRequired) {
              if (state.message?.trim().isNotEmpty ?? false) {
                ToastUtils.show(context, state.message!, type: ToastType.info);
              }
              context.pushNamed(
                AppRoutes.twoFactorLogin,
                extra: state.challenge,
              );
            } else if (state is LoginError) {
              ToastUtils.show(context, state.message, type: ToastType.error);
            }
          },
        ),
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.message != current.message,
          listener: (context, state) {
            if (state.status == BiometricAuthStatus.success) {
              if (state.message?.trim().isNotEmpty == true) {
                ToastUtils.show(
                  context,
                  state.message!.trim(),
                  type: ToastType.success,
                );
              }
              context.read<CartBloc>().add(
                const LoadCart(showLoader: false, silent: true),
              );
              context.read<WishlistBloc>().add(
                const LoadWishlist(showLoader: false, silent: true),
              );
              context.go(RoutePaths.wardrobes);
              return;
            }

            if (state.status == BiometricAuthStatus.failure &&
                state.message?.trim().isNotEmpty == true) {
              ToastUtils.show(
                context,
                state.message!.trim(),
                type: ToastType.error,
              );
            }
          },
        ),
      ],
      child: SafeArea(
        child: Padding(
          padding: AppPadding.horizontalLarge,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppGap(AppSizes.s50),
                  AppText(
                    text: AppLocalizations.of(context)!.loginDes.toUpperCase(),
                    style: AppTextStyles.ts24(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const AppGap(AppSizes.s10),
                  AppText(
                    text: AppLocalizations.of(context)!.loginDescription,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const AppGap(AppSizes.s64),
                  AppText(
                    text: AppLocalizations.of(context)!.enterYourEmail,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const AppGap(AppSizes.s10),
                  AppTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s20),
                  AppText(
                    text: AppLocalizations.of(context)!.enterYourPassword,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const AppGap(AppSizes.s10),
                  AppTextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: AppLocalizations.of(context)!.enterPassword,
                    obscureText: true,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s16),
                  AppForgotPasswordButton(
                    onTap: () {
                      context.pushNamed(AppRoutes.forgotPassword);
                    },
                  ),
                  const AppGap(AppSizes.s24),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      final isLoading = state is LoginLoading;
                      return AppButton(
                        height: AppSizes.s48,
                        text: isLoading
                            ? AppLocalizations.of(context)!.loggingIn
                            : AppLocalizations.of(context)!.login,
                        borderRadius: AppRadius.circular,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<LoginBloc>().add(
                                    LoginSubmitted(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  ),
                  BlocBuilder<BiometricAuthBloc, BiometricAuthState>(
                    builder: (context, state) {
                      if (!state.canLoginWithBiometrics) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: AppSizes.s12),
                        child: AppButton(
                          height: AppSizes.s48,
                          isLoading:
                              state.status ==
                              BiometricAuthStatus.authenticating,
                          text: AppLocalizations.of(
                            context,
                          )!.editProfileBiometricTitle,
                          borderRadius: AppRadius.circular,
                          backgroundColor: AppColors.lightBg.withValues(
                            alpha: 0.9,
                          ),
                          borderColor: AppColors.secondary.withValues(
                            alpha: 0.5,
                          ),
                          leadingIcon: Icon(
                            state.prefersFaceId
                                ? Icons.face_retouching_natural_rounded
                                : Icons.fingerprint_rounded,
                            color: AppColors.pureWhite,
                            size: AppSizes.s18,
                          ),
                          onPressed: state.isBusy
                              ? null
                              : () {
                                  context.read<BiometricAuthBloc>().add(
                                    const BiometricLoginRequested(),
                                  );
                                },
                        ),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s14),
                  AppDivider.horizontal(
                    text: AppLocalizations.of(context)!.orText,
                    textColor: AppColors.pureWhite,
                    color: AppColors.primary,
                  ),
                  const AppGap(AppSizes.s14),
                  SocialAuthButton(
                    type: SocialAuthType.google,
                    onPressed: () {},
                    backgroundColor: AppColors.pureWhite,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s16),
                  SocialAuthButton(
                    type: SocialAuthType.apple,
                    onPressed: () {},
                    backgroundColor: AppColors.pureWhite,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s64),
                  AppAuthSwitchText(
                    leadingText: AppLocalizations.of(context)!.dontHaveAccount,
                    actionText: AppLocalizations.of(context)!.signup,
                    onTap: () {
                      context.pushNamed(AppRoutes.signup);
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
