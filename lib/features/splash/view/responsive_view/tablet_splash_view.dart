import 'splash_barrels.dart';

class TabletSplashView extends StatelessWidget {
  const TabletSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.splash),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withValues(alpha: 0.65),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: AppPadding.horizontalLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!.appName,
                    style: AppTextStyles.ts32(
                      context,
                      color:  Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const AppGap(AppSizes.s24),

                  AppText(
                    text: AppLocalizations.of(context)!.splashTitle,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: AppTextStyles.ts16(
                      context,
                      color:Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),

                  const AppGap(AppSizes.s48),

                  AppButton(
                    width: AppSizes.fitWidth,
                    height: AppSizes.s48,
                    text: AppLocalizations.of(context)!.getStarted,
                    onPressed: () {
                      context.goNamed(AppRoutes.onboarding);
                    },
                  ),
                  const AppGap(AppSizes.s40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
