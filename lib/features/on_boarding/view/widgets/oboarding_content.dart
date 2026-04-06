import 'package:drip_talk/features/splash/view/responsive_view/splash_barrels.dart';

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnboardingContent> pages(BuildContext context) => [
    OnboardingContent(
      image: Assets.imagesOnboarding1,
      title: AppLocalizations.of(context)!.onboardingWelcome,
      description: AppLocalizations.of(context)!.featureOneDescription,
    ),
    // OnboardingContent(
    //   image: Assets.imagesOnboarding2,
    //   title: AppLocalizations.of(context)!.onboardingWelcome,
    //   description: AppLocalizations.of(context)!.featureOneDescription,
    // ),
    // OnboardingContent(
    //   image: Assets.imagesOnboarding3,
    //   title: AppLocalizations.of(context)!.onboardingWelcome,
    //   description: AppLocalizations.of(context)!.featureOneDescription,
    // ),

    OnboardingContent(
      image:Assets.imagesOnboarding2,
      title: AppLocalizations.of(context)!.featureTwoTitle,
      description: AppLocalizations.of(context)!.featureTwoDescription,
    ),

    OnboardingContent(
      image: Assets.imagesOnboarding3,
      title: AppLocalizations.of(context)!.featureThreeTitle,
      description: AppLocalizations.of(context)!.featureThreeDescription,
    ),
  ];
}
