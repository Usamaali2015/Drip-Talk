import 'dart:io';

import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_update_response_model.dart';
import 'package:equatable/equatable.dart';

enum EditProfileLoadStatus { initial, loading, success, failure }

enum EditProfileSaveStatus { initial, saving, success, failure }

enum EditProfileTwoFactorVerificationStatus {
  initial,
  loading,
  success,
  failure,
}

enum EditProfileNameValidationError { empty }

enum EditProfilePhoneValidationError { invalid }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.loadStatus = EditProfileLoadStatus.initial,
    this.saveStatus = EditProfileSaveStatus.initial,
    this.profile,
    this.defaultAddress,
    this.name = '',
    this.username = '',
    this.phone = '',
    this.countryDialCode = '+1',
    this.selectedGender,
    this.selectedDateOfBirth,
    this.selectedProfileImageFile,
    this.twoFactorEnabled = false,
    this.isTwoFactorProcessing = false,
    this.twoFactorVerificationStatus =
        EditProfileTwoFactorVerificationStatus.initial,
    this.twoFactorSetup,
    this.biometricEnabled = false,
    this.nameValidationError,
    this.phoneValidationError,
    this.loadErrorMessage,
    this.feedbackMessage,
  });

  final EditProfileLoadStatus loadStatus;
  final EditProfileSaveStatus saveStatus;
  final ProfileData? profile;
  final AddressListItem? defaultAddress;
  final String name;
  final String username;
  final String phone;
  final String countryDialCode;
  final String? selectedGender;
  final DateTime? selectedDateOfBirth;
  final File? selectedProfileImageFile;
  final bool twoFactorEnabled;
  final bool isTwoFactorProcessing;
  final EditProfileTwoFactorVerificationStatus twoFactorVerificationStatus;
  final TwoFactorSetupData? twoFactorSetup;
  final bool biometricEnabled;
  final EditProfileNameValidationError? nameValidationError;
  final EditProfilePhoneValidationError? phoneValidationError;
  final String? loadErrorMessage;
  final String? feedbackMessage;

  bool get isInitialLoading =>
      profile == null &&
      (loadStatus == EditProfileLoadStatus.initial ||
          loadStatus == EditProfileLoadStatus.loading);

  bool get isSaving => saveStatus == EditProfileSaveStatus.saving;

  bool get isTwoFactorVerifying =>
      twoFactorVerificationStatus ==
      EditProfileTwoFactorVerificationStatus.loading;

  bool get isTwoFactorBusy => isTwoFactorProcessing || isTwoFactorVerifying;

  bool get effectiveTwoFactorEnabled =>
      twoFactorVerificationStatus ==
          EditProfileTwoFactorVerificationStatus.success
      ? true
      : twoFactorEnabled;

  EditProfileState copyWith({
    EditProfileLoadStatus? loadStatus,
    EditProfileSaveStatus? saveStatus,
    ProfileData? profile,
    String? name,
    String? username,
    String? phone,
    String? countryDialCode,
    Object? selectedGender = _sentinel,
    Object? selectedDateOfBirth = _sentinel,
    Object? selectedProfileImageFile = _sentinel,
    bool? twoFactorEnabled,
    bool? isTwoFactorProcessing,
    EditProfileTwoFactorVerificationStatus? twoFactorVerificationStatus,
    Object? twoFactorSetup = _sentinel,
    bool? biometricEnabled,
    AddressListItem? defaultAddress,
    bool preserveDefaultAddress = true,
    EditProfileNameValidationError? nameValidationError,
    bool clearNameValidationError = false,
    EditProfilePhoneValidationError? phoneValidationError,
    bool clearPhoneValidationError = false,
    String? loadErrorMessage,
    bool clearLoadErrorMessage = false,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return EditProfileState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      profile: profile ?? this.profile,
      defaultAddress: preserveDefaultAddress
          ? (defaultAddress ?? this.defaultAddress)
          : defaultAddress,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      countryDialCode: countryDialCode ?? this.countryDialCode,
      selectedGender: selectedGender == _sentinel
          ? this.selectedGender
          : selectedGender as String?,
      selectedDateOfBirth: selectedDateOfBirth == _sentinel
          ? this.selectedDateOfBirth
          : selectedDateOfBirth as DateTime?,
      selectedProfileImageFile: selectedProfileImageFile == _sentinel
          ? this.selectedProfileImageFile
          : selectedProfileImageFile as File?,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      isTwoFactorProcessing:
          isTwoFactorProcessing ?? this.isTwoFactorProcessing,
      twoFactorVerificationStatus:
          twoFactorVerificationStatus ?? this.twoFactorVerificationStatus,
      twoFactorSetup: twoFactorSetup == _sentinel
          ? this.twoFactorSetup
          : twoFactorSetup as TwoFactorSetupData?,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      nameValidationError: clearNameValidationError
          ? null
          : (nameValidationError ?? this.nameValidationError),
      phoneValidationError: clearPhoneValidationError
          ? null
          : (phoneValidationError ?? this.phoneValidationError),
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    saveStatus,
    profile,
    defaultAddress,
    name,
    username,
    phone,
    countryDialCode,
    selectedGender,
    selectedDateOfBirth,
    selectedProfileImageFile,
    twoFactorEnabled,
    isTwoFactorProcessing,
    twoFactorVerificationStatus,
    twoFactorSetup,
    biometricEnabled,
    nameValidationError,
    phoneValidationError,
    loadErrorMessage,
    feedbackMessage,
  ];
}

const Object _sentinel = Object();
