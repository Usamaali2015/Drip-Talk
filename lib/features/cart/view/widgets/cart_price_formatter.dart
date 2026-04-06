String formatCartPrice(
  double? amount, {
  String? currency,
  bool hideZeroDecimals = false,
}) {
  final resolvedAmount = amount ?? 0;
  final normalizedCurrency = currency?.trim().toUpperCase();
  final formattedAmount = hideZeroDecimals && resolvedAmount % 1 == 0
      ? resolvedAmount.toStringAsFixed(0)
      : resolvedAmount.toStringAsFixed(2);

  if (normalizedCurrency == null ||
      normalizedCurrency.isEmpty ||
      normalizedCurrency == 'USD' ||
      normalizedCurrency == '\$') {
    return '\$$formattedAmount';
  }

  return '$formattedAmount $normalizedCurrency';
}
