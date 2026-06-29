import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_bloc.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_event.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_state.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_item_status.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_bloc.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_event.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_state.dart';
import 'package:drip_talk/features/wardrobe/view/widgets/wardrobe_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum WardrobeMoveTarget { laundry, wardrobe }

Future<WardrobeMoveTarget?> showWardrobeMoveSelectedItemsDialog(
  BuildContext context,
) {
  final wardrobeDetailsBloc = context.read<WardrobeDetailsBloc>();

  return showDialog<WardrobeMoveTarget>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.pureBlack.withValues(alpha: 0.62),
    builder: (_) => BlocProvider.value(
      value: wardrobeDetailsBloc,
      child: const _MoveSelectedItemsDialog(),
    ),
  );
}

Future<void> showWardrobeTargetPickerSheet(BuildContext context) {
  final wardrobeDetailsBloc = context.read<WardrobeDetailsBloc>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: true,
    barrierColor: AppColors.pureBlack.withValues(alpha: 0.72),
    backgroundColor: AppColors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: wardrobeDetailsBloc,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<WardrobeListBloc>(
              create: (_) =>
                  getIt<WardrobeListBloc>()
                    ..add(const LoadWardrobesRequested()),
            ),
            BlocProvider<_WardrobeTargetPickerCubit>(
              create: (_) => _WardrobeTargetPickerCubit(),
            ),
          ],
          child: const _WardrobeTargetPickerSheet(),
        ),
      );
    },
  );
}

Future<void> showWardrobeTargetPickerDialog(BuildContext context) {
  return showWardrobeTargetPickerSheet(context);
}

class _MoveSelectedItemsDialog extends StatelessWidget {
  const _MoveSelectedItemsDialog();

  void _submitLaundry(BuildContext context) {
    context.read<WardrobeDetailsBloc>().add(
      const WardrobeSelectedItemsStatusUpdateRequested(
        status: wardrobeItemStatusInLaundry,
        action: WardrobeSelectedItemsAction.sendToLaundry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<WardrobeDetailsBloc, WardrobeDetailsState>(
      listenWhen: (previous, current) =>
          previous.isUpdatingItems != current.isUpdatingItems,
      listener: (context, state) {
        if (state.isUpdatingItems) {
          return;
        }

        if (state.selectedItemsAction ==
                WardrobeSelectedItemsAction.sendToLaundry &&
            state.feedbackType == WardrobeDetailsFeedbackType.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        void closeDialogIfAllowed() {
          if (state.isUpdatingItems) {
            return;
          }
          Navigator.of(context).pop();
        }

        return PopScope(
          canPop: !state.isUpdatingItems,
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s24,
              vertical: AppSizes.s24,
            ),
            backgroundColor: AppColors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r30),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.22),
                width: 1.4,
              ),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(AppSizes.s24),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(AppRadius.r30),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.pureBlack26,
                    blurRadius: 16,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSizes.s64,
                    height: AppSizes.s64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: AppAssetImage(
                        assetPath: Assets.moveIcon,
                        width: AppSizes.s28,
                        height: AppSizes.s28,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s18),
                  AppText(
                    text: l10n.wardrobeMoveSelectedItemTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.ts20(
                      context,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ).copyWith(height: 1.2),
                  ),
                  const AppGap(AppSizes.s22),
                  AppButton(
                    text: l10n.wardrobeSendToLaundryDialogAction,
                    onPressed: state.canSendToLaundry
                        ? () {
                            if (state.isUpdatingItems) {
                              return;
                            }
                            _submitLaundry(context);
                          }
                        : null,
                    isLoading:
                        state.isUpdatingItems &&
                        state.selectedItemsAction ==
                            WardrobeSelectedItemsAction.sendToLaundry,
                    width: double.infinity,
                    height: AppSizes.s56,
                    borderRadius: AppRadius.circular,
                    fontSize: 15,
                    gradientColors: const [
                      AppColors.softPink,
                      AppColors.secondary,
                    ],
                    leadingIcon: const AppAssetImage(
                      assetPath: Assets.iconsSend,
                      width: AppSizes.s18,
                      height: AppSizes.s18,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const AppGap(AppSizes.s10),
                  AppButton(
                    text: l10n.wardrobeSendToWardrobeDialogAction,
                    onPressed: () {
                      if (state.isUpdatingItems) {
                        return;
                      }
                      Navigator.of(context).pop(WardrobeMoveTarget.wardrobe);
                    },
                    width: double.infinity,
                    height: AppSizes.s56,
                    borderRadius: AppRadius.circular,
                    fontSize: 15,
                    gradientColors: const [
                      AppColors.softPink,
                      AppColors.secondary,
                    ],
                    leadingIcon: const AppAssetImage(
                      assetPath: Assets.iconsSend,
                      width: AppSizes.s18,
                      height: AppSizes.s18,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const AppGap(AppSizes.s10),
                  AppButton(
                    text: l10n.cancel,
                    onPressed: closeDialogIfAllowed,
                    width: double.infinity,
                    height: AppSizes.s56,
                    borderRadius: AppRadius.circular,
                    fontSize: 15,
                    gradientColors: const [
                      AppColors.primaryDark,
                      AppColors.primary,
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WardrobeTargetPickerSheet extends StatelessWidget {
  const _WardrobeTargetPickerSheet();

  void _retry(BuildContext context) {
    context.read<_WardrobeTargetPickerCubit>().clearSelection();
    context.read<WardrobeListBloc>().add(const LoadWardrobesRequested());
  }

  void _submitWardrobeMove(
    BuildContext context,
    WardrobeModel selectedWardrobe,
  ) {
    final wardrobeId = selectedWardrobe.id;
    if (wardrobeId == null) {
      return;
    }

    context.read<WardrobeDetailsBloc>().add(
      WardrobeSelectedItemsStatusUpdateRequested(
        status: wardrobeItemStatusInWardrobe,
        action: WardrobeSelectedItemsAction.moveToWardrobe,
        targetWardrobeId: wardrobeId,
      ),
    );
  }

  WardrobeModel? _resolveSelectedWardrobe(
    List<WardrobeModel> wardrobes,
    int? selectedWardrobeId,
  ) {
    if (selectedWardrobeId == null) {
      return null;
    }

    for (final wardrobe in wardrobes) {
      if (wardrobe.id == selectedWardrobeId) {
        return wardrobe;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final heightFactor = mediaQuery.size.height < 700 ? 0.94 : 0.88;

    return BlocConsumer<WardrobeDetailsBloc, WardrobeDetailsState>(
      listenWhen: (previous, current) =>
          previous.isUpdatingItems != current.isUpdatingItems,
      listener: (context, state) {
        if (state.isUpdatingItems) {
          return;
        }

        if (state.selectedItemsAction ==
                WardrobeSelectedItemsAction.moveToWardrobe &&
            state.feedbackType == WardrobeDetailsFeedbackType.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isSaving =
            state.isUpdatingItems &&
            state.selectedItemsAction ==
                WardrobeSelectedItemsAction.moveToWardrobe;

        void closeSheetIfAllowed() {
          if (isSaving) {
            return;
          }
          Navigator.of(context).pop();
        }

        void selectWardrobeIfAllowed(int? wardrobeId) {
          if (isSaving || wardrobeId == null) {
            return;
          }
          context.read<_WardrobeTargetPickerCubit>().selectWardrobe(wardrobeId);
        }

        return PopScope(
          canPop: !isSaving,
          child: FractionallySizedBox(
            heightFactor: heightFactor,
            child: Material(
              color: AppColors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.modalGradientStart,
                      AppColors.modalGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.r30),
                  ),
                  border: Border(
                    top: BorderSide(color: AppColors.secondary, width: 4),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.s24,
                      AppSizes.s12,
                      AppSizes.s24,
                      AppSizes.s24,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: AppSizes.s56,
                            height: AppSizes.s4,
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite.withValues(
                                alpha: 0.22,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.circular,
                              ),
                            ),
                          ),
                        ),
                        const AppGap(AppSizes.s16),
                        WardrobeHeader(
                          titleLeading: l10n.wardrobeListHeaderLeading,
                          titleAccent: l10n.wardrobeListHeaderAccent,
                          subtitle: l10n.wardrobeListHeaderSubtitle,
                          onBack: () => Navigator.of(context).pop(),
                        ),
                        const AppGap(AppSizes.s20),
                        Expanded(
                          child: BlocBuilder<WardrobeListBloc, WardrobeListState>(
                            builder: (context, listState) {
                              if (listState.isInitialLoading) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        physics: isSaving
                                            ? const NeverScrollableScrollPhysics()
                                            : const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          bottom: AppSizes.s8,
                                        ),
                                        itemCount: 5,
                                        separatorBuilder: (context, _) =>
                                            const SizedBox(
                                              height: AppSizes.s12,
                                            ),
                                        itemBuilder: (context, index) {
                                          return const WardrobeCardSkeleton();
                                        },
                                      ),
                                    ),
                                    const AppGap(AppSizes.s18),
                                    _WardrobePickerActions(
                                      cancelLabel: l10n.cancel,
                                      saveLabel: l10n.wardrobeSaveAction,
                                      onCancel: closeSheetIfAllowed,
                                      onSave: null,
                                      isSaveLoading: false,
                                    ),
                                  ],
                                );
                              }

                              if (listState.status ==
                                      WardrobeListStatus.failure &&
                                  listState.wardrobes.isEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: _WardrobePickerFailureState(
                                        message: l10n.wardrobeListLoadFailed,
                                        onRetry: () => _retry(context),
                                      ),
                                    ),
                                    const AppGap(AppSizes.s18),
                                    _WardrobePickerActions(
                                      cancelLabel: l10n.cancel,
                                      saveLabel: l10n.wardrobeSaveAction,
                                      onCancel: closeSheetIfAllowed,
                                      onSave: null,
                                      isSaveLoading: false,
                                    ),
                                  ],
                                );
                              }

                              final wardrobes = listState.wardrobes
                                  .where((wardrobe) => wardrobe.id != null)
                                  .toList(growable: false);

                              if (wardrobes.isEmpty) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: _WardrobePickerEmptyState(
                                        title: l10n.wardrobeEmptyTitle,
                                        subtitle: l10n.wardrobeEmptySubtitle,
                                      ),
                                    ),
                                    const AppGap(AppSizes.s18),
                                    _WardrobePickerActions(
                                      cancelLabel: l10n.cancel,
                                      saveLabel: l10n.wardrobeSaveAction,
                                      onCancel: closeSheetIfAllowed,
                                      onSave: null,
                                      isSaveLoading: false,
                                    ),
                                  ],
                                );
                              }

                              return BlocBuilder<
                                _WardrobeTargetPickerCubit,
                                int?
                              >(
                                builder: (context, selectedWardrobeId) {
                                  final selectedWardrobe =
                                      _resolveSelectedWardrobe(
                                        wardrobes,
                                        selectedWardrobeId,
                                      );

                                  return Column(
                                    children: [
                                      if (listState.isRefreshing) ...[
                                        const Center(
                                          child:
                                              WardrobeRefreshProgressIndicator(),
                                        ),
                                        const AppGap(AppSizes.s14),
                                      ],
                                      Expanded(
                                        child: ListView.separated(
                                          physics: isSaving
                                              ? const NeverScrollableScrollPhysics()
                                              : const AlwaysScrollableScrollPhysics(),
                                          padding: const EdgeInsets.only(
                                            bottom: AppSizes.s8,
                                          ),
                                          itemCount: wardrobes.length,
                                          separatorBuilder: (context, _) =>
                                              const SizedBox(
                                                height: AppSizes.s12,
                                              ),
                                          itemBuilder: (context, index) {
                                            final wardrobe = wardrobes[index];
                                            final isSelected =
                                                wardrobe.id != null &&
                                                wardrobe.id ==
                                                    selectedWardrobeId;

                                            return _WardrobePickerCard(
                                              wardrobe: wardrobe,
                                              isSelected: isSelected,
                                              onTap: () =>
                                                  selectWardrobeIfAllowed(
                                                    wardrobe.id,
                                                  ),
                                            );
                                          },
                                        ),
                                      ),
                                      const AppGap(AppSizes.s18),
                                      _WardrobePickerActions(
                                        cancelLabel: l10n.cancel,
                                        saveLabel: l10n.wardrobeSaveAction,
                                        onCancel: closeSheetIfAllowed,
                                        onSave:
                                            selectedWardrobe == null || isSaving
                                            ? null
                                            : () => _submitWardrobeMove(
                                                context,
                                                selectedWardrobe,
                                              ),
                                        isSaveLoading: isSaving,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WardrobePickerActions extends StatelessWidget {
  const _WardrobePickerActions({
    required this.cancelLabel,
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
    required this.isSaveLoading,
  });

  final String cancelLabel;
  final String saveLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final bool isSaveLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: cancelLabel,
            onPressed: onCancel,
            height: AppSizes.s56,
            borderRadius: AppRadius.circular,
            backgroundColor: AppColors.transparent,
            borderColor: AppColors.secondary.withValues(alpha: 0.72),
            textColor: AppColors.secondary,
            borderWidth: 1.2,
            fontSize: 15,
          ),
        ),
        const AppGap(AppSizes.s10, axis: Axis.horizontal),
        Expanded(
          child: AppButton(
            text: saveLabel,
            onPressed: onSave,
            isLoading: isSaveLoading,
            height: AppSizes.s56,
            borderRadius: AppRadius.circular,
            gradientColors: const [AppColors.softPink, AppColors.secondary],
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _WardrobePickerFailureState extends StatelessWidget {
  const _WardrobePickerFailureState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.secondary,
              size: AppSizes.s44,
            ),
            const AppGap(AppSizes.s14),
            AppText(
              text: message,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts16(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.88),
                fontWeight: FontWeight.w600,
              ).copyWith(height: 1.45),
            ),
            const AppGap(AppSizes.s18),
            AppButton(
              text: AppLocalizations.of(context)!.retry,
              onPressed: onRetry,
              width: AppSizes.s160,
              gradientColors: const [AppColors.softPink, AppColors.secondary],
            ),
          ],
        ),
      ),
    );
  }
}

class _WardrobePickerEmptyState extends StatelessWidget {
  const _WardrobePickerEmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checkroom_rounded,
              color: AppColors.secondary,
              size: AppSizes.s44,
            ),
            const AppGap(AppSizes.s14),
            AppText(
              text: title,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts18(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w800,
              ),
            ),
            const AppGap(AppSizes.s8),
            AppText(
              text: subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.76),
                fontWeight: FontWeight.w500,
              ).copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class _WardrobeTargetPickerCubit extends Cubit<int?> {
  _WardrobeTargetPickerCubit() : super(null);

  void selectWardrobe(int? wardrobeId) {
    emit(wardrobeId);
  }

  void clearSelection() {
    emit(null);
  }
}

class _WardrobePickerCard extends StatelessWidget {
  const _WardrobePickerCard({
    required this.wardrobe,
    required this.isSelected,
    required this.onTap,
  });

  final WardrobeModel wardrobe;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      AppColors.secondary.withValues(alpha: 0.22),
                      AppColors.primary.withValues(alpha: 0.20),
                    ]
                  : [
                      AppColors.pureWhite.withValues(alpha: 0.08),
                      AppColors.pureWhite.withValues(alpha: 0.04),
                    ],
            ),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : AppColors.pureWhite.withValues(alpha: 0.22),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  WardrobeNetworkImageTile(
                    imageUrl: wardrobe.resolvedCoverImageUrl,
                    size: AppSizes.s56,
                    borderRadius: AppRadius.r16,
                  ),
                  if (isSelected)
                    PositionedDirectional(
                      end: -AppSizes.s4,
                      top: -AppSizes.s4,
                      child: Container(
                        width: AppSizes.s22,
                        height: AppSizes.s22,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.pureWhite,
                          size: AppSizes.s14,
                        ),
                      ),
                    ),
                ],
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
                        _WardrobePickerCounterPill(
                          color: AppColors.secondary,
                          label:
                              '${wardrobe.resolvedInWardrobeCount.toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.wardrobeInWardrobeLabel}',
                        ),
                        _WardrobePickerCounterPill(
                          color: AppColors.starGold,
                          label:
                              '${wardrobe.resolvedInLaundryCount.toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.wardrobeInLaundryLabel}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WardrobePickerCounterPill extends StatelessWidget {
  const _WardrobePickerCounterPill({required this.color, required this.label});

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
