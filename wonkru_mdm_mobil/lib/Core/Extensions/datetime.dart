import 'package:get/get.dart';
import 'package:intl/intl.dart';

String formatShortDateLocale(DateTime d) {
  final locale = Get.locale?.toString() ?? 'en_US';
  return DateFormat('EEE, d MMM y', locale).format(d);
}

extension DateTimeExtension on DateTime {
  String formatShortDate() => formatShortDateLocale(this);

  String formatDateTime([String format = 'dd.MM.yyyy HH:mm']) {
    return DateFormat(format).format(this);
  }
}
