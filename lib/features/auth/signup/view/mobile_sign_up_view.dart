import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/barrels/signup_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileSignUpView extends StatefulWidget {
  const MobileSignUpView({super.key});

  @override
  State<MobileSignUpView> createState() => _MobileSignUpViewState();
}

class _MobileSignUpViewState extends State<MobileSignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          if (state.message?.trim().isNotEmpty ?? false) {
            ToastUtils.show(
              context,
              state.message!,
              type: state.requiresOtpVerification
                  ? ToastType.info
                  : ToastType.success,
            );
          }

          if (state.requiresOtpVerification) {
            context.pushNamed(
              AppRoutes.otp,
              queryParameters: {
                'email': state.email,
                'type': AuthOtpPurpose.signupVerification.queryValue,
              },
            );
          } else if (state.hasAuthenticatedSession) {
            context.goNamed(AppRoutes.profileSetup);
          } else {
            context.goNamed(AppRoutes.login);
          }
        } else if (state is SignUpError) {
          debugPrint(state.message);
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
                children: [
                  const AppGap(AppSizes.s32),
                  AppBackButton(),
                  const AppGap(AppSizes.s32),
                  AppText(
                    text: AppLocalizations.of(
                      context,
                    )!.signupSubtitle.toUpperCase(),
                    style: AppTextStyles.ts24(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                  ),
                  const AppGap(AppSizes.s16),
                  AppText(
                    text: AppLocalizations.of(context)!.createAccountSubtitle,
                    maxLines: 2,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const AppGap(AppSizes.s32),
                  SignUpForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),

                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      final isLoading = state is SignUpLoading;
                      return AppButton(
                        height: AppSizes.s50,
                        text: isLoading
                            ? AppLocalizations.of(context)!.loadingSubmit
                            : AppLocalizations.of(context)!.signup,
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
                                  context.read<SignUpBloc>().add(
                                    SignUpSubmitted(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      passwordConfirmation:
                                          _confirmPasswordController.text,
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  ),
                  const AppGap(AppSizes.s50),
                  AppAuthSwitchText(
                    leadingText: AppLocalizations.of(
                      context,
                    )!.alreadyHaveAccount,
                    actionText: AppLocalizations.of(context)!.login,
                    onTap: () => context.goNamed(AppRoutes.login),
                  ),
                  const AppGap(AppSizes.s28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
