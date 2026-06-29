abstract class PaymentMethodsEvent {
  const PaymentMethodsEvent();
}

class LoadPaymentMethodsRequested extends PaymentMethodsEvent {
  const LoadPaymentMethodsRequested();
}

class PaymentMethodSelected extends PaymentMethodsEvent {
  const PaymentMethodSelected(this.methodId);

  final String methodId;
}
