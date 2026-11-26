import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';

/// Filters local storage dumps before sync so identity secrets never reach the server.
///
/// The secure store (`st`) uses an allowlist ([Sk] keys minus [secretKeys]) so
/// a secret added later is excluded by default. The plain store (`bs`) shares
/// keys with the Android side, so it uses a denylist instead.
class SyncStorageFilter {
  const SyncStorageFilter._();

  static final Set<String> secretKeys = {
    Sk.deviceToken.name,
    Sk.enrollmentKey.name,
    Sk.enrollmentKeyRejected.name,
    Sk.commandJournal.name,
    Sk.bt_management_admin_password.name,
    EnrollmentKeyStore.provisioningExtra,
    'device_config',
  };

  static final Set<String> secureAllowlist = {
    for (final key in Sk.values)
      if (!secretKeys.contains(key.name)) key.name,
  };

  static final Set<String> _plainNoise = {Sk.app_events.name};

  static Map<String, dynamic> secureStorage(Map<String, dynamic> data) => {
    for (final entry in data.entries)
      if (secureAllowlist.contains(entry.key)) entry.key: entry.value,
  };

  static Map<String, dynamic> basicStorage(Map<String, dynamic> data) => {
    for (final entry in data.entries)
      if (!secretKeys.contains(entry.key) && !_plainNoise.contains(entry.key))
        entry.key: entry.value,
  };
}
