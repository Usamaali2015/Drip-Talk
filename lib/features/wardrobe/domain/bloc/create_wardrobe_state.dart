import 'dart:io';

import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:equatable/equatable.dart';

enum CreateWardrobeStatus { initial, submitting, success, failure }

enum CreateWardrobeFeedbackType { success, error, info }

class CreateWardrobeState extends Equatable {
  const CreateWardrobeState({
    this.title = '',
    this.images = const <File>[],
    this.status = CreateWardrobeStatus.initial,
    this.createdWardrobe,
    this.titleErrorMessage,
    this.errorMessage,
    this.feedbackMessage,
    this.feedbackType = CreateWardrobeFeedbackType.info,
  });

  final String title;
  final List<File> images;
  final CreateWardrobeStatus status;
  final WardrobeModel? createdWardrobe;
  final String? titleErrorMessage;
  final String? errorMessage;
  final String? feedbackMessage;
  final CreateWardrobeFeedbackType feedbackType;

  bool get isSubmitting => status == CreateWardrobeStatus.submitting;

  bool get canSubmit => !isSubmitting;

  CreateWardrobeState copyWith({
    String? title,
    List<File>? images,
    CreateWardrobeStatus? status,
    WardrobeModel? createdWardrobe,
    bool clearCreatedWardrobe = false,
    String? titleErrorMessage,
    bool clearTitleErrorMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? feedbackMessage,
    CreateWardrobeFeedbackType? feedbackType,
    bool clearFeedback = false,
  }) {
    return CreateWardrobeState(
      title: title ?? this.title,
      images: images ?? this.images,
      status: status ?? this.status,
      createdWardrobe: clearCreatedWardrobe
          ? null
          : (createdWardrobe ?? this.createdWardrobe),
      titleErrorMessage: clearTitleErrorMessage
          ? null
          : (titleErrorMessage ?? this.titleErrorMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      feedbackMessage: clearFeedback
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      feedbackType: feedbackType ?? this.feedbackType,
    );
  }

  @override
  List<Object?> get props => [
    title,
    images,
    status,
    createdWardrobe,
    titleErrorMessage,
    errorMessage,
    feedbackMessage,
    feedbackType,
  ];
}
