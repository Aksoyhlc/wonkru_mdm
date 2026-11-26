/// The single user-facing date/time format for the server.
///
/// Panel tables, CSV exports and alert texts show the value in the server's
/// local zone; keeping one function stops the copies from drifting (some used
/// UTC, some added seconds). Null maps to an empty string so CSV rows keep
/// their column count.
String formatDateTime(DateTime? moment) {
  if (moment == null) {
    return '';
  }

  final local = moment.toLocal();
  String two(int value) => value.toString().padLeft(2, '0');

  return '${two(local.day)}.${two(local.month)}.${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
