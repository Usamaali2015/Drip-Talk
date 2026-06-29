import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/helpers_utils.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/barrels/forgot_password_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileForgotPasswordView extends StatefulWidget {
  final String? initialEmail;
  final PasswordResetSource source;

  const MobileForgotPasswordView({
    super.key,
    this.initialEmail,
    this.source = PasswordResetSource.auth,
  });

  @override
  State<MobileForgotPasswordView> createState() =>
      _MobileForgotPasswordViewState();
}

class _MobileForgotPasswordViewState extends State<MobileForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isProfileFlow = widget.source == PasswordResetSource.profile;

    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            final pageContext = context;
            AppHelpersUtils.showCustomDialog(
              pageContext,
              AppDialog(
                assetPath: Assets.forgotIcon,
                title: l10n.checkYourEmail,
                description: isProfileFlow
                    ? l10n.changePasswordVerificationSentDescription
                    : l10n.resettingYourPassword,
                content: const SizedBox.shrink(),
                primaryButtonText: l10n.verifyCode,
                onPrimaryPressed: () async {
                  Navigator.of(pageContext, rootNavigator: true).pop();
                  final didChangePassword = await pageContext.pushNamed(
                    AppRoutes.otp,
                    queryParameters: {
                      'email': _emailController.text,
                      'type': AuthOtpPurpose.forgotPassword.queryValue,
                      'source': widget.source.queryValue,
                    },
                  );
                  if (!pageContext.mounted) {
                    return;
                  }

                  if (isProfileFlow && didChangePassword == true) {
                    pageContext.pop(true);
                  }
                },
              ),
            );
          } else if (state is ForgotPasswordError) {
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
                  const AppGap(AppSizes.s28),
                  Center(
                    child: AppText(
                      text:
                          (isProfileFlow
                                  ? l10n.changePassword
                                  : l10n.forgotPassword)
                              .toUpperCase(),
                      style: AppTextStyles.ts24(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s16),
                  AppText(
                    text: isProfileFlow
                        ? l10n.changePasswordVerificationSubtitle
                        : l10n.forgotPasswordSubtitle,
                    maxLines: 4,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const AppGap(AppSizes.s50),
                  AppTextField(
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    hintText: l10n.enterEmail,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s48),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      return AppButton(
                        height: AppSizes.s48,
                        text: state is ForgotPasswordLoading
                            ? 'Sending...'
                            : (isProfileFlow
                                  ? l10n.sendVerificationCode
                                  : l10n.sendResetLink),
                        borderRadius: AppRadius.circular,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        onPressed: state is ForgotPasswordLoading
                            ? null
                            : () => context.read<ForgotPasswordBloc>().add(
                                ForgotPasswordSubmitted(_emailController.text),
                              ),
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
