import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Hashes and verifies policy admin passwords with the Serverpod auth module's
/// Argon2id, so the panel and the device agent agree on one format.
class PasswordHasher {
  PasswordHasher._();

  /// Argon2 salt length in bytes.
  static const _saltLength = 16;

  /// Lets tests mimic `PASSWORD_HASH_PEPPER`. When null the real environment is
  /// read; an empty string means "undefined".
  @visibleForTesting
  static String? debugPepper;

  /// Lets tests mimic `config/passwords.yaml` without a `Serverpod` instance.
  /// When set it stands in for the config value and bypasses the environment,
  /// so tests do not depend on the shell.
  @visibleForTesting
  static String? Function(String key)? debugConfigLookup;

  /// Pepper source, in priority order: [debugPepper] (tests; `''` means
  /// undefined), then in production the `PASSWORD_HASH_PEPPER` environment
  /// variable and `passwordHashPepper` in `config/passwords.yaml`. Returns
  /// `null` when none is set; the caller does not fall back to a silent
  /// default. Kept identical to `TotpSecretCipher` so both derive from the same
  /// secret.
  static String? get _configured {
    final debug = debugPepper;
    if (debug != null) return debug.isEmpty ? null : debug;

    final configLookup = debugConfigLookup;
    if (configLookup != null) {
      final fromConfig = configLookup('passwordHashPepper');
      return (fromConfig == null || fromConfig.isEmpty) ? null : fromConfig;
    }

    final fromEnvironment = Platform.environment['PASSWORD_HASH_PEPPER'];
    if (fromEnvironment != null && fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }

    // Ignored when there is no `Serverpod` instance, e.g. in a unit test.
    try {
      final fromConfig = Serverpod.instance.getPassword('passwordHashPepper');
      return (fromConfig == null || fromConfig.isEmpty) ? null : fromConfig;
    } on StateError {
      return null;
    }
  }

  /// Used to warn early at startup: without a pepper, policy admin password and
  /// 2FA recovery code endpoints return 500.
  static bool get isConfigured => _configured != null;

  /// Fails rather than falling back to a silent default: a fixed pepper is a
  /// security hole.
  static String get _pepper {
    final value = _configured;
    if (value == null) {
      throw StateError(
        'PASSWORD_HASH_PEPPER is not set. Provide the environment variable or '
        'add `passwordHashPepper` to config/passwords.yaml.',
      );
    }
    return value;
  }

  static Argon2HashUtil _argon2(String pepper) =>
      Argon2HashUtil(hashPepper: pepper, hashSaltLength: _saltLength);

  /// Produces a PHC-format Argon2id hash.
  static Future<String> hash(String password) =>
      _argon2(_pepper).createHashFromString(secret: password);

  /// Verifies [password] against an Argon2id (`$argon2…`) [hash].
  ///
  /// Only Argon2id hashes are accepted; any other format returns `false`. The
  /// pepper is required; a missing one throws [StateError] rather than failing
  /// silently. An empty [hash] is always `false`.
  static Future<bool> verify({
    required String password,
    required String hash,
  }) async {
    if (hash.isEmpty || !hash.startsWith(r'$argon2')) {
      return false;
    }

    return _argon2(
      _pepper,
    ).validateHashFromString(secret: password, hashString: hash);
  }

  /// Whether [hash] is an Argon2id PHC hash.
  static bool isHashed(String hash) => hash.startsWith(r'$argon2');
}
