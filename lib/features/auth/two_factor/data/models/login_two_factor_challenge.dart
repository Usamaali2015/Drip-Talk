import 'package:equatable/equatable.dart';

class LoginTwoFactorChallenge extends Equatable {
  const LoginTwoFactorChallenge({
    required this.email,
    required this.password,
    required this.twoFactorToken,
  });

  final String email;
  final String password;
  final String twoFactorToken;

  @override
  List<Object?> get props => [email, password, twoFactorToken];
}
