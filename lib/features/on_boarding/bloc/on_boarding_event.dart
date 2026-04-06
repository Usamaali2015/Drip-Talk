part of 'on_boarding_bloc.dart';


abstract class OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int index;
  OnboardingPageChanged(this.index);
}