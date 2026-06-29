import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class CreateWardrobeRequestModel extends Equatable {
  const CreateWardrobeRequestModel({required this.title, required this.images});

  final String title;
  final List<File> images;

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({'title': title.trim()});

    for (final image in images) {
      formData.files.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }

  @override
  List<Object?> get props => [title, images];
}

class UpdateWardrobeRequestModel extends Equatable {
  const UpdateWardrobeRequestModel({
    this.title,
    this.coverItemId,
    this.images = const <File>[],
    this.deleteItemIds = const <int>[],
  });

  final String? title;
  final int? coverItemId;
  final List<File> images;
  final List<int> deleteItemIds;

  bool get hasChanges =>
      _normalized(title) != null ||
      coverItemId != null ||
      images.isNotEmpty ||
      deleteItemIds.isNotEmpty;

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({'_method': 'PATCH'});

    final normalizedTitle = _normalized(title);
    if (normalizedTitle != null) {
      formData.fields.add(MapEntry('title', normalizedTitle));
    }

    if (coverItemId != null) {
      formData.fields.add(MapEntry('cover_item_id', '$coverItemId'));
    }

    for (final image in images) {
      formData.files.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }

    for (final itemId in deleteItemIds) {
      formData.fields.add(MapEntry('delete_item_ids[]', '$itemId'));
    }

    return formData;
  }

  @override
  List<Object?> get props => [title, coverItemId, images, deleteItemIds];
}

class UpdateWardrobeItemsRequestModel extends Equatable {
  const UpdateWardrobeItemsRequestModel({
    required this.itemIds,
    this.status,
    this.targetWardrobeId,
  });

  final List<int> itemIds;
  final String? status;
  final int? targetWardrobeId;

  FormData toFormData() {
    final formData = FormData.fromMap({'_method': 'PATCH'});

    for (final itemId in itemIds) {
      formData.fields.add(MapEntry('item_ids[]', '$itemId'));
    }

    final normalizedStatus = _normalized(status);
    if (normalizedStatus != null) {
      formData.fields.add(MapEntry('status', normalizedStatus));
    }

    if (targetWardrobeId != null) {
      formData.fields.add(MapEntry('target_wardrobe_id', '$targetWardrobeId'));
    }

    return formData;
  }

  @override
  List<Object?> get props => [itemIds, status, targetWardrobeId];
}

String? _normalized(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}
