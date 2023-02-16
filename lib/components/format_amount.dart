import 'package:intl/intl.dart';

///
///  This function is responsible for controlling how currency is displayed in the application.
///
final _amountFormat = NumberFormat.compactCurrency(
    symbol: String.fromCharCode(0x20A6), decimalDigits: 2);
String formatAmount(num amount) {
  return _amountFormat.format(amount);
}
