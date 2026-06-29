import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:equatable/equatable.dart';

abstract class WardrobeListEvent extends Equatable {
  const WardrobeListEvent();

  @override
  List<Object?> get props => const [];
}

class LoadWardrobesRequested extends WardrobeListEvent {
  const LoadWardrobesRequested({this.showLoader = true});

  final bool showLoader;

  @override
  List<Object?> get props => [showLoader];
}

class DeleteWardrobeFromListRequested extends WardrobeListEvent {
  const DeleteWardrobeFromListRequested(this.wardrobe);

  final WardrobeModel wardrobe;

  @override
  List<Object?> get props => [wardrobe];
}
