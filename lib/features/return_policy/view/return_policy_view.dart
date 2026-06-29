import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/return_policy/barrels/return_policy_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/return_policy_view_widgets.dart';

class ReturnPolicyView extends StatelessWidget {
  const ReturnPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ReturnPolicyBloc, ReturnPolicyState>(
      builder: (context, state) {
        final policy = state.policy;
        final sections = policy?.sections ?? const <ReturnPolicySection>[];

        return AppResponsivePageLayout(
          backgroundGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.berryOverlayTop, AppColors.berryOverlayBottom],
          ),
          headerBuilder: (context, _) => ReturnPolicyPageHeader(
            title: _resolveTitle(policy, l10n),
            subtitle: _resolveSubtitle(policy, l10n),
            onBack: () => _handleBack(context),
          ),
          bodyBuilder: (context, contentWidth) {
            final isWideLayout = contentWidth >= 860;
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
                  if (state.isInitialLoading)
                    _ReturnPolicyLoadingState(
                      isWideLayout: isWideLayout,
                      contentWidth: contentWidth,
                      sectionGap: sectionGap,
                    )
                  else if (state.isFailure)
                    ErrorRetryWidget(
                      message: state.errorMessage?.trim().isNotEmpty == true
                          ? state.errorMessage!.trim()
                          : l10n.returnPolicyLoadFailed,
                      onRetry: () {
                        context.read<ReturnPolicyBloc>().add(
                          const LoadReturnPolicyRequested(),
                        );
                      },
                    )
                  else ...[
                    _ReturnPolicyHeadingCard(
                      message: _resolveHeading(policy, l10n),
                    ),
                    const AppGap(AppSizes.s24),
                    if (state.isEmpty)
                      _ReturnPolicyMessageCard(
                        message: l10n.returnPolicyNoSections,
                      )
                    else
                      _ReturnPolicySectionsLayout(
                        sections: sections,
                        contentWidth: contentWidth,
                        sectionGap: sectionGap,
                      ),
                    const AppGap(AppSizes.s28),
                    AppButton(
                      text: l10n.returnPolicyStartAction,
                      onPressed: () => context.pushNamed(AppRoutes.chat),
                      height: AppSizes.s56,
                      width: isWideLayout ? 280 : double.infinity,
                      borderRadius: AppRadius.r16,
                      fontSize: 15,
                      gradientColors: const [
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                      leadingIcon: const FaIcon(
                        FontAwesomeIcons.arrowRotateLeft,
                        size: AppSizes.s16,
                        color: AppColors.pureWhite,
                      ),
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

  static String _resolveTitle(ReturnPolicyData? policy, AppLocalizations l10n) {
    final title = policy?.title?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    return l10n.returnPolicy;
  }

  static String _resolveSubtitle(
    ReturnPolicyData? policy,
    AppLocalizations l10n,
  ) {
    final subtitle = policy?.subtitle?.trim();
    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }

    return l10n.returnPolicyDefaultSubtitle;
  }

  static String _resolveHeading(
    ReturnPolicyData? policy,
    AppLocalizations l10n,
  ) {
    final heading = policy?.heading?.trim();
    if (heading != null && heading.isNotEmpty) {
      return heading;
    }

    return l10n.returnPolicyDefaultHeading;
  }

  void _handleBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.profiles);
  }
}
