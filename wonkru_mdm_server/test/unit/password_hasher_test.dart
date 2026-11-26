import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/util/password_hasher.dart';

void main() {
  const pepper = 'test-pepper';
  const password = 'secret-password';

  setUp(() {
    PasswordHasher.debugPepper = pepper;
  });

  tearDown(() {
    PasswordHasher.debugPepper = null;
    PasswordHasher.debugConfigLookup = null;
  });

  group('Given PasswordHasher.verify', () {
    test('argon2 hash is verified', () async {
      final hash = await PasswordHasher.hash(password);

      expect(hash, startsWith(r'$argon2'));
      expect(
        await PasswordHasher.verify(password: password, hash: hash),
        isTrue,
      );
      expect(
        await PasswordHasher.verify(password: 'wrong-password', hash: hash),
        isFalse,
      );
    });

    test('non-argon2 records are rejected', () async {
      expect(
        await PasswordHasher.verify(
          password: 'any-password',
          hash: r'$2y$12$lt1.c52Gec25kmCrJzCyfeljvNzUDlXqsGdiliZ81lqxCfpvuUrLq',
        ),
        isFalse,
      );
      expect(
        await PasswordHasher.verify(password: 'plain', hash: 'plain'),
        isFalse,
      );
    });

    test('empty hash is rejected', () async {
      expect(
        await PasswordHasher.verify(password: password, hash: ''),
        isFalse,
      );
    });
  });

  group('Given PasswordHasher.isHashed', () {
    test('only argon2 hashes are reported as hashed', () async {
      final hash = await PasswordHasher.hash(password);

      expect(PasswordHasher.isHashed(hash), isTrue);
      expect(PasswordHasher.isHashed(r'$2y$12$abc'), isFalse);
      expect(PasswordHasher.isHashed('plain'), isFalse);
    });
  });

  group('Given PasswordHasher pepper', () {
    test('hash throws when pepper is missing', () async {
      PasswordHasher.debugPepper = '';

      expect(() => PasswordHasher.hash(password), throwsStateError);
    });

    test('argon2 verification throws when pepper is missing', () async {
      PasswordHasher.debugPepper = '';

      expect(
        () => PasswordHasher.verify(
          password: password,
          hash:
              r'$argon2id$v=19$m=4096,t=3,p=1$c2FsdHNhbHRzYWx0c2FsdA$Zm9vYmFyYmF6cXV1eA',
        ),
        throwsStateError,
      );
    });

    test('empty hash is rejected even without pepper', () async {
      PasswordHasher.debugPepper = '';

      expect(
        await PasswordHasher.verify(password: password, hash: ''),
        isFalse,
      );
    });
  });

  group('Given PasswordHasher pepper fallback', () {
    test('uses passwordHashPepper when no pepper is given', () async {
      PasswordHasher.debugPepper = null;
      PasswordHasher.debugConfigLookup = (_) => 'config-pepper';

      expect(PasswordHasher.isConfigured, isTrue);

      final hash = await PasswordHasher.hash(password);
      expect(hash, startsWith(r'$argon2'));
      expect(
        await PasswordHasher.verify(password: password, hash: hash),
        isTrue,
      );
    });

    test('throws when neither the env nor the config provides a pepper', () {
      PasswordHasher.debugPepper = null;
      PasswordHasher.debugConfigLookup = (_) => null;

      expect(PasswordHasher.isConfigured, isFalse);
      expect(() => PasswordHasher.hash(password), throwsStateError);
    });

    test('debugPepper takes priority over the config value', () async {
      PasswordHasher.debugPepper = 'debug-pepper';
      PasswordHasher.debugConfigLookup = (_) => 'config-pepper';
      final hash = await PasswordHasher.hash(password);

      PasswordHasher.debugPepper = null;

      expect(
        await PasswordHasher.verify(password: password, hash: hash),
        isFalse,
      );
    });
  });
}
