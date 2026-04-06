import 'package:drip_talk/core/services/api/api_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/features/auth/login/bloc/login_event.dart';
import 'package:drip_talk/features/auth/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/auth/login/bloc/login_bloc.dart';
import 'login_responsive_barrels.dart';

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
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ToastUtils.show(
              context,
              state.message ?? AppLocalizations.of(context)!.loginSuccess,
            );
            context.go(RoutePaths.home);
          } else if (state is LoginVerificationRequired) {
            if (state.message?.trim().isNotEmpty ?? false) {
              ToastUtils.show(
                context,
                state.message!,
                type: ToastType.info,
              );
            }
            context.pushNamed(
              AppRoutes.otp,
              queryParameters: {'email': state.email, 'type': 'signup'},
            );
          } else if (state is LoginError) {
            ToastUtils.show(context, state.message, type: ToastType.error);
          }
        },
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
                      text: AppLocalizations.of(
                        context,
                      )!.loginDes.toUpperCase(),
                      style: AppTextStyles.ts24(
                        context,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const AppGap(AppSizes.s10),
                    AppText(
                      text: AppLocalizations.of(context)!.loginDescription,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const AppGap(AppSizes.s64),
                    AppText(
                      text: AppLocalizations.of(context)!.enterYourEmail,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.white,
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
                        color: AppColors.white,
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
                              ? 'Logging in...'
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
                    const AppGap(AppSizes.s14),
                    AppDivider.horizontal(
                      text: AppLocalizations.of(context)!.orText,
                      textColor: AppColors.white,
                      color: AppColors.primary,
                    ),
                    const AppGap(AppSizes.s14),
                    SocialAuthButton(
                      type: SocialAuthType.google,
                      onPressed: () {},
                      backgroundColor: AppColors.white,
                      borderRadius: AppRadius.circular,
                    ),
                    const AppGap(AppSizes.s16),
                    SocialAuthButton(
                      type: SocialAuthType.apple,
                      onPressed: () {},
                      backgroundColor: AppColors.white,
                      borderRadius: AppRadius.circular,
                    ),
                    const AppGap(AppSizes.s80),
                    AppAuthSwitchText(
                      leadingText: AppLocalizations.of(
                        context,
                      )!.dontHaveAccount,
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
      ),
    );
  }
}
