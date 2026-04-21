import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/dashboard/home/domain/bloc/home_state.dart';
import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<Map<String, dynamic>> _dummyData = [
    {
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=800&auto=format&fit=crop',
      'height': 240.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=800&auto=format&fit=crop',
      'height': 180.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=800&auto=format&fit=crop',
      'height': 300.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1550639525-c97d455acf70?q=80&w=800&auto=format&fit=crop',
      'height': 220.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?q=80&w=800&auto=format&fit=crop',
      'height': 200.0,
    },
    {
      'image':
          'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?q=80&w=800&auto=format&fit=crop',
      'height': 260.0,
    },
  ];

  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>(_onLoadData);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(
      state.copyWith(
        status: HomeStatus.success,
        gridData: List.from(_dummyData),
      ),
    );
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<HomeState> emit,
  ) async {
    if (event.index == state.selectedCategoryIndex) return;
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        selectedCategoryIndex: event.index,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final shuffledData = List<Map<String, dynamic>>.from(_dummyData)..shuffle();
    emit(state.copyWith(status: HomeStatus.success, gridData: shuffledData));
  }
}
