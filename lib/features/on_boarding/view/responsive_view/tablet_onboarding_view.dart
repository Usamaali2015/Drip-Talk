import 'on_boarding_barrels.dart';

class TabletOnboardingView extends StatelessWidget {
  const TabletOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.onboardingBg),
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: AppPadding.horizontalLarge,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      const AppGap(AppSizes.s32),
                      const OnboardingDots(count: 3),
                      const AppGap(AppSizes.s40),

                      AppText(
                        text:
                        AppLocalizations.of(context)!
                            .onboardingWelcome +
                            AppLocalizations.of(context)!
                                .onboardingMatch,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.ts16(context,
                          color:  Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                        maxLines: 4,
                      ),

                      const AppGap(AppSizes.s48),

                      AppButton(
                        width: AppSizes.fitWidth,
                        text:
                        AppLocalizations.of(context)!.next,
                        onPressed: () {
                          context.goNamed(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
