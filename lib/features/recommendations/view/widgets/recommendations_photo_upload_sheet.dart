import 'dart:io';
import 'dart:math' as math;
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/app_picker_utils.dart';
import 'package:drip_talk/features/recommendations/data/models/recommendations_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_result_model.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_bloc.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_event.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

const List<Color> _recommendationsPrimaryGradientColors = <Color>[
  AppColors.secondary,
  AppColors.recommendationsGradientAccent,
];

const List<Color> _recommendationsActionGradientColors = <Color>[
  AppColors.secondary,
  AppColors.recommendationsActionAccent,
];

final RegExp _headlineNumberPattern = RegExp(r'\d+');

enum RecommendationsFlowAction { openChat }

Future<RecommendationsFlowAction?> showRecommendationsPhotoUploadSheet(
  BuildContext context,
) {
  return Navigator.of(context).push<RecommendationsFlowAction>(
    MaterialPageRoute<RecommendationsFlowAction>(
      fullscreenDialog: true,
      builder: (_) {
        return BlocProvider<RecommendationsBloc>(
          create: (_) => getIt<RecommendationsBloc>(),
          child: const RecommendationsPhotoUploadSheet(),
        );
      },
    ),
  );
}

class RecommendationsPhotoUploadSheet extends StatefulWidget {
  const RecommendationsPhotoUploadSheet({super.key});

  @override
  State<RecommendationsPhotoUploadSheet> createState() =>
      _RecommendationsPhotoUploadSheetState();
}

class _RecommendationsPhotoUploadSheetState
    extends State<RecommendationsPhotoUploadSheet> {
  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 520,
      tabletLargeMaxWidth: 560,
      desktopMaxWidth: 600,
      pageBuilder: (context, _) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s24,
              AppSizes.s14,
              AppSizes.s24,
              AppSizes.s22,
            ),
            child: BlocBuilder<RecommendationsBloc, RecommendationsState>(
              builder: (context, state) {
                return _RecommendationsSheetScaffold(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildStep(context, state),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, RecommendationsState state) {
    if (state.hasTryOnResults) {
      return _TryOnResultsStep(
        key: const ValueKey('try-on-results'),
        state: state,
        onContinueToChat: () =>
            Navigator.of(context).pop(RecommendationsFlowAction.openChat),
      );
    }

    if (state.isShowingTryOnProcessing) {
      return _TryOnProcessingStep(
        key: const ValueKey('try-on-processing'),
        state: state,
      );
    }

    if (state.isCompleted) {
      return _RecommendationsLooksStep(
        key: const ValueKey('looks'),
        state: state,
      );
    }

    if (state.isReviewing) {
      return _RecommendationsReviewStep(
        key: const ValueKey('review'),
        state: state,
      );
    }

    if (state.isLoading) {
      return _RecommendationsLoadingStep(key: const ValueKey('loading'));
    }

    return _RecommendationsPhotoStep(
      key: const ValueKey('photo'),
      state: state,
    );
  }
}

class _RecommendationsSheetScaffold extends StatelessWidget {
  const _RecommendationsSheetScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: -AppSizes.s90,
          right: -40,
          child: _GlowOrb(
            size: AppSizes.s220,
            color: AppColors.secondary,
            opacity: 0.18,
          ),
        ),
        const Positioned(
          bottom: -140,
          left: -36,
          child: _GlowOrb(
            size: AppSizes.s280,
            color: AppColors.primary,
            opacity: 0.18,
          ),
        ),
        const Positioned(
          bottom: AppSizes.s120,
          right: -AppSizes.s24,
          child: _GlowOrb(
            size: AppSizes.s160,
            color: AppColors.secondary,
            opacity: 0.1,
          ),
        ),
        child,
      ],
    );
  }
}

class _RecommendationsPhotoStep extends StatelessWidget {
  const _RecommendationsPhotoStep({super.key, required this.state});

  final RecommendationsState state;

  Future<void> _pickPhoto(BuildContext context, ImageSource source) async {
    final files = await AppPickerUtils.pickImages(
      multiple: false,
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (files.isEmpty || !context.mounted) {
      return;
    }

    context.read<RecommendationsBloc>().add(
      RecommendationsPhotoSelected(files.first),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasReadyPhoto =
        state.selectedPhoto != null &&
        !state.isValidatingPhoto &&
        (state.errorMessage?.trim().isEmpty ?? true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsSheetTitle,
          accentTitle: null,
          subtitle: l10n.recommendationsSheetSubtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.s30),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _AccentHeadline(
                  leading: l10n.recommendationsSelfieHeadlineLeading,
                  accent: l10n.recommendationsSelfieHeadlineAccent,
                ),
                const SizedBox(height: AppSizes.s10),
                AppText(
                  text: l10n.recommendationsSelfieDescription,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: AppTextStyles.ts15(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.4),
                ),

                _SelfiePreviewFrame(
                  photo: state.selectedPhoto,
                  isValidatingPhoto: state.isValidatingPhoto,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _PhotoActionCard(
                        icon: Icons.photo_camera_rounded,
                        title: l10n.recommendationsTakePhotoAction,
                        subtitle: l10n.recommendationsTakePhotoCaption,
                        onTap: state.isValidatingPhoto
                            ? null
                            : () => _pickPhoto(context, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: _PhotoActionCard(
                        icon: Icons.photo_library_rounded,
                        title: l10n.recommendationsUploadPhotoAction,
                        subtitle: l10n.recommendationsUploadPhotoCaption,
                        onTap: state.isValidatingPhoto
                            ? null
                            : () => _pickPhoto(context, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s14),
                _InfoStrip(
                  icon: Icons.shield_outlined,
                  message: l10n.recommendationsPrivacyNote,
                ),
                if (hasReadyPhoto) ...[
                  const SizedBox(height: AppSizes.s14),
                  _StatusStrip(
                    icon: Icons.check_circle_rounded,
                    message: l10n.recommendationsPhotoReadyMessage,
                  ),
                ] else ...[
                  const SizedBox(height: AppSizes.s14),
                  _InfoStrip(
                    icon: Icons.face_retouching_natural_rounded,
                    message: l10n.recommendationsPhotoGuidanceMessage,
                  ),
                ],
                if (state.isValidatingPhoto) ...[
                  const SizedBox(height: AppSizes.s14),
                  _StatusStrip(
                    icon: Icons.search_rounded,
                    message: l10n.recommendationsPhotoValidationMessage,
                  ),
                ],
                if (state.errorMessage?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSizes.s14),
                  _ErrorStrip(message: state.errorMessage!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.s20),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: l10n.skip,
                height: AppSizes.s56,
                borderRadius: AppRadius.r28,
                backgroundColor: AppColors.pureWhite.withValues(alpha: 0.03),
                borderColor: AppColors.secondary,
                borderWidth: 1.4,
                onPressed: state.isBusy
                    ? null
                    : () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: AppSizes.s16),
            Expanded(
              child: Opacity(
                opacity: state.canFetchRecommendations ? 1 : 0.45,
                child: AppButton(
                  text: l10n.continueText,
                  height: AppSizes.s56,
                  borderRadius: AppRadius.r28,
                  gradientColors: _recommendationsPrimaryGradientColors,
                  isLoading: state.isLoading,
                  onPressed: state.canFetchRecommendations
                      ? () => context.read<RecommendationsBloc>().add(
                          const RecommendationsFetchRequested(),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecommendationsLoadingStep extends StatelessWidget {
  const _RecommendationsLoadingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsTrainingTitle,
          accentTitle: null,
          subtitle: l10n.recommendationsTrainingSubtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.s118,
                  height: AppSizes.s118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSizes.s24),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s24),
                AppText(
                  text: l10n.recommendationsLoadingMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s10),
                AppText(
                  text: l10n.recommendationsTrainingDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationsReviewStep extends StatelessWidget {
  const _RecommendationsReviewStep({super.key, required this.state});

  final RecommendationsState state;

  @override
  Widget build(BuildContext context) {
    final item = state.currentItem;
    final l10n = AppLocalizations.of(context)!;
    if (item == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsTrainingTitle,
          accentTitle: null,
          subtitle: l10n.recommendationsReviewProgress(
            state.currentPosition,
            state.totalItems,
          ),
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.s20),
        _ProgressSegments(
          currentIndex: state.currentIndex,
          total: state.totalItems,
        ),
        const SizedBox(height: AppSizes.s22),
        Expanded(
          child: _LookReviewCard(
            item: item,
            currentPosition: state.currentPosition,
            totalItems: state.totalItems,
          ),
        ),
        const SizedBox(height: AppSizes.s24),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: l10n.skip,
                height: AppSizes.s48,
                borderRadius: AppRadius.r28,
                backgroundColor: AppColors.pureWhite.withValues(alpha: 0.03),
                borderColor: AppColors.secondary,
                borderWidth: 1.4,
                fontSize: AppSizes.s16,
                onPressed: () => context.read<RecommendationsBloc>().add(
                  const RecommendationsReviewSkipped(),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.s16),
            _ReactionIconButton(
              icon: Icons.thumb_down_alt_rounded,
              onTap: () => context.read<RecommendationsBloc>().add(
                const RecommendationsDisliked(),
              ),
            ),
            const SizedBox(width: AppSizes.s16),
            Expanded(
              child: AppButton(
                text: l10n.recommendationsLoveAction,
                height: AppSizes.s48,
                borderRadius: AppRadius.r28,
                fontSize: AppSizes.s16,
                gradientColors: _recommendationsPrimaryGradientColors,
                leadingIcon: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s20,
                ),
                onPressed: () => context.read<RecommendationsBloc>().add(
                  const RecommendationsLiked(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecommendationsLooksStep extends StatelessWidget {
  const _RecommendationsLooksStep({super.key, required this.state});

  final RecommendationsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final likedCount = state.likedItems.length;
    final eligibleTryOnCount = state.likedItemsWithThumbnails.length;
    final subtitle = l10n.recommendationsLooksMatchedSubtitle(state.totalItems);
    final headline = likedCount > 0
        ? l10n.recommendationsLovedLooksHeadline(likedCount)
        : l10n.recommendationsReviewedLooksHeadline(state.totalItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsStyleDnaTitle,
          accentTitle: null,
          subtitle: subtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.s28),
        _SummaryHeadline(
          headline: headline,
          subtitle: likedCount > 0
              ? l10n.recommendationsSummaryLovedSubtitle
              : l10n.recommendationsSummaryReviewedSubtitle,
        ),
        const SizedBox(height: AppSizes.s22),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.totalItems,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSizes.s14,
                    crossAxisSpacing: AppSizes.s14,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _LooksGridCard(
                      item: item,
                      isLiked: state.isItemLiked(index),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.s20),
                _StyleSignalCard(
                  title: l10n.recommendationsVibeSignalTitle,
                  message: _buildStyleSignalMessage(context, state),
                ),
                if (likedCount > 0) ...[
                  const SizedBox(height: AppSizes.s14),
                  _InfoStrip(
                    icon: Icons.auto_awesome_rounded,
                    message: eligibleTryOnCount > 0
                        ? l10n.recommendationsTryOnEligibleMessage(
                            eligibleTryOnCount,
                          )
                        : l10n.recommendationsTryOnMissingImagesMessage,
                  ),
                ],
                if (state.errorMessage?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSizes.s14),
                  _ErrorStrip(message: state.errorMessage!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.s20),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: l10n.recommendationsRetrainAction,
                height: AppSizes.s56,
                borderRadius: AppRadius.r28,
                backgroundColor: AppColors.pureWhite.withValues(alpha: 0.03),
                borderColor: AppColors.secondary,
                borderWidth: 1.4,
                onPressed: () => context.read<RecommendationsBloc>().add(
                  const RecommendationsRestartRequested(),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.s16),
            Expanded(
              child: AppButton(
                text: l10n.continueText,
                height: AppSizes.s56,
                borderRadius: AppRadius.r28,
                gradientColors: _recommendationsPrimaryGradientColors,
                onPressed: state.canGenerateTryOn
                    ? () => context.read<RecommendationsBloc>().add(
                        const RecommendationsTryOnRequested(),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TryOnResultsStep extends StatefulWidget {
  const _TryOnResultsStep({
    super.key,
    required this.state,
    required this.onContinueToChat,
  });

  final RecommendationsState state;
  final VoidCallback onContinueToChat;

  @override
  State<_TryOnResultsStep> createState() => _TryOnResultsStepState();
}

class _TryOnResultsStepState extends State<_TryOnResultsStep> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  List<TryOnGeneratedLook> get _results => widget.state.tryOnResults;

  int get _totalItems => _results.length;

  bool get _isLastAvailable =>
      _results.isEmpty || _currentIndex >= _results.length - 1;

  bool get _hasNextAvailable => _currentIndex + 1 < _results.length;

  int get _currentPosition => _results.isEmpty ? 0 : _currentIndex + 1;

  bool get _showContinueAction =>
      widget.state.isTryOnComplete && _results.isNotEmpty && _isLastAvailable;

  TryOnGeneratedLook? get _currentResult {
    if (_results.isEmpty ||
        _currentIndex < 0 ||
        _currentIndex >= _results.length) {
      return null;
    }

    return _results[_currentIndex];
  }

  RecommendationItem? get _currentSourceItem {
    final result = _currentResult;
    final sourceItems = widget.state.likedItemsWithThumbnails;
    if (result == null || sourceItems.isEmpty) {
      return null;
    }

    final sequence = result.sequence;
    if (sequence != null) {
      final sequenceIndex = sequence - 1;
      if (sequenceIndex >= 0 && sequenceIndex < sourceItems.length) {
        return sourceItems[sequenceIndex];
      }
    }

    if (_currentIndex < sourceItems.length) {
      return sourceItems[_currentIndex];
    }

    return null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _TryOnResultsStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_results.isEmpty) {
      if (_currentIndex != 0) {
        setState(() {
          _currentIndex = 0;
        });
      }
      return;
    }

    final maxIndex = _results.length - 1;
    if (_currentIndex > maxIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _currentIndex = maxIndex;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(maxIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _currentResult;
    final l10n = AppLocalizations.of(context)!;
    if (result == null) {
      return const SizedBox.shrink();
    }

    final progressText = widget.state.tryOnProgressText?.trim();
    final subtitle = progressText != null && progressText.isNotEmpty
        ? '${l10n.recommendationsGeneratedSubtitle} ($progressText)'
        : l10n.recommendationsGeneratedSubtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsGeneratedTitle,
          accentTitle: null,
          subtitle: subtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.s20),
        _ProgressSegments(currentIndex: _currentIndex, total: _totalItems),
        const SizedBox(height: AppSizes.s22),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _results.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (_currentIndex == index) {
                    return;
                  }

                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final pageResult = _results[index];
                  final sourceItems = widget.state.likedItemsWithThumbnails;
                  RecommendationItem? pageSourceItem;

                  final sequence = pageResult.sequence;
                  if (sequence != null) {
                    final sequenceIndex = sequence - 1;
                    if (sequenceIndex >= 0 &&
                        sequenceIndex < sourceItems.length) {
                      pageSourceItem = sourceItems[sequenceIndex];
                    }
                  }

                  pageSourceItem ??=
                      index < sourceItems.length ? sourceItems[index] : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.s2),
                    child: _TryOnLookCard(
                      result: pageResult,
                      sourceItem: pageSourceItem,
                      currentPosition: index + 1,
                      totalItems: _totalItems,
                    ),
                  );
                },
              ),
              if (widget.state.isGeneratingTryOn)
                const Positioned(
                  top: AppSizes.s18,
                  right: AppSizes.s18,
                  child: _TryOnLiveStatusPill(),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s24),
        if (_showContinueAction)
          AppButton(
            text: l10n.recommendationsContinueChatAction,
            height: AppSizes.s56,
            borderRadius: AppRadius.r28,
            gradientColors: _recommendationsPrimaryGradientColors,
            onPressed: widget.onContinueToChat,
          )
        else
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: l10n.skip,
                  height: AppSizes.s56,
                  borderRadius: AppRadius.r28,
                  backgroundColor: AppColors.pureWhite.withValues(alpha: 0.03),
                  borderColor: AppColors.secondary,
                  borderWidth: 1.4,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: AppButton(
                  text: _hasNextAvailable
                      ? l10n.recommendationsNextLookAction
                      : l10n.recommendationsProcessingLabel,
                  height: AppSizes.s56,
                  borderRadius: AppRadius.r28,
                  gradientColors: _recommendationsPrimaryGradientColors,
                  isLoading: !_hasNextAvailable && widget.state.isGeneratingTryOn,
                  onPressed: _hasNextAvailable
                      ? () {
                          final nextIndex = _currentIndex + 1;
                          _pageController.animateToPage(
                            nextIndex,
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _TryOnProcessingStep extends StatelessWidget {
  const _TryOnProcessingStep({super.key, required this.state});

  final RecommendationsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = state.tryOnProgress.clamp(0, 100);
    final progressText = state.tryOnProgressText?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SheetHeader(
          title: l10n.recommendationsGeneratingTitle,
          accentTitle: null,
          subtitle: l10n.recommendationsGeneratingSubtitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSizes.s30),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _TryOnIndeterminateIndicator(),
                const SizedBox(height: AppSizes.s28),
                AppText(
                  text: l10n.recommendationsBuildingTryOnTitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: AppTextStyles.ts22(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s10),
                AppText(
                  text: progressText != null && progressText.isNotEmpty
                      ? '${_tryOnProgressLabel(context, progress)} ($progressText)'
                      : _tryOnProgressLabel(context, progress),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.74),
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.45),
                ),
                const SizedBox(height: AppSizes.s20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.s16),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    children: [
                      _TryOnTimelineRow(
                        isDone: progress >= 20,
                        label: l10n.recommendationsTryOnUploadTimeline,
                      ),
                      const SizedBox(height: AppSizes.s12),
                      _TryOnTimelineRow(
                        isDone: progress >= 55,
                        label: l10n.recommendationsTryOnFitTimeline,
                      ),
                      const SizedBox(height: AppSizes.s12),
                      _TryOnTimelineRow(
                        isDone: progress >= 85,
                        label: l10n.recommendationsTryOnRenderTimeline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TryOnIndeterminateIndicator extends StatelessWidget {
  const _TryOnIndeterminateIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: AppSizes.s160,
      height: AppSizes.s160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.32),
            AppColors.secondary.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: AppSizes.s118,
            height: AppSizes.s118,
            child: CircularProgressIndicator(
              strokeWidth: 7,
              color: AppColors.secondary,
              backgroundColor: AppColors.pureWhite.withValues(alpha: 0.12),
            ),
          ),
          AppText(
            text: l10n.recommendationsProcessingLabel,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TryOnLiveStatusPill extends StatelessWidget {
  const _TryOnLiveStatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.pureBlack.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: AppSizes.s14,
            height: AppSizes.s14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          AppText(
            text: AppLocalizations.of(context)!.recommendationsProcessingLabel,
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

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.accentTitle,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String? accentTitle;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackGradientButton(onTap: onBack),
        const SizedBox(width: AppSizes.s14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (accentTitle == null)
                AppText(
                  text: title,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                )
              else
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: AppTextStyles.ts20(
                          context,
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: accentTitle,
                        style: AppTextStyles.ts20(
                          context,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSizes.s2),
              AppText(
                text: subtitle,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackGradientButton extends StatelessWidget {
  const _BackGradientButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.s44,
        height: AppSizes.s44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _recommendationsPrimaryGradientColors,
          ),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: AppColors.pureWhite),
      ),
    );
  }
}

class _AccentHeadline extends StatelessWidget {
  const _AccentHeadline({required this.leading, required this.accent});

  final String leading;
  final String accent;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: leading,
            style: AppTextStyles.ts32(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: accent,
            style: AppTextStyles.ts32(
              context,
              color: AppColors.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _SummaryHeadline extends StatelessWidget {
  const _SummaryHeadline({required this.headline, required this.subtitle});

  final String headline;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final countMatch = _headlineNumberPattern.firstMatch(headline);
    final countText = countMatch?.group(0);
    final parts = countText == null ? [headline] : headline.split(countText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (countText == null)
          AppText(
            text: headline,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts28(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w800,
            ),
          )
        else
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: parts.first,
                  style: AppTextStyles.ts28(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: countText,
                  style: AppTextStyles.ts28(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: parts.length > 1 ? parts.last : '',
                  style: AppTextStyles.ts28(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: AppSizes.s6),
        AppText(
          text: subtitle,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.74),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SelfiePreviewFrame extends StatelessWidget {
  const _SelfiePreviewFrame({
    required this.photo,
    required this.isValidatingPhoto,
  });

  final File? photo;
  final bool isValidatingPhoto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.s220,
      height: AppSizes.s220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(top: 20, left: 20, child: _CornerAccent()),
          const Positioned(
            top: 20,
            right: 20,
            child: _CornerAccent(mirroredX: true),
          ),
          const Positioned(
            bottom: 20,
            left: 20,
            child: _CornerAccent(mirroredY: true),
          ),
          const Positioned(
            bottom: 20,
            right: 20,
            child: _CornerAccent(mirroredX: true, mirroredY: true),
          ),
          CustomPaint(
            size: const Size.square(AppSizes.s176),
            painter: _DashedCirclePainter(
              color: AppColors.secondary.withValues(alpha: 0.9),
            ),
          ),
          Container(
            width: AppSizes.s170,
            height: AppSizes.s170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.12),
            ),
            child: ClipOval(
              child: photo == null
                  ? const _SelfiePlaceholder()
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(photo!, fit: BoxFit.cover),
                        if (isValidatingPhoto)
                          Container(
                            color: AppColors.pureBlack.withValues(alpha: 0.5),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: AppSizes.s28,
                              height: AppSizes.s28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfiePlaceholder extends StatelessWidget {
  const _SelfiePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.secondary.withValues(alpha: 0.16),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.account_circle_rounded,
          color: AppColors.secondary,
          size: AppSizes.s106,
        ),
      ),
    );
  }
}

class _PhotoActionCard extends StatelessWidget {
  const _PhotoActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Opacity(
        opacity: onTap == null ? 0.55 : 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s14,
              vertical: AppSizes.s14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _recommendationsActionGradientColors,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.s32,
                  height: AppSizes.s32,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.pureWhite,
                    size: AppSizes.s22,
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: title,
                        style: AppTextStyles.ts12(
                          context,
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: AppSizes.s2),
                      AppText(
                        text: subtitle,
                        style: AppTextStyles.ts10(
                          context,
                          color: AppColors.pureWhite.withValues(alpha: 0.86),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s12,
      ),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: AppSizes.s16),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: AppText(
              text: message,
              maxLines: 2,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.76),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: AppSizes.s10),
          Expanded(
            child: AppText(
              text: message,
              maxLines: 4,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorStrip extends StatelessWidget {
  const _ErrorStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.materialRedAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: AppColors.materialRedAccent.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.materialRedAccent,
          ),
          const SizedBox(width: AppSizes.s10),
          Expanded(
            child: AppText(
              text: message,
              maxLines: 4,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              ).copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSegments extends StatelessWidget {
  const _ProgressSegments({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index == total - 1 ? 0 : AppSizes.s8,
            ),
            height: AppSizes.s6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              color: isActive
                  ? AppColors.secondary
                  : AppColors.pureWhite.withValues(alpha: 0.22),
            ),
          ),
        );
      }),
    );
  }
}

class _LookReviewCard extends StatelessWidget {
  const _LookReviewCard({
    required this.item,
    required this.currentPosition,
    required this.totalItems,
  });

  final RecommendationItem item;
  final int currentPosition;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.secondary, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.thumbnail?.trim().isNotEmpty == true)
              AppCachedNetworkImage(
                imageUrl: item.thumbnail!.trim(),
                fit: BoxFit.cover,
                errorWidget: const _RecommendationImageFallback(),
              )
            else
              const _RecommendationImageFallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.recommendationsOverlayLight,
                    AppColors.recommendationsOverlayMedium,
                    AppColors.recommendationsOverlayStrong,
                  ],
                  stops: [0, 0.35, 1],
                ),
              ),
            ),
            Positioned(
              left: AppSizes.s18,
              right: AppSizes.s18,
              bottom: AppSizes.s18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: AppLocalizations.of(
                            context,
                          )!.recommendationsLookLabel(currentPosition),
                          style: AppTextStyles.ts18(
                            context,
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w600,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: AppSizes.s6),
                        AppText(
                          text: item.title?.trim().isNotEmpty == true
                              ? item.title!.trim()
                              : AppLocalizations.of(
                                  context,
                                )!.chatCatalogProductFallbackTitle,
                          style: AppTextStyles.ts24(
                            context,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                        ),
                        if (item.category?.name?.trim().isNotEmpty == true) ...[
                          const SizedBox(height: AppSizes.s6),
                          _MetaPill(label: item.category!.name!.trim()),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  _IndexPill(label: '$currentPosition/$totalItems'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TryOnLookCard extends StatelessWidget {
  const _TryOnLookCard({
    required this.result,
    required this.sourceItem,
    required this.currentPosition,
    required this.totalItems,
  });

  final TryOnGeneratedLook result;
  final RecommendationItem? sourceItem;
  final int currentPosition;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final lookTitle = result.title?.trim().isNotEmpty == true
        ? result.title!.trim()
        : sourceItem?.title?.trim().isNotEmpty == true
        ? sourceItem!.title!.trim()
        : AppLocalizations.of(context)!.recommendationsStyledLookFallback;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.secondary, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppCachedNetworkImage(
              imageUrl: result.imageUrl.trim(),
              fit: BoxFit.cover,
              errorWidget: const _RecommendationImageFallback(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.recommendationsOverlaySoft,
                    AppColors.recommendationsOverlayMediumStrong,
                    AppColors.recommendationsOverlayStrong,
                  ],
                  stops: [0, 0.36, 1],
                ),
              ),
            ),
            Positioned(
              left: AppSizes.s18,
              right: AppSizes.s18,
              bottom: AppSizes.s18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: AppLocalizations.of(
                            context,
                          )!.recommendationsLookLabel(currentPosition),
                          style: AppTextStyles.ts18(
                            context,
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w600,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: AppSizes.s6),
                        AppText(
                          text: lookTitle,
                          style: AppTextStyles.ts24(
                            context,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                        ),
                        if (sourceItem?.category?.name?.trim().isNotEmpty ==
                            true) ...[
                          const SizedBox(height: AppSizes.s6),
                          _MetaPill(label: sourceItem!.category!.name!.trim()),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  _IndexPill(label: '$currentPosition/$totalItems'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LooksGridCard extends StatelessWidget {
  const _LooksGridCard({required this.item, required this.isLiked});

  final RecommendationItem item;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(
          color: isLiked
              ? AppColors.secondary
              : AppColors.secondary.withValues(alpha: 0.65),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.thumbnail?.trim().isNotEmpty == true)
              AppCachedNetworkImage(
                imageUrl: item.thumbnail!.trim(),
                fit: BoxFit.cover,
                errorWidget: const _RecommendationImageFallback(),
              )
            else
              const _RecommendationImageFallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.recommendationsOverlayLight,
                    AppColors.recommendationsOverlayMedium,
                    AppColors.recommendationsOverlayHeavy,
                  ],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
            Positioned(
              top: AppSizes.s10,
              right: AppSizes.s10,
              child: Container(
                width: AppSizes.s34,
                height: AppSizes.s34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isLiked
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _recommendationsPrimaryGradientColors,
                        )
                      : null,
                  color: isLiked
                      ? null
                      : AppColors.pureBlack.withValues(alpha: 0.42),
                  border: Border.all(
                    color: isLiked
                        ? AppColors.transparent
                        : AppColors.pureWhite.withValues(alpha: 0.24),
                  ),
                ),
                child: Icon(
                  isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s18,
                ),
              ),
            ),
            Positioned(
              left: AppSizes.s12,
              right: AppSizes.s12,
              bottom: AppSizes.s12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: item.title?.trim().isNotEmpty == true
                        ? item.title!.trim()
                        : AppLocalizations.of(
                            context,
                          )!.chatCatalogProductFallbackTitle,
                    style: AppTextStyles.ts14(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                  ),
                  if (item.category?.name?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: AppSizes.s6),
                    _MetaPill(label: item.category!.name!.trim()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TryOnTimelineRow extends StatelessWidget {
  const _TryOnTimelineRow({required this.isDone, required this.label});

  final bool isDone;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.secondary
                : AppColors.pureWhite.withValues(alpha: 0.08),
            border: Border.all(
              color: isDone
                  ? AppColors.secondary
                  : AppColors.pureWhite.withValues(alpha: 0.22),
            ),
          ),
          child: Icon(
            isDone ? Icons.check_rounded : Icons.hourglass_top_rounded,
            size: AppSizes.s14,
            color: AppColors.pureWhite,
          ),
        ),
        const SizedBox(width: AppSizes.s10),
        Expanded(
          child: AppText(
            text: label,
            maxLines: 3,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.82),
              fontWeight: FontWeight.w500,
            ).copyWith(height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _StyleSignalCard extends StatelessWidget {
  const _StyleSignalCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withValues(alpha: 0.18),
            AppColors.primary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.s34,
            height: AppSizes.s34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.pureWhite,
              size: AppSizes.s18,
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  style: AppTextStyles.ts16(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s4),
                AppText(
                  text: message,
                  maxLines: 4,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexPill extends StatelessWidget {
  const _IndexPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pureBlack.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.8)),
      ),
      child: AppText(
        text: label,
        maxLines: 4,
        style: AppTextStyles.ts16(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.18)),
      ),
      child: AppText(
        text: label,
        maxLines: 4,
        style: AppTextStyles.ts12(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReactionIconButton extends StatelessWidget {
  const _ReactionIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.s48,
        height: AppSizes.s48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.pureWhite.withValues(alpha: 0.08),
              AppColors.pureWhite.withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: AppColors.pureWhite, size: AppSizes.s20),
      ),
    );
  }
}

class _RecommendationImageFallback extends StatelessWidget {
  const _RecommendationImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.recommendationsFallbackStart,
            AppColors.recommendationsFallbackEnd,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.checkroom_rounded,
        color: AppColors.pureWhite.withValues(alpha: 0.38),
        size: AppSizes.s86,
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle),
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  const _CornerAccent({this.mirroredX = false, this.mirroredY = false});

  final bool mirroredX;
  final bool mirroredY;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
        mirroredX ? -1.0 : 1.0,
        mirroredY ? -1.0 : 1.0,
        1.0,
      ),
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.secondary, width: 2),
            left: BorderSide(color: AppColors.secondary, width: 2),
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashCount = 42;
    const gapFactor = 0.48;
    final radius = size.width / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final fullSweep = (2 * math.pi) / dashCount;
    final dashSweep = fullSweep * (1 - gapFactor);

    for (var index = 0; index < dashCount; index++) {
      final startAngle = fullSweep * index;
      canvas.drawArc(rect, startAngle, dashSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

String _buildStyleSignalMessage(
  BuildContext context,
  RecommendationsState state,
) {
  final l10n = AppLocalizations.of(context)!;
  final seed = state.likedItems.isNotEmpty
      ? state.likedItems.first
      : state.items.isNotEmpty
      ? state.items.first
      : null;

  final descriptor = seed?.category?.name?.trim().isNotEmpty == true
      ? seed!.category!.name!.trim()
      : seed?.title?.trim().isNotEmpty == true
      ? seed!.title!.trim()
      : l10n.recommendationsStyleDescriptorFallback;

  if (state.likedItems.isEmpty) {
    return l10n.recommendationsStyleSignalEmpty(descriptor);
  }

  return l10n.recommendationsStyleSignalLoved(descriptor.toLowerCase());
}

String _tryOnProgressLabel(BuildContext context, int progress) {
  final l10n = AppLocalizations.of(context)!;
  if (progress >= 85) {
    return l10n.recommendationsTryOnProgressFinal;
  }

  if (progress >= 55) {
    return l10n.recommendationsTryOnProgressFitting;
  }

  if (progress >= 20) {
    return l10n.recommendationsTryOnProgressPreparing;
  }

  return l10n.recommendationsTryOnProgressUploading;
}
