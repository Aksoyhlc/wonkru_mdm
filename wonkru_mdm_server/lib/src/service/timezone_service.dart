import 'package:serverpod/serverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../generated/protocol.dart';
import 'setting_service.dart';

/// Installation-wide time zone setting. Timestamps are carried as UTC instants
/// everywhere; display and export use the region selected here, falling back to
/// UTC when unset. The value is an IANA region name (`Europe/Istanbul`), never a
/// fixed offset, so DST is handled correctly. Not per user.
class TimezoneService {
  const TimezoneService._();

  static const settingKey = 'panel_timezone';

  static const fieldName = 'panelTimezone';

  static bool _initialized = false;

  /// Loads the IANA zone database and is idempotent. Zone resolution depends on
  /// it, so the server calls it once at startup.
  static void ensureInitialized() {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    _initialized = true;
  }

  static Future<String?> name(
    Session session, {
    Transaction? transaction,
  }) async {
    final stored = await SettingService.raw(
      session,
      settingKey,
      transaction: transaction,
    );
    final trimmed = stored?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static Future<tz.Location?> current(
    Session session, {
    Transaction? transaction,
  }) async => resolve(await name(session, transaction: transaction));

  static tz.Location? resolve(String? value) {
    ensureInitialized();

    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    return tz.timeZoneDatabase.locations[trimmed];
  }

  /// Empty is accepted, unknown names are rejected. The error carries
  /// `fieldName` so the panel can show it under the field.
  static void validate(String? value) {
    ensureInitialized();

    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return;
    if (tz.timeZoneDatabase.locations.containsKey(trimmed)) return;

    throw AdminSettingsException(
      field: fieldName,
      message: 'Bilinmeyen saat dilimi: "$trimmed".',
    );
  }
}
