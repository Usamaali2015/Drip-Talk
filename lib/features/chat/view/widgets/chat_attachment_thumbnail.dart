import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_item_status.dart';
import 'package:flutter/material.dart';

class ChatAttachmentThumbnail extends StatelessWidget {
  const ChatAttachmentThumbnail({
    super.key,
    required this.attachment,
    this.size = AppSizes.s96,
    this.onRemove,
  });

  final ChatAttachment attachment;
  final double size;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.r16);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.chatBubbleBackground,
                borderRadius: borderRadius,
                border: Border.all(color: AppColors.pureWhite12),
              ),
              child: GestureDetector(
                onTap: () => AppImagePreview.show(context, attachment),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Hero(
                    tag: attachment.id,
                    child: _AttachmentImage(attachment: attachment),
                  ),
                ),
              ),
            ),
          ),
          if (attachment.status == wardrobeItemStatusInWardrobe)
            Positioned(
              bottom: AppSizes.s6,
              left: AppSizes.s6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: AppSizes.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pureBlack.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.checkroom_rounded,
                      size: AppSizes.s12,
                      color: AppColors.pureWhite,
                    ),
                    const AppGap(AppSizes.s4, axis: Axis.horizontal),
                    AppText(
                      text: 'In wardrobe',
                      variant: AppTextVariant.ts10,
                      textColor: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
          if (onRemove != null)
            Positioned(
              top: AppSizes.s6,
              right: AppSizes.s6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: AppSizes.s24,
                  height: AppSizes.s24,
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(AppRadius.circular),
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
    );
  }
}

class _AttachmentImage extends StatelessWidget {
  const _AttachmentImage({required this.attachment});

  final ChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.isLocal && attachment.localPath != null) {
      return Image.file(
        File(attachment.localPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const _AttachmentPlaceholder(),
      );
    }

    if (attachment.isRemote && attachment.remoteUrl != null) {
      return AppCachedNetworkImage(
        imageUrl: attachment.remoteUrl!,
        fit: BoxFit.cover,
        placeholder: const _AttachmentPlaceholder(),
        errorWidget: const _AttachmentPlaceholder(),
      );
    }

    return const _AttachmentPlaceholder();
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  const _AttachmentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.chatBubbleBackground,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.pureWhite54,
        size: AppSizes.s28,
      ),
    );
  }
}
