import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/legal_pages/barrels/legal_pages_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/legal_page_view_widgets.dart';

class LegalPageView extends StatelessWidget {
  const LegalPageView({super.key, required this.pageType});

  final LegalPageType pageType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LegalPageBloc, LegalPageState>(
      builder: (context, state) {
        final page = state.page;
        final sections = page?.sections ?? const <LegalPageSection>[];

        return AppResponsivePageLayout(
          headerBuilder: (context, _) => LegalPageHeader(
            title: _resolveTitle(page, l10n),
            subtitle: _resolveSubtitle(page, l10n),
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
                    _LegalPageLoadingState(
                      isWideLayout: isWideLayout,
                      contentWidth: contentWidth,
                      sectionGap: sectionGap,
                    )
                  else if (state.isFailure)
                    ErrorRetryWidget(
                      message: state.errorMessage?.trim().isNotEmpty == true
                          ? state.errorMessage!.trim()
                          : _loadFailedMessage(l10n),
                      onRetry: () {
                        context.read<LegalPageBloc>().add(
                          const LoadLegalPageRequested(),
                        );
                      },
                    )
                  else if (state.isEmpty)
                    _LegalPageMessageCard(message: _emptyMessage(l10n))
                  else
                    _LegalPageSectionsGrid(
                      sections: sections,
                      contentWidth: contentWidth,
                      sectionGap: sectionGap,
                      titleFallback: _resolveTitle(page, l10n),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _resolveTitle(LegalPageData? page, AppLocalizations l10n) {
    final title = page?.title?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return l10n.privacyPolicy;
      case LegalPageType.termsAndConditions:
        return l10n.termsAndConditions;
    }
  }

  String _resolveSubtitle(LegalPageData? page, AppLocalizations l10n) {
    final subtitle = page?.subtitle?.trim();
    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }

    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return l10n.privacyPolicyDefaultSubtitle;
      case LegalPageType.termsAndConditions:
        return l10n.termsAndConditionsDefaultSubtitle;
    }
  }

  String _loadFailedMessage(AppLocalizations l10n) {
    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return l10n.privacyPolicyLoadFailed;
      case LegalPageType.termsAndConditions:
        return l10n.termsAndConditionsLoadFailed;
    }
  }

  String _emptyMessage(AppLocalizations l10n) {
    switch (pageType) {
      case LegalPageType.privacyPolicy:
        return l10n.privacyPolicyNoSections;
      case LegalPageType.termsAndConditions:
        return l10n.termsAndConditionsNoSections;
    }
  }

  void _handleBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.profiles);
  }
}
