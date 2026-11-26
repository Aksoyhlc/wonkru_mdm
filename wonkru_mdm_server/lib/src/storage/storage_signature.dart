import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Signs the local storage's upload and download links.
///
/// The path, action, expiry, and size limit travel inside an HMAC-signed token
/// rather than a database row: as long as the server can verify the token, no
/// extra record is needed.
///
/// The key is derived from a configured secret ([StorageSignature.resolve]), so
/// the 7-day signed download links do not die on restart and multiple instances
/// verify the same token.
class StorageSignature {
  StorageSignature._(this._key);

  static const minSecretLength = 32;

  /// Domain separation: the derived key stays independent even if the same
  /// secret is reused for another purpose.
  static const _derivationLabel = 'wonkru-storage-signature-v1';

  /// Random per-process key, used only as a last resort when no secret exists;
  /// every signed link becomes invalid on restart.
  factory StorageSignature.generate() {
    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
    return StorageSignature._(key);
  }

  factory StorageSignature.fromSecret(String secret) {
    final key = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(_derivationLabel)).bytes;
    return StorageSignature._(key);
  }

  /// Resolution order:
  ///  1. [signingKey] (`passwords.yaml` -> `storageSigningKey`, or
  ///     `SERVERPOD_PASSWORD_storageSigningKey`); at least [minSecretLength] chars.
  ///  2. [fallbackSecret] (e.g. `jwtHmacSha512PrivateKey`): stable but not a
  ///     dedicated secret; warns in `production`/`staging`.
  ///  3. Random per-process key (with a warning).
  static StorageSignature resolve({
    required String? signingKey,
    required String? fallbackSecret,
    required String runMode,
    required void Function(String message) warn,
  }) {
    final isDeployed = runMode == 'production' || runMode == 'staging';

    if (signingKey != null && signingKey.length >= minSecretLength) {
      return StorageSignature.fromSecret(signingKey);
    }
    if (signingKey != null && signingKey.isNotEmpty) {
      warn(
        'WARNING: storageSigningKey is shorter than $minSecretLength '
        'characters; ignored.',
      );
    }

    if (fallbackSecret != null && fallbackSecret.isNotEmpty) {
      if (isDeployed) {
        warn(
          'WARNING: storageSigningKey is not set ($runMode). Signed storage '
          'links are derived from the JWT key; add a separate '
          '`storageSigningKey` of at least $minSecretLength characters to '
          'passwords.yaml.',
        );
      }
      return StorageSignature.fromSecret(fallbackSecret);
    }

    warn(
      'WARNING: no storageSigningKey and no fallback secret; signed storage '
      'links are signed with a random per-process key and will become '
      'invalid on restart.',
    );
    return StorageSignature.generate();
  }

  final List<int> _key;

  /// Upload token claims: path, max size, expected size, expiry.
  String signUpload({
    required String storageId,
    required String path,
    required int maxSize,
    required int? contentLength,
    required DateTime expiration,
    required bool preventOverwrite,
  }) => _sign({
    'a': 'upload',
    's': storageId,
    'p': path,
    'm': maxSize,
    'c': ?contentLength,
    'o': preventOverwrite,
    'e': expiration.toUtc().millisecondsSinceEpoch,
  });

  /// Download token claims: path, expiry.
  String signDownload({
    required String storageId,
    required String path,
    required DateTime expiration,
  }) => _sign({
    'a': 'download',
    's': storageId,
    'p': path,
    'e': expiration.toUtc().millisecondsSinceEpoch,
  });

  /// Returns the signed claims, so the caller applies the token's path and
  /// limits rather than values from the client. `null` on a bad signature or an
  /// expired token.
  Map<String, dynamic>? verify(String token, {required String action}) {
    final parts = token.split('.');
    if (parts.length != 2) return null;

    final payload = parts[0];
    final expected = _digest(payload);
    // Constant-time comparison so the signature cannot be guessed.
    if (!_constantTimeEquals(parts[1], expected)) return null;

    final Map<String, dynamic> claims;
    try {
      claims =
          jsonDecode(utf8.decode(base64Url.decode(payload)))
              as Map<String, dynamic>;
    } catch (_) {
      return null;
    }

    if (claims['a'] != action) return null;

    final expiresAt = claims['e'];
    if (expiresAt is! int) return null;
    if (DateTime.now().toUtc().millisecondsSinceEpoch > expiresAt) return null;

    return claims;
  }

  String _sign(Map<String, dynamic> claims) {
    final payload = base64Url.encode(utf8.encode(jsonEncode(claims)));
    return '$payload.${_digest(payload)}';
  }

  String _digest(String payload) =>
      Hmac(sha256, _key).convert(utf8.encode(payload)).toString();

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;

    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
