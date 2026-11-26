/// Backup schedule times stored in the `settings` table.
///
/// A schedule used to be a single `..._at` value; those keys are still read as
/// a fallback so an old database keeps working.
class BackupScheduleSettings {
  const BackupScheduleSettings._();

  static const cleanTimesKey = 'backup_schedule_clean_times';
  static const runTimesKey = 'backup_schedule_run_times';
  static const monitorTimesKey = 'backup_schedule_monitor_times';

  static const cleanAtKey = 'backup_schedule_clean_at';
  static const runAtKey = 'backup_schedule_run_at';
  static const monitorAtKey = 'backup_schedule_monitor_at';

  static const notifyUserIdsKey = 'backup_notify_user_ids';

  static const defaultCleanTimes = ['01:00'];
  static const defaultRunTimes = ['01:30'];
  static const defaultMonitorTimes = ['04:00'];

  static final timePattern = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');

  /// Reads one schedule: the stored list wins, then the legacy single value,
  /// then the fallback.
  static List<String> readTimes(
    dynamic stored,
    String? legacy,
    List<String> fallback,
  ) {
    if (stored is List && stored.isNotEmpty) {
      final normalized = normalizeTimes(stored);
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    if (legacy != null && timePattern.hasMatch(legacy)) {
      return [legacy];
    }

    return fallback;
  }

  /// Keeps only well-formed, unique `HH:mm` values.
  static List<String> normalizeTimes(dynamic times) {
    if (times is! List) {
      return const [];
    }

    final normalized = <String>[];
    for (final time in times) {
      if (time is! String) {
        continue;
      }
      final trimmed = time.trim();
      if (trimmed.isEmpty || !timePattern.hasMatch(trimmed)) {
        continue;
      }
      if (!normalized.contains(trimmed)) {
        normalized.add(trimmed);
      }
    }

    return normalized;
  }
}
