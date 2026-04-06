import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpTimerStarted extends OtpEvent {}

class OtpTimerTicked extends OtpEvent {
  final int duration;
  OtpTimerTicked(this.duration);

  @override
  List<Object?> get props => [duration];
}

class OtpSubmitted extends OtpEvent {
  final String email;
  final String otp;
  final String type;
  OtpSubmitted({required this.email, required this.otp, required this.type});
  @override
  List<Object?> get props => [email, otp, type];
}

class OtpResent extends OtpEvent {
  final String email;
  final String type;
  OtpResent({required this.email, required this.type});

  @override
  List<Object?> get props => [email, type];
}