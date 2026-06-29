import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/wardrobe/barrels/wardrobe_barrels.dart';
import 'package:drip_talk/features/wardrobe/view/widgets/wardrobe_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateWardrobeView extends StatefulWidget {
  const CreateWardrobeView({super.key});

  @override
  State<CreateWardrobeView> createState() => _CreateWardrobeViewState();
}

class _CreateWardrobeViewState extends State<CreateWardrobeView> {
  late final TextEditingController _titleController;
  late final FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CreateWardrobeBloc, CreateWardrobeState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage &&
              current.feedbackMessage?.trim().isNotEmpty == true ||
          previous.status != current.status,
      listener: (context, state) {
        final message = state.feedbackMessage?.trim();
        if (message != null && message.isNotEmpty) {
          ToastUtils.show(
            context,
            message,
            type: switch (state.feedbackType) {
              CreateWardrobeFeedbackType.success => ToastType.success,
              CreateWardrobeFeedbackType.error => ToastType.error,
              CreateWardrobeFeedbackType.info => ToastType.info,
            },
          );
        }

        if (state.titleErrorMessage?.trim().isNotEmpty == true) {
          _titleFocusNode.requestFocus();
        }

        if (state.status == CreateWardrobeStatus.success) {
          context.pop(true);
        }
      },
      child: WardrobeScreenScaffold(
        bottomSafeArea: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 560 ? 28.0 : 24.0;
            final topPadding = constraints.maxWidth >= 560 ? 22.0 : 18.0;

            return BlocBuilder<CreateWardrobeBloc, CreateWardrobeState>(
              builder: (context, state) {
                if (_titleController.text != state.title) {
                  _titleController.value = _titleController.value.copyWith(
                    text: state.title,
                    selection: TextSelection.collapsed(
                      offset: state.title.length,
                    ),
                    composing: TextRange.empty,
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topPadding,
                    horizontalPadding,
                    AppSizes.s28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WardrobeHeader(
                        titleLeading: l10n.wardrobeCreateHeaderLeading,
                        titleAccent: l10n.wardrobeCreateHeaderAccent,
                        subtitle: l10n.wardrobeCreateHeaderSubtitle,
                        onBack: () => context.pop(),
                      ),
                      const AppGap(AppSizes.s28),
                      AppTextField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        hintText: l10n.wardrobeNameHint,
                        labelText: l10n.wardrobeNameLabel,
                        isRequired: true,
                        errorText: state.titleErrorMessage,
                        fillColor: AppColors.pureWhite,
                        textColor: AppColors.pureBlack,
                        hintColor: AppColors.materialGrey700,
                        borderRadius: AppRadius.r16,
                        onChanged: (value) {
                          context.read<CreateWardrobeBloc>().add(
                            WardrobeTitleChanged(value),
                          );
                        },
                      ),
                      const AppGap(AppSizes.s28),
                      _UploadZone(
                        onPickPressed: () => _openImagePicker(context),
                      ),
                      const AppGap(AppSizes.s24),
                      _SelectedImagesGrid(
                        images: state.images,
                        onRemove: (path) {
                          context.read<CreateWardrobeBloc>().add(
                            WardrobeImageRemoved(path),
                          );
                        },
                      ),
                      const AppGap(AppSizes.s28),
                      AppButton(
                        text: l10n.wardrobeCreateAction,
                        isLoading: state.isSubmitting,
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                context.read<CreateWardrobeBloc>().add(
                                  const CreateWardrobeSubmitted(),
                                );
                              },
                        height: AppSizes.s56,
                        borderRadius: AppRadius.circular,
                        gradientColors: const [
                          AppColors.softPink,
                          AppColors.secondary,
                        ],
                        leadingIcon: const Icon(
                          Icons.add_rounded,
                          color: AppColors.pureWhite,
                          size: AppSizes.s18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openImagePicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.pureBlack.withValues(alpha: 0.55),
      builder: (_) {
        return AppImagePicker(
          multiple: true,
          onPicked: (images) {
            context.read<CreateWardrobeBloc>().add(WardrobeImagesAdded(images));
          },
        );
      },
    );
  }
}

class _UploadZone extends StatelessWidget {
  const _UploadZone({required this.onPickPressed});

  final VoidCallback onPickPressed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedRectPainter(
        color: AppColors.secondary.withValues(alpha: 0.88),
        radius: AppRadius.r30,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s20,
          vertical: AppSizes.s22,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r30),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.pureBlack.withValues(alpha: 0.08),
              AppColors.pureWhite.withValues(alpha: 0.03),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: AppSizes.s64,
              height: AppSizes.s64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                color: AppColors.secondary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.32),
                ),
              ),
              child: const Icon(
                Icons.upload_rounded,
                color: AppColors.softPink,
                size: AppSizes.s30,
              ),
            ),
            const AppGap(AppSizes.s22),
            AppText(
              text: AppLocalizations.of(context)!.wardrobeUploadTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts18(
                context,
                color: AppColors.secondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const AppGap(AppSizes.s10),
            AppText(
              text: AppLocalizations.of(context)!.wardrobeUploadSubtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.82),
                fontWeight: FontWeight.w500,
              ).copyWith(height: 1.45),
            ),
            const AppGap(AppSizes.s22),
            AppButton(
              text: AppLocalizations.of(context)!.wardrobeUploadAction,
              onPressed: onPickPressed,
              height: AppSizes.s50,
              borderRadius: AppRadius.circular,
              fontSize: AppSizes.s16,
              gradientColors: const [AppColors.softPink, AppColors.secondary],
              leadingIcon: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.pureWhite,
                size: AppSizes.s18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedImagesGrid extends StatelessWidget {
  const _SelectedImagesGrid({required this.images, required this.onRemove});

  final List<File> images;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 520 ? 4 : 3;
        final minimumSlots = crossAxisCount * 2;
        final totalSlots = images.length < minimumSlots
            ? minimumSlots
            : images.length;

        return GridView.builder(
          itemCount: totalSlots,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSizes.s10,
            crossAxisSpacing: AppSizes.s10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index >= images.length) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  color: const Color(0xFF40375A).withValues(alpha: 0.72),
                  border: Border.all(
                    color: AppColors.pureWhite.withValues(alpha: 0.14),
                  ),
                ),
              );
            }

            final image = images[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
                Positioned(
                  top: AppSizes.s8,
                  right: AppSizes.s8,
                  child: GestureDetector(
                    onTap: () => onRemove(image.path),
                    child: Container(
                      width: AppSizes.s28,
                      height: AppSizes.s28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.pureWhite,
                        size: AppSizes.s16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const dashWidth = 7.0;
    const dashSpace = 6.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
