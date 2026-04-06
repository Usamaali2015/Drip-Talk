import 'package:drip_talk/core/common/widgets/app_auth_switch_text.dart';
import 'package:drip_talk/core/common/widgets/app_back_button.dart';
import 'package:drip_talk/core/common/widgets/app_dialog_box.dart';
import 'package:drip_talk/core/services/api/api_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/helpers_utils.dart';
import 'package:drip_talk/core/utils/routes/routes_barrels.dart';
import 'package:drip_talk/features/auth/otp/domain/bloc/otp_bloc.dart';
import 'package:drip_talk/features/auth/otp/domain/bloc/otp_event.dart';
import 'package:drip_talk/features/auth/otp/domain/bloc/otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_otp.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';

class MobileOtpView extends StatefulWidget {
  final String email;
  final String type;
  const MobileOtpView({super.key, required this.email, required this.type});

  @override
  State<MobileOtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<MobileOtpView> {
  late final FocusNode _fn1, _fn2, _fn3, _fn4, _fn5, _fn6;
  late final TextEditingController _c1, _c2, _c3, _c4, _c5, _c6;

  @override
  void initState() {
    super.initState();
    _fn1 = FocusNode();
    _fn2 = FocusNode();
    _fn3 = FocusNode();
    _fn4 = FocusNode();
    _fn5 = FocusNode();
    _fn6 = FocusNode();
    _c1 = TextEditingController();
    _c2 = TextEditingController();
    _c3 = TextEditingController();
    _c4 = TextEditingController();
    _c5 = TextEditingController();
    _c6 = TextEditingController();
  }

  @override
  void dispose() {
    _fn1.dispose();
    _fn2.dispose();
    _fn3.dispose();
    _fn4.dispose();
    _fn5.dispose();
    _fn6.dispose();
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    _c5.dispose();
    _c6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OtpBloc>()..add(OtpTimerStarted()),
      child: BlocListener<OtpBloc, OtpState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.isResendSuccess != current.isResendSuccess ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.isSuccess) {
            if (widget.type == 'forgot_password' && state.resetToken != null) {
              context.pushNamed(
                AppRoutes.resetPassword,
                queryParameters: {
                  'email': widget.email,
                  'reset_token': state.resetToken!,
                },
              );
              ToastUtils.show(context, "OTP Verified", type: ToastType.success);
            } else {
              AppHelpersUtils.showCustomDialog(
                context,
                AppDialog(
                  title: AppLocalizations.of(
                    context,
                  )!.youHaveSignedUpSuccessfully,
                  description: AppLocalizations.of(context)!.congratulations,
                  assetPath: Assets.forgotIcon,
                  content: const SizedBox.shrink(),
                  primaryButtonText: AppLocalizations.of(context)!.continueText,
                  onPrimaryPressed: () => context.goNamed(AppRoutes.login),
                ),
              );
            }
          } else if (state.isResendSuccess) {
            ToastUtils.show(context, "OTP Resent", type: ToastType.success);
          } else if (state.errorMessage != null) {
            ToastUtils.show(
              context,
              state.errorMessage!,
              type: ToastType.error,
            );
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
                      text: AppLocalizations.of(
                        context,
                      )!.enterOtp.toUpperCase(),
                      style: AppTextStyles.ts24(
                        context,
                        color:AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppText(
                    text: AppLocalizations.of(context)!.resettingYourPassword,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const AppGap(AppSizes.s32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientOtpInput(
                        controller: _c1,
                        focusNode: _fn1,
                        nextFocus: _fn2,
                      ),
                      GradientOtpInput(
                        controller: _c2,
                        focusNode: _fn2,
                        nextFocus: _fn3,
                        previousFocus: _fn1,
                      ),
                      GradientOtpInput(
                        controller: _c3,
                        focusNode: _fn3,
                        nextFocus: _fn4,
                        previousFocus: _fn2,
                      ),
                      GradientOtpInput(
                        controller: _c4,
                        focusNode: _fn4,
                        nextFocus: _fn5,
                        previousFocus: _fn3,
                      ),
                      GradientOtpInput(
                        controller: _c5,
                        focusNode: _fn5,
                        nextFocus: _fn6,
                        previousFocus: _fn4,
                      ),
                      GradientOtpInput(
                        controller: _c6,
                        focusNode: _fn6,
                        previousFocus: _fn5,
                      ),
                    ],
                  ),
                  const AppGap(AppSizes.s32),
                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return AppButton(
                        height: AppSizes.s48,
                        text: state.isLoading
                            ? 'Verifying...'
                            : AppLocalizations.of(context)!.verifyCode,
                        borderRadius: AppRadius.circular,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        onPressed: state.isLoading
                            ? null
                            : () {
                                final otp =
                                    _c1.text +
                                    _c2.text +
                                    _c3.text +
                                    _c4.text +
                                    _c5.text +
                                    _c6.text;
                                context.read<OtpBloc>().add(
                                  OtpSubmitted(
                                    email: widget.email,
                                    otp: otp,
                                    type: widget.type,
                                  ),
                                );
                              },
                      );
                    },
                  ),
                  const AppGap(AppSizes.s24),
                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppAuthSwitchText(
                            leadingText: state.canResend
                                ? AppLocalizations.of(context)!.didntReceiveCode
                                : AppLocalizations.of(context)!.resend,
                            actionText: state.canResend
                                ? AppLocalizations.of(context)!.resend
                                : "00:${state.timerCount.toString().padLeft(2, '0')}",
                            onTap: state.canResend
                                ? () {
                                    context.read<OtpBloc>().add(
                                      OtpResent(
                                        email: widget.email,
                                        type: widget.type,
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ],
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
