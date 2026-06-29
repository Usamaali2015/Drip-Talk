import 'package:drip_talk/features/auth/two_factor/data/models/login_two_factor_challenge.dart';
import 'package:equatable/equatable.dart';

abstract class TwoFactorLoginEvent extends Equatable {
  const TwoFactorLoginEvent();

  @override
  List<Object?> get props => const [];
}

class TwoFactorLoginCodeChanged extends TwoFactorLoginEvent {
  const TwoFactorLoginCodeChanged(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class TwoFactorLoginSubmitted extends TwoFactorLoginEvent {
  const TwoFactorLoginSubmitted(this.challenge);

  final LoginTwoFactorChallenge challenge;

  @override
  List<Object?> get props => [challenge];
}
