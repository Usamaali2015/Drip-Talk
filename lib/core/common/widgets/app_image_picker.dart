import 'dart:io';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/utils/app_utils/app_picker_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_text.dart';

class AppImagePicker extends StatelessWidget {
  final bool multiple;
  final Function(List<File>) onPicked;

  const AppImagePicker({
    super.key,
    this.multiple = false,
    required this.onPicked,
  });

  void _pick(BuildContext context, ImageSource source) async {
    final files = await AppPickerUtils.pickImages(
      multiple: multiple,
      source: source,
    );
    if (files.isNotEmpty) onPicked(files);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: AppText(
            style: AppTextStyles.ts16(
              context,
              color:  Theme.of(context).colorScheme.onSurface,
            ),
            text: "Camera",
          ),
          onTap: () => _pick(context, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: AppText(
            text: 'Gallery',
            style: AppTextStyles.ts16(
              context,
              color:Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap: () => _pick(context, ImageSource.gallery),
        ),
      ],
    );
  }
}
