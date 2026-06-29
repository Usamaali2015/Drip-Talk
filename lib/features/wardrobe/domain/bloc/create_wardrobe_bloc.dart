import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/wardrobe/data/models/wardrobe_request_models.dart';
import 'package:drip_talk/features/wardrobe/data/repository/wardrobe_repository.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/create_wardrobe_event.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/create_wardrobe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateWardrobeBloc
    extends Bloc<CreateWardrobeEvent, CreateWardrobeState> {
  CreateWardrobeBloc(this._repository) : super(const CreateWardrobeState()) {
    on<WardrobeTitleChanged>(_onTitleChanged);
    on<WardrobeImagesAdded>(_onImagesAdded);
    on<WardrobeImageRemoved>(_onImageRemoved);
    on<CreateWardrobeSubmitted>(_onSubmitted);
  }

  final WardrobeRepository _repository;

  void _onTitleChanged(
    WardrobeTitleChanged event,
    Emitter<CreateWardrobeState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title,
        status: CreateWardrobeStatus.initial,
        clearTitleErrorMessage: true,
        clearErrorMessage: true,
        clearFeedback: true,
        clearCreatedWardrobe: true,
      ),
    );
  }

  void _onImagesAdded(
    WardrobeImagesAdded event,
    Emitter<CreateWardrobeState> emit,
  ) {
    final dedupedByPath = <String, dynamic>{};
    for (final image in [...state.images, ...event.images]) {
      dedupedByPath[image.path] = image;
    }

    emit(
      state.copyWith(
        images: dedupedByPath.values.cast<File>().toList(),
        status: CreateWardrobeStatus.initial,
        clearTitleErrorMessage: true,
        clearErrorMessage: true,
        clearFeedback: true,
        clearCreatedWardrobe: true,
      ),
    );
  }

  void _onImageRemoved(
    WardrobeImageRemoved event,
    Emitter<CreateWardrobeState> emit,
  ) {
    emit(
      state.copyWith(
        images: state.images
            .where((image) => image.path != event.imagePath)
            .toList(),
        status: CreateWardrobeStatus.initial,
        clearTitleErrorMessage: true,
        clearErrorMessage: true,
        clearFeedback: true,
        clearCreatedWardrobe: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateWardrobeSubmitted event,
    Emitter<CreateWardrobeState> emit,
  ) async {
    final normalizedTitle = state.title.trim();
    if (normalizedTitle.isEmpty) {
      final message = localizedString(
        fallback: 'Wardrobe name is required',
        select: (l10n) => l10n.wardrobeNameRequired,
      );
      emit(
        state.copyWith(
          status: CreateWardrobeStatus.failure,
          titleErrorMessage: message,
          errorMessage: message,
          feedbackMessage: message,
          feedbackType: CreateWardrobeFeedbackType.error,
          clearCreatedWardrobe: true,
        ),
      );
      return;
    }

    if (state.images.isEmpty) {
      final message = localizedString(
        fallback: 'Add at least one dress image',
        select: (l10n) => l10n.wardrobeImageRequired,
      );
      emit(
        state.copyWith(
          status: CreateWardrobeStatus.failure,
          clearTitleErrorMessage: true,
          errorMessage: message,
          feedbackMessage: message,
          feedbackType: CreateWardrobeFeedbackType.error,
          clearCreatedWardrobe: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CreateWardrobeStatus.submitting,
        clearTitleErrorMessage: true,
        clearErrorMessage: true,
        clearFeedback: true,
        clearCreatedWardrobe: true,
      ),
    );

    try {
      final response = await _repository.createWardrobe(
        CreateWardrobeRequestModel(
          title: normalizedTitle,
          images: state.images,
        ),
      );

      emit(
        state.copyWith(
          status: CreateWardrobeStatus.success,
          createdWardrobe: response.firstWardrobe,
          clearTitleErrorMessage: true,
          feedbackMessage: response.message?.trim().isNotEmpty == true
              ? response.message!.trim()
              : localizedString(
                  fallback: 'Wardrobe created successfully',
                  select: (l10n) => l10n.wardrobeCreatedSuccess,
                ),
          feedbackType: CreateWardrobeFeedbackType.success,
        ),
      );
    } catch (error) {
      final message = _resolveErrorMessage(
        error,
        fallback: localizedString(
          fallback: 'Unable to create wardrobe',
          select: (l10n) => l10n.wardrobeCreateFailed,
        ),
      );
      emit(
        state.copyWith(
          status: CreateWardrobeStatus.failure,
          clearTitleErrorMessage: true,
          errorMessage: message,
          feedbackMessage: message,
          feedbackType: CreateWardrobeFeedbackType.error,
          clearCreatedWardrobe: true,
        ),
      );
    }
  }
}

String _resolveErrorMessage(Object error, {required String fallback}) {
  if (error is DioException) {
    final responseMap = _asMap(error.response?.data);
    final message = responseMap?['message']?.toString().trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    final dioMessage = error.message?.trim();
    if (dioMessage != null && dioMessage.isNotEmpty) {
      return dioMessage;
    }
  }

  return fallback;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}
