import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/export.dart';
import 'package:serverpod/serverpod.dart';

/// AES-256-GCM wrapper that keeps the TOTP secret encrypted at rest. The key is
/// derived from the `PASSWORD_HASH_PEPPER` source (shared with `PasswordHasher`
/// but hashed with a `wonkru-totp-v1:` prefix for domain separation), so the
/// secret is never written to the database in plaintext. Stored as
/// `base64(nonce || ciphertext+tag)`.
class TotpSecretCipher {
  TotpSecretCipher._();

  /// GCM nonce length in bytes.
  static const _nonceLength = 12;

  /// GCM authentication tag in bits.
  static const _tagLength = 128;

  /// Lets tests mimic `PASSWORD_HASH_PEPPER`. When null the real environment is
  /// read; an empty string means "undefined".
  @visibleForTesting
  static String? debugPepper;

  /// Pepper source, in priority order: [debugPepper] (tests; `''` means
  /// undefined), the `PASSWORD_HASH_PEPPER` environment variable, then
  /// `passwordHashPepper` in `config/passwords.yaml`. Returns `null` when none
  /// is set; the caller does not fall back to a silent default.
  static String? get _configured {
    final debug = debugPepper;
    if (debug != null) return debug.isEmpty ? null : debug;

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

  /// Used to warn early at startup: without a pepper, 2FA setup and policy admin
  /// password endpoints return 500.
  static bool get isConfigured => _configured != null;

  /// Fails rather than falling back to a silent default: a fixed key is a
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

  /// AES-256 key: `SHA-256("wonkru-totp-v1:" + pepper)`.
  static Uint8List _key() {
    final digest = sha256.convert(utf8.encode('wonkru-totp-v1:$_pepper'));
    return Uint8List.fromList(digest.bytes);
  }

  static String encrypt(String plaintext) {
    final nonce = _randomBytes(_nonceLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(_key()), _tagLength, nonce, Uint8List(0)),
      );
    final encrypted = cipher.process(
      Uint8List.fromList(utf8.encode(plaintext)),
    );

    return base64.encode(Uint8List.fromList([...nonce, ...encrypted]));
  }

  /// Throws [FormatException] on corrupt data or a wrong key; the raw crypto
  /// exception is not leaked.
  static String decrypt(String encoded) {
    final raw = base64.decode(encoded);
    if (raw.length <= _nonceLength) {
      throw const FormatException('Encrypted secret could not be read.');
    }

    final nonce = Uint8List.sublistView(raw, 0, _nonceLength);
    final data = Uint8List.sublistView(raw, _nonceLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(_key()), _tagLength, nonce, Uint8List(0)),
      );

    try {
      return utf8.decode(cipher.process(data));
    } on InvalidCipherTextException {
      throw const FormatException('Encrypted secret could not be read.');
    }
  }

  static Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
