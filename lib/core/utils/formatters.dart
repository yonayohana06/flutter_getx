import 'package:intl/intl.dart';

class AppFormatters {
  // ── Date ───────────────────────────────────────────────────
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  // ── Currency ───────────────────────────────────────────────
  static String formatCurrency(
    double amount, {
    String locale = 'id_ID',
    String symbol = 'Rp',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // ── Number ─────────────────────────────────────────────────
  static String formatCompact(num number) {
    return NumberFormat.compact().format(number);
  }

  // ── String ─────────────────────────────────────────────────
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String titleCase(String text) {
    return text.split(' ').map(capitalize).join(' ');
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final visible = name.length > 3 ? name.substring(0, 3) : name[0];
    return '$visible***@${parts[1]}';
  }

  static String maskPhone(String phone) {
    if (phone.length < 6) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 3)}';
  }
}
