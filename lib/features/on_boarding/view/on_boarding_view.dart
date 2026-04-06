import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';

import 'on_boarding_barrels.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const ResponsiveOnboarding(),
    );
  }
}

class ResponsiveOnboarding extends StatelessWidget {
  const ResponsiveOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: const MobileOnBoardingView(),
        tablet: const TabletOnboardingView(),
        tabletLarge: const TabletOnboardingView(),
        desktop: const DesktopOnboardingView(),
      ),
    );
  }
}
