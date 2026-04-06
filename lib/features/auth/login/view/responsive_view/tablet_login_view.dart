import 'login_responsive_barrels.dart';

class TabletLoginView extends StatelessWidget {
  const TabletLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🎥 Background Video
        const AppVideoPlayer(asset: AppAssets.loginBg),

        /// 🌑 Dark overlay
        Container(color: AppColors.black.withValues(alpha: 0.6)),

        /// 🧱 Content
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSizes.s420),
              child: SingleChildScrollView(
                padding: AppPadding.horizontalLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppLocalizations.of(context)!.login,
                      style: AppTextStyles.ts24(
                        context,
                        color:Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const AppGap(AppSizes.s16),

                    AppText(
                      text: AppLocalizations.of(context)!.loginDescription,
                      maxLines: 3,
                      style: AppTextStyles.ts14(
                        context,
                        color:Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),

                    const AppGap(AppSizes.s40),

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

                    const AppGap(AppSizes.s48),

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

                    const AppGap(AppSizes.s48),

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
      ],
    );
  }
}
