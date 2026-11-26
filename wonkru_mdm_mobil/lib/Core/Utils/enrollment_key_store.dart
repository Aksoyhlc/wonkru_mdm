import 'package:flutter/foundation.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

/// The device's global enrollment key.
///
/// The key arrives through the provisioning QR's `enrollment_key` extra, which
/// is written to plain [BasicStorage]; [adoptProvisioned] moves it to secure
/// storage ([StorageHelper], `Sk.enrollmentKey`) and deletes the plain copy.
/// Installations without a QR enter it through the setup screen via [save].
/// When the server rejects the key, [markRejected] stores the rejected value
/// and [isRejected] stays `true` until the key changes, so automatic
/// re-registration does not hammer the server.
class EnrollmentKeyStore {
  EnrollmentKeyStore({
    required String? Function(String key) readSecure,
    required void Function(String key, String value) writeSecure,
    required void Function(String key) removeSecure,
    required String? Function(String key) readPlain,
    required void Function(String key) removePlain,
  }) : _readSecure = readSecure,
       _writeSecure = writeSecure,
       _removeSecure = removeSecure,
       _readPlain = readPlain,
       _removePlain = removePlain;

  static const provisioningExtra = 'enrollment_key';

  static EnrollmentKeyStore? _instance;

  static EnrollmentKeyStore get instance => _instance ??= EnrollmentKeyStore(
    readSecure: StorageHelper.instance.getString,
    writeSecure: StorageHelper.instance.setString,
    removeSecure: StorageHelper.instance.remove,
    readPlain: (key) {
      try {
        return BasicStorage.instance.getString(key);
      } catch (_) {
        return null;
      }
    },
    removePlain: (key) {
      try {
        BasicStorage.instance.remove(key);
      } catch (_) {}
    },
  );

  @visibleForTesting
  static set instance(EnrollmentKeyStore? store) => _instance = store;

  final String? Function(String key) _readSecure;
  final void Function(String key, String value) _writeSecure;
  final void Function(String key) _removeSecure;
  final String? Function(String key) _readPlain;
  final void Function(String key) _removePlain;

  void adoptProvisioned() {
    final provisioned = _readPlain(provisioningExtra)?.trim();
    if (provisioned == null || provisioned.isEmpty) return;
    save(provisioned);
    _removePlain(provisioningExtra);
  }

  String? get key {
    adoptProvisioned();
    final value = _readSecure(Sk.enrollmentKey.name)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  void save(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _removeSecure(Sk.enrollmentKey.name);
      return;
    }
    if (_readSecure(Sk.enrollmentKeyRejected.name) != trimmed) {
      _removeSecure(Sk.enrollmentKeyRejected.name);
    }
    _writeSecure(Sk.enrollmentKey.name, trimmed);
  }

  void markRejected() {
    final current = key;
    // Mark even when no key exists: retrying the same state is pointless.
    _writeSecure(Sk.enrollmentKeyRejected.name, current ?? '');
  }

  bool get isRejected {
    final rejected = _readSecure(Sk.enrollmentKeyRejected.name);
    if (rejected == null) return false;
    return rejected == (key ?? '');
  }
}
