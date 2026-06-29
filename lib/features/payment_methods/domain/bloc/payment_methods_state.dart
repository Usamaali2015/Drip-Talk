import 'package:drip_talk/features/payment_methods/data/models/payment_method_model.dart';
import 'package:equatable/equatable.dart';

enum PaymentMethodsStatus { initial, loading, success, failure }

class PaymentMethodsState extends Equatable {
  const PaymentMethodsState({
    this.status = PaymentMethodsStatus.initial,
    this.wallets = const <PaymentMethodModel>[],
    this.supportedPaymentTypes = const <SupportedPaymentType>[],
    this.selectedMethodId,
    this.errorMessage,
  });

  final PaymentMethodsStatus status;
  final List<PaymentMethodModel> wallets;
  final List<SupportedPaymentType> supportedPaymentTypes;
  final String? selectedMethodId;
  final String? errorMessage;

  bool get isInitialLoading =>
      status == PaymentMethodsStatus.loading && wallets.isEmpty;

  bool get isFailure => status == PaymentMethodsStatus.failure;

  bool get hasWallets => wallets.isNotEmpty;

  bool get isEmpty => status == PaymentMethodsStatus.success && wallets.isEmpty;

  PaymentMethodModel? get selectedMethod {
    for (final wallet in wallets) {
      if (wallet.id == selectedMethodId) {
        return wallet;
      }
    }

    return wallets.isEmpty ? null : wallets.first;
  }

  List<SupportedPaymentType> get visibleSupportedPaymentTypes {
    final method = selectedMethod;
    if (method == null || method.supportedPaymentTypes.isEmpty) {
      return supportedPaymentTypes;
    }

    return method.supportedPaymentTypes;
  }

  PaymentMethodsState copyWith({
    PaymentMethodsStatus? status,
    List<PaymentMethodModel>? wallets,
    bool clearWallets = false,
    List<SupportedPaymentType>? supportedPaymentTypes,
    bool clearSupportedPaymentTypes = false,
    String? selectedMethodId,
    bool clearSelectedMethodId = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PaymentMethodsState(
      status: status ?? this.status,
      wallets: clearWallets
          ? const <PaymentMethodModel>[]
          : wallets ?? this.wallets,
      supportedPaymentTypes: clearSupportedPaymentTypes
          ? const <SupportedPaymentType>[]
          : supportedPaymentTypes ?? this.supportedPaymentTypes,
      selectedMethodId: clearSelectedMethodId
          ? null
          : selectedMethodId ?? this.selectedMethodId,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    wallets,
    supportedPaymentTypes,
    selectedMethodId,
    errorMessage,
  ];
}
