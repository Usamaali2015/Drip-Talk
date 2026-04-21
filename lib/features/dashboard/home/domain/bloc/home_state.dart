import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success }

class HomeState extends Equatable {
  final HomeStatus status;
  final int selectedCategoryIndex;
  final List<Map<String, dynamic>> gridData;

  const HomeState({
    this.status = HomeStatus.initial,
    this.selectedCategoryIndex = 0,
    this.gridData = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    int? selectedCategoryIndex,
    List<Map<String, dynamic>>? gridData,
  }) {
    return HomeState(
      status: status ?? this.status,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      gridData: gridData ?? this.gridData,
    );
  }

  @override
  List<Object?> get props => [status, selectedCategoryIndex, gridData];
}
