import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/app_back_button.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/features/chat/data/models/chat_attachment.dart';
import 'package:flutter/material.dart';

class AppImagePreview extends StatelessWidget {
  const AppImagePreview({super.key, required this.attachment});

  final ChatAttachment attachment;

  static Future<void> show(BuildContext context, ChatAttachment attachment) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AppImagePreview(attachment: attachment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const AppBackButton(),
        ),
        title: attachment.name != null
            ? AppText(
                text: attachment.name!,
                variant: AppTextVariant.ts16,
                textColor: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              )
            : null,
      ),
      child: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: attachment.id,
            child: _PreviewImage(attachment: attachment),
          ),
        ),
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.attachment});

  final ChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.isLocal && attachment.localPath != null) {
      return Image.file(
        File(attachment.localPath!),
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (attachment.isRemote && attachment.remoteUrl != null) {
      return AppCachedNetworkImage(
        imageUrl: attachment.remoteUrl!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        color: AppColors.pureWhite54,
        size: AppSizes.s48,
      ),
    );
  }
}
