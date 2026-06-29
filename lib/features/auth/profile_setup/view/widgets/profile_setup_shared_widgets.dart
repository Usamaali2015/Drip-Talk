import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/app_picker_utils.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupSelectionField extends StatelessWidget {
  const ProfileSetupSelectionField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.hintText,
    this.errorText,
    this.trailing,
    this.borderRadius = AppRadius.r24,
    this.height = AppSizes.s56,
    this.horizontalPadding = const EdgeInsets.symmetric(
      horizontal: AppSizes.s18,
    ),
    this.labelSpacing = AppSizes.s8,
    this.textStyle,
    this.hintStyle,
  });

  final String label;
  final String? value;
  final String? hintText;
  final String? errorText;
  final Widget? trailing;
  final VoidCallback onTap;
  final double borderRadius;
  final double height;
  final EdgeInsetsGeometry horizontalPadding;
  final double labelSpacing;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle =
        textStyle ??
        AppTextStyles.ts12(
          context,
          color: AppColors.pureBlack,
          fontWeight: FontWeight.w500,
        );
    final resolvedHintStyle =
        hintStyle ??
        AppTextStyles.ts12(
          context,
          color: AppColors.pureBlack.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        );
    final hasValue = value?.trim().isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupFieldLabel(text: label),
        SizedBox(height: labelSpacing),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: height,
            padding: horizontalPadding,
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.secondary, width: 1.1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: hasValue ? value! : (hintText ?? ''),
                    style: hasValue ? resolvedTextStyle : resolvedHintStyle,
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.pureBlack,
                      size: AppSizes.s24,
                    ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSizes.s6),
          ProfileSetupFieldErrorText(message: errorText!),
        ],
      ],
    );
  }
}

class ProfileSetupFieldLabel extends StatelessWidget {
  const ProfileSetupFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      style: AppTextStyles.ts14(
        context,
        color: AppColors.pureWhite,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class ProfileSetupFieldErrorText extends StatelessWidget {
  const ProfileSetupFieldErrorText({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: message,
      style: AppTextStyles.ts12(
        context,
        color: AppColors.materialRedAccent,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class ProfileSetupSheetHeader extends StatelessWidget {
  const ProfileSetupSheetHeader({super.key, this.title, this.onClose});

  final String? title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (title != null && title!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s44),
              child: AppText(
                text: title!,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: AppSizes.s36,
                height: AppSizes.s36,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.pureWhite.withValues(alpha: 0.14),
                  ),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSetupChoiceChipTile extends StatelessWidget {
  const ProfileSetupChoiceChipTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                )
              : null,
          color: selected ? null : AppColors.lightBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.circular),
          border: Border.all(
            color: selected
                ? AppColors.transparent
                : AppColors.secondary.withValues(alpha: 0.82),
          ),
        ),
        child: AppText(
          text: label,
          style: AppTextStyles.ts14(
            context,
            color: selected
                ? AppColors.pureWhite
                : AppColors.pureWhite.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ProfileSetupColorChipTile extends StatelessWidget {
  const ProfileSetupColorChipTile({
    super.key,
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final ProfileSetupColorOption choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSizes.s12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              choice.color.withValues(alpha: 0.34),
              AppColors.lightBg.withValues(alpha: 0.92),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : choice.color.withValues(alpha: 0.7),
            width: selected ? 1.6 : 1.1,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x26FF499E),
                    blurRadius: 22,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: choice.color,
                border: Border.all(
                  color: AppColors.pureWhite.withValues(alpha: 0.78),
                  width: 1.2,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: AppText(
                text: choice.label,
                maxLines: 2,
                style: AppTextStyles.ts12(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0,
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.secondary,
                size: AppSizes.s20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetupInfoCard extends StatelessWidget {
  const ProfileSetupInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.pureWhite,
            ),
          ),
          const SizedBox(width: AppSizes.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: l10n.profileSetupMemoryTitle,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s4),
                AppText(
                  text: l10n.profileSetupMemoryDescription,
                  maxLines: 2,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSetupUploadDropZone extends StatelessWidget {
  const ProfileSetupUploadDropZone({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s38),
        decoration: BoxDecoration(
          color: const Color(0xFF3A173B).withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(AppRadius.r30),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.78),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_upload_rounded,
              size: AppSizes.s40,
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppSizes.s10),
            AppText(
              text: l10n.profileSetupChooseFiles,
              style: AppTextStyles.ts18(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.s4),
            AppText(
              text: l10n.profileSetupChooseFilesHint,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetupCheckTile extends StatelessWidget {
  const ProfileSetupCheckTile({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r6),
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                )
              : null,
          color: selected ? null : AppColors.transparent,
          border: Border.all(
            color: selected ? AppColors.transparent : AppColors.secondary,
          ),
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                size: AppSizes.s16,
                color: AppColors.pureWhite,
              )
            : null,
      ),
    );
  }
}

class ProfileSetupPreviewTile extends StatelessWidget {
  const ProfileSetupPreviewTile.network({super.key, required this.imageUrl})
    : file = null,
      onRemove = null,
      _isPlaceholder = false;

  const ProfileSetupPreviewTile.file({
    super.key,
    required this.file,
    this.onRemove,
  }) : imageUrl = null,
       _isPlaceholder = false;

  const ProfileSetupPreviewTile.placeholder({super.key})
    : imageUrl = null,
      file = null,
      onRemove = null,
      _isPlaceholder = true;

  final String? imageUrl;
  final File? file;
  final VoidCallback? onRemove;
  final bool _isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF35183E),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.82)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isPlaceholder)
              const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.materialGrey400,
                  size: 30,
                ),
              )
            else if (file != null)
              Image.file(file!, fit: BoxFit.cover)
            else if (imageUrl != null)
              AppCachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover),
            if (onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.pureBlack.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: AppSizes.s16,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetupStatusSummaryCard extends StatelessWidget {
  const ProfileSetupStatusSummaryCard({
    super.key,
    required this.savedCount,
    required this.wardrobeCount,
  });

  final int savedCount;
  final int wardrobeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.pureWhite),
          ),
          const SizedBox(width: AppSizes.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: l10n.profileSetupStatusTitle,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.s4),
                AppText(
                  text: l10n.profileSetupStatusSummary(
                    savedCount,
                    wardrobeCount,
                  ),
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSetupUploadPickerSheet extends StatelessWidget {
  const ProfileSetupUploadPickerSheet({super.key, required this.onPicked});

  final ValueChanged<List<File>> onPicked;

  Future<void> _pickImages(BuildContext context, ImageSource source) async {
    final files = await AppPickerUtils.pickImages(
      multiple: true,
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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D1747), Color(0xFF1A1230)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.pureWhite.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(AppRadius.circular),
            ),
          ),
          const AppGap(AppSizes.s14),
          ProfileSetupSheetHeader(title: l10n.profileSetupStepPhotosLabel),
          const AppGap(AppSizes.s8),
          AppText(
            text: l10n.profileSetupChooseFilesHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const AppGap(AppSizes.s18),
          _ProfileSetupUploadActionTile(
            icon: Icons.photo_library_rounded,
            title: l10n.editProfilePhotoGalleryAction,
            subtitle: l10n.profileSetupChooseFiles,
            highlighted: true,
            onTap: () => _pickImages(context, ImageSource.gallery),
          ),
          const AppGap(AppSizes.s12),
          _ProfileSetupUploadActionTile(
            icon: Icons.photo_camera_rounded,
            title: l10n.editProfilePhotoCameraAction,
            subtitle: l10n.profileSetupStepPhotosSubtitle,
            highlighted: false,
            onTap: () => _pickImages(context, ImageSource.camera),
          ),
        ],
      ),
    );
  }
}

class _ProfileSetupUploadActionTile extends StatelessWidget {
  const _ProfileSetupUploadActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.highlighted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = highlighted
        ? AppColors.transparent
        : AppColors.secondary.withValues(alpha: 0.4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r24),
      child: Ink(
        decoration: BoxDecoration(
          gradient: highlighted
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.pureWhite.withValues(alpha: 0.08),
                    AppColors.pureWhite.withValues(alpha: 0.03),
                  ],
                ),
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(color: borderColor),
          boxShadow: highlighted
              ? const [
                  BoxShadow(
                    color: Color(0x33FF499E),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s18,
            vertical: AppSizes.s16,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.s50,
                height: AppSizes.s50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: highlighted
                      ? AppColors.pureWhite.withValues(alpha: 0.18)
                      : AppColors.secondary.withValues(alpha: 0.14),
                  border: Border.all(
                    color: highlighted
                        ? AppColors.pureWhite.withValues(alpha: 0.18)
                        : AppColors.secondary.withValues(alpha: 0.32),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pureWhite,
                  size: AppSizes.s24,
                ),
              ),
              const SizedBox(width: AppSizes.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    AppText(
                      text: subtitle,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.pureWhite.withValues(alpha: 0.86),
                size: AppSizes.s16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSetupSeeMoreTile extends StatelessWidget {
  const ProfileSetupSeeMoreTile({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.circular),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.72),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_rounded,
              color: AppColors.secondary,
              size: AppSizes.s18,
            ),
            const SizedBox(width: AppSizes.s8),
            AppText(
              text: label,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
