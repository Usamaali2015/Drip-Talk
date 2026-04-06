import 'forgot_password_view_barrels.dart';

class DesktopForgotPasswordView extends StatelessWidget {
  const DesktopForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        const AppVideoPlayer(asset: AppAssets.forgotPasswordBg),
        Container(color: Colors.black.withValues(alpha: 0.7)),

        Row(
          children: [
            /// LEFT – Branding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppLocalizations.of(context)!.forgotPassword,
                      style: AppTextStyles.ts40(context,
                        color:colorScheme.onSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const AppGap(AppSizes.s24),
                    AppText(
                      text: AppLocalizations.of(context)!.appName,
                      style: AppTextStyles.ts32(context,
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const AppGap(AppSizes.s24),

                    AppText(
                      text: AppLocalizations.of(
                        context,
                      )!.forgotPasswordSubtitle,
                      style: AppTextStyles.ts18(context,
                        color:colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,

                      ),
                      maxLines: 3,
                    ),
                    const AppGap(AppSizes.s24),

                    AppText(
                      text: AppLocalizations.of(
                        context,
                      )!.secureReliable,
                      style: AppTextStyles.ts18(context,
                        color:colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,

                      ),

                    ),
                  ],
                ),
              ),
            ),

            /// RIGHT – Glass Card
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSizes.s440),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.s40),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.forgotPassword,
                          style: AppTextStyles.ts24(context,
                            color:colorScheme.onSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const AppGap(AppSizes.s32),

                        AppTextField(
                          prefixIcon: Icons.email_outlined,
                          hintText: AppLocalizations.of(context)!.email,
                        ),

                        const AppGap(AppSizes.s40),

                        AppButton(
                          height: AppSizes.s48,
                          text: AppLocalizations.of(context)!.sendResetLink,
                          onPressed: () {},
                        ),

                        const AppGap(AppSizes.s28),

                        AppAuthSwitchText(
                          leadingText: AppLocalizations.of(
                            context,
                          )!.rememberPassword,
                          actionText: AppLocalizations.of(context)!.login,
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
        ),
      ],
    );
  }
}
