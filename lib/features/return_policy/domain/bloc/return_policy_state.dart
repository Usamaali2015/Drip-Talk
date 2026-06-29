import 'package:drip_talk/features/return_policy/data/models/return_policy_model.dart';
import 'package:equatable/equatable.dart';

enum ReturnPolicyStatus { initial, loading, success, failure }

class ReturnPolicyState extends Equatable {
  const ReturnPolicyState({
    this.status = ReturnPolicyStatus.initial,
    this.policy,
    this.errorMessage,
  });

  final ReturnPolicyStatus status;
  final ReturnPolicyData? policy;
  final String? errorMessage;

  bool get isInitialLoading =>
      status == ReturnPolicyStatus.loading && policy == null;

  bool get isFailure => status == ReturnPolicyStatus.failure;

  bool get isEmpty =>
      status == ReturnPolicyStatus.success && !(policy?.hasSections ?? false);

  ReturnPolicyState copyWith({
    ReturnPolicyStatus? status,
    ReturnPolicyData? policy,
    bool clearPolicy = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ReturnPolicyState(
      status: status ?? this.status,
      policy: clearPolicy ? null : policy ?? this.policy,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, policy, errorMessage];
}
