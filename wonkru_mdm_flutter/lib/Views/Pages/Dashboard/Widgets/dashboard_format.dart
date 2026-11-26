import 'package:intl/intl.dart';

class DashboardFormat {
  const DashboardFormat._();

  static final _number = NumberFormat.decimalPattern('tr');

  /// Formats a possibly missing count; `—` when null.
  static String count(int? value) =>
      value == null ? '—' : _number.format(value);

  static String number(int value) => _number.format(value);

  /// Fraction of [value] over [total]; null when unknowable.
  static double? ratio(int? value, int total) =>
      value == null || total == 0 ? null : value / total;

  static String share(int value, int total) {
    if (total == 0) return '%0';
    final share = value * 100 / total;
    return '%${share.toStringAsFixed(share >= 10 || share == 0 ? 0 : 1)}';
  }

  static String dayLabel(String label) => label.replaceFirst(' ', '.');

  static String hourLabel(String label) {
    final space = label.lastIndexOf(' ');
    return space < 0 ? label : label.substring(space + 1);
  }
}
