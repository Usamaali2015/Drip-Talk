import 'dart:io';

import 'package:dio/dio.dart';

const String _faceImageField = 'face_image';
const String _dressImageField = 'dress_images[]';

class TryOnGenerateRequestModel {
  const TryOnGenerateRequestModel({
    required this.faceImageFile,
    required this.dressImageUrls,
  });

  final File faceImageFile;
  final List<String> dressImageUrls;

  bool get hasDressImages => dressImageUrls.isNotEmpty;

  Map<String, dynamic> toDebugMap() {
    return <String, dynamic>{
      _faceImageField: faceImageFile.path,
      _dressImageField: dressImageUrls,
    };
  }

  Future<FormData> toFormData(List<File> dressImageFiles) async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        _faceImageField,
        await MultipartFile.fromFile(
          faceImageFile.path,
          filename: _fileName(faceImageFile.path, fallback: 'face_image.jpg'),
        ),
      ),
    );

    for (var index = 0; index < dressImageFiles.length; index++) {
      final file = dressImageFiles[index];
      formData.files.add(
        MapEntry(
          _dressImageField,
          await MultipartFile.fromFile(
            file.path,
            filename: _fileName(file.path, fallback: 'dress_$index.jpg'),
          ),
        ),
      );
    }

    return formData;
  }
}

String _fileName(String path, {required String fallback}) {
  final segments = path.split(Platform.pathSeparator);
  final value = segments.isEmpty ? '' : segments.last.trim();
  return value.isEmpty ? fallback : value;
}
