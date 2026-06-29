import 'package:drip_talk/features/contact_support/domain/contact_support_issue_type.dart';

class ContactSupportRequestModel {
  const ContactSupportRequestModel({
    required this.name,
    required this.email,
    required this.orderId,
    required this.issueType,
    required this.message,
  });

  final String name;
  final String email;
  final String orderId;
  final ContactSupportIssueType issueType;
  final String message;

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'order_id': orderId.trim(),
      'issue_type': issueType.value,
      'message': message.trim(),
    };
  }
}
