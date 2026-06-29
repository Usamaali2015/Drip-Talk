import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/contact_support/data/models/contact_support_request_model.dart';
import 'package:drip_talk/features/contact_support/data/repository/contact_support_repository.dart';
import 'package:drip_talk/features/contact_support/domain/bloc/contact_support_event.dart';
import 'package:drip_talk/features/contact_support/domain/bloc/contact_support_state.dart';
import 'package:drip_talk/features/dashboard/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactSupportBloc
    extends Bloc<ContactSupportEvent, ContactSupportState> {
  ContactSupportBloc(this._repository, this._authSessionRepository)
    : super(const ContactSupportState()) {
    on<InitializeContactSupportRequested>(_onInitializeRequested);
    on<ContactSupportNameChanged>(_onNameChanged);
    on<ContactSupportEmailChanged>(_onEmailChanged);
    on<ContactSupportOrderIdChanged>(_onOrderIdChanged);
    on<ContactSupportIssueTypeChanged>(_onIssueTypeChanged);
    on<ContactSupportMessageChanged>(_onMessageChanged);
    on<SubmitContactSupportRequested>(_onSubmitRequested);
  }

  final ContactSupportRepository _repository;
  final AuthSessionRepository _authSessionRepository;

  Future<void> _onInitializeRequested(
    InitializeContactSupportRequested event,
    Emitter<ContactSupportState> emit,
  ) async {
    emit(state.copyWith(status: ContactSupportStatus.loading));

    try {
      final user = await _authSessionRepository.getAuthenticatedUser();
      final profile = ProfileData.fromJson(user);

      emit(
        state.copyWith(
          status: ContactSupportStatus.ready,
          name: state.name.isEmpty ? (profile.name ?? '') : state.name,
          email: state.email.isEmpty ? (profile.email ?? '') : state.email,
          clearFeedbackMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ContactSupportStatus.ready,
          clearFeedbackMessage: true,
        ),
      );
    }
  }

  void _onNameChanged(
    ContactSupportNameChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    emit(
      state.copyWith(
        status: ContactSupportStatus.ready,
        name: event.value,
        clearNameError: true,
        clearFeedbackMessage: true,
      ),
    );
  }

  void _onEmailChanged(
    ContactSupportEmailChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    emit(
      state.copyWith(
        status: ContactSupportStatus.ready,
        email: event.value,
        clearEmailError: true,
        clearFeedbackMessage: true,
      ),
    );
  }

  void _onOrderIdChanged(
    ContactSupportOrderIdChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    emit(
      state.copyWith(
        status: ContactSupportStatus.ready,
        orderId: event.value,
        clearOrderIdError: true,
        clearFeedbackMessage: true,
      ),
    );
  }

  void _onIssueTypeChanged(
    ContactSupportIssueTypeChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    emit(
      state.copyWith(
        status: ContactSupportStatus.ready,
        issueType: event.value,
        clearIssueTypeError: true,
        clearFeedbackMessage: true,
      ),
    );
  }

  void _onMessageChanged(
    ContactSupportMessageChanged event,
    Emitter<ContactSupportState> emit,
  ) {
    final nextValue =
        event.value.length > ContactSupportState.messageCharacterLimit
        ? event.value.substring(0, ContactSupportState.messageCharacterLimit)
        : event.value;

    emit(
      state.copyWith(
        status: ContactSupportStatus.ready,
        message: nextValue,
        clearMessageError: true,
        clearFeedbackMessage: true,
      ),
    );
  }

  Future<void> _onSubmitRequested(
    SubmitContactSupportRequested event,
    Emitter<ContactSupportState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final nameError = _validateName(state.name);
    final emailError = _validateEmail(state.email);
    final messageError = _validateMessage(state.message);

    if (nameError != null || emailError != null || messageError != null) {
      emit(
        state.copyWith(
          status: ContactSupportStatus.ready,
          nameError: nameError,
          emailError: emailError,
          messageError: messageError,
          clearFeedbackMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ContactSupportStatus.submitting,
        clearNameError: true,
        clearEmailError: true,
        clearOrderIdError: true,
        clearIssueTypeError: true,
        clearMessageError: true,
        clearFeedbackMessage: true,
      ),
    );

    try {
      final response = await _repository.submitSupportRequest(
        ContactSupportRequestModel(
          name: state.name,
          email: state.email,
          orderId: state.orderId,
          issueType: state.issueType,
          message: state.message,
        ),
      );

      if (!response.isSuccessful) {
        emit(
          state.copyWith(
            status: ContactSupportStatus.failure,
            feedbackMessage:
                response.message ??
                localizedString(
                  fallback: 'Unable to submit your support request.',
                  select: (l10n) => l10n.contactSupportSubmitFailed,
                ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ContactSupportStatus.success,
          orderId: '',
          issueType: state.issueType,
          message: '',
          clearOrderIdError: true,
          clearIssueTypeError: true,
          clearMessageError: true,
          feedbackMessage:
              response.message ??
              localizedString(
                fallback:
                    'Your support request has been submitted successfully.',
                select: (l10n) => l10n.contactSupportSubmitSuccess,
              ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ContactSupportStatus.failure,
          feedbackMessage: resolveApiErrorMessage(
            error,
            fallback: localizedString(
              fallback: 'Unable to submit your support request.',
              select: (l10n) => l10n.contactSupportSubmitFailed,
            ),
          ),
        ),
      );
    }
  }

  String? _validateName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return localizedString(
        fallback: 'Name is required.',
        select: (l10n) => l10n.contactSupportNameRequired,
      );
    }

    if (normalized.length < 2) {
      return localizedString(
        fallback: 'Name must be at least 2 characters.',
        select: (l10n) => l10n.contactSupportNameTooShort,
      );
    }

    return null;
  }

  String? _validateEmail(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return localizedString(
        fallback: 'Email is required.',
        select: (l10n) => l10n.contactSupportEmailRequired,
      );
    }

    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(normalized)) {
      return localizedString(
        fallback: 'Enter a valid email address.',
        select: (l10n) => l10n.contactSupportEmailInvalid,
      );
    }

    return null;
  }

  String? _validateMessage(String value) {
    if (value.trim().isEmpty) {
      return localizedString(
        fallback: 'Message is required.',
        select: (l10n) => l10n.contactSupportMessageRequired,
      );
    }

    return null;
  }
}
