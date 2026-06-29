import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();

  @override
  List<Object?> get props => const [];
}

class RecommendationsPhotoSelected extends RecommendationsEvent {
  const RecommendationsPhotoSelected(this.photo);

  final File photo;

  @override
  List<Object?> get props => [photo.path];
}

class RecommendationsFetchRequested extends RecommendationsEvent {
  const RecommendationsFetchRequested();
}

class RecommendationsLiked extends RecommendationsEvent {
  const RecommendationsLiked();
}

class RecommendationsDisliked extends RecommendationsEvent {
  const RecommendationsDisliked();
}

class RecommendationsReviewSkipped extends RecommendationsEvent {
  const RecommendationsReviewSkipped();
}

class RecommendationsRestartRequested extends RecommendationsEvent {
  const RecommendationsRestartRequested();
}

class RecommendationsTryOnRequested extends RecommendationsEvent {
  const RecommendationsTryOnRequested();
}
