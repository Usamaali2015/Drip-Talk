import 'package:drip_talk/features/contact_support/domain/contact_support_issue_type.dart';
import 'package:equatable/equatable.dart';

abstract class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();

  @override
  List<Object?> get props => const [];
}

class InitializeContactSupportRequested extends ContactSupportEvent {
  const InitializeContactSupportRequested();
}

class ContactSupportNameChanged extends ContactSupportEvent {
  const ContactSupportNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ContactSupportEmailChanged extends ContactSupportEvent {
  const ContactSupportEmailChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ContactSupportOrderIdChanged extends ContactSupportEvent {
  const ContactSupportOrderIdChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ContactSupportIssueTypeChanged extends ContactSupportEvent {
  const ContactSupportIssueTypeChanged(this.value);

  final ContactSupportIssueType value;

  @override
  List<Object?> get props => [value];
}

class ContactSupportMessageChanged extends ContactSupportEvent {
  const ContactSupportMessageChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SubmitContactSupportRequested extends ContactSupportEvent {
  const SubmitContactSupportRequested();
}
