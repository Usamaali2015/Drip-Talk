import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => const [];
}

class LoadEditProfileRequested extends EditProfileEvent {
  const LoadEditProfileRequested({
    this.showLoader = true,
    this.preserveFormValues = false,
  });

  final bool showLoader;
  final bool preserveFormValues;

  @override
  List<Object?> get props => [showLoader, preserveFormValues];
}

class EditProfileNameChanged extends EditProfileEvent {
  const EditProfileNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditProfileUsernameChanged extends EditProfileEvent {
  const EditProfileUsernameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditProfilePhoneChanged extends EditProfileEvent {
  const EditProfilePhoneChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditProfileCountryDialCodeChanged extends EditProfileEvent {
  const EditProfileCountryDialCodeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditProfileDateOfBirthChanged extends EditProfileEvent {
  const EditProfileDateOfBirthChanged(this.value);

  final DateTime? value;

  @override
  List<Object?> get props => [value];
}

class EditProfileGenderChanged extends EditProfileEvent {
  const EditProfileGenderChanged(this.value);

  final String? value;

  @override
  List<Object?> get props => [value];
}

class EditProfileImageChanged extends EditProfileEvent {
  const EditProfileImageChanged(this.value);

  final File? value;

  @override
  List<Object?> get props => [value];
}

class EditProfileTwoFactorChanged extends EditProfileEvent {
  const EditProfileTwoFactorChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class EditProfileBiometricChanged extends EditProfileEvent {
  const EditProfileBiometricChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class VerifyEditProfileTwoFactorRequested extends EditProfileEvent {
  const VerifyEditProfileTwoFactorRequested(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class DismissEditProfileTwoFactorSetupRequested extends EditProfileEvent {
  const DismissEditProfileTwoFactorSetupRequested();
}

class SaveEditProfileRequested extends EditProfileEvent {
  const SaveEditProfileRequested();
}
