import 'on_boarding_barrels.dart';

class DesktopOnboardingView extends StatelessWidget {
  const DesktopOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          /// LEFT – Carousel
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.onboardingBg),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.black.withValues(alpha: 0.7),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  const OnboardingDots(count: 3),
                  const AppGap(AppSizes.s80),

                  SizedBox(
                    width: AppSizes.s400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.onboardingWelcome,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.ts28(
                            context,
                            color:colorScheme.onSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 4,
                        ),

                        const AppGap(AppSizes.s24),

                        AppText(
                          text: AppLocalizations.of(context)!.onboardingMatch,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.ts18(
                            context,
                            color:colorScheme.onSecondary,
                          ),
                          maxLines: 2,
                        ),

                        const AppGap(AppSizes.s48),

                        AppButton(
                          height: AppSizes.s56,
                          text: AppLocalizations.of(context)!.next,
                          onPressed: () {
                            context.goNamed(AppRoutes.login);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// RIGHT – Content (Features)
          Expanded(
            child: Padding(
              padding: AppPadding.extraHorizontalLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **Feature 1** (Instant Recommendations)
                  _FeatureItem(
                    icon: Icons.flash_on,
                    title: AppLocalizations.of(context)!.featureOneTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureOneDescription,
                  ),
                  const AppGap(AppSizes.s32),

                  /// **Feature 2** (Style Matching)
                  _FeatureItem(
                    icon: Icons.sync,
                    title: AppLocalizations.of(context)!.featureTwoTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureTwoDescription,
                  ),
                  const AppGap(AppSizes.s32),

                  /// **Feature 3** (Secure and Reliable)
                  _FeatureItem(
                    icon: Icons.security,
                    title: AppLocalizations.of(context)!.featureThreeTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureThreeDescription,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: AppSizes.s28),
        const AppGap(AppSizes.s16, axis: Axis.horizontal),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                style: AppTextStyles.ts18(
                  context,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const AppGap(AppSizes.s8),
              AppText(
                text: description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.ts14(context, color:colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
