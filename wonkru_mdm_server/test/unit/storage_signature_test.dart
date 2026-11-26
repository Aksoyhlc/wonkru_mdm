import 'dart:convert';

import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/storage/storage_signature.dart';

/// The signing key is derived from the configured secret: the same secret
/// yields the same key, so tokens stay valid across restarts and on multiple
/// instances.
void main() {
  const secret = 'this-is-at-least-thirty-two-characters-secret-1234';

  String sign(StorageSignature signature) => signature.signDownload(
    storageId: 'private',
    path: 'certificates/a.p12',
    expiration: DateTime.utc(2099),
  );

  test('signatures derived from the same secret verify each other', () {
    final first = StorageSignature.fromSecret(secret);
    final restarted = StorageSignature.fromSecret(secret);

    expect(restarted.verify(sign(first), action: 'download'), isNotNull);
  });

  test('a different secret or a random key does not verify', () {
    final token = sign(StorageSignature.fromSecret(secret));

    expect(
      StorageSignature.fromSecret('$secret-other').verify(
        token,
        action: 'download',
      ),
      isNull,
    );
    expect(
      StorageSignature.generate().verify(token, action: 'download'),
      isNull,
    );
  });

  test('resolve uses storageSigningKey first, otherwise the fallback secret', () {
    final warnings = <String>[];
    final configured = StorageSignature.resolve(
      signingKey: secret,
      fallbackSecret: 'jwt',
      runMode: 'production',
      warn: warnings.add,
    );
    expect(warnings, isEmpty);
    expect(
      StorageSignature.fromSecret(
        secret,
      ).verify(sign(configured), action: 'download'),
      isNotNull,
    );

    final fallback = StorageSignature.resolve(
      signingKey: null,
      fallbackSecret: 'jwt-key',
      runMode: 'production',
      warn: warnings.add,
    );
    expect(warnings, hasLength(1), reason: 'a missing key warns in production');
    expect(
      StorageSignature.fromSecret(
        'jwt-key',
      ).verify(sign(fallback), action: 'download'),
      isNotNull,
    );
  });

  test(
    'the fallback secret is used silently in development; a short key is ignored',
    () {
      final warnings = <String>[];
      StorageSignature.resolve(
        signingKey: null,
        fallbackSecret: 'jwt',
        runMode: 'development',
        warn: warnings.add,
      );
      expect(warnings, isEmpty);

      final short = StorageSignature.resolve(
        signingKey: 'short',
        fallbackSecret: 'jwt',
        runMode: 'development',
        warn: warnings.add,
      );
      expect(warnings, hasLength(1));
      expect(
        StorageSignature.fromSecret(
          'jwt',
        ).verify(sign(short), action: 'download'),
        isNotNull,
      );
    },
  );

  group('verify rejects', () {
    final signature = StorageSignature.fromSecret(secret);

    String download({DateTime? expiration}) => signature.signDownload(
      storageId: 'private',
      path: 'certificates/a.p12',
      expiration: expiration ?? DateTime.now().add(const Duration(minutes: 5)),
    );

    String tamper(String token, Map<String, dynamic> Function(Map) edit) {
      final parts = token.split('.');
      final claims = jsonDecode(utf8.decode(base64Url.decode(parts[0]))) as Map;
      final forged = base64Url.encode(utf8.encode(jsonEncode(edit(claims))));
      return '$forged.${parts[1]}';
    }

    test('a valid token is accepted and returns the signed fields', () {
      final claims = signature.verify(download(), action: 'download');

      expect(claims, isNotNull);
      expect(claims!['s'], 'private');
      expect(claims['p'], 'certificates/a.p12');
    });

    test('an expired token', () {
      final token = download(
        expiration: DateTime.now().subtract(const Duration(seconds: 1)),
      );

      expect(signature.verify(token, action: 'download'), isNull);
    });

    test('a token signed for another action', () {
      expect(signature.verify(download(), action: 'upload'), isNull);
    });

    test('a payload with a tampered path (signature is of the old payload)', () {
      final forged = tamper(
        download(),
        (c) => {...c, 'p': '../passwords.yaml'},
      );

      expect(signature.verify(forged, action: 'download'), isNull);
    });

    test('a payload with an extended expiration', () {
      final expired = download(
        expiration: DateTime.now().subtract(const Duration(days: 1)),
      );
      final forged = tamper(
        expired,
        (c) => {...c, 'e': DateTime.utc(2099).millisecondsSinceEpoch},
      );

      expect(signature.verify(forged, action: 'download'), isNull);
    });

    for (final malformed in ['', 'single-part', 'a.b.c', '%%%.abc', '.']) {
      test('malformed token "$malformed"', () {
        expect(signature.verify(malformed, action: 'download'), isNull);
      });
    }
  });
}
