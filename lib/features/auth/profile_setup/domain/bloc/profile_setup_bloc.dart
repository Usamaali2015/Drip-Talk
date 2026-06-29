import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/profile_setup/data/models/brands_model.dart';
import 'package:drip_talk/features/auth/profile_setup/data/repository/profile_setup_brands_repository.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_event.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_state.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/update_profile_request_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/repository/profile_repository.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc(
    this._profileRepository,
    this._brandsRepository,
    this._authSessionRepository,
    this._dioClient,
  ) : super(const ProfileSetupState()) {
    on<ProfileSetupInitialized>(_onInitialized);
    on<ProfileSetupBrandsRequested>(_onBrandsRequested);
    on<ProfileSetupDraftUpdated>(_onDraftUpdated);
    on<ProfileSetupStepSelected>(_onStepSelected);
    on<ProfileSetupStepInteracted>(_onStepInteracted);
    on<ProfileSetupContinueRequested>(_onContinueRequested);
    on<ProfileSetupSkipRequested>(_onSkipRequested);
    on<ProfileSetupBackRequested>(_onBackRequested);
    on<ProfileSetupSubmitted>(_onSubmitted);
  }

  final ProfileRepository _profileRepository;
  final ProfileSetupBrandsRepository _brandsRepository;
  final AuthSessionRepository _authSessionRepository;
  final DioClient _dioClient;

  Future<void> _onInitialized(
    ProfileSetupInitialized event,
    Emitter<ProfileSetupState> emit,
  ) async {
    final storedProfile = await _getStoredProfile();
    final initialForm = ProfileSetupFormData.fromProfile(storedProfile);
    emit(
      state.copyWith(
        loadStatus: ProfileSetupLoadStatus.loading,
        submitStatus: ProfileSetupSubmitStatus.initial,
        currentStep: ProfileSetupStep.basics,
        profile: storedProfile,
        form: initialForm,
        completedSteps: _completedStepsFor(initialForm),
        interactedSteps: const <ProfileSetupStep>[],
        validationErrors: ProfileSetupValidationErrors.empty,
        errorMessage: null,
        feedbackMessage: null,
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final response = await _profileRepository.getProfile();
      final resolvedProfile = _resolvedProfile(response.data) ?? storedProfile;
      if (resolvedProfile == null) {
        emit(
          state.copyWith(
            loadStatus: ProfileSetupLoadStatus.failure,
            errorMessage: response.message ?? _profileLoadFailedMessage(),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          loadStatus: ProfileSetupLoadStatus.success,
          profile: resolvedProfile,
          form: ProfileSetupFormData.fromProfile(resolvedProfile),
          completedSteps: _completedStepsFor(
            ProfileSetupFormData.fromProfile(resolvedProfile),
          ),
          interactedSteps: const <ProfileSetupStep>[],
          validationErrors: ProfileSetupValidationErrors.empty,
          errorMessage: null,
        ),
      );
      add(
        ProfileSetupBrandsRequested(
          showLoadingIndicator: state.availableBrands.isEmpty,
        ),
      );
    } catch (error) {
      if (storedProfile != null && !storedProfile.isEmpty) {
        emit(
          state.copyWith(
            loadStatus: ProfileSetupLoadStatus.success,
            profile: storedProfile,
            form: initialForm,
            completedSteps: _completedStepsFor(initialForm),
            interactedSteps: const <ProfileSetupStep>[],
            validationErrors: ProfileSetupValidationErrors.empty,
            errorMessage: null,
          ),
        );
        add(
          ProfileSetupBrandsRequested(
            showLoadingIndicator: state.availableBrands.isEmpty,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          loadStatus: ProfileSetupLoadStatus.failure,
          errorMessage: resolveApiErrorMessage(
            error,
            fallback: _profileLoadFailedMessage(),
          ),
        ),
      );
    }
  }

  Future<void> _onBrandsRequested(
    ProfileSetupBrandsRequested event,
    Emitter<ProfileSetupState> emit,
  ) async {
    if (state.brandLoadStatus == ProfileSetupBrandLoadStatus.loading) {
      return;
    }

    if (event.showLoadingIndicator || state.availableBrands.isEmpty) {
      emit(
        state.copyWith(
          brandLoadStatus: ProfileSetupBrandLoadStatus.loading,
          brandErrorMessage: null,
        ),
      );
    } else {
      emit(state.copyWith(brandErrorMessage: null));
    }

    try {
      await _ensureAuthenticatedRequestContext();
      final response = await _brandsRepository.getBrands();
      emit(
        state.copyWith(
          brandLoadStatus: ProfileSetupBrandLoadStatus.success,
          availableBrands: _buildAvailableBrands(response.data, state.form),
          brandErrorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          brandLoadStatus: ProfileSetupBrandLoadStatus.failure,
          availableBrands: _buildAvailableBrands(
            state.availableBrands,
            state.form,
          ),
          brandErrorMessage: resolveApiErrorMessage(
            error,
            fallback: _brandLoadFailedMessage(),
          ),
        ),
      );
    }
  }

  void _onDraftUpdated(
    ProfileSetupDraftUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    emit(
      state.copyWith(
        form: event.form,
        completedSteps: _retainCompletedSteps(state.completedSteps, event.form),
        availableBrands: _buildAvailableBrands(
          state.availableBrands,
          event.form,
        ),
        submitStatus: ProfileSetupSubmitStatus.initial,
        validationErrors: ProfileSetupValidationErrors.empty,
        feedbackMessage: null,
      ),
    );
  }

  void _onStepSelected(
    ProfileSetupStepSelected event,
    Emitter<ProfileSetupState> emit,
  ) {
    if (event.step.index <= state.currentStep.index) {
      emit(state.copyWith(currentStep: event.step));
      return;
    }

    final stepErrors = _validateStep(state.currentStep, state.form);
    if (stepErrors.hasAny) {
      emit(
        state.copyWith(
          validationErrors: stepErrors,
          submitStatus: ProfileSetupSubmitStatus.initial,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        currentStep: event.step,
        completedSteps: _markStepCompleted(
          state.completedSteps,
          state.currentStep,
          state.form,
        ),
        validationErrors: ProfileSetupValidationErrors.empty,
      ),
    );
  }

  void _onStepInteracted(
    ProfileSetupStepInteracted event,
    Emitter<ProfileSetupState> emit,
  ) {
    if (state.interactedSteps.contains(event.step)) {
      return;
    }

    emit(
      state.copyWith(
        interactedSteps: [...state.interactedSteps, event.step]
          ..sort((left, right) => left.index.compareTo(right.index)),
      ),
    );
  }

  void _onContinueRequested(
    ProfileSetupContinueRequested event,
    Emitter<ProfileSetupState> emit,
  ) {
    if (!state.canContinueCurrentStep) {
      return;
    }

    final stepErrors = _validateStep(state.currentStep, state.form);
    if (stepErrors.hasAny) {
      emit(
        state.copyWith(
          validationErrors: stepErrors,
          submitStatus: ProfileSetupSubmitStatus.initial,
        ),
      );
      return;
    }

    if (state.currentStep.isLast) {
      emit(
        state.copyWith(
          completedSteps: _markStepCompleted(
            state.completedSteps,
            state.currentStep,
            state.form,
          ),
          validationErrors: ProfileSetupValidationErrors.empty,
        ),
      );
      add(const ProfileSetupSubmitted());
      return;
    }

    emit(
      state.copyWith(
        currentStep: state.currentStep.next,
        completedSteps: _markStepCompleted(
          state.completedSteps,
          state.currentStep,
          state.form,
        ),
        validationErrors: ProfileSetupValidationErrors.empty,
      ),
    );
  }

  void _onSkipRequested(
    ProfileSetupSkipRequested event,
    Emitter<ProfileSetupState> emit,
  ) {
    if (!state.canSkipCurrentStep) {
      return;
    }

    if (state.currentStep.isLast) {
      add(const ProfileSetupSubmitted());
      return;
    }

    emit(
      state.copyWith(
        currentStep: state.currentStep.next,
        validationErrors: ProfileSetupValidationErrors.empty,
        submitStatus: ProfileSetupSubmitStatus.initial,
        feedbackMessage: null,
      ),
    );
  }

  void _onBackRequested(
    ProfileSetupBackRequested event,
    Emitter<ProfileSetupState> emit,
  ) {
    if (state.currentStep == ProfileSetupStep.basics) {
      return;
    }

    emit(
      state.copyWith(
        currentStep: state.currentStep.previous,
        validationErrors: ProfileSetupValidationErrors.empty,
        submitStatus: ProfileSetupSubmitStatus.initial,
        feedbackMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    ProfileSetupSubmitted event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(
      state.copyWith(
        submitStatus: ProfileSetupSubmitStatus.submitting,
        feedbackMessage: null,
      ),
    );

    try {
      await _ensureAuthenticatedRequestContext();
      final response = await _profileRepository.updateProfile(
        _buildRequest(state.form, state.profile),
      );

      final updatedProfile = _resolvedProfile(response.user) ?? state.profile;
      if (updatedProfile != null && !updatedProfile.isEmpty) {
        await _syncAuthenticatedProfileSession(updatedProfile);
      }
      await _authSessionRepository.setProfileSetupRequired(false);
      AuthGuard.completeProfileSetup();

      emit(
        state.copyWith(
          submitStatus: ProfileSetupSubmitStatus.success,
          profile: updatedProfile,
          form: state.form.copyWith(
            wardrobeFiles: const [],
            wardrobeFileUrls:
                updatedProfile?.wardrobeFiles ?? state.form.wardrobeFileUrls,
          ),
          validationErrors: ProfileSetupValidationErrors.empty,
          feedbackMessage: response.message ?? _profileSaveSuccessMessage(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submitStatus: ProfileSetupSubmitStatus.failure,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: _profileSaveFailedMessage(),
          ),
        ),
      );
    }
  }

  UpdateProfileRequestModel _buildRequest(
    ProfileSetupFormData form,
    ProfileData? profile,
  ) {
    return UpdateProfileRequestModel(
      name: _trim(form.name) ?? profile?.displayName ?? 'DripTalk User',
      username: _trim(profile?.editableUsername),
      phone: _trim(form.phone),
      gender: _trim(form.gender),
      dateOfBirth: form.dateOfBirth == null
          ? null
          : DateFormat('yyyy-MM-dd').format(form.dateOfBirth!),
      country: _trim(form.country),
      city: _trim(form.city),
      height: _trim(form.heightForSubmission),
      weight: _trim(form.weightForSubmission),
      bodyType: _trim(form.bodyType),
      skinTone: _trim(form.skinTone),
      favoriteCelebrities: _trim(form.favoriteCelebrities),
      preferredStyle: form.preferredStyleValue,
      stylePreferences: form.stylePreferencesText,
      avoidStyles: _trim(form.avoidStyles),
      favoriteColors: form.favoriteColorsText,
      preferredFit: _trim(profile?.preferredFit),
      stylePatterns: _trim(profile?.stylePatterns),
      preferredBrands: form.preferredBrandsText,
      budgetMin: _trim(form.budgetMin),
      budgetMax: _trim(form.budgetMax),
      replaceWardrobe: form.wardrobeFiles.isEmpty ? null : form.replaceWardrobe,
      wardrobeFiles: form.wardrobeFiles,
      enabledBiometric: profile?.enabledBiometric,
      googleTwoFactorEnabled: profile?.googleTwoFactorEnabled,
      googleTwoFactorCode: _trim(form.googleTwoFactorCode),
    );
  }

  ProfileSetupValidationErrors _validateStep(
    ProfileSetupStep step,
    ProfileSetupFormData form,
  ) {
    switch (step) {
      case ProfileSetupStep.basics:
        return ProfileSetupValidationErrors(
          phone: _trim(form.phone) == null ? _validationPhoneMessage() : null,
          gender: _trim(form.gender) == null
              ? _validationGenderMessage()
              : null,
          dateOfBirth: form.dateOfBirth == null
              ? _validationDateOfBirthMessage()
              : null,
          country: _trim(form.country) == null
              ? _validationCountryMessage()
              : null,
          city: _trim(form.city) == null ? _validationCityMessage() : null,
        );
      case ProfileSetupStep.body:
        return ProfileSetupValidationErrors(
          bodyType: _trim(form.bodyType) == null
              ? _validationBodyTypeMessage()
              : null,
        );
      case ProfileSetupStep.skin:
        return ProfileSetupValidationErrors(
          skinTone: _trim(form.skinTone) == null
              ? _validationSkinToneMessage()
              : null,
        );
      case ProfileSetupStep.style:
        final hasAnyBudgetValue =
            form.budgetMin.trim().isNotEmpty ||
            form.budgetMax.trim().isNotEmpty;
        final budgetMin = _parseBudget(form.budgetMin);
        final budgetMax = _parseBudget(form.budgetMax);
        return ProfileSetupValidationErrors(
          stylePreferences: form.stylePreferences.isEmpty
              ? _validationStyleMessage()
              : null,
          budgetMin: !hasAnyBudgetValue
              ? null
              : budgetMin == null
              ? _validationBudgetMinMessage()
              : null,
          budgetMax: !hasAnyBudgetValue
              ? null
              : budgetMax == null
              ? _validationBudgetMaxMessage()
              : budgetMin != null && budgetMax < budgetMin
              ? _validationBudgetRangeMessage()
              : null,
        );
      case ProfileSetupStep.height:
        return ProfileSetupValidationErrors(
          height: !form.hasValidHeight ? _validationHeightMessage() : null,
        );
      case ProfileSetupStep.weight:
        return ProfileSetupValidationErrors(
          weight: !form.hasValidWeight ? _validationWeightMessage() : null,
        );
      case ProfileSetupStep.brands:
        return ProfileSetupValidationErrors(
          preferredBrands: form.preferredBrands.isEmpty
              ? _validationBrandMessage()
              : null,
        );
      case ProfileSetupStep.colors:
        return ProfileSetupValidationErrors(
          favoriteColors: form.favoriteColors.isEmpty
              ? _validationColorMessage()
              : null,
        );
      case ProfileSetupStep.avoids:
      case ProfileSetupStep.photo:
        return ProfileSetupValidationErrors.empty;
    }
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
    final profile = ProfileData.fromJson(storedUser);
    return profile.isEmpty ? null : profile;
  }

  Future<void> _syncAuthenticatedProfileSession(ProfileData profile) async {
    final token = await _authSessionRepository.getAuthToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    final refreshToken = await _authSessionRepository.getRefreshToken();
    final emailVerifiedAt =
        profile.emailVerifiedAt?.toIso8601String() ??
        await _authSessionRepository.getEmailVerifiedAt();

    await _authSessionRepository.saveAuthenticatedSession(
      token: token,
      refreshToken: refreshToken,
      user: profile.toSessionJson(),
      emailVerifiedAt: emailVerifiedAt,
    );
  }

  ProfileData? _resolvedProfile(ProfileData? profile) {
    if (profile == null || profile.isEmpty) {
      return null;
    }

    return profile;
  }

  List<BrandData> _buildAvailableBrands(
    List<BrandData> brands,
    ProfileSetupFormData form,
  ) {
    final resolved = <String, BrandData>{};

    for (final brand in brands) {
      final name = _trim(brand.name);
      if (name == null) {
        continue;
      }
      resolved[name.toLowerCase()] = BrandData(
        id: brand.id,
        name: name,
        logo: _trim(brand.logo),
        isFeatured: brand.isFeatured,
      );
    }

    for (final selectedBrand in form.preferredBrands) {
      final normalized = _trim(selectedBrand);
      if (normalized == null) {
        continue;
      }
      resolved.putIfAbsent(
        normalized.toLowerCase(),
        () => BrandData(name: normalized),
      );
    }

    final values = resolved.values.toList(growable: false);
    values.sort((left, right) {
      if (left.isFeatured != right.isFeatured) {
        return left.isFeatured ? -1 : 1;
      }

      final leftName = left.name?.toLowerCase() ?? '';
      final rightName = right.name?.toLowerCase() ?? '';
      return leftName.compareTo(rightName);
    });
    return values;
  }

  List<ProfileSetupStep> _completedStepsFor(
    ProfileSetupFormData form, {
    Iterable<ProfileSetupStep>? source,
  }) {
    final resolvedSource = source ?? ProfileSetupStep.values;
    return resolvedSource
        .where((step) => _isStepComplete(step, form))
        .toList(growable: false)
      ..sort((left, right) => left.index.compareTo(right.index));
  }

  List<ProfileSetupStep> _retainCompletedSteps(
    List<ProfileSetupStep> current,
    ProfileSetupFormData form,
  ) {
    return _completedStepsFor(form, source: current);
  }

  List<ProfileSetupStep> _markStepCompleted(
    List<ProfileSetupStep> current,
    ProfileSetupStep step,
    ProfileSetupFormData form,
  ) {
    final retainedSteps = _retainCompletedSteps(current, form);
    if (!_isStepComplete(step, form) || retainedSteps.contains(step)) {
      return retainedSteps;
    }

    return [...retainedSteps, step]
      ..sort((left, right) => left.index.compareTo(right.index));
  }

  bool _isStepComplete(ProfileSetupStep step, ProfileSetupFormData form) {
    switch (step) {
      case ProfileSetupStep.avoids:
        return form.avoidStylesList.isNotEmpty;
      case ProfileSetupStep.photo:
        return form.wardrobePreviewCount > 0;
      case ProfileSetupStep.basics:
      case ProfileSetupStep.body:
      case ProfileSetupStep.skin:
      case ProfileSetupStep.style:
      case ProfileSetupStep.height:
      case ProfileSetupStep.weight:
      case ProfileSetupStep.brands:
      case ProfileSetupStep.colors:
        return !_validateStep(step, form).hasAny;
    }
  }

  String _profileLoadFailedMessage() => _localized(
    fallback: 'Unable to load your profile.',
    select: (l10n) => l10n.profileSetupLoadFailedMessage,
  );

  String _brandLoadFailedMessage() => _localized(
    fallback: 'Unable to load brands right now.',
    select: (l10n) => l10n.profileSetupBrandsLoadFailedMessage,
  );

  String _profileSaveSuccessMessage() => _localized(
    fallback: 'Profile setup completed successfully.',
    select: (l10n) => l10n.profileSetupSaveSuccessMessage,
  );

  String _profileSaveFailedMessage() => _localized(
    fallback: 'Unable to save your profile.',
    select: (l10n) => l10n.profileSetupSaveFailedMessage,
  );

  String _validationPhoneMessage() => _localized(
    fallback: 'Phone number is required.',
    select: (l10n) => l10n.profileSetupValidationPhone,
  );

  String _validationGenderMessage() => _localized(
    fallback: 'Select a gender.',
    select: (l10n) => l10n.profileSetupValidationGender,
  );

  String _validationDateOfBirthMessage() => _localized(
    fallback: 'Select your date of birth.',
    select: (l10n) => l10n.profileSetupValidationDateOfBirth,
  );

  String _validationCountryMessage() => _localized(
    fallback: 'Select a country.',
    select: (l10n) => l10n.profileSetupValidationCountry,
  );

  String _validationCityMessage() => _localized(
    fallback: 'Select a city.',
    select: (l10n) => l10n.profileSetupValidationCity,
  );

  String _validationBodyTypeMessage() => _localized(
    fallback: 'Select a body type.',
    select: (l10n) => l10n.profileSetupValidationBodyType,
  );

  String _validationSkinToneMessage() => _localized(
    fallback: 'Select a skin tone.',
    select: (l10n) => l10n.profileSetupValidationSkinTone,
  );

  String _validationStyleMessage() => _localized(
    fallback: 'Choose at least one style.',
    select: (l10n) => l10n.profileSetupValidationStyle,
  );

  String _validationBudgetMinMessage() => _localized(
    fallback: 'Enter a valid minimum budget.',
    select: (l10n) => l10n.profileSetupValidationBudgetMin,
  );

  String _validationBudgetMaxMessage() => _localized(
    fallback: 'Enter a valid maximum budget.',
    select: (l10n) => l10n.profileSetupValidationBudgetMax,
  );

  String _validationBudgetRangeMessage() => _localized(
    fallback: 'Maximum budget must be greater than minimum budget.',
    select: (l10n) => l10n.profileSetupValidationBudgetRange,
  );

  String _validationColorMessage() => _localized(
    fallback: 'Choose at least one color.',
    select: (l10n) => l10n.profileSetupValidationColor,
  );

  String _validationBrandMessage() => _localized(
    fallback: 'Choose at least one brand.',
    select: (l10n) => l10n.profileSetupValidationBrand,
  );

  String _validationHeightMessage() => _localized(
    fallback: 'Height is required.',
    select: (l10n) => l10n.profileSetupValidationHeight,
  );

  String _validationWeightMessage() => _localized(
    fallback: 'Weight is required.',
    select: (l10n) => l10n.profileSetupValidationWeight,
  );

  String _validationInspirationsMessage() => _localized(
    fallback: 'Add your style inspirations.',
    select: (l10n) => l10n.profileSetupValidationInspirations,
  );

  String _validationAvoidStylesMessage() => _localized(
    fallback: 'Add the styles you want to avoid.',
    select: (l10n) => l10n.profileSetupValidationAvoidStyles,
  );
}

String _localized({
  required String fallback,
  required String Function(AppLocalizations l10n) select,
}) {
  return localizedString(fallback: fallback, select: select);
}

double? _parseBudget(String value) {
  final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '').trim();
  if (normalized.isEmpty) {
    return null;
  }

  return double.tryParse(normalized);
}

String? _trim(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}
