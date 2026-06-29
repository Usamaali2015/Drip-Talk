import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/payment_methods/barrels/payment_methods_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/payment_methods_view_widgets.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
      builder: (context, state) {
        return AppResponsivePageLayout(
          headerBuilder: (context, _) => PaymentMethodsPageHeader(
            title: l10n.paymentMethods,
            subtitle: l10n.paymentMethodsEncryptedSecure,
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
                    _PaymentMethodsLoadingState(
                      isWideLayout: isWideLayout,
                      sectionGap: sectionGap,
                    )
                  else if (state.isFailure && !state.hasWallets)
                    ErrorRetryWidget(
                      message: state.errorMessage?.trim().isNotEmpty == true
                          ? state.errorMessage!.trim()
                          : l10n.paymentMethodsLoadFailed,
                      onRetry: () {
                        context.read<PaymentMethodsBloc>().add(
                          const LoadPaymentMethodsRequested(),
                        );
                      },
                    )
                  else if (state.isEmpty)
                    _PaymentMethodsMessageCard(
                      message: l10n.paymentMethodsEmptyState,
                    )
                  else if (isWideLayout)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: _WalletMethodsSection(
                            heading: l10n.paymentMethodsDigitalWalletsHeading,
                            methods: state.wallets,
                            titleResolver: _methodTitle,
                            descriptionResolver: (type) =>
                                _methodDescription(type, l10n),
                            actionResolver: (type) =>
                                _methodActionLabel(type, l10n),
                            badgeResolver: (type) => _badgeLabel(type, l10n),
                            selectedMethodId: state.selectedMethodId,
                            onSelected: (methodId) {
                              context.read<PaymentMethodsBloc>().add(
                                PaymentMethodSelected(methodId),
                              );
                            },
                          ),
                        ),
                        AppGap(sectionGap, axis: Axis.horizontal),
                        Expanded(
                          flex: 4,
                          child: _SupportedMethodsPanel(
                            heading: l10n.paymentMethodsSupportedSectionTitle,
                            paymentTypes: state.visibleSupportedPaymentTypes,
                            emptyMessage: l10n.paymentMethodsNoSupportedOptions,
                            labelResolver: (type) =>
                                _supportedTypeLabel(type, l10n),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WalletMethodsSection(
                          heading: l10n.paymentMethodsDigitalWalletsHeading,
                          methods: state.wallets,
                          titleResolver: _methodTitle,
                          descriptionResolver: (type) =>
                              _methodDescription(type, l10n),
                          actionResolver: (type) =>
                              _methodActionLabel(type, l10n),
                          badgeResolver: (type) => _badgeLabel(type, l10n),
                          selectedMethodId: state.selectedMethodId,
                          onSelected: (methodId) {
                            context.read<PaymentMethodsBloc>().add(
                              PaymentMethodSelected(methodId),
                            );
                          },
                        ),
                        const AppGap(AppSizes.s10),
                        _SupportedMethodsList(
                          heading: l10n.paymentMethodsSupportedSectionTitle,
                          paymentTypes: state.visibleSupportedPaymentTypes,
                          emptyMessage: l10n.paymentMethodsNoSupportedOptions,
                          labelResolver: (type) =>
                              _supportedTypeLabel(type, l10n),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _methodTitle(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.googlePay:
        return 'Google Pay';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
    }
  }

  String _methodDescription(PaymentMethodType type, AppLocalizations l10n) {
    switch (type) {
      case PaymentMethodType.googlePay:
        return l10n.paymentMethodsGooglePayDescription;
      case PaymentMethodType.applePay:
        return l10n.paymentMethodsApplePayDescription;
    }
  }

  String _methodActionLabel(PaymentMethodType type, AppLocalizations l10n) {
    switch (type) {
      case PaymentMethodType.googlePay:
        return l10n.paymentMethodsGooglePayAction;
      case PaymentMethodType.applePay:
        return l10n.paymentMethodsApplePayAction;
    }
  }

  String _badgeLabel(PaymentMethodBadgeType type, AppLocalizations l10n) {
    switch (type) {
      case PaymentMethodBadgeType.recommended:
        return l10n.paymentMethodsRecommendedBadge;
      case PaymentMethodBadgeType.iosAndMac:
        return l10n.paymentMethodsIosAndMacBadge;
    }
  }

  String _supportedTypeLabel(SupportedPaymentType type, AppLocalizations l10n) {
    switch (type) {
      case SupportedPaymentType.creditDebit:
        return l10n.paymentMethodsCreditDebit;
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
