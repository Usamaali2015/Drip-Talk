import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/wardrobe/barrels/wardrobe_barrels.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_item_status.dart';
import 'package:drip_talk/features/wardrobe/view/widgets/wardrobe_move_selected_items_dialog.dart';
import 'package:drip_talk/features/wardrobe/view/widgets/wardrobe_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WardrobeDetailsView extends StatelessWidget {
  const WardrobeDetailsView({
    super.key,
    required this.wardrobeId,
    this.initialWardrobe,
  });

  final int wardrobeId;
  final WardrobeModel? initialWardrobe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WardrobeDetailsBloc, WardrobeDetailsState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage ||
          previous.status != current.status,
      listener: (context, state) async {
        final feedbackMessage = state.feedbackMessage?.trim();
        if (feedbackMessage != null && feedbackMessage.isNotEmpty) {
          ToastUtils.show(
            context,
            feedbackMessage,
            type: switch (state.feedbackType) {
              WardrobeDetailsFeedbackType.success => ToastType.success,
              WardrobeDetailsFeedbackType.error => ToastType.error,
              WardrobeDetailsFeedbackType.info => ToastType.info,
            },
          );
        }

        if (state.status == WardrobeDetailsStatus.deleted && context.mounted) {
          context.pop(true);
        }
      },
      child: WardrobeScreenScaffold(
        bottomSafeArea: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 560 ? 28.0 : 24.0;
            final topPadding = constraints.maxWidth >= 560 ? 22.0 : 18.0;
            final gridCrossAxisCount = constraints.maxWidth >= 620
                ? 5
                : (constraints.maxWidth >= 500 ? 4 : 3);

            return BlocBuilder<WardrobeDetailsBloc, WardrobeDetailsState>(
              builder: (context, state) {
                final wardrobe = state.wardrobe ?? initialWardrobe;
                if (state.isInitialLoading && wardrobe == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }

                if (state.status == WardrobeDetailsStatus.failure &&
                    wardrobe == null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.secondary,
                            size: AppSizes.s48,
                          ),
                          const AppGap(AppSizes.s16),
                          AppText(
                            text: state.errorMessage?.trim().isNotEmpty == true
                                ? state.errorMessage!.trim()
                                : l10n.wardrobeDetailsLoadFailed,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.ts16(
                              context,
                              color: AppColors.pureWhite.withValues(
                                alpha: 0.86,
                              ),
                              fontWeight: FontWeight.w600,
                            ).copyWith(height: 1.45),
                          ),
                          const AppGap(AppSizes.s20),
                          AppButton(
                            text: l10n.retry,
                            onPressed: () {
                              context.read<WardrobeDetailsBloc>().add(
                                LoadWardrobeDetailsRequested(
                                  wardrobeId: wardrobeId,
                                  initialWardrobe: initialWardrobe,
                                ),
                              );
                            },
                            width: AppSizes.s160,
                            gradientColors: const [
                              AppColors.softPink,
                              AppColors.secondary,
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final resolvedWardrobe = wardrobe!;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _refreshDetails(context),
                              color: AppColors.secondary,
                              backgroundColor: AppColors.lightBg,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  topPadding,
                                  horizontalPadding,
                                  AppSizes.s20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WardrobeHeader(
                                      titleLeading: _firstWord(
                                        resolvedWardrobe.displayTitle,
                                      ),
                                      titleAccent: _remainingWords(
                                        resolvedWardrobe.displayTitle,
                                      ),
                                      subtitle: l10n
                                          .wardrobeDetailsTotalDressesSubtitle(
                                            resolvedWardrobe.resolvedTotalItems
                                                .toString()
                                                .padLeft(2, '0'),
                                          ),
                                      onBack: () => context.pop(),
                                    ),
                                    const AppGap(AppSizes.s28),
                                    _StatsRow(wardrobe: resolvedWardrobe),
                                    const AppGap(AppSizes.s24),
                                    _FilterChipsRow(state: state),
                                    const AppGap(AppSizes.s18),
                                    Row(
                                      children: [
                                        AppText(
                                          text: l10n.wardrobeSelectHint,
                                          style: AppTextStyles.ts16(
                                            context,
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: state.filteredItems.isEmpty
                                              ? null
                                              : () {
                                                  context
                                                      .read<
                                                        WardrobeDetailsBloc
                                                      >()
                                                      .add(
                                                        const WardrobeVisibleSelectionToggled(),
                                                      );
                                                },
                                          child: AppText(
                                            text: state.allVisibleItemsSelected
                                                ? l10n.wardrobeClearAllAction
                                                : l10n.wardrobeSelectAllAction,
                                            style: AppTextStyles.ts14(
                                              context,
                                              color: AppColors.pureWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const AppGap(AppSizes.s8),
                                    if (state.filteredItems.isEmpty)
                                      _EmptyFilteredWardrobeState(
                                        filter: state.filter,
                                      )
                                    else
                                      GridView.builder(
                                        itemCount: state.filteredItems.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  gridCrossAxisCount,
                                              mainAxisSpacing: AppSizes.s10,
                                              crossAxisSpacing: AppSizes.s10,
                                              childAspectRatio:
                                                  gridCrossAxisCount > 3
                                                  ? 0.92
                                                  : 0.88,
                                            ),
                                        itemBuilder: (context, index) {
                                          final item =
                                              state.filteredItems[index];
                                          final isSelected =
                                              item.id != null &&
                                              state.selectedItemIds.contains(
                                                item.id,
                                              );

                                          return _WardrobeItemGridTile(
                                            item: item,
                                            isSelected: isSelected,
                                            onTap: item.id == null
                                                ? null
                                                : () {
                                                    context
                                                        .read<
                                                          WardrobeDetailsBloc
                                                        >()
                                                        .add(
                                                          WardrobeItemSelectionToggled(
                                                            item.id!,
                                                          ),
                                                        );
                                                  },
                                          );
                                        },
                                      ),
                                    const AppGap(AppSizes.s24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              AppSizes.s8,
                              horizontalPadding,
                              AppSizes.s24,
                            ),
                            child: _WardrobePrimaryActionButton(
                              state: state,
                              onPressed: () {
                                _handlePrimaryActionPressed(
                                  context,
                                  state,
                                  resolvedWardrobe,
                                );
                              },
                            ),
                          ),
                        ],
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

  Future<void> _refreshDetails(BuildContext context) async {
    final bloc = context.read<WardrobeDetailsBloc>();
    if (bloc.state.isRefreshing || bloc.state.isInitialLoading) {
      return;
    }

    bloc.add(
      LoadWardrobeDetailsRequested(
        wardrobeId: wardrobeId,
        initialWardrobe: initialWardrobe,
        showLoader: false,
      ),
    );
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  Future<void> _handlePrimaryActionPressed(
    BuildContext context,
    WardrobeDetailsState state,
    WardrobeModel wardrobe,
  ) async {
    final isLaundryTab = state.filter == WardrobeItemFilter.laundry;
    if (isLaundryTab) {
      context.read<WardrobeDetailsBloc>().add(
        const WardrobeSelectedItemsStatusUpdateRequested(
          status: wardrobeItemStatusInWardrobe,
          action: WardrobeSelectedItemsAction.removeFromLaundry,
        ),
      );
      return;
    }

    final selection = await showWardrobeMoveSelectedItemsDialog(context);
    if (!context.mounted || selection != WardrobeMoveTarget.wardrobe) {
      return;
    }

    await showWardrobeTargetPickerSheet(context);
  }
}

class _WardrobePrimaryActionButton extends StatelessWidget {
  const _WardrobePrimaryActionButton({
    required this.state,
    required this.onPressed,
  });

  final WardrobeDetailsState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLaundryTab = state.filter == WardrobeItemFilter.laundry;
    final isLoading =
        isLaundryTab &&
        state.isSelectedItemsActionLoading &&
        state.selectedItemsAction ==
            WardrobeSelectedItemsAction.removeFromLaundry;
    final canPerformAction = isLaundryTab
        ? state.canRemoveFromLaundry && !isLoading
        : state.hasSelection;
    final label = isLaundryTab
        ? l10n.wardrobeRemoveFromLaundryAction
        : l10n.wardrobeSendToAction;
    final icon = isLaundryTab
        ? const Icon(
            Icons.reply_rounded,
            color: AppColors.pureWhite,
            size: AppSizes.s18,
          )
        : const AppAssetImage(
            assetPath: Assets.iconsSend,
            width: AppSizes.s18,
            height: AppSizes.s18,
            color: AppColors.pureWhite,
          );

    return AppButton(
      text: label,
      onPressed: canPerformAction ? onPressed : null,
      isLoading: isLoading,
      height: AppSizes.s56,
      borderRadius: AppRadius.circular,
      gradientColors: canPerformAction
          ? const [AppColors.softPink, AppColors.secondary]
          : null,
      leadingIcon: icon,
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.wardrobe});

  final WardrobeModel wardrobe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: wardrobe.resolvedInWardrobeCount.toString().padLeft(2, '0'),
            label: l10n.wardrobeWardrobeLabel,
            background: AppColors.secondary.withValues(alpha: 0.18),
            borderColor: AppColors.secondary.withValues(alpha: 0.65),
            valueColor: AppColors.secondary,
          ),
        ),
        const AppGap(AppSizes.s10, axis: Axis.horizontal),
        Expanded(
          child: _StatCard(
            value: wardrobe.resolvedInLaundryCount.toString().padLeft(2, '0'),
            label: l10n.wardrobeLaundryLabel,
            background: AppColors.starGold.withValues(alpha: 0.12),
            borderColor: AppColors.starGold.withValues(alpha: 0.34),
            valueColor: AppColors.starGold,
          ),
        ),
        const AppGap(AppSizes.s10, axis: Axis.horizontal),
        Expanded(
          child: _StatCard(
            value: wardrobe.resolvedTotalItems.toString().padLeft(2, '0'),
            label: l10n.wardrobeTotalLabel,
            background: AppColors.primary.withValues(alpha: 0.18),
            borderColor: AppColors.primary.withValues(alpha: 0.42),
            valueColor: const Color(0xFF7D6BFF),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.background,
    required this.borderColor,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color background;
  final Color borderColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s10,
        vertical: AppSizes.s14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        color: background,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          AppText(
            text: value,
            style: AppTextStyles.ts36(
              context,
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const AppGap(AppSizes.s4),
          AppText(
            text: label.toUpperCase(),
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({required this.state});

  final WardrobeDetailsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.circular),
        color: AppColors.secondary.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.62),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterChipButton(
              label: l10n.wardrobeAllLabel,
              isSelected: state.filter == WardrobeItemFilter.all,
              onTap: () {
                context.read<WardrobeDetailsBloc>().add(
                  const WardrobeFilterChanged(WardrobeItemFilter.all),
                );
              },
            ),
          ),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
          Expanded(
            child: _FilterChipButton(
              label: l10n.wardrobeWardrobeLabel,
              isSelected: state.filter == WardrobeItemFilter.wardrobe,
              onTap: () {
                context.read<WardrobeDetailsBloc>().add(
                  const WardrobeFilterChanged(WardrobeItemFilter.wardrobe),
                );
              },
            ),
          ),
          const AppGap(AppSizes.s8, axis: Axis.horizontal),
          Expanded(
            child: _FilterChipButton(
              label: l10n.wardrobeLaundryLabel,
              isSelected: state.filter == WardrobeItemFilter.laundry,
              onTap: () {
                context.read<WardrobeDetailsBloc>().add(
                  const WardrobeFilterChanged(WardrobeItemFilter.laundry),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: AppSizes.s48,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.circular),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.softPink, AppColors.secondary],
                  )
                : null,
            color: isSelected ? null : const Color(0xFF2C1D41),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary.withValues(alpha: 0.72)
                  : AppColors.pureWhite.withValues(alpha: 0.08),
            ),
          ),
          child: AppText(
            text: label,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _WardrobeItemGridTile extends StatelessWidget {
  const _WardrobeItemGridTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final WardrobeItemModel item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : AppColors.pureWhite.withValues(alpha: 0.10),
              width: isSelected ? 2.2 : 1.0,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                child: WardrobeNetworkImageTile(
                  imageUrl: item.resolvedImageUrl,
                  borderRadius: AppRadius.r20,
                ),
              ),
              if (item.isInLaundry)
                Positioned(
                  top: AppSizes.s8,
                  left: AppSizes.s8,
                  child: Container(
                    width: AppSizes.s30,
                    height: AppSizes.s30,
                    padding: const EdgeInsets.all(AppSizes.s6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                      border: Border.all(
                        color: AppColors.pureWhite.withValues(alpha: 0.32),
                      ),
                    ),
                    child: const AppAssetImage(
                      assetPath: Assets.laundaryIcon,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ),
              if (!item.isAiProcessed)
                Positioned(
                  left: AppSizes.s8,
                  right: AppSizes.s8,
                  bottom: AppSizes.s8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s8,
                      vertical: AppSizes.s4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                      color: AppColors.pureBlack.withValues(alpha: 0.52),
                    ),
                    child: AppText(
                      text: l10n.wardrobeProcessingLabel,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.ts10(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  top: AppSizes.s8,
                  right: AppSizes.s8,
                  child: Container(
                    width: AppSizes.s28,
                    height: AppSizes.s28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.pureWhite,
                      size: AppSizes.s18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFilteredWardrobeState extends StatelessWidget {
  const _EmptyFilteredWardrobeState({required this.filter});

  final WardrobeItemFilter filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final label = switch (filter) {
      WardrobeItemFilter.all => l10n.wardrobeNoDressesInWardrobe,
      WardrobeItemFilter.wardrobe => l10n.wardrobeNoDressesInWardrobeFilter,
      WardrobeItemFilter.laundry => l10n.wardrobeNoDressesInLaundryFilter,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        color: AppColors.pureWhite.withValues(alpha: 0.06),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.08)),
      ),
      child: AppText(
        text: label,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts15(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.78),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _firstWord(String value) {
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.length <= 1) {
    return value.trim();
  }

  return words.first;
}

String _remainingWords(String value) {
  final words = value.trim().split(RegExp(r'\s+'));
  if (words.length <= 1) {
    return value.trim();
  }

  return words.sublist(1).join(' ');
}

extension on List<WardrobeItemModel> {
  WardrobeItemModel? get firstOrNull {
    if (isEmpty) {
      return null;
    }

    return first;
  }
}
