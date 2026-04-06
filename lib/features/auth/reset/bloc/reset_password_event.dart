import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String resetToken;
  final String password;
  final String passwordConfirmation;

  ResetPasswordSubmitted({
    required this.email,
    required this.resetToken,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, resetToken, password, passwordConfirmation];
}