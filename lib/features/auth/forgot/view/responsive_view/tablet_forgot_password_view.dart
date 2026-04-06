import 'forgot_password_view_barrels.dart';

class TabletForgotPasswordView extends StatelessWidget {
  const TabletForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppVideoPlayer(asset: AppAssets.forgotPasswordBg),
        Container(color: Colors.black.withValues(alpha: 0.65)),

        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: AppPadding.horizontalLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppLocalizations.of(context)!
                          .forgotPassword,
                      style: AppTextStyles.ts24(context,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const AppGap(AppSizes.s16),

                    AppText(
                      text: AppLocalizations.of(context)!
                          .forgotPasswordSubtitle,
                      style: AppTextStyles.ts14(context,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                    ),

                    const AppGap(AppSizes.s40),

                    AppTextField(
                      prefixIcon: Icons.email_outlined,
                      hintText:
                      AppLocalizations.of(context)!.email,
                    ),

                    const AppGap(AppSizes.s48),

                    AppButton(
                      height: AppSizes.s48,
                      text:
                      AppLocalizations.of(context)!
                          .sendResetLink,
                      onPressed: () {},
                    ),

                    const AppGap(AppSizes.s28),

                    AppAuthSwitchText(
                      leadingText:
                      AppLocalizations.of(context)!
                          .rememberPassword,
                      actionText:
                      AppLocalizations.of(context)!.login,
                      onTap: () {
                        context.goNamed(AppRoutes.login);
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
