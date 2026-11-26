import 'package:timezone/timezone.dart' as tz;

/// The single place that produces date/time text on the server. Timestamps are
/// carried as UTC instants everywhere; display and export text is produced in
/// the panel's chosen zone, falling back to UTC when no zone is set. Never a
/// fixed offset, so DST comes from the zone name.
class ServerTime {
  const ServerTime._();

  /// Writes `dd.MM.yyyy HH:mm`, optionally with seconds.
  static String format(
    DateTime moment,
    tz.Location? zone, {
    bool withSeconds = false,
  }) {
    final zoned = zone == null
        ? moment.toUtc()
        : tz.TZDateTime.from(moment, zone);

    final text =
        '${_two(zoned.day)}.${_two(zoned.month)}.${zoned.year} '
        '${_two(zoned.hour)}:${_two(zoned.minute)}';

    return withSeconds ? '$text:${_two(zoned.second)}' : text;
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
