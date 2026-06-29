import 'package:equatable/equatable.dart';

abstract class BiometricAuthEvent extends Equatable {
  const BiometricAuthEvent();

  @override
  List<Object?> get props => const [];
}

class InitializeBiometricAuthRequested extends BiometricAuthEvent {
  const InitializeBiometricAuthRequested();
}

class BiometricLoginRequested extends BiometricAuthEvent {
  const BiometricLoginRequested();
}
