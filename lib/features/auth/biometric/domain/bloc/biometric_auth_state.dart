import 'package:drip_talk/features/auth/biometric/data/models/biometric_auth_models.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricAuthStatus {
  initial,
  loading,
  ready,
  unavailable,
  authenticating,
  success,
  failure,
}

class BiometricAuthState extends Equatable {
  const BiometricAuthState({
    this.status = BiometricAuthStatus.initial,
    this.availability = const BiometricAvailability(),
    this.isEnabled = false,
    this.hasSavedSession = false,
    this.message,
  });

  final BiometricAuthStatus status;
  final BiometricAvailability availability;
  final bool isEnabled;
  final bool hasSavedSession;
  final String? message;

  bool get canLoginWithBiometrics =>
      availability.isAvailable && isEnabled && hasSavedSession;

  bool get isBusy =>
      status == BiometricAuthStatus.loading ||
      status == BiometricAuthStatus.authenticating;

  bool get prefersFaceId => availability.hasFace;

  List<BiometricType> get availableBiometrics =>
      availability.availableBiometrics;

  BiometricAuthState copyWith({
    BiometricAuthStatus? status,
    BiometricAvailability? availability,
    bool? isEnabled,
    bool? hasSavedSession,
    String? message,
    bool clearMessage = false,
  }) {
    return BiometricAuthState(
      status: status ?? this.status,
      availability: availability ?? this.availability,
      isEnabled: isEnabled ?? this.isEnabled,
      hasSavedSession: hasSavedSession ?? this.hasSavedSession,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    availability,
    isEnabled,
    hasSavedSession,
    message,
  ];
}
