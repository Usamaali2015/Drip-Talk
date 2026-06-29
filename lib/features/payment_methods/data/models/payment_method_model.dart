import 'package:equatable/equatable.dart';

enum PaymentMethodType { googlePay, applePay }

enum PaymentMethodBadgeType { recommended, iosAndMac }

enum SupportedPaymentType { creditDebit }

class PaymentMethodsCatalog extends Equatable {
  const PaymentMethodsCatalog({
    this.digitalWallets = const <PaymentMethodModel>[],
    this.supportedPaymentTypes = const <SupportedPaymentType>[],
    this.preferredMethodId,
  });

  final List<PaymentMethodModel> digitalWallets;
  final List<SupportedPaymentType> supportedPaymentTypes;
  final String? preferredMethodId;

  @override
  List<Object?> get props => [
    digitalWallets,
    supportedPaymentTypes,
    preferredMethodId,
  ];
}

class PaymentMethodModel extends Equatable {
  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.assetPath,
    required this.badgeType,
    this.supportedPaymentTypes = const <SupportedPaymentType>[],
  });

  final String id;
  final PaymentMethodType type;
  final String assetPath;
  final PaymentMethodBadgeType badgeType;
  final List<SupportedPaymentType> supportedPaymentTypes;

  @override
  List<Object?> get props => [
    id,
    type,
    assetPath,
    badgeType,
    supportedPaymentTypes,
  ];
}
