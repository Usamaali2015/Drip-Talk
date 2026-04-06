import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {
  final String email;
  final bool requiresOtpVerification;
  final String? message;

  SignUpSuccess({
    required this.email,
    required this.requiresOtpVerification,
    this.message,
  });

  @override
  List<Object?> get props => [email, requiresOtpVerification, message];
}

class SignUpError extends SignUpState {
  final String message;
  SignUpError(this.message);
  @override
  List<Object?> get props => [message];
}
