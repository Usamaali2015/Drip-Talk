import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CreateWardrobeEvent extends Equatable {
  const CreateWardrobeEvent();

  @override
  List<Object?> get props => const [];
}

class WardrobeTitleChanged extends CreateWardrobeEvent {
  const WardrobeTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class WardrobeImagesAdded extends CreateWardrobeEvent {
  const WardrobeImagesAdded(this.images);

  final List<File> images;

  @override
  List<Object?> get props => [images];
}

class WardrobeImageRemoved extends CreateWardrobeEvent {
  const WardrobeImageRemoved(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class CreateWardrobeSubmitted extends CreateWardrobeEvent {
  const CreateWardrobeSubmitted();
}
