import 'package:drip_talk/features/contact_support/domain/contact_support_issue_type.dart';
import 'package:equatable/equatable.dart';

enum ContactSupportStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class ContactSupportState extends Equatable {
  const ContactSupportState({
    this.status = ContactSupportStatus.initial,
    this.name = '',
    this.email = '',
    this.orderId = '',
    this.issueType = ContactSupportIssueType.orderIssue,
    this.message = '',
    this.nameError,
    this.emailError,
    this.orderIdError,
    this.issueTypeError,
    this.messageError,
    this.feedbackMessage,
  });

  static const int messageCharacterLimit = 500;

  final ContactSupportStatus status;
  final String name;
  final String email;
  final String orderId;
  final ContactSupportIssueType issueType;
  final String message;
  final String? nameError;
  final String? emailError;
  final String? orderIdError;
  final String? issueTypeError;
  final String? messageError;
  final String? feedbackMessage;

  bool get isSubmitting => status == ContactSupportStatus.submitting;
  int get messageLength => message.length;

  ContactSupportState copyWith({
    ContactSupportStatus? status,
    String? name,
    String? email,
    String? orderId,
    ContactSupportIssueType? issueType,
    String? message,
    String? nameError,
    bool clearNameError = false,
    String? emailError,
    bool clearEmailError = false,
    String? orderIdError,
    bool clearOrderIdError = false,
    String? issueTypeError,
    bool clearIssueTypeError = false,
    String? messageError,
    bool clearMessageError = false,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
  }) {
    return ContactSupportState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      orderId: orderId ?? this.orderId,
      issueType: issueType ?? this.issueType,
      message: message ?? this.message,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      orderIdError: clearOrderIdError
          ? null
          : (orderIdError ?? this.orderIdError),
      issueTypeError: clearIssueTypeError
          ? null
          : (issueTypeError ?? this.issueTypeError),
      messageError: clearMessageError
          ? null
          : (messageError ?? this.messageError),
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    email,
    orderId,
    issueType,
    message,
    nameError,
    emailError,
    orderIdError,
    issueTypeError,
    messageError,
    feedbackMessage,
  ];
}
