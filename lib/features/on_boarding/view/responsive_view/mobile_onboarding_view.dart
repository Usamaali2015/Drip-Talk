import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'on_boarding_barrels.dart';

class MobileOnBoardingView extends StatelessWidget {
  const MobileOnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: OnboardingContent.pages(context).length,
            itemBuilder: (context, index) {
              final onboardingContent = OnboardingContent.pages(context)[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      double page = pageController.position.haveDimensions
                          ? pageController.page!
                          : pageController.initialPage.toDouble();
                      double value = page - index;
                      double alignmentX =
                          -value *
                          0.5;
                      alignmentX = alignmentX.clamp(-1.0, 1.0);
                      return Container(
                        height: AppSizes.s583,
                        width: AppSizes.fitWidth,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(onboardingContent.image),
                            fit: BoxFit.cover,
                            alignment: Alignment(alignmentX, 0),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (index) {
              context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
            },
            pageSnapping: true,
            physics: const BouncingScrollPhysics(),
          ),
        ),

        Padding(
          padding: AppPadding.horizontalLarge,
          child: Column(
            children: [
              const AppGap(AppSizes.s32),
              OnboardingDots(count: OnboardingContent.pages(context).length),
              const AppGap(AppSizes.s24),
              Builder(
                builder: (context) {
                  final state = context.watch<OnboardingBloc>().state;
                  final onboardingContent = OnboardingContent.pages(
                    context,
                  )[state.currentIndex];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: Column(
                      key: ValueKey<int>(state.currentIndex),
                      children: [
                        AppText(
                          text: onboardingContent.title.toUpperCase(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.ts20(context, color:AppColors.white),
                        ),
                        const AppGap(AppSizes.s16),
                        AppText(
                          text: onboardingContent.description,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const AppGap(AppSizes.s20),
              Builder(
                builder: (context) {
                  final state = context.watch<OnboardingBloc>().state;
                  final totalPages = OnboardingContent.pages(context).length;
                  final isLastPage = state.currentIndex == totalPages - 1;
                  return AppButton(
                    text: isLastPage
                        ? AppLocalizations.of(context)!.getStarted
                        : AppLocalizations.of(context)!.continueText,
                    height: AppSizes.s50,
                    borderRadius: AppRadius.circular,
                    gradientColors: [AppColors.secondary, AppColors.primary],
                    onPressed: () {
                      int nextPage = state.currentIndex + 1;
                      if (nextPage < totalPages) {
                        pageController.animateToPage(
                          nextPage,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        context.read<OnboardingBloc>().add(
                          OnboardingPageChanged(nextPage),
                        );
                      } else {
                        context.goNamed(AppRoutes.login);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const AppGap(AppSizes.s40),
      ],
    );
  }
}
