enum ContactSupportIssueType {
  orderIssue('order_issue'),
  paymentIssue('payment_issue'),
  shippingDelay('shipping_delay'),
  returnRefund('return_refund'),
  accountIssue('account_issue'),
  other('other');

  const ContactSupportIssueType(this.value);

  final String value;
}
