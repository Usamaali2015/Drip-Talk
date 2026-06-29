import 'package:equatable/equatable.dart';

enum AddAddressStatus { initial, submitting, success, failure }

enum AddressSubmissionMode { create, update }

enum AddressLabel { home, work, other }

extension AddressLabelX on AddressLabel {
  String get value {
    switch (this) {
      case AddressLabel.home:
        return 'home';
      case AddressLabel.work:
        return 'work';
      case AddressLabel.other:
        return 'other';
    }
  }
}

AddressLabel addressLabelFromValue(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'work':
      return AddressLabel.work;
    case 'other':
      return AddressLabel.other;
    case 'home':
    default:
      return AddressLabel.home;
  }
}

class AddAddressState extends Equatable {
  const AddAddressState({
    this.status = AddAddressStatus.initial,
    this.selectedLabel = AddressLabel.home,
    this.isDefault = true,
    this.submissionMode = AddressSubmissionMode.create,
    this.editingAddressId,
    this.message,
  });

  final AddAddressStatus status;
  final AddressLabel selectedLabel;
  final bool isDefault;
  final AddressSubmissionMode submissionMode;
  final int? editingAddressId;
  final String? message;

  bool get isSubmitting => status == AddAddressStatus.submitting;
  bool get isEditing =>
      submissionMode == AddressSubmissionMode.update &&
      editingAddressId != null;

  AddAddressState copyWith({
    AddAddressStatus? status,
    AddressLabel? selectedLabel,
    bool? isDefault,
    AddressSubmissionMode? submissionMode,
    int? editingAddressId,
    bool preserveEditingAddressId = true,
    String? message,
    bool clearMessage = false,
  }) {
    return AddAddressState(
      status: status ?? this.status,
      selectedLabel: selectedLabel ?? this.selectedLabel,
      isDefault: isDefault ?? this.isDefault,
      submissionMode: submissionMode ?? this.submissionMode,
      editingAddressId: preserveEditingAddressId
          ? (editingAddressId ?? this.editingAddressId)
          : editingAddressId,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedLabel,
    isDefault,
    submissionMode,
    editingAddressId,
    message,
  ];
}
