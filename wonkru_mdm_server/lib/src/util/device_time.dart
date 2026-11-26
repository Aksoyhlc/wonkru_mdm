library;

/// Matches ISO-8601 text carrying an explicit UTC offset (`Z` or `±hh:mm` /
/// `±hhmm` / `±hh`).
final RegExp _explicitOffset = RegExp(r'(Z|[+-]\d{2}(:?\d{2})?)$');

/// Returns `null` when the zone is ambiguous. An offset-less timestamp cannot
/// be trusted: `DateTime.tryParse` treats it as the server's local time, which
/// drifts by hours when device and server are in different zones, so callers
/// fall back to the server's receive time. For synchronous RPCs that costs only
/// network latency, which beats a wrong-zone shift.
DateTime? parseDeviceTimestamp(String? raw) {
  final text = raw?.trim();
  if (text == null || text.isEmpty) return null;
  if (!_explicitOffset.hasMatch(text)) return null;
  // A date-only value (`2026-09-24`) ends in a `-24` that looks like an offset;
  // without a time component there is no zone information either.
  if (!text.contains('T') && !text.contains(' ')) return null;
  return DateTime.tryParse(text)?.toUtc();
}
