import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:drip_talk/features/permission/domain/utils/permission_guard.dart';

class AppPickerUtils {
  static final ImagePicker _imagePicker = ImagePicker();

  /// 📸 IMAGE PICKER
  static Future<List<File>> pickImages({
    required BuildContext context,
    bool multiple = false,
    ImageSource source = ImageSource.gallery,
    int imageQuality = 85,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    // 1. Determine permission to request
    final Permission? permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (Platform.isAndroid) {
        if (PermissionGuard.getAndroidSdk() >= 33) {
          // Android 13+ uses system Photo Picker (no runtime permission needed)
          // and READ_MEDIA_IMAGES is removed from manifest.
          permission = null;
        } else {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.photos;
      }
    }

    // 2. Perform permission guard check if needed
    if (permission != null) {
      final granted = await PermissionGuard.request(context, permission);
      if (!granted) {
        return [];
      }
    }

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

