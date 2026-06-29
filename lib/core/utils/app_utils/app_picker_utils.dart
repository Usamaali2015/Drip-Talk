import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AppPickerUtils {
  static final ImagePicker _imagePicker = ImagePicker();

  /// 📸 IMAGE PICKER
  static Future<List<File>> pickImages({
    bool multiple = false,
    ImageSource source = ImageSource.gallery,
    int imageQuality = 85,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      if (multiple && source == ImageSource.gallery) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: imageQuality,
        );
        return images.map((e) => File(e.path)).toList();
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
      );

      return image != null ? [File(image.path)] : [];
    } catch (_) {
      return [];
    }
  }
}
