import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  static String currency(num value) {
    return NumberFormat.currency(symbol: '\$').format(value);
  }

  static String compact(num value) {
    return NumberFormat.compact().format(value);
  }
}
