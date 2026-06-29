import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/auth/profile_setup/data/models/brands_model.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

enum ProfileSetupLoadStatus { initial, loading, success, failure }

enum ProfileSetupSubmitStatus { initial, submitting, success, failure }

enum ProfileSetupBrandLoadStatus { initial, loading, success, failure }

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.loadStatus = ProfileSetupLoadStatus.initial,
    this.submitStatus = ProfileSetupSubmitStatus.initial,
    this.brandLoadStatus = ProfileSetupBrandLoadStatus.initial,
    this.currentStep = ProfileSetupStep.basics,
    this.completedSteps = const <ProfileSetupStep>[],
    this.interactedSteps = const <ProfileSetupStep>[],
    this.availableBrands = const <BrandData>[],
    this.form = const ProfileSetupFormData(),
    this.validationErrors = ProfileSetupValidationErrors.empty,
    this.profile,
    this.errorMessage,
    this.feedbackMessage,
    this.brandErrorMessage,
  });

  final ProfileSetupLoadStatus loadStatus;
  final ProfileSetupSubmitStatus submitStatus;
  final ProfileSetupBrandLoadStatus brandLoadStatus;
  final ProfileSetupStep currentStep;
  final List<ProfileSetupStep> completedSteps;
  final List<ProfileSetupStep> interactedSteps;
  final List<BrandData> availableBrands;
  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors validationErrors;
  final ProfileData? profile;
  final String? errorMessage;
  final String? feedbackMessage;
  final String? brandErrorMessage;

  bool get isInitialLoading =>
      profile == null &&
      (loadStatus == ProfileSetupLoadStatus.initial ||
          loadStatus == ProfileSetupLoadStatus.loading);

  bool get isSubmitting => submitStatus == ProfileSetupSubmitStatus.submitting;

  bool get canContinueCurrentStep {
    switch (currentStep) {
      case ProfileSetupStep.height:
      case ProfileSetupStep.weight:
        return interactedSteps.contains(currentStep);
      case ProfileSetupStep.basics:
      case ProfileSetupStep.body:
      case ProfileSetupStep.skin:
      case ProfileSetupStep.style:
      case ProfileSetupStep.brands:
      case ProfileSetupStep.colors:
      case ProfileSetupStep.avoids:
      case ProfileSetupStep.photo:
        return form.hasAnyValueForStep(currentStep);
    }
  }

  bool get canSkipCurrentStep => true;

  bool isStepCompleted(ProfileSetupStep step) => completedSteps.contains(step);

  ProfileSetupState copyWith({
    ProfileSetupLoadStatus? loadStatus,
    ProfileSetupSubmitStatus? submitStatus,
    ProfileSetupBrandLoadStatus? brandLoadStatus,
    ProfileSetupStep? currentStep,
    List<ProfileSetupStep>? completedSteps,
    List<ProfileSetupStep>? interactedSteps,
    List<BrandData>? availableBrands,
    ProfileSetupFormData? form,
    ProfileSetupValidationErrors? validationErrors,
    Object? profile = _stateSentinel,
    Object? errorMessage = _stateSentinel,
    Object? feedbackMessage = _stateSentinel,
    Object? brandErrorMessage = _stateSentinel,
  }) {
    return ProfileSetupState(
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      brandLoadStatus: brandLoadStatus ?? this.brandLoadStatus,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      interactedSteps: interactedSteps ?? this.interactedSteps,
      availableBrands: availableBrands ?? this.availableBrands,
      form: form ?? this.form,
      validationErrors: validationErrors ?? this.validationErrors,
      profile: profile == _stateSentinel
          ? this.profile
          : profile as ProfileData?,
      errorMessage: errorMessage == _stateSentinel
          ? this.errorMessage
          : errorMessage as String?,
      feedbackMessage: feedbackMessage == _stateSentinel
          ? this.feedbackMessage
          : feedbackMessage as String?,
      brandErrorMessage: brandErrorMessage == _stateSentinel
          ? this.brandErrorMessage
          : brandErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    submitStatus,
    brandLoadStatus,
    currentStep,
    completedSteps,
    interactedSteps,
    availableBrands,
    form,
    validationErrors,
    profile,
    errorMessage,
    feedbackMessage,
    brandErrorMessage,
  ];
}

const Object _stateSentinel = Object();
