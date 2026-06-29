import 'dart:io';

import 'package:drip_talk/features/wardrobe/data/models/wardrobe_model.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_state.dart';
import 'package:equatable/equatable.dart';

abstract class WardrobeDetailsEvent extends Equatable {
  const WardrobeDetailsEvent();

  @override
  List<Object?> get props => const [];
}

class LoadWardrobeDetailsRequested extends WardrobeDetailsEvent {
  const LoadWardrobeDetailsRequested({
    required this.wardrobeId,
    this.initialWardrobe,
    this.showLoader = true,
  });

  final int wardrobeId;
  final WardrobeModel? initialWardrobe;
  final bool showLoader;

  @override
  List<Object?> get props => [wardrobeId, initialWardrobe, showLoader];
}

class WardrobeFilterChanged extends WardrobeDetailsEvent {
  const WardrobeFilterChanged(this.filter);

  final WardrobeItemFilter filter;

  @override
  List<Object?> get props => [filter];
}

class WardrobeItemSelectionToggled extends WardrobeDetailsEvent {
  const WardrobeItemSelectionToggled(this.itemId);

  final int itemId;

  @override
  List<Object?> get props => [itemId];
}

class WardrobeVisibleSelectionToggled extends WardrobeDetailsEvent {
  const WardrobeVisibleSelectionToggled();
}

class WardrobeSelectionCleared extends WardrobeDetailsEvent {
  const WardrobeSelectionCleared();
}

class WardrobeSelectedItemsStatusUpdateRequested extends WardrobeDetailsEvent {
  const WardrobeSelectedItemsStatusUpdateRequested({
    required this.status,
    required this.action,
    this.targetWardrobeId,
  });

  final String status;
  final WardrobeSelectedItemsAction action;
  final int? targetWardrobeId;

  @override
  List<Object?> get props => [status, action, targetWardrobeId];
}

class DeleteSelectedWardrobeItemsRequested extends WardrobeDetailsEvent {
  const DeleteSelectedWardrobeItemsRequested();
}

class RenameWardrobeRequested extends WardrobeDetailsEvent {
  const RenameWardrobeRequested(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class AddWardrobeImagesRequested extends WardrobeDetailsEvent {
  const AddWardrobeImagesRequested(this.images);

  final List<File> images;

  @override
  List<Object?> get props => [images];
}

class SetWardrobeCoverRequested extends WardrobeDetailsEvent {
  const SetWardrobeCoverRequested(this.itemId);

  final int itemId;

  @override
  List<Object?> get props => [itemId];
}

class DeleteWardrobeRequested extends WardrobeDetailsEvent {
  const DeleteWardrobeRequested();
}
