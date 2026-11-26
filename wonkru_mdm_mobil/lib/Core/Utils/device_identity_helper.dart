import 'package:uuid/v7.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Extensions/string.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

class DeviceIdentityHelper {
  static StorageHelper get _storage => StorageHelper.instance;
  static BasicStorage get _basicStorage => BasicStorage.instance;

  static void saveCode(String code) {
    final c = code.trim();
    if (c.isEmpty) {
      _storage.remove(Sk.deviceCode.name);
      _basicStorage.remove(Sk.deviceCode.name);
    } else {
      _storage.setString(Sk.deviceCode.name, c);
      _basicStorage.setString(Sk.deviceCode.name, c);
    }
  }

  static void saveUuid(String uuid) {
    final u = uuid.trim();
    if (u.isEmpty) {
      _storage.remove(Sk.deviceUuid.name);
      _basicStorage.remove(Sk.deviceUuid.name);
    } else {
      _storage.setString(Sk.deviceUuid.name, u);
      _basicStorage.setString(Sk.deviceUuid.name, u);
    }
  }

  static void saveRegistration(String code, String uuid) {
    saveCode(code);
    saveUuid(uuid);
  }

  static void saveToken(String token) {
    final t = token.trim();
    if (t.isEmpty) {
      _storage.remove(Sk.deviceToken.name);
    } else {
      _storage.setString(Sk.deviceToken.name, t);
    }
  }

  static String? getToken() => _storage.getString(Sk.deviceToken.name);

  /// Clears local identity so the device re-enrolls from scratch. Does not touch
  /// the key pair.
  static Future<void> clearEnrollment() async {
    for (final key in [
      Sk.deviceCode.name,
      Sk.deviceUuid.name,
      Sk.deviceToken.name,
    ]) {
      _storage.remove(key);
      _basicStorage.remove(key);
    }
  }

  static String? getCode() => _storage.getString(Sk.deviceCode.name);

  static String? getUuid() => _storage.getString(Sk.deviceUuid.name);

  /// Returns the local device uuid, generating and saving one if absent.
  ///
  /// If the token exists but the uuid was lost, the generated random uuid does
  /// not match on the server: the server returns the real uuid via
  /// `DeviceIdentityMismatchException` and `EnrollmentRecovery.adoptIdentity`
  /// adopts it (no re-registration).
  static String getDeviceId() {
    String? uuid = getUuid();
    if (uuid.isNullOrEmpty) {
      uuid = UuidV7().generate();
      saveUuid(uuid);
    }
    return uuid!;
  }
}
