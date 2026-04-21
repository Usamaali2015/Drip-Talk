import 'package:equatable/equatable.dart';

class ForgotPasswordSubmitted extends Equatable {
  final String email;
  const ForgotPasswordSubmitted(this.email);
  @override
  List<Object?> get props => [email];
}
