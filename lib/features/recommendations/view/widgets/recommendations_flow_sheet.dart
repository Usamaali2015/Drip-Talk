import 'package:drip_talk/features/recommendations/view/widgets/recommendations_intro_sheet.dart';
import 'package:drip_talk/features/recommendations/view/widgets/recommendations_photo_upload_sheet.dart';
import 'package:flutter/material.dart';

Future<RecommendationsFlowAction?> showRecommendationsFlowSheet(
  BuildContext context, {
  bool showCompletionStep = false,
}) async {
  if (showCompletionStep) {
    final shouldOpenPhotoUpload = await showRecommendationsIntroSheet(context);
    if (!shouldOpenPhotoUpload || !context.mounted) {
      return null;
    }
  }

  return showRecommendationsPhotoUploadSheet(context);
}
