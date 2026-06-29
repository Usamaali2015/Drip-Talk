import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/services/ip_country/ip_country_service.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:drip_talk/features/address/data/repository/address_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_update_response_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/update_profile_request_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/repository/profile_repository.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_event.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(
    this._profileRepository,
    this._addressRepository,
    this._biometricAuthRepository,
    this._authSessionRepository,
    this._dioClient,
  ) : super(const EditProfileState()) {
    on<LoadEditProfileRequested>(_onLoadEditProfileRequested);
    on<EditProfileNameChanged>(_onNameChanged);
    on<EditProfileUsernameChanged>(_onUsernameChanged);
    on<EditProfilePhoneChanged>(_onPhoneChanged);
    on<EditProfileCountryDialCodeChanged>(_onCountryDialCodeChanged);
    on<EditProfileDateOfBirthChanged>(_onDateOfBirthChanged);
    on<EditProfileGenderChanged>(_onGenderChanged);
    on<EditProfileImageChanged>(_onImageChanged);
    on<EditProfileTwoFactorChanged>(_onTwoFactorChanged);
    on<EditProfileBiometricChanged>(_onBiometricChanged);
    on<VerifyEditProfileTwoFactorRequested>(_onVerifyTwoFactorRequested);
    on<DismissEditProfileTwoFactorSetupRequested>(
      _onDismissTwoFactorSetupRequested,
    );
    on<SaveEditProfileRequested>(_onSaveEditProfileRequested);
  }

  final ProfileRepository _profileRepository;
  final AddressRepository _addressRepository;
  final BiometricAuthRepository _biometricAuthRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;

  Future<void> _onLoadEditProfileRequested(
    LoadEditProfileRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    final cachedProfile = await _getStoredProfile();
    final storedTwoFactorEnabled = await _getStoredTwoFactorEnabled();
    final biometricEnabled = await _biometricAuthRepository
        .isBiometricLoginEnabled();
    final defaultDialCode = await IpCountryService.instance.resolveDialCode();
    await _ensureAuthenticatedRequestContext();

    if (!event.preserveFormValues &&
        state.profile == null &&
        cachedProfile != null &&
        !cachedProfile.isEmpty) {
      emit(
        _buildPopulatedState(
          profile: cachedProfile,
          defaultAddress: state.defaultAddress,
          biometricEnabled: biometricEnabled,
          twoFactorEnabled:
              cachedProfile.googleTwoFactorEnabled ?? storedTwoFactorEnabled,
          defaultDialCode: defaultDialCode,
        ),
      );
    }

    emit(
      state.copyWith(
        loadStatus: event.showLoader || state.profile == null
            ? EditProfileLoadStatus.loading
            : state.loadStatus,
        saveStatus: EditProfileSaveStatus.initial,
        clearLoadErrorMessage: true,
        clearFeedbackMessage: true,
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final profileResponse = await _profileRepository.getProfile();
      final profile = profileResponse.data;
      if (!profileResponse.isSuccessful || profile == null || profile.isEmpty) {
        emit(
          state.copyWith(
            loadStatus: state.profile == null
                ? EditProfileLoadStatus.failure
                : EditProfileLoadStatus.success,
            loadErrorMessage:
                profileResponse.message ??
                localizedString(
                  fallback: 'Unable to load profile',
                  select: (l10n) => l10n.editProfileLoadFailed,
                ),
            preserveDefaultAddress: false,
          ),
        );
        return;
      }

      AddressListItem? defaultAddress;
      try {
        final addressesResponse = await _addressRepository.getAddresses();
        defaultAddress = _resolveDefaultAddress(addressesResponse.data);
      } catch (_) {
        defaultAddress = state.defaultAddress;
      }

      _logTwoFactorState(
        'profile_load',
        profile.googleTwoFactorEnabled ?? storedTwoFactorEnabled,
      );

      emit(
        event.preserveFormValues && state.profile != null
            ? state.copyWith(
                loadStatus: EditProfileLoadStatus.success,
                saveStatus: EditProfileSaveStatus.initial,
                profile: profile,
                defaultAddress: defaultAddress,
                preserveDefaultAddress: false,
                twoFactorEnabled:
                    profile.googleTwoFactorEnabled ??
                    storedTwoFactorEnabled ??
                    state.twoFactorEnabled,
                isTwoFactorProcessing: false,
                twoFactorVerificationStatus:
                    EditProfileTwoFactorVerificationStatus.initial,
                twoFactorSetup: null,
                biometricEnabled: biometricEnabled,
                clearLoadErrorMessage: true,
              )
            : _buildPopulatedState(
                profile: profile,
                defaultAddress: defaultAddress,
                biometricEnabled: biometricEnabled,
                twoFactorEnabled:
                    profile.googleTwoFactorEnabled ?? storedTwoFactorEnabled,
                defaultDialCode: defaultDialCode,
              ),
      );
    } catch (error) {
      if (state.profile != null && !(state.profile?.isEmpty ?? true)) {
        emit(
          state.copyWith(
            loadStatus: EditProfileLoadStatus.success,
            loadErrorMessage: _resolveLoadErrorMessage(error),
            preserveDefaultAddress: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          loadStatus: EditProfileLoadStatus.failure,
          loadErrorMessage: _resolveLoadErrorMessage(error),
          preserveDefaultAddress: false,
        ),
      );
    }
  }

  void _onNameChanged(
    EditProfileNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.value,
        clearNameValidationError: true,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onUsernameChanged(
    EditProfileUsernameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        username: event.value,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onPhoneChanged(
    EditProfilePhoneChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        phone: event.value,
        clearPhoneValidationError: true,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onCountryDialCodeChanged(
    EditProfileCountryDialCodeChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        countryDialCode: event.value,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onDateOfBirthChanged(
    EditProfileDateOfBirthChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        selectedDateOfBirth: event.value,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onGenderChanged(
    EditProfileGenderChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        selectedGender: event.value,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  void _onImageChanged(
    EditProfileImageChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProfileImageFile: event.value,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  Future<void> _onTwoFactorChanged(
    EditProfileTwoFactorChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isSaving || state.isTwoFactorBusy) {
      return;
    }

    final previousValue = state.twoFactorEnabled;
    if (event.value == previousValue) {
      return;
    }

    final currentProfile = state.profile;
    if (currentProfile == null || currentProfile.isEmpty) {
      emit(
        state.copyWith(
          feedbackMessage: localizedString(
            fallback:
                'Load your profile before updating two-factor authentication.',
            select: (l10n) => l10n.editProfileLoadBeforeTwoFactorUpdate,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        twoFactorEnabled: event.value,
        isTwoFactorProcessing: true,
        twoFactorVerificationStatus:
            EditProfileTwoFactorVerificationStatus.initial,
        twoFactorSetup: null,
        clearFeedbackMessage: true,
      ),
    );
    _logTwoFactorState('toggle_requested', event.value);

    try {
      await _ensureAuthenticatedRequestContext();
      final updateResponse = await _profileRepository.updateProfile(
        _buildTwoFactorUpdateRequest(event.value),
      );
      final resolvedProfile = await _resolveLatestProfile(
        updateResponse.user ?? currentProfile,
      );
      final nextProfile = resolvedProfile ?? currentProfile;
      final setup = updateResponse.twoFactorSetup;

      await _syncAuthenticatedProfileSession(
        nextProfile,
        twoFactorEnabledOverride: event.value,
      );
      _logTwoFactorState('toggle_response', event.value);

      if (event.value && setup != null && !setup.isEmpty) {
        emit(
          _buildPopulatedState(
            profile: nextProfile,
            defaultAddress: state.defaultAddress,
            biometricEnabled: state.biometricEnabled,
            twoFactorEnabled: true,
            twoFactorSetup: setup,
          ),
        );
        return;
      }

      emit(
        _buildPopulatedState(
          profile: nextProfile,
          defaultAddress: state.defaultAddress,
          biometricEnabled: state.biometricEnabled,
          twoFactorEnabled: event.value,
          feedbackMessage:
              updateResponse.message ??
              (event.value
                  ? localizedString(
                      fallback:
                          'Two-factor authentication enabled successfully.',
                      select: (l10n) => l10n.editProfileTwoFactorEnabledSuccess,
                    )
                  : localizedString(
                      fallback:
                          'Two-factor authentication disabled successfully.',
                      select: (l10n) =>
                          l10n.editProfileTwoFactorDisabledSuccess,
                    )),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          twoFactorEnabled: previousValue,
          isTwoFactorProcessing: false,
          twoFactorVerificationStatus:
              EditProfileTwoFactorVerificationStatus.initial,
          twoFactorSetup: null,
          feedbackMessage: _resolveSaveErrorMessage(error),
        ),
      );
    }
  }

  void _onBiometricChanged(
    EditProfileBiometricChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    final result = await _syncBiometricPreference(event.value);
    emit(
      state.copyWith(
        biometricEnabled: result.enabled,
        feedbackMessage: result.message,
        saveStatus: EditProfileSaveStatus.initial,
      ),
    );
  }

  Future<void> _onVerifyTwoFactorRequested(
    VerifyEditProfileTwoFactorRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isTwoFactorVerifying) {
      return;
    }

    final normalizedCode = event.code.trim();
    if (normalizedCode.length != 6) {
      emit(
        state.copyWith(
          twoFactorVerificationStatus:
              EditProfileTwoFactorVerificationStatus.failure,
          feedbackMessage: localizedString(
            fallback: 'Enter the 6-digit code from your authenticator app.',
            select: (l10n) => l10n.twoFactorEnterAuthenticatorCode,
          ),
        ),
      );
      return;
    }

    final currentProfile = state.profile;
    if (currentProfile == null || currentProfile.isEmpty) {
      emit(
        state.copyWith(
          twoFactorVerificationStatus:
              EditProfileTwoFactorVerificationStatus.failure,
          feedbackMessage: localizedString(
            fallback:
                'Load your profile before verifying two-factor authentication.',
            select: (l10n) => l10n.editProfileLoadBeforeTwoFactorVerify,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        twoFactorVerificationStatus:
            EditProfileTwoFactorVerificationStatus.loading,
        clearFeedbackMessage: true,
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final verifyRequest = _buildTwoFactorUpdateRequest(
        true,
        googleTwoFactorCode: normalizedCode,
      );
      _debugLog('2FA verify request submitted.');
      final verifyResponse = await _profileRepository.updateProfile(
        verifyRequest,
      );
      final resolvedProfile = await _resolveLatestProfile(
        verifyResponse.user ?? currentProfile,
      );
      final nextProfile = resolvedProfile ?? currentProfile;

      await _syncAuthenticatedProfileSession(
        nextProfile,
        twoFactorEnabledOverride: true,
        source: 'verify_enable',
      );
      _logTwoFactorState('verify_success', true);

      emit(
        _buildPopulatedState(
          profile: nextProfile,
          defaultAddress: state.defaultAddress,
          biometricEnabled: state.biometricEnabled,
          twoFactorEnabled: true,
          twoFactorVerificationStatus:
              EditProfileTwoFactorVerificationStatus.success,
          feedbackMessage:
              verifyResponse.message ??
              localizedString(
                fallback: 'Two-factor authentication enabled successfully.',
                select: (l10n) => l10n.editProfileTwoFactorEnabledSuccess,
              ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          twoFactorVerificationStatus:
              EditProfileTwoFactorVerificationStatus.failure,
          feedbackMessage: _resolveSaveErrorMessage(error),
        ),
      );
    }
  }

  void _onDismissTwoFactorSetupRequested(
    DismissEditProfileTwoFactorSetupRequested event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        twoFactorEnabled: false,
        isTwoFactorProcessing: false,
        twoFactorVerificationStatus:
            EditProfileTwoFactorVerificationStatus.initial,
        twoFactorSetup: null,
        clearFeedbackMessage: true,
      ),
    );
  }

  Future<void> _onSaveEditProfileRequested(
    SaveEditProfileRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.isSaving || state.isTwoFactorBusy) {
      return;
    }

    final normalizedName = state.name.trim();
    final normalizedUsername = state.username.trim().replaceFirst(
      RegExp(r'^@+'),
      '',
    );
    final normalizedPhone = state.phone.trim();
    final nameValidationError = normalizedName.isEmpty
        ? EditProfileNameValidationError.empty
        : null;
    final phoneValidationError =
        normalizedPhone.isNotEmpty && _digitsOnly(normalizedPhone).length < 7
        ? EditProfilePhoneValidationError.invalid
        : null;

    if (nameValidationError != null || phoneValidationError != null) {
      emit(
        state.copyWith(
          saveStatus: EditProfileSaveStatus.initial,
          nameValidationError: nameValidationError,
          clearNameValidationError: nameValidationError == null,
          phoneValidationError: phoneValidationError,
          clearPhoneValidationError: phoneValidationError == null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        saveStatus: EditProfileSaveStatus.saving,
        clearFeedbackMessage: true,
        clearNameValidationError: true,
        clearPhoneValidationError: true,
      ),
    );

    final request = UpdateProfileRequestModel(
      name: normalizedName,
      username: normalizedUsername.isEmpty ? null : normalizedUsername,
      phone: normalizedPhone.isEmpty
          ? null
          : '${state.countryDialCode}${_digitsOnly(normalizedPhone)}',
      gender: state.selectedGender,
      dateOfBirth: state.selectedDateOfBirth == null
          ? null
          : DateFormat('yyyy-MM-dd').format(state.selectedDateOfBirth!),
      profileImageFile: state.selectedProfileImageFile,
      enabledBiometric: state.biometricEnabled,
    );

    try {
      await _ensureAuthenticatedRequestContext();
      _debugLog('Edit profile update request submitted.');
      final updateResponse = await _profileRepository.updateProfile(request);
      final latestProfileResponse = await _profileRepository.getProfile();
      final latestProfile = latestProfileResponse.data ?? state.profile;

      if (latestProfile != null) {
        await _syncAuthenticatedProfileSession(
          latestProfile,
          twoFactorEnabledOverride:
              latestProfile.googleTwoFactorEnabled ??
              state.effectiveTwoFactorEnabled,
          source: 'profile_save',
        );
      }

      emit(
        latestProfile == null
            ? state.copyWith(
                loadStatus: EditProfileLoadStatus.success,
                saveStatus: updateResponse.isSuccessful
                    ? EditProfileSaveStatus.success
                    : EditProfileSaveStatus.failure,
                feedbackMessage:
                    updateResponse.message ??
                    localizedString(
                      fallback: 'Profile updated successfully',
                      select: (l10n) => l10n.editProfileSavedSuccess,
                    ),
              )
            : _buildPopulatedState(
                profile: latestProfile,
                defaultAddress: state.defaultAddress,
                biometricEnabled: state.biometricEnabled,
                twoFactorEnabled:
                    latestProfile.googleTwoFactorEnabled ??
                    state.effectiveTwoFactorEnabled,
                saveStatus: updateResponse.isSuccessful
                    ? EditProfileSaveStatus.success
                    : EditProfileSaveStatus.failure,
                feedbackMessage:
                    updateResponse.message ??
                    localizedString(
                      fallback: 'Profile updated successfully',
                      select: (l10n) => l10n.editProfileSavedSuccess,
                    ),
              ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          saveStatus: EditProfileSaveStatus.failure,
          feedbackMessage: _resolveSaveErrorMessage(error),
        ),
      );
    }
  }

  EditProfileState _buildPopulatedState({
    required ProfileData profile,
    required AddressListItem? defaultAddress,
    required bool biometricEnabled,
    bool? twoFactorEnabled,
    TwoFactorSetupData? twoFactorSetup,
    EditProfileTwoFactorVerificationStatus twoFactorVerificationStatus =
        EditProfileTwoFactorVerificationStatus.initial,
    EditProfileSaveStatus saveStatus = EditProfileSaveStatus.initial,
    String? feedbackMessage,
    String? defaultDialCode,
  }) {
    final phoneParts = _splitPhoneNumber(
      profile.phone,
      fallbackDialCode: defaultDialCode,
    );
    final normalizedGender = profile.gender?.trim().toLowerCase();

    return state.copyWith(
      loadStatus: EditProfileLoadStatus.success,
      saveStatus: saveStatus,
      profile: profile,
      defaultAddress: defaultAddress,
      preserveDefaultAddress: false,
      name: profile.displayName,
      username: profile.editableUsername,
      phone: phoneParts.localNumber,
      countryDialCode: phoneParts.dialCode,
      selectedGender: normalizedGender == null || normalizedGender.isEmpty
          ? null
          : normalizedGender,
      selectedDateOfBirth: profile.dateOfBirth,
      selectedProfileImageFile: null,
      twoFactorEnabled:
          twoFactorEnabled ?? profile.googleTwoFactorEnabled ?? false,
      isTwoFactorProcessing: false,
      twoFactorVerificationStatus: twoFactorVerificationStatus,
      twoFactorSetup: twoFactorSetup,
      biometricEnabled: biometricEnabled,
      clearNameValidationError: true,
      clearPhoneValidationError: true,
      clearLoadErrorMessage: true,
      feedbackMessage: feedbackMessage,
      clearFeedbackMessage: feedbackMessage == null,
    );
  }

  UpdateProfileRequestModel _buildTwoFactorUpdateRequest(
    bool enabled, {
    String? googleTwoFactorCode,
  }) {
    final profile = state.profile;
    final safeProfile = profile ?? ProfileData.nullProfile;

    return UpdateProfileRequestModel(
      name: safeProfile.displayName,
      username: safeProfile.editableUsername,
      phone: safeProfile.phone,
      gender: safeProfile.gender,
      dateOfBirth: safeProfile.dateOfBirth == null
          ? null
          : DateFormat('yyyy-MM-dd').format(safeProfile.dateOfBirth!),
      country: safeProfile.country,
      city: safeProfile.city,
      enabledBiometric: state.biometricEnabled,
      googleTwoFactorEnabled: enabled,
      googleTwoFactorCode: googleTwoFactorCode,
    );
  }

  Future<ProfileData?> _resolveLatestProfile(ProfileData? fallback) async {
    final fallbackProfile = fallback;
    if (fallbackProfile != null && !fallbackProfile.isEmpty) {
      return fallbackProfile;
    }

    try {
      final latestProfileResponse = await _profileRepository.getProfile();
      final latestProfile = latestProfileResponse.data;
      if (latestProfileResponse.isSuccessful &&
          latestProfile != null &&
          !latestProfile.isEmpty) {
        return latestProfile;
      }
    } catch (_) {}

    return state.profile;
  }

  AddressListItem? _resolveDefaultAddress(List<AddressListItem> addresses) {
    for (final address in addresses) {
      if (address.isDefaultAddress) {
        return address;
      }
    }

    if (addresses.isEmpty) {
      return null;
    }

    return addresses.first;
  }

  _PhoneParts _splitPhoneNumber(String? rawPhone, {String? fallbackDialCode}) {
    final compact = rawPhone?.replaceAll(RegExp(r'\s+'), '') ?? '';
    final resolvedFallbackDialCode =
        _normalizeDialCode(fallbackDialCode) ??
        _normalizeDialCode(state.countryDialCode) ??
        _defaultDialCode;

    if (compact.isEmpty) {
      return _PhoneParts(dialCode: resolvedFallbackDialCode, localNumber: '');
    }

    if (!compact.startsWith('+')) {
      return _PhoneParts(
        dialCode: resolvedFallbackDialCode,
        localNumber: compact,
      );
    }

    for (int dialDigits = 4; dialDigits >= 1; dialDigits--) {
      final endIndex = dialDigits + 1;
      if (compact.length <= endIndex) {
        continue;
      }

      final candidate = compact.substring(0, endIndex);
      final code = CountryCode.tryFromDialCode(candidate);
      if (code != null) {
        return _PhoneParts(
          dialCode: candidate,
          localNumber: compact.substring(endIndex),
        );
      }
    }

    return _PhoneParts(
      dialCode: resolvedFallbackDialCode,
      localNumber: compact.replaceFirst(RegExp(r'^\+'), ''),
    );
  }

  String? _normalizeDialCode(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized.startsWith('+') ? normalized : '+$normalized';
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<_BiometricPreferenceResult> _syncBiometricPreference(
    bool enabled,
  ) async {
    if (!enabled) {
      await _biometricAuthRepository.disableBiometricLogin(
        clearCredentials: false,
      );
      return _BiometricPreferenceResult(
        enabled: false,
        message: localizedString(
          fallback: 'Biometric login disabled.',
          select: (l10n) => l10n.editProfileBiometricDisabled,
        ),
      );
    }

    final availability = await _biometricAuthRepository.getAvailability();
    if (!availability.isAvailable) {
      return _BiometricPreferenceResult(
        enabled: false,
        message: localizedString(
          fallback: 'Biometric login is not available on this device.',
          select: (l10n) => l10n.editProfileBiometricUnavailable,
        ),
      );
    }

    final token = await _authSessionRepository.getAuthToken();
    final refreshToken = await _authSessionRepository.getRefreshToken();
    final user = await _authSessionRepository.getAuthenticatedUser();
    final emailVerifiedAt = await _authSessionRepository.getEmailVerifiedAt();
    final credentials = await _biometricAuthRepository
        .getBiometricLoginCredentials();

    if (token == null || token.trim().isEmpty) {
      return _BiometricPreferenceResult(
        enabled: false,
        message: localizedString(
          fallback: 'Log in again before enabling biometric login.',
          select: (l10n) => l10n.editProfileBiometricReLogin,
        ),
      );
    }

    if (credentials == null || !credentials.isValid) {
      return _BiometricPreferenceResult(
        enabled: false,
        message: localizedString(
          fallback:
              'Log in once with email and password before enabling biometric login.',
          select: (l10n) => l10n.editProfileBiometricPasswordLoginRequired,
        ),
      );
    }

    await _biometricAuthRepository.enableBiometricLogin(
      token: token,
      refreshToken: refreshToken,
      user: user,
      emailVerifiedAt: emailVerifiedAt,
    );

    return _BiometricPreferenceResult(
      enabled: true,
      message: localizedString(
        fallback: 'Biometric login enabled.',
        select: (l10n) => l10n.editProfileBiometricEnabled,
      ),
    );
  }

  Future<void> _syncAuthenticatedProfileSession(
    ProfileData profile, {
    bool? twoFactorEnabledOverride,
    String source = 'session_sync',
  }) async {
    final token = await _authSessionRepository.getAuthToken();
    final refreshToken = await _authSessionRepository.getRefreshToken();
    if (token == null || token.trim().isEmpty) {
      _debugLog(
        '2FA local save [$source]: skipped because auth token is missing.',
      );
      return;
    }

    final emailVerifiedAt =
        profile.emailVerifiedAt?.toIso8601String() ??
        await _authSessionRepository.getEmailVerifiedAt();
    final profileUser = {
      ...profile.toSessionJson(),
      'google2fa_enabled': ?twoFactorEnabledOverride,
    };

    await _authSessionRepository.saveAuthenticatedSession(
      token: token,
      refreshToken: refreshToken,
      user: profileUser,
      emailVerifiedAt: emailVerifiedAt,
    );
    final storedUser = await _authSessionRepository.getAuthenticatedUser();
    final storedValue = _asBool(
      storedUser?['google2fa_enabled'] ??
          storedUser?['google_2fa_enabled'] ??
          storedUser?['user']?['google2fa_enabled'] ??
          storedUser?['user']?['google_2fa_enabled'],
    );
    final expectedValue =
        twoFactorEnabledOverride ?? profile.googleTwoFactorEnabled;
    final didSaveLocally = storedValue == expectedValue;
    _debugLog(
      '2FA local save [$source]: expected=${_asOnOff(expectedValue)}, stored=${_asOnOff(storedValue)}, saved=${didSaveLocally ? 'YES' : 'NO'}',
    );
    _logTwoFactorState(source, expectedValue);
    await _biometricAuthRepository.refreshBiometricSessionIfEnabled(
      token: token,
      refreshToken: refreshToken,
      user: profileUser,
      emailVerifiedAt: emailVerifiedAt,
    );
  }

  Future<void> _ensureAuthenticatedRequestContext() async {
    final token = await _authSessionRepository.getAuthToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    _dioClient.setAuthToken(token.trim());
  }

  Future<ProfileData?> _getStoredProfile() async {
    final storedUser = await _authSessionRepository.getAuthenticatedUser();
    final profile = ProfileData.fromJson(_asMap(storedUser));
    if (profile.isEmpty) {
      return null;
    }

    return profile;
  }

  Future<bool?> _getStoredTwoFactorEnabled() async {
    final user = await _authSessionRepository.getAuthenticatedUser();
    final value = _asBool(
      user?['google2fa_enabled'] ??
          user?['google_2fa_enabled'] ??
          user?['user']?['google2fa_enabled'] ??
          user?['user']?['google_2fa_enabled'],
    );
    _logTwoFactorState('stored_session', value);
    return value;
  }

  void _logTwoFactorState(String source, bool? value) {
    _debugLog('2FA state [$source]: ${_asOnOff(value)}');
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  String _asOnOff(bool? value) {
    if (value == true) {
      return 'ON';
    }
    if (value == false) {
      return 'OFF';
    }
    return 'UNKNOWN';
  }

  String _resolveLoadErrorMessage(Object error) {
    if (error is DioException) {
      final responseMessage = _asMap(
        error.response?.data,
      )?['message']?.toString().trim();
      if (responseMessage != null && responseMessage.isNotEmpty) {
        return responseMessage;
      }

      final dioMessage = error.message?.trim();
      if (dioMessage != null && dioMessage.isNotEmpty) {
        return dioMessage;
      }
    }

    return localizedString(
      fallback: 'Unable to load profile',
      select: (l10n) => l10n.editProfileLoadFailed,
    );
  }

  String _resolveSaveErrorMessage(Object error) {
    if (error is DioException) {
      final responseMessage = _asMap(
        error.response?.data,
      )?['message']?.toString().trim();
      if (responseMessage != null && responseMessage.isNotEmpty) {
        return responseMessage;
      }

      final dioMessage = error.message?.trim();
      if (dioMessage != null && dioMessage.isNotEmpty) {
        return dioMessage;
      }
    }

    return localizedString(
      fallback: 'Unable to update profile',
      select: (l10n) => l10n.editProfileSaveFailed,
    );
  }
}

const String _defaultDialCode = '+1';

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty || normalized == 'null') {
    return null;
  }

  if (normalized == '1' || normalized == 'true') {
    return true;
  }

  if (normalized == '0' || normalized == 'false') {
    return false;
  }

  return null;
}

class _PhoneParts {
  const _PhoneParts({required this.dialCode, required this.localNumber});

  final String dialCode;
  final String localNumber;
}

class _BiometricPreferenceResult {
  const _BiometricPreferenceResult({required this.enabled, this.message});

  final bool enabled;
  final String? message;
}
