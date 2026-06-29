import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/address/barrels/address_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/my_addresses_view_widgets.dart';

class MyAddressesView extends StatelessWidget {
  const MyAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<MyAddressesBloc, MyAddressesState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage &&
          current.feedbackMessage?.trim().isNotEmpty == true,
      listener: (context, state) {
        ToastUtils.show(
          context,
          state.feedbackMessage!.trim(),
          type: switch (state.feedbackType) {
            MyAddressesFeedbackType.success => ToastType.success,
            MyAddressesFeedbackType.error => ToastType.error,
            MyAddressesFeedbackType.info => ToastType.info,
          },
        );
      },
      child: AppResponsivePageLayout(
        mobileMaxWidth: 430,
        tabletMaxWidth: 560,
        tabletLargeMaxWidth: 640,
        desktopMaxWidth: 720,
        showHeaderDivider: false,
        pageBuilder: (context, _) {
          final horizontalPadding = context.responsive(
            20.0,
            tablet: 24.0,
            tabletLarge: 28.0,
            desktop: 32.0,
          );
          final topPadding = context.responsive(
            12.0,
            tablet: 16.0,
            tabletLarge: 18.0,
            desktop: 20.0,
          );

          return BlocBuilder<MyAddressesBloc, MyAddressesState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () => _refreshAddresses(context),
                color: AppColors.secondary,
                backgroundColor: AppColors.lightBg,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          topPadding,
                          horizontalPadding,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddressPageHeader(
                              title: l10n.myAddressesTitle,
                              subtitle: l10n.addAddressSubtitle,
                              onBack: () => context.pop(),
                            ),
                            if (state.isRefreshing) ...[
                              const AppGap(AppSizes.s12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r10,
                                ),
                                child: const LinearProgressIndicator(
                                  minHeight: 4,
                                  backgroundColor: AppColors.lightBg,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                            const AppGap(AppSizes.s24),
                          ],
                        ),
                      ),
                    ),
                    if (state.isInitialLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: const AddressLoadingList(itemCount: 3),
                        ),
                      )
                    else if (state.status == MyAddressesStatus.failure &&
                        state.addresses.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: _FailureState(
                            title: l10n.myAddressesLoadFailed,
                            message:
                                state.errorMessage?.trim().isNotEmpty == true
                                ? state.errorMessage!.trim()
                                : l10n.somethingWentWrong,
                            onRetry: () {
                              context.read<MyAddressesBloc>().add(
                                const LoadMyAddressesRequested(),
                              );
                            },
                          ),
                        ),
                      )
                    else if (state.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: _EmptyState(
                            title: l10n.myAddressesEmptyTitle,
                            message: l10n.myAddressesEmptySubtitle,
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final address = state.addresses[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.s14,
                              ),
                              child: AddressCard(
                                address: address,
                                isDeleting: state.isDeletingAddress(address.id),
                                onEdit: () =>
                                    _openEditAddress(context, address),
                                onDelete: () =>
                                    _confirmDelete(context, address),
                              ),
                            );
                          }, childCount: state.addresses.length),
                        ),
                      ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          AppSizes.s12,
                          horizontalPadding,
                          AppSizes.s24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              text: l10n.myAddressesAddNewButton,
                              onPressed: () => _openAddAddress(context),
                              height: AppSizes.s56,
                              borderRadius: AppRadius.r16,
                              fontSize: AppSizes.s16,
                              iconGap: AppSizes.s8,
                              leadingIcon: const Icon(
                                Icons.add_circle_outline_rounded,
                                color: AppColors.pureWhite,
                                size: AppSizes.s18,
                              ),
                              gradientColors: const [
                                AppColors.secondary,
                                AppColors.primary,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openAddAddress(BuildContext context) async {
    final created = await context.pushNamed<bool>(AppRoutes.addAddress);
    if (!context.mounted || created != true) {
      return;
    }

    context.read<MyAddressesBloc>().add(
      const LoadMyAddressesRequested(showLoader: false),
    );
  }

  Future<void> _openEditAddress(
    BuildContext context,
    AddressListItem address,
  ) async {
    if (context.read<MyAddressesBloc>().state.isDeletingAddress(address.id)) {
      return;
    }

    final updated = await context.pushNamed<bool>(
      AppRoutes.addAddress,
      extra: address,
    );
    if (!context.mounted || updated != true) {
      return;
    }

    context.read<MyAddressesBloc>().add(
      const LoadMyAddressesRequested(showLoader: false),
    );
  }

  Future<void> _refreshAddresses(BuildContext context) async {
    final bloc = context.read<MyAddressesBloc>();
    if (bloc.state.isRefreshing || bloc.state.isInitialLoading) {
      return;
    }

    bloc.add(const LoadMyAddressesRequested(showLoader: false));
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AddressListItem address,
  ) async {
    final bloc = context.read<MyAddressesBloc>();
    if (bloc.state.isDeletingAddress(address.id)) {
      return;
    }

    final shouldDelete = await DeleteAddressSheet.show(
      context,
      address: address,
    );
    if (!context.mounted || shouldDelete != true) {
      return;
    }

    bloc.add(DeleteAddressRequested(address));
  }
}
