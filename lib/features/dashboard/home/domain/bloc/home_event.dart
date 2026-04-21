import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class SelectCategory extends HomeEvent {
  final int index;
  SelectCategory(this.index);

  @override
  List<Object?> get props => [index];
}
