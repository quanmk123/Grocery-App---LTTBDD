import 'package:intl/intl.dart';

/// Format helpers cho currency, date, etc.
class Formatters {
  Formatters._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  static final NumberFormat _usdFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  /// Format tiền tệ VND
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format tiền tệ USD
  static String formatUSD(double amount) {
    return _usdFormat.format(amount);
  }

  /// Format số đơn giản có dấu phẩy
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  /// Format ngày giờ
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Format ngày
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Format thời gian
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format ngày dạng "2 giờ trước", "hôm qua", etc.
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return formatDate(dateTime);
  }

  /// Format rating
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Discount text
  static String formatDiscount(int discount) {
    return '-$discount%';
  }
}
