/// Formats a price in dollars, dropping the cents when they are zero.
///
/// `149` → `$149`, `149.5` → `$149.50`.
String formatPrice(double price) {
  final bool isWhole = price == price.roundToDouble();
  return '\$${isWhole ? price.toStringAsFixed(0) : price.toStringAsFixed(2)}';
}

/// Formats a count in a compact form: `212` → `212`, `1284` → `1.2k`.
String formatCompactCount(int count) {
  if (count < 1000) return '$count';
  // Truncate instead of rounding so 1,284 reads as 1.2k, never overstating.
  final String value = ((count ~/ 100) / 10).toStringAsFixed(1);
  return '${value.endsWith('.0') ? value.substring(0, value.length - 2) : value}k';
}

/// Formats a count with thousands separators: `1284` → `1,284`.
String formatCount(int count) {
  final String digits = '$count';
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
