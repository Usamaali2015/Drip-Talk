import 'package:bloc/bloc.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState(0)) {
    on<OnboardingPageChanged>(
      (event, emit) => emit(OnboardingState(event.index)),
    );
  }
}
