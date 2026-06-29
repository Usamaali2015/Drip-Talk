import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/wardrobe/barrels/wardrobe_barrels.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_sync_notifier.dart';
import 'package:drip_talk/features/wardrobe/view/widgets/wardrobe_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WardrobeListView extends StatefulWidget {
  const WardrobeListView({super.key});

  @override
  State<WardrobeListView> createState() => _WardrobeListViewState();
}

class _WardrobeListViewState extends State<WardrobeListView> {
  late final WardrobeSyncNotifier _syncNotifier;

  @override
  void initState() {
    super.initState();
    _syncNotifier = getIt<WardrobeSyncNotifier>();
    _syncNotifier.addListener(_handleWardrobeSync);
  }

  @override
  void dispose() {
    _syncNotifier.removeListener(_handleWardrobeSync);
    super.dispose();
  }

  void _handleWardrobeSync() {
    if (!mounted) {
      return;
    }

    final bloc = context.read<WardrobeListBloc>();
    if (bloc.state.isRefreshing || bloc.state.isInitialLoading) {
      return;
    }

    bloc.add(const LoadWardrobesRequested(showLoader: false));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WardrobeListBloc, WardrobeListState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage &&
          current.feedbackMessage?.trim().isNotEmpty == true,
      listener: (context, state) {
        ToastUtils.show(
          context,
          state.feedbackMessage!.trim(),
          type: switch (state.feedbackType) {
            WardrobeListFeedbackType.success => ToastType.success,
            WardrobeListFeedbackType.error => ToastType.error,
            WardrobeListFeedbackType.info => ToastType.info,
          },
        );
      },
      child: WardrobeScreenScaffold(
        wrapWithScaffold: false,
        useSafeArea: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 560 ? 28.0 : 24.0;
            final topPadding = constraints.maxWidth >= 560 ? 28.0 : 22.0;

            return BlocBuilder<WardrobeListBloc, WardrobeListState>(
              builder: (context, state) {
                final showCreateFab =
                    state.wardrobes.isNotEmpty && !state.isInitialLoading;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: RefreshIndicator(
                        onRefresh: () => _refreshWardrobes(context),
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
                                  children: [
                                    WardrobeHeader(
                                      titleLeading:
                                          l10n.wardrobeListHeaderLeading,
                                      titleAccent:
                                          l10n.wardrobeListHeaderAccent,
                                      subtitle: l10n.wardrobeListHeaderSubtitle,
                                      showBackButton: false,
                                    ),
                                    const AppGap(AppSizes.s24),
                                  ],
                                ),
                              ),
                            ),
                            if (state.isInitialLoading)
                              SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    return const Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppSizes.s16,
                                      ),
                                      child: WardrobeCardSkeleton(),
                                    );
                                  }, childCount: 6),
                                ),
                              )
                            else if (state.status ==
                                    WardrobeListStatus.failure &&
                                state.wardrobes.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                  ),
                                  child: _WardrobeFailureState(
                                    message:
                                        state.errorMessage?.trim().isNotEmpty ==
                                            true
                                        ? state.errorMessage!.trim()
                                        : l10n.wardrobeListLoadFailed,
                                  ),
                                ),
                              )
                            else if (state.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                fillOverscroll: true,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                  ),
                                  child: _EmptyWardrobeState(
                                    onCreatePressed: () =>
                                        _openCreateWardrobe(context),
                                  ),
                                ),
                              )
                            else
                              SliverPadding(
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  0,
                                  horizontalPadding,
                                  showCreateFab ? AppSizes.s100 : AppSizes.s24,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final wardrobe = state.wardrobes[index];
                                    return _buildWardrobeCard(
                                      context,
                                      wardrobe,
                                      state.isDeletingWardrobe(wardrobe.id),
                                    );
                                  }, childCount: state.wardrobes.length),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (showCreateFab)
                      PositionedDirectional(
                        end: horizontalPadding,
                        bottom: AppSizes.s100,
                        child: WardrobeFloatingActionButton(
                          label: l10n.wardrobeListCreateAction,
                          onTap: () {
                            _openCreateWardrobe(context);
                          },
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWardrobeCard(
    BuildContext context,
    WardrobeModel wardrobe,
    bool isDeleting,
  ) {
    return Dismissible(
      key: ValueKey(
        'wardrobe_${wardrobe.id}_${isDeleting ? 'deleting' : 'active'}',
      ),
      direction: isDeleting
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: const _DismissibleBackground(),
      confirmDismiss: isDeleting
          ? null
          : (direction) async {
              return await _confirmDeleteWardrobe(context, wardrobe);
            },
      onDismissed: isDeleting
          ? null
          : (direction) {
              context.read<WardrobeListBloc>().add(
                DeleteWardrobeFromListRequested(wardrobe),
              );
            },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.s16),
        child: _WardrobeSummaryCard(
          wardrobe: wardrobe,
          isDeleting: isDeleting,
          onTap: isDeleting
              ? () {}
              : () {
                  _openWardrobeDetails(context, wardrobe);
                },
        ),
      ),
    );
  }

  Future<void> _openCreateWardrobe(BuildContext context) async {
    final created = await context.pushNamed<bool>(AppRoutes.wardrobeCreate);
    if (!context.mounted || created != true) {
      return;
    }

    context.read<WardrobeListBloc>().add(
      const LoadWardrobesRequested(showLoader: false),
    );
  }

  Future<void> _openWardrobeDetails(
    BuildContext context,
    WardrobeModel wardrobe,
  ) async {
    final wardrobeId = wardrobe.id;
    if (wardrobeId == null) {
      return;
    }

    final updated = await context.pushNamed<bool>(
      AppRoutes.wardrobeDetails,
      pathParameters: {'id': '$wardrobeId'},
      extra: wardrobe,
    );
    if (!context.mounted || updated != true) {
      return;
    }

    context.read<WardrobeListBloc>().add(
      const LoadWardrobesRequested(showLoader: false),
    );
  }

  Future<void> _refreshWardrobes(BuildContext context) async {
    final bloc = context.read<WardrobeListBloc>();
    if (bloc.state.isRefreshing || bloc.state.isInitialLoading) {
      return;
    }

    bloc.add(const LoadWardrobesRequested(showLoader: false));
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  Future<bool> _confirmDeleteWardrobe(
    BuildContext context,
    WardrobeModel wardrobe,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.supportHeaderBackground,
          title: Text(
            l10n.wardrobeListDeleteDialogTitle,
            style: TextStyle(color: AppColors.pureWhite),
          ),
          content: Text(
            l10n.wardrobeListDeleteDialogMessage(wardrobe.displayTitle),
            style: TextStyle(
              color: AppColors.pureWhite.withValues(alpha: 0.82),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: AppColors.pureWhite70),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.deleteAction,
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSizes.s24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.red, AppColors.error],
        ),
      ),
      child: const Icon(
        Icons.delete_rounded,
        color: AppColors.pureWhite,
        size: AppSizes.s28,
      ),
    );
  }
}

class _WardrobeSummaryCard extends StatelessWidget {
  const _WardrobeSummaryCard({
    required this.wardrobe,
    required this.isDeleting,
    required this.onTap,
  });

  final WardrobeModel wardrobe;
  final bool isDeleting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: isDeleting ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Ink(
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondary.withValues(alpha: 0.16),
                AppColors.primary.withValues(alpha: 0.12),
              ],
            ),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.58),
            ),
          ),
          child: Row(
            children: [
              WardrobeNetworkImageTile(
                imageUrl: wardrobe.resolvedCoverImageUrl,
                size: AppSizes.s56,
                borderRadius: AppRadius.r16,
              ),
              const AppGap(AppSizes.s14, axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: wardrobe.displayTitle,
                      style: AppTextStyles.ts18(
                        context,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const AppGap(AppSizes.s6),
                    Wrap(
                      spacing: AppSizes.s10,
                      runSpacing: AppSizes.s4,
                      children: [
                        _WardrobeCounterPill(
                          color: AppColors.secondary,
                          label:
                              '${wardrobe.resolvedInWardrobeCount.toString().padLeft(2, '0')} ${l10n.wardrobeInWardrobeLabel}',
                        ),
                        _WardrobeCounterPill(
                          color: AppColors.starGold,
                          label:
                              '${wardrobe.resolvedInLaundryCount.toString().padLeft(2, '0')} ${l10n.wardrobeInLaundryLabel}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isDeleting)
                const SizedBox(
                  width: AppSizes.s22,
                  height: AppSizes.s22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.secondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WardrobeCounterPill extends StatelessWidget {
  const _WardrobeCounterPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.s6,
          height: AppSizes.s6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const AppGap(AppSizes.s4, axis: Axis.horizontal),
        AppText(
          text: label,
          style: AppTextStyles.ts10(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.84),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyWardrobeState extends StatelessWidget {
  const _EmptyWardrobeState({required this.onCreatePressed});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Spacer(flex: 3),
        Container(
          width: AppSizes.s86,
          height: AppSizes.s86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.softPink, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.18),
                blurRadius: AppSizes.s28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Center(child: WardrobeModuleIcon(size: AppSizes.s42)),
        ),
        const AppGap(AppSizes.s22),
        AppText(
          text: l10n.wardrobeEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.ts24(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const AppGap(AppSizes.s10),
        AppText(
          text: l10n.wardrobeEmptySubtitle,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.80),
            fontWeight: FontWeight.w500,
          ).copyWith(height: 1.45),
        ),
        const AppGap(AppSizes.s28),
        AppButton(
          text: l10n.wardrobeEmptyAction,
          onPressed: onCreatePressed,
          height: AppSizes.s56,
          borderRadius: AppRadius.circular,
          fontSize: AppSizes.s16,
          gradientColors: const [AppColors.softPink, AppColors.secondary],
          leadingIcon: const Icon(
            Icons.add_rounded,
            color: AppColors.pureWhite,
            size: AppSizes.s18,
          ),
        ),
        const Spacer(flex: 4),
      ],
    );
  }
}

class _WardrobeFailureState extends StatelessWidget {
  const _WardrobeFailureState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          color: AppColors.secondary,
          size: AppSizes.s48,
        ),
        const AppGap(AppSizes.s16),
        AppText(
          text: message,
          textAlign: TextAlign.center,
          style: AppTextStyles.ts16(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.86),
            fontWeight: FontWeight.w600,
          ).copyWith(height: 1.45),
        ),
        const AppGap(AppSizes.s20),
        AppButton(
          text: l10n.retry,
          onPressed: () {
            context.read<WardrobeListBloc>().add(
              const LoadWardrobesRequested(),
            );
          },
          width: AppSizes.s160,
          height: AppSizes.s50,
          borderRadius: AppRadius.r20,
          gradientColors: const [AppColors.softPink, AppColors.secondary],
        ),
      ],
    );
  }
}
