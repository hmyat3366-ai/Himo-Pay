import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0', 'en_US');

  /// Formats an integer amount to Myanmar Kyat format (e.g. 125,000 MMK)
  static String formatMMK(num amount, {bool includeSymbol = true}) {
    final formatted = _formatter.format(amount);
    return includeSymbol ? '$formatted MMK' : formatted;
  }

  /// Formats number without MMK symbol suffix (e.g. "50,000")
  static String formatNumberOnly(num amount) {
    return _formatter.format(amount);
  }

  /// Parses a formatted amount string like "25,000" back to int
  static int parseAmount(String input) {
    final sanitized = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(sanitized) ?? 0;
  }
}
