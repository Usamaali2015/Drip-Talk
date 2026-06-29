import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/on_boarding/barrels/on_boarding_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileOnBoardingView extends StatefulWidget {
  const MobileOnBoardingView({super.key});

  @override
  State<MobileOnBoardingView> createState() => _MobileOnBoardingViewState();
}

class _MobileOnBoardingViewState extends State<MobileOnBoardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: OnboardingContent.pages(context).length,
            itemBuilder: (context, index) {
              final onboardingContent = OnboardingContent.pages(context)[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double page = _pageController.position.haveDimensions
                          ? _pageController.page!
                          : _pageController.initialPage.toDouble();
                      double value = page - index;
                      double alignmentX = -value * 0.5;
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
                      color: AppColors.pureBlack.withValues(alpha: 0.5),
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
                          style: AppTextStyles.ts20(
                            context,
                            color: AppColors.pureWhite,
                          ),
                        ),
                        const AppGap(AppSizes.s16),
                        AppText(
                          text: onboardingContent.description,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.pureWhite,
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
                        _pageController.animateToPage(
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
