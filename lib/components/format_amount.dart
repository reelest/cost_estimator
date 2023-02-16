import 'package:intl/intl.dart';

final _amountFormat = NumberFormat.compactCurrency(
    symbol: String.fromCharCode(0x20A6), decimalDigits: 2);
String formatAmount(num amount) {
  return _amountFormat.format(amount);
}
