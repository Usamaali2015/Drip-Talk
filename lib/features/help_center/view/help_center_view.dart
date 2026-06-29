import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/help_center/barrels/help_center_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HelpCenterBloc, HelpCenterState>(
      builder: (context, state) {
        final selectedCategory = state.selectedCategory;
        final questions = HelpCenterContent.questionsFor(selectedCategory);

        return AppResponsivePageLayout(
          backgroundGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.berryOverlayTop, AppColors.berryOverlayBottom],
          ),
          headerBuilder: (context, _) => HelpCenterPageHeader(
            title: l10n.helpCenter,
            subtitle: HelpCenterContent.subtitle(l10n),
            onBack: () => _handleBack(context),
          ),
          bodyBuilder: (context, contentWidth) {
            final isWideLayout = contentWidth >= 860;
            final categoryColumns = contentWidth >= 980
                ? 4
                : contentWidth >= 720
                ? 3
                : 2;
            final categoryAspectRatio = context.responsive(
              1.4,
              tablet: 1.5,
              tabletLarge: 1.55,
              desktop: 1.7,
            );
            final sectionGap = context.responsive(
              AppSizes.s16,
              tablet: AppSizes.s20,
              tabletLarge: AppSizes.s24,
              desktop: AppSizes.s28,
            );

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppButton(
                    text: l10n.contactSupport,
                    onPressed: () =>
                        context.pushNamed(AppRoutes.contactSupport),
                    height: AppSizes.s56,
                    width: isWideLayout ? 280 : double.infinity,
                    borderRadius: AppRadius.r16,
                    fontSize: 15,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    leadingIcon: const AppAssetImage(
                      assetPath: Assets.contactSupport,
                      width: AppSizes.s20,
                      height: AppSizes.s20,
                    ),
                  ),
                  if (state.isRefreshing) ...[
                    const AppGap(AppSizes.s16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: AppColors.lightBg,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                  const AppGap(AppSizes.s28),
                  if (state.isInitialLoading)
                    HelpCenterLoadingState(
                      categoryColumns: categoryColumns,
                      categoryAspectRatio: categoryAspectRatio,
                    )
                  else if (state.isFailure && !state.hasCategories)
                    ErrorRetryWidget(
                      message: state.errorMessage?.trim().isNotEmpty == true
                          ? state.errorMessage!.trim()
                          : l10n.helpCenterLoadFailed,
                      onRetry: () {
                        context.read<HelpCenterBloc>().add(
                          const LoadHelpCenterRequested(),
                        );
                      },
                    )
                  else if (state.isEmpty)
                    HelpCenterMessageCard(message: l10n.helpCenterNoCategories)
                  else if (isWideLayout)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: HelpCenterCategoriesSection(
                            title: HelpCenterContent.browseByCategoryTitle(
                              l10n,
                            ),
                            categories: state.categories,
                            selectedCategoryId: selectedCategory?.id,
                            categoryColumns: categoryColumns,
                            categoryAspectRatio: categoryAspectRatio,
                          ),
                        ),
                        AppGap(sectionGap, axis: Axis.horizontal),
                        Expanded(
                          flex: 4,
                          child: HelpCenterQuestionsSection(
                            title: HelpCenterContent.popularQuestionsTitle(
                              l10n,
                            ),
                            questions: questions,
                            emptyMessage: l10n.helpCenterNoQuestions,
                            boxed: true,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    HelpCenterCategoriesSection(
                      title: HelpCenterContent.browseByCategoryTitle(l10n),
                      categories: state.categories,
                      selectedCategoryId: selectedCategory?.id,
                      categoryColumns: categoryColumns,
                      categoryAspectRatio: categoryAspectRatio,
                    ),
                    const AppGap(AppSizes.s28),
                    HelpCenterQuestionsSection(
                      title: HelpCenterContent.popularQuestionsTitle(l10n),
                      questions: questions,
                      emptyMessage: l10n.helpCenterNoQuestions,
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.profiles);
  }
}
