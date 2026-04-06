import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/widgets/app_back_button.dart';
import 'package:drip_talk/core/common/widgets/app_dialog_box.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/helpers_utils.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_bloc.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_event.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_state.dart';
import 'package:drip_talk/features/splash/view/responsive_view/splash_barrels.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_view_barrels.dart';

class MobileForgotPasswordView extends StatefulWidget {
  const MobileForgotPasswordView({super.key});

  @override
  State<MobileForgotPasswordView> createState() =>
      _MobileForgotPasswordViewState();
}

class _MobileForgotPasswordViewState extends State<MobileForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            AppHelpersUtils.showCustomDialog(
              context,
              AppDialog(
                assetPath: Assets.forgotIcon,
                title: AppLocalizations.of(context)!.checkYourEmail,
                description: AppLocalizations.of(
                  context,
                )!.resettingYourPassword,
                content: const SizedBox.shrink(),
                primaryButtonText: AppLocalizations.of(context)!.verifyCode,
                onPrimaryPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    AppRoutes.otp,
                    queryParameters: {
                      'email': _emailController.text,
                      'type': 'forgot_password',
                    },
                  );
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
                      text: AppLocalizations.of(
                        context,
                      )!.forgotPassword.toUpperCase(),
                      style: AppTextStyles.ts24(
                        context,
                        color:AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s16),
                  AppText(
                    text: AppLocalizations.of(context)!.forgotPasswordSubtitle,
                    maxLines: 4,
                    style: AppTextStyles.ts14(
                      context,
                      color:AppColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const AppGap(AppSizes.s50),
                  AppTextField(
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    borderRadius: AppRadius.circular,
                  ),
                  const AppGap(AppSizes.s48),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      return AppButton(
                        height: AppSizes.s48,
                        text: state is ForgotPasswordLoading
                            ? 'Sending...'
                            : AppLocalizations.of(context)!.sendResetLink,
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
