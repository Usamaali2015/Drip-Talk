import 'package:equatable/equatable.dart';
import 'package:drip_talk/features/auth/auth_repository/password_reset_source.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordPasswordChanged extends ResetPasswordEvent {
  final String value;

  const ResetPasswordPasswordChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class ResetPasswordConfirmationChanged extends ResetPasswordEvent {
  final String value;

  const ResetPasswordConfirmationChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String resetToken;
  final PasswordResetSource source;

  const ResetPasswordSubmitted({
    required this.email,
    required this.resetToken,
    this.source = PasswordResetSource.auth,
  });

  @override
  List<Object?> get props => [email, resetToken, source];
}
