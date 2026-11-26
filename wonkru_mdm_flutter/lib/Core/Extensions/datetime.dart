import 'package:get/get.dart';

import '../L10n/L.dart';
import '../Time/app_time.dart';

String formatShortDateLocale(DateTime d) {
  final locale = Get.locale?.toString() ?? 'en_US';
  return AppTime.instance.format(d, 'EEE, d MMM y', locale: locale);
}

/// Date/time formatters.
///
/// All go through [AppTime]: the panel's selected timezone applies, and UTC is
/// shown when unset, so no call site needs to know the timezone.
///
/// Relative time ([timeAgo]) is timezone-independent: it takes the difference
/// of two instants, so it is unaffected by wall-clock time.
extension DateTimeExtension on DateTime {
  String formatShortDate() => formatShortDateLocale(this);

  String formatDate([String format = 'dd.MM.yyyy']) {
    return AppTime.instance.format(this, format);
  }

  String formatDateTime([String format = 'dd.MM.yyyy HH:mm']) {
    return AppTime.instance.format(this, format);
  }

  String formatTime([String format = 'HH:mm']) {
    return AppTime.instance.format(this, format);
  }

  String timeAgo() => _relative();

  String relativeTr() => _relative();

  String _relative() {
    final diff = DateTime.now().difference(this);
    if (diff.isNegative) return formatDateTime();
    if (diff.inMinutes < 1) return L.common.timeJustNow;
    if (diff.inMinutes < 60) {
      return L.common.timeMinutesAgo.trParams({'count': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return L.common.timeHoursAgo.trParams({'count': '${diff.inHours}'});
    }
    if (diff.inDays < 30) {
      return L.common.timeDaysAgo.trParams({'count': '${diff.inDays}'});
    }
    if (diff.inDays < 365) {
      return L.common.timeMonthsAgo.trParams({
        'count': '${(diff.inDays / 30).floor()}',
      });
    }
    return L.common.timeYearsAgo.trParams({
      'count': '${(diff.inDays / 365).floor()}',
    });
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  DateTime get startOfYear => DateTime(year, 1, 1);

  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59);

  String get weekdayInEnglish {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String get monthInEnglish {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return '';
    }
  }
}
