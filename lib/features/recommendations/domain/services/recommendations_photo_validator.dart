import 'dart:io';

import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RecommendationsPhotoValidator {
  RecommendationsPhotoValidator({FaceDetector? faceDetector})
    : _faceDetector =
          faceDetector ??
          FaceDetector(
            options: FaceDetectorOptions(
              performanceMode: FaceDetectorMode.accurate,
              minFaceSize: 0.18,
            ),
          );

  final FaceDetector _faceDetector;

  Future<RecommendationsPhotoValidationResult> validate(File photo) async {
    try {
      final inputImage = InputImage.fromFile(photo);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return RecommendationsPhotoValidationResult.invalid(
          _noFaceDetectedMessage(),
        );
      }

      if (faces.length > 1) {
        return RecommendationsPhotoValidationResult.invalid(
          _multipleFacesDetectedMessage(),
        );
      }

      final face = faces.first;
      if (face.headEulerAngleX == null ||
          face.headEulerAngleY == null ||
          face.headEulerAngleZ == null) {
        return RecommendationsPhotoValidationResult.invalid(
          _photoVerificationFailedMessage(),
        );
      }

      final yaw = face.headEulerAngleY!.abs();
      final pitch = face.headEulerAngleX!.abs();
      final roll = face.headEulerAngleZ!.abs();

      const maxYaw = 12.0;
      const maxPitch = 18.0;
      const maxRoll = 10.0;

      final isFrontFacing =
          yaw <= maxYaw && pitch <= maxPitch && roll <= maxRoll;

      if (!isFrontFacing) {
        return RecommendationsPhotoValidationResult.invalid(
          _sidePoseNotSupportedMessage(),
        );
      }

      return const RecommendationsPhotoValidationResult.valid();
    } catch (_) {
      return RecommendationsPhotoValidationResult.invalid(
        _photoVerificationFailedMessage(),
      );
    }
  }

  Future<void> close() => _faceDetector.close();

  String _noFaceDetectedMessage() => localizedString(
    select: (l10n) => l10n.recommendationsPhotoNoFaceMessage,
  );

  String _multipleFacesDetectedMessage() => localizedString(
    select: (l10n) => l10n.recommendationsPhotoMultipleFacesMessage,
  );

  String _photoVerificationFailedMessage() => localizedString(
    select: (l10n) => l10n.recommendationsPhotoVerificationFailedMessage,
  );

  String _sidePoseNotSupportedMessage() => localizedString(
    select: (l10n) => l10n.recommendationsPhotoSidePoseMessage,
  );
}

class RecommendationsPhotoValidationResult {
  const RecommendationsPhotoValidationResult._({
    required this.isValid,
    this.message,
  });

  const RecommendationsPhotoValidationResult.valid() : this._(isValid: true);

  const RecommendationsPhotoValidationResult.invalid(String message)
    : this._(isValid: false, message: message);

  final bool isValid;
  final String? message;
}
