// ============================================================
// UTILS: formatter.dart
// Utilitas format mata uang, tanggal, dan angka
// ============================================================
 
import 'package:intl/intl.dart';
 
class Formatter {
  // ── FORMAT RUPIAH ─────────────────────────────────────────
  static String currency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return format.format(amount);
  }
 
  // Format singkat: 1.5jt, 250rb
  static String currencyShort(double amount) {
    if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return currency(amount);
  }
 
  // ── FORMAT TANGGAL ────────────────────────────────────────
  static String date(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }
 
  static String dateTime(DateTime date) {
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
  }
 
  static String dateShort(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }
 
  // ── FORMAT ANGKA ─────────────────────────────────────────
  static String number(int value) {
    return NumberFormat('#,###', 'id_ID').format(value);
  }
 
  // Format rating: 4.8
  static String rating(double value) {
    return value.toStringAsFixed(1);
  }
 
  // Format persen diskon
  static String discount(double percent) {
    return '${percent.toInt()}%';
  }
}
 