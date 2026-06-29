import 'package:equatable/equatable.dart';

abstract class ResponsiveEvent extends Equatable {
  const ResponsiveEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatch this from a root [LayoutBuilder] (or [ResponsiveLayout]) to keep
/// the [ResponsiveBloc] in sync with the actual display dimensions.
class ScreenSizeChanged extends ResponsiveEvent {
  const ScreenSizeChanged({required this.width, required this.height});

  final double width;
  final double height;

  @override
  List<Object?> get props => [width, height];
}
