import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileSetupEvent extends Equatable {
  const ProfileSetupEvent();

  @override
  List<Object?> get props => const [];
}

class ProfileSetupInitialized extends ProfileSetupEvent {
  const ProfileSetupInitialized();
}

class ProfileSetupDraftUpdated extends ProfileSetupEvent {
  const ProfileSetupDraftUpdated(this.form);

  final ProfileSetupFormData form;

  @override
  List<Object?> get props => [form];
}

class ProfileSetupStepSelected extends ProfileSetupEvent {
  const ProfileSetupStepSelected(this.step);

  final ProfileSetupStep step;

  @override
  List<Object?> get props => [step];
}

class ProfileSetupStepInteracted extends ProfileSetupEvent {
  const ProfileSetupStepInteracted(this.step);

  final ProfileSetupStep step;

  @override
  List<Object?> get props => [step];
}

class ProfileSetupContinueRequested extends ProfileSetupEvent {
  const ProfileSetupContinueRequested();
}

class ProfileSetupSkipRequested extends ProfileSetupEvent {
  const ProfileSetupSkipRequested();
}

class ProfileSetupBackRequested extends ProfileSetupEvent {
  const ProfileSetupBackRequested();
}

class ProfileSetupBrandsRequested extends ProfileSetupEvent {
  const ProfileSetupBrandsRequested({this.showLoadingIndicator = true});

  final bool showLoadingIndicator;

  @override
  List<Object?> get props => [showLoadingIndicator];
}

class ProfileSetupSubmitted extends ProfileSetupEvent {
  const ProfileSetupSubmitted();
}
