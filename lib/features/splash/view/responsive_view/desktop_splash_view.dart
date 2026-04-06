import 'splash_barrels.dart';

class DesktopSplashView extends StatelessWidget {
  const DesktopSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        /// LEFT – Branding
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.splash),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.black.withValues(alpha: 0.7),
                  BlendMode.darken,
                ),
              ),
            ),
            padding: const EdgeInsets.all(AppSizes.s64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: AppLocalizations.of(context)!.appName,
                  style: AppTextStyles.ts40(
                    context,
                    color:colorScheme.onSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const AppGap(AppSizes.s24),
                SizedBox(
                  width: AppSizes.s400,
                  child: AppText(
                    text: AppLocalizations.of(context)!.splashTitle,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: AppTextStyles.ts18(context, color:colorScheme.onSecondary),
                  ),
                ),
                const AppGap(AppSizes.s48),
                AppButton(
                  width: AppSizes.s400,
                  height: AppSizes.s56,
                  text: AppLocalizations.of(context)!.getStarted,
                  onPressed: () {
                    context.goNamed(AppRoutes.onboarding);
                  },
                ),
              ],
            ),
          ),
        ),

        /// RIGHT – CTA + Features
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.s420),
            child: Padding(
              padding: AppPadding.extraHorizontalLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Feature List with Icons
                  _FeatureItem(
                    icon: Icons.flash_on,
                    title: AppLocalizations.of(context)!.featureOneTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureOneDescription,
                  ),
                  _FeatureItem(
                    icon: Icons.sync,
                    title: AppLocalizations.of(context)!.featureTwoTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureTwoDescription,
                  ),
                  _FeatureItem(
                    icon: Icons.security,
                    title: AppLocalizations.of(context)!.featureThreeTitle,
                    description: AppLocalizations.of(
                      context,
                    )!.featureThreeDescription,
                  ),
                  const SizedBox(height: AppSizes.s32),
                ],
              ),
            ),
          ),
        ),
      ],
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

    return Padding(
      padding: AppPadding.horizontalSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppGap(AppSizes.s20),
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: AppSizes.s28),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              Expanded(
                // Wrap the title in an Expanded widget
                child: AppText(
                  text: title,
                  maxLines: 2,
                  style: AppTextStyles.ts18(
                    context,
                    color:colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const AppGap(AppSizes.s10),
          // Make description text flexible, so it adjusts based on available space
          AppText(
            text: description,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.ts14(context,color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
