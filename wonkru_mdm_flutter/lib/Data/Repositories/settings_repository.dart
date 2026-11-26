import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Logging/wlog.dart';
import '../Client/serverpod_client.dart';

const _tag = 'SettingsRepository';

class SettingsRepository {
  const SettingsRepository._();

  static const defaultOfflineTimeoutMinutes = 5;

  /// Device list and detail must not refetch the setting on every paint;
  /// [save] invalidates this.
  static int? _offlineTimeoutCache;

  static Future<SettingsFormState> get() => serverpodClient.adminSettings.get();

  static Future<String?> mdmApkUrl() =>
      serverpodClient.adminSettings.getMdmApkUrl();

  /// Window in which devices count as "online" (minutes); falls back to
  /// [defaultOfflineTimeoutMinutes] when the setting is missing or unreadable.
  static Future<int> offlineTimeout() async {
    final cached = _offlineTimeoutCache;
    if (cached != null) return cached;

    try {
      final state = await get();
      if (state.offlineTimeout > 0) {
        _offlineTimeoutCache = state.offlineTimeout;
        return state.offlineTimeout;
      }
    } catch (e, st) {
      WLog.e(_tag, 'could not read offline_timeout', error: e, stackTrace: st);
    }

    return defaultOfflineTimeoutMinutes;
  }

  static Future<void> save(SettingsFormState state) async {
    await serverpodClient.adminSettings.save(state);
    _offlineTimeoutCache = null;
  }

  static Future<List<SmtpTestNotice>> sendSmtpTestMail(
    SettingsFormState state,
    String? recipient,
  ) => serverpodClient.adminSettings.sendSmtpTestMail(state, recipient);

  /// Needed before the settings page opens (the panel renders all times in
  /// this zone, see `AppTime`), so only the zone is fetched, not the whole form.
  static Future<String?> timezone() =>
      serverpodClient.adminSettings.getTimezone();

  /// Generates a key on the server if none exists yet.
  static Future<String> enrollmentKey() =>
      serverpodClient.adminSettings.getEnrollmentKey();

  /// Already-registered devices are not affected.
  static Future<String> rotateEnrollmentKey() =>
      serverpodClient.adminSettings.rotateEnrollmentKey();
}
