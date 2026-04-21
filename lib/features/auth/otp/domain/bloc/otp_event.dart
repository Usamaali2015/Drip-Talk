import 'package:drip_talk/features/auth/auth_repository/auth_otp_purpose.dart';
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
  final AuthOtpPurpose purpose;

  OtpSubmitted({required this.email, required this.otp, required this.purpose});

  @override
  List<Object?> get props => [email, otp, purpose];
}

class OtpResent extends OtpEvent {
  final String email;
  final AuthOtpPurpose purpose;

  OtpResent({required this.email, required this.purpose});

  @override
  List<Object?> get props => [email, purpose];
}
