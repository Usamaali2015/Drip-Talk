import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? message;

  LoginSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class LoginVerificationRequired extends LoginState {
  final String email;
  final String? message;

  LoginVerificationRequired({required this.email, this.message});

  @override
  List<Object?> get props => [email, message];
}

class LogoutSuccess extends LoginState {
  final String? message;

  LogoutSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteAccountLoading extends LoginState {}

class DeleteAccountSuccess extends LoginState {
  final String? message;

  DeleteAccountSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteAccountError extends LoginState {
  final String message;

  DeleteAccountError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
