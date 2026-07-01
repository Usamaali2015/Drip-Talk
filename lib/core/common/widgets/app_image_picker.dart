import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/app_picker_utils.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'app_button.dart';
import 'app_gap.dart';
import 'app_text.dart';

class AppImagePicker extends StatelessWidget {
  const AppImagePicker({
    super.key,
    this.multiple = false,
    required this.onPicked,
  });

  final bool multiple;
  final ValueChanged<List<File>> onPicked;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final files = await AppPickerUtils.pickImages(
      context: context,
      multiple: multiple,
      source: source,
    );
    if (files.isNotEmpty) {
      onPicked(files);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    final title = multiple
        ? l10n.chatAttachImages
        : l10n.editProfilePhotoSourceTitle;
    final subtitle = multiple
        ? l10n.imagePickerMultipleHint
        : l10n.imagePickerSingleHint;
    final galleryCaption = multiple
        ? l10n.imagePickerGalleryCaptionMultiple
        : l10n.imagePickerGalleryCaptionSingle;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary, AppColors.cyan],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.18),
            blurRadius: AppSizes.s32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.supportHeaderBackground,
                AppColors.lightBg,
                AppColors.darkBg2,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -AppSizes.s56,
                right: -AppSizes.s24,
                child: _SheetGlow(
                  size: AppSizes.s160,
                  color: AppColors.secondary,
                ),
              ),
              Positioned(
                top: AppSizes.s24,
                left: -AppSizes.s32,
                child: _SheetGlow(
                  size: AppSizes.s120,
                  color: AppColors.primary,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.s20,
                  AppSizes.s12,
                  AppSizes.s20,
                  bottomPadding + AppSizes.s20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSizes.s56,
                      height: AppSizes.s4,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.24),
                        borderRadius: BorderRadius.circular(AppRadius.circular),
                      ),
                    ),
                    const AppGap(AppSizes.s20),
                    Container(
                      width: AppSizes.s72,
                      height: AppSizes.s72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.24),
                            AppColors.primary.withValues(alpha: 0.22),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.pureWhite.withValues(alpha: 0.16),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: AppColors.pureWhite,
                        size: AppSizes.s32,
                      ),
                    ),
                    const AppGap(AppSizes.s18),
                    AppText(
                      text: title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.ts24(
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
                        color: AppColors.pureWhite.withValues(alpha: 0.74),
                        fontWeight: FontWeight.w500,
                      ).copyWith(height: 1.4),
                      maxLines: 3,
                    ),
                    const AppGap(AppSizes.s24),
                    _ImagePickerActionCard(
                      icon: Icons.photo_library_rounded,
                      title: l10n.editProfilePhotoGalleryAction,
                      subtitle: galleryCaption,
                      accentColor: AppColors.secondary,
                      highlighted: true,
                      onTap: () => _pick(context, ImageSource.gallery),
                    ),
                    const AppGap(AppSizes.s12),
                    _ImagePickerActionCard(
                      icon: Icons.camera_alt_rounded,
                      title: l10n.editProfilePhotoCameraAction,
                      subtitle: l10n.imagePickerCameraCaption,
                      accentColor: AppColors.cyan,
                      highlighted: false,
                      onTap: () => _pick(context, ImageSource.camera),
                    ),
                    const AppGap(AppSizes.s16),
                    AppButton(
                      text: l10n.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      height: AppSizes.s50,
                      borderRadius: AppRadius.r20,
                      backgroundColor: AppColors.pureWhite.withValues(
                        alpha: 0.04,
                      ),
                      borderColor: AppColors.pureWhite.withValues(alpha: 0.12),
                      textColor: AppColors.pureWhite,
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

class _ImagePickerActionCard extends StatelessWidget {
  const _ImagePickerActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.highlighted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: Ink(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            gradient: highlighted
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.22),
                      AppColors.primary.withValues(alpha: 0.18),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.pureWhite.withValues(alpha: 0.06),
                      AppColors.pureWhite.withValues(alpha: 0.03),
                    ],
                  ),
            border: Border.all(
              color: highlighted
                  ? AppColors.secondary.withValues(alpha: 0.42)
                  : AppColors.pureWhite.withValues(alpha: 0.12),
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      blurRadius: AppSizes.s24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.s50,
                height: AppSizes.s50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.24),
                      AppColors.primary.withValues(alpha: 0.16),
                    ],
                  ),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.28),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pureWhite,
                  size: AppSizes.s24,
                ),
              ),
              const AppGap(AppSizes.s14, axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const AppGap(AppSizes.s4),
                    AppText(
                      text: subtitle,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w500,
                      ).copyWith(height: 1.35),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const AppGap(AppSizes.s10, axis: Axis.horizontal),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.pureWhite.withValues(alpha: 0.78),
                size: AppSizes.s20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetGlow extends StatelessWidget {
  const _SheetGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.16),
            blurRadius: size * 0.4,
            spreadRadius: size * 0.08,
          ),
        ],
      ),
    );
  }
}
