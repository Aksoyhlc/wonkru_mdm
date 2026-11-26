import 'package:shared_preferences/shared_preferences.dart';

/// UI preferences stored on the device (web: `localStorage`).
///
/// Not secret; session/token data must never live here. When storage is
/// unreachable (tests, private window) reads return `null` and writes are
/// silently skipped, so the preference only holds for that session.
class PreferencesRepository {
  const PreferencesRepository._();

  static const _scaleKey = 'ui.scale';
  static const _themeModeKey = 'ui.themeMode';
  static const _localeKey = 'ui.locale';

  static final _prefs = SharedPreferencesAsync();

  static Future<double?> scale() async {
    try {
      return await _prefs.getDouble(_scaleKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveScale(double value) async {
    try {
      await _prefs.setDouble(_scaleKey, value);
    } catch (_) {}
  }

  /// Stored theme mode name (`light`, `dark`, `system`); null when unset.
  static Future<String?> themeMode() async {
    try {
      return await _prefs.getString(_themeModeKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveThemeMode(String value) async {
    try {
      await _prefs.setString(_themeModeKey, value);
    } catch (_) {}
  }

  /// Stored UI locale tag (`tr-TR`, `en-US`); null when unset.
  static Future<String?> locale() async {
    try {
      return await _prefs.getString(_localeKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLocale(String value) async {
    try {
      await _prefs.setString(_localeKey, value);
    } catch (_) {}
  }
}
