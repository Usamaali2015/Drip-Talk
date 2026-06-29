import 'package:drip_talk/features/payment_methods/data/models/payment_method_model.dart';
import 'package:drip_talk/generated/assets.dart';

class PaymentMethodsRepository {
  Future<PaymentMethodsCatalog> getPaymentMethodsCatalog() async {
    return const PaymentMethodsCatalog(
      preferredMethodId: 'apple_pay',
      digitalWallets: [
        PaymentMethodModel(
          id: 'google_pay',
          type: PaymentMethodType.googlePay,
          assetPath: Assets.iconsGoogle,
          badgeType: PaymentMethodBadgeType.recommended,
          supportedPaymentTypes: [SupportedPaymentType.creditDebit],
        ),
        PaymentMethodModel(
          id: 'apple_pay',
          type: PaymentMethodType.applePay,
          assetPath: Assets.iconsApple,
          badgeType: PaymentMethodBadgeType.iosAndMac,
          supportedPaymentTypes: [SupportedPaymentType.creditDebit],
        ),
      ],
      supportedPaymentTypes: [SupportedPaymentType.creditDebit],
    );
  }
}
