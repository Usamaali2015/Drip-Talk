import 'login_responsive_barrels.dart';

class DesktopLoginView extends StatelessWidget {
  const DesktopLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        /// LEFT – Background Video + Branding Text
        Expanded(
          child: Stack(
            children: [
              /// Video Background
              const AppVideoPlayer(asset: AppAssets.loginBg),
              Container(color: AppColors.black.withValues(alpha: 0.7)),

              /// Branding Text over the video
              Padding(
                padding: const EdgeInsets.all(AppSizes.s64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppLocalizations.of(context)!.loginSubtitle,
                      style: AppTextStyles.ts40(
                        context,
                        color: colorScheme.onSecondary,
                      ),
                    ),
                    const AppGap(AppSizes.s24),
                    AppText(
                      text: AppLocalizations.of(context)!.appName,
                      style: AppTextStyles.ts32(
                        context,
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const AppGap(AppSizes.s24),
                    SizedBox(
                      width: AppSizes.s400,
                      child: AppText(
                        text: AppLocalizations.of(context)!.loginDescription,
                        style: AppTextStyles.ts18(
                          context,
                          color: colorScheme.onSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const AppGap(AppSizes.s24),
                    AppText(
                      text: AppLocalizations.of(context)!.secureReliable,
                      style: AppTextStyles.ts18(
                        context,
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// RIGHT – Login Form (Glass Card)
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSizes.s440),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.s40),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(AppRadius.r28),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: AppLocalizations.of(context)!.login,
                        style: AppTextStyles.ts24(
                          context,
                          color:colorScheme.onSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const AppGap(AppSizes.s32),

                      AppTextField(
                        prefixIcon: Icons.email_outlined,
                        hintText: AppLocalizations.of(context)!.email,
                      ),

                      const AppGap(AppSizes.s16),

                      AppTextField(
                        prefixIcon: Icons.lock_outline,
                        hintText: AppLocalizations.of(context)!.password,
                        obscureText: true,
                      ),

                      const AppGap(AppSizes.s16),

                      AppForgotPasswordButton(
                        onTap: () {
                          context.goNamed(AppRoutes.forgotPassword);
                        },
                      ),

                      const AppGap(AppSizes.s40),

                      AppDivider.horizontal(
                        text: AppLocalizations.of(context)!.orContinueWith,
                      ),

                      const AppGap(AppSizes.s28),

                      SocialAuthButton(
                        type: SocialAuthType.google,
                        onPressed: () {},
                      ),

                      const AppGap(AppSizes.s16),

                      SocialAuthButton(
                        type: SocialAuthType.apple,
                        onPressed: () {},
                      ),

                      const AppGap(AppSizes.s40),

                      AppButton(
                        height: AppSizes.s48,
                        text: AppLocalizations.of(context)!.login,
                        onPressed: () {
                          AuthGuard.isLoggedIn.value = true;
                          context.go(RoutePaths.home);
                        },
                      ),

                      const AppGap(AppSizes.s28),

                      AppAuthSwitchText(
                        leadingText: AppLocalizations.of(
                          context,
                        )!.dontHaveAccount,
                        actionText: AppLocalizations.of(context)!.signup,
                        onTap: () {
                          context.goNamed(AppRoutes.signup);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
