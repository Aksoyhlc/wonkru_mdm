import 'package:otp/otp.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_auth_service.dart';
import 'package:wonkru_mdm_server/src/service/admin_two_factor_service.dart';
import 'package:wonkru_mdm_server/src/util/password_hasher.dart';
import 'package:wonkru_mdm_server/src/util/totp_secret_cipher.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Admin 2FA', (sessionBuilder, endpoints) {
    const adminUserId = '33333333-3333-4333-8333-333333333333';
    const pepper = 'test-pepper';

    final adminUserIdValue = UuidValue.fromString(adminUserId);

    // Verification is keyed by session id; scenarios pass authId explicitly to
    // impersonate different sessions.
    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        const <Scope>{},
        authId: 'session-admin',
      ),
    );

    TestSessionBuilder builderFor(String authId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        const <Scope>{},
        authId: authId,
      ),
    );

    setUp(() async {
      TotpSecretCipher.debugPepper = pepper;
      PasswordHasher.debugPepper = pepper;

      final now = DateTime.now().toUtc();
      await AdminProfile.db.insertRow(
        sessionBuilder.build(),
        AdminProfile(
          userId: adminUserIdValue,
          status: AdminAccountStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    tearDown(() {
      TotpSecretCipher.debugPepper = null;
      PasswordHasher.debugPepper = null;
    });

    String codeAt(String secret, int stepOffset) => OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch + stepOffset * 30 * 1000,
      length: 6,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );

    String currentCode(String secret) => codeAt(secret, 0);

    Future<AdminProfile?> storedProfile() =>
        AdminProfile.db.findFirstRow(sessionBuilder.build());

    /// Replay protection rejects a used step, so each successful verification
    /// needs a fresh code. The test window is ±1 step, so used steps start one
    /// step behind real time.
    Future<String> freshCodeFromStoredSecret() async {
      final profile = await storedProfile();
      final secret = TotpSecretCipher.decrypt(profile!.totpSecret!);
      final now = DateTime.now().millisecondsSinceEpoch;
      final currentStep = (now / 1000 / 30).floor();
      final lastUsed = profile.totpLastUsedCounter ?? currentStep - 1;
      final nextStep = lastUsed + 1;
      final nextMillis = now + (nextStep - currentStep) * 30 * 1000;
      return OTP.generateTOTPCodeString(
        secret,
        nextMillis,
        length: 6,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
    }

    /// Confirmation uses the previous step's code so the current and next steps
    /// stay free for later verification tests (±1 step window).
    Future<List<String>> enableTwoFactor() async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      return endpoints.adminAuth.confirmTotpSetup(
        adminBuilder,
        codeAt(setup.secret, -1),
      );
    }

    test('stores the setup secret encrypted and returns the QR address', () async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);

      expect(setup.secret, isNotEmpty);
      expect(setup.otpauthUri, startsWith('otpauth://totp/'));
      expect(setup.otpauthUri, contains('secret=${setup.secret}'));

      final profile = await storedProfile();
      expect(profile?.totpSecret, isNotNull);
      expect(profile?.totpSecret, isNot(setup.secret));
      expect(profile?.recoveryCodes, isNull);

      final info = await endpoints.adminAuth.me(adminBuilder);
      expect(info.totpEnabled, isFalse);
    });

    test(
      'confirming with the right code generates recovery codes and enables the account',
      () async {
        final codes = await enableTwoFactor();

        expect(codes, hasLength(10));
        expect(codes.toSet(), hasLength(10));

        final profile = await storedProfile();
        expect(profile?.recoveryCodes, isNotNull);
        expect(profile?.recoveryCodes, isNot(contains(codes.first)));

        final info = await endpoints.adminAuth.me(adminBuilder);
        expect(info.totpEnabled, isTrue);
        expect(info.twoFactorRequired, isFalse);
      },
    );

    test('confirmation with a wrong code is rejected', () async {
      await endpoints.adminAuth.startTotpSetup(adminBuilder);

      await expectLater(
        endpoints.adminAuth.confirmTotpSetup(adminBuilder, '000000'),
        throwsA(isA<AdminTotpException>()),
      );

      final profile = await storedProfile();
      expect(profile?.recoveryCodes, isNull);
    });

    test('me() asks for a code while 2FA is enabled and unverified', () async {
      await enableTwoFactor();

      final info = await endpoints.adminAuth.me(builderFor('session-fresh'));

      expect(info.totpEnabled, isTrue);
      expect(info.twoFactorRequired, isTrue);
    });

    test('requireAdmin rejects while 2FA is enabled and unverified; '
        'it passes after verifyTotp', () async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      await endpoints.adminAuth.confirmTotpSetup(
        adminBuilder,
        codeAt(setup.secret, -1),
      );

      final freshBuilder = builderFor('session-fresh');
      await expectLater(
        AdminAuthService.requireAdmin(freshBuilder.build()),
        throwsA(isA<NotAuthorizedException>()),
      );

      final ok = await endpoints.adminAuth.verifyTotp(
        freshBuilder,
        await freshCodeFromStoredSecret(),
      );
      expect(ok, isTrue);

      final profile = await AdminAuthService.requireAdmin(
        freshBuilder.build(),
      );
      expect(profile.userId, adminUserIdValue);
    });

    test('a session with 2FA enabled and unverified cannot change the password', () async {
      await enableTwoFactor();

      await expectLater(
        endpoints.adminAuth.changePassword(
          builderFor('session-stolen'),
          'admin@example.com',
          'new-password',
        ),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });

    test('a session with 2FA enabled and unverified cannot change the email', () async {
      await enableTwoFactor();

      await expectLater(
        endpoints.adminAuth.changeEmail(
          builderFor('session-stolen'),
          'admin@example.com',
          'attacker@example.com',
        ),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
    });

    test(
      '2FA is required after a re-login and cleared after verification',
      () async {
        await enableTwoFactor();

        // The panel refreshes the session via `emailIdp.login` before a
        // credential change; the new session id carries no 2FA verification.
        final fresh = builderFor('session-relogin');
        var info = await endpoints.adminAuth.me(fresh);
        expect(info.totpEnabled, isTrue);
        expect(info.twoFactorRequired, isTrue);

        expect(
          await endpoints.adminAuth.verifyTotp(
            fresh,
            await freshCodeFromStoredSecret(),
          ),
          isTrue,
        );

        info = await endpoints.adminAuth.me(fresh);
        expect(info.twoFactorRequired, isFalse);
        expect(
          await AdminAuthService.requireAdmin(fresh.build()),
          isA<AdminProfile>(),
        );
      },
    );

    test('the same TOTP code is not accepted a second time', () async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      final code = currentCode(setup.secret);
      await endpoints.adminAuth.confirmTotpSetup(adminBuilder, code);

      final fresh = builderFor('session-fresh');
      expect(await endpoints.adminAuth.verifyTotp(fresh, code), isFalse);

      final next = codeAt(setup.secret, 1);
      expect(await endpoints.adminAuth.verifyTotp(fresh, next), isTrue);

      expect(
        await endpoints.adminAuth.verifyTotp(
          builderFor('session-third'),
          next,
        ),
        isFalse,
      );
    });

    test('repeated wrong codes temporarily lock the account', () async {
      await enableTwoFactor();
      final fresh = builderFor('session-fresh');

      for (var i = 0; i < AdminTwoFactorService.maxFailedAttempts - 1; i++) {
        expect(await endpoints.adminAuth.verifyTotp(fresh, '000000'), isFalse);
      }
      await expectLater(
        endpoints.adminAuth.verifyTotp(fresh, '000000'),
        throwsA(isA<AdminTotpException>()),
      );

      final profile = await storedProfile();
      expect(
        profile?.totpFailedAttempts,
        AdminTwoFactorService.maxFailedAttempts,
      );
      expect(profile?.totpLockedUntil, isNotNull);

      await expectLater(
        endpoints.adminAuth.verifyTotp(
          fresh,
          await freshCodeFromStoredSecret(),
        ),
        throwsA(isA<AdminTotpException>()),
      );
    });

    test('an expired lock accepts the right code again', () async {
      await enableTwoFactor();
      final profile = (await storedProfile())!
        ..totpFailedAttempts = AdminTwoFactorService.maxFailedAttempts
        ..totpLockedUntil = DateTime.now().toUtc().subtract(
          const Duration(seconds: 1),
        );
      await AdminProfile.db.updateRow(sessionBuilder.build(), profile);

      expect(
        await endpoints.adminAuth.verifyTotp(
          builderFor('session-after-lock'),
          await freshCodeFromStoredSecret(),
        ),
        isTrue,
      );
      expect((await storedProfile())?.totpFailedAttempts, 0);
    });

    test('an expired verification row does not count the session as verified', () async {
      await enableTwoFactor();
      final now = DateTime.now().toUtc();
      await AdminTotpSession.db.insertRow(
        sessionBuilder.build(),
        AdminTotpSession(
          userId: adminUserIdValue,
          sessionId: 'session-stale',
          verifiedUntil: now.subtract(const Duration(seconds: 1)),
          createdAt: now.subtract(const Duration(hours: 13)),
        ),
      );

      final stale = builderFor('session-stale');
      expect(await AdminTwoFactorService.isVerified(stale.build()), isFalse);
      await expectLater(
        AdminAuthService.requireAdmin(stale.build()),
        throwsA(isA<NotAuthorizedException>()),
      );
    });

    test('a successful verification resets the attempt counter', () async {
      await enableTwoFactor();
      final fresh = builderFor('session-fresh');

      expect(await endpoints.adminAuth.verifyTotp(fresh, '000000'), isFalse);
      expect(await endpoints.adminAuth.verifyTotp(fresh, '000000'), isFalse);

      expect(
        await endpoints.adminAuth.verifyTotp(
          fresh,
          await freshCodeFromStoredSecret(),
        ),
        isTrue,
      );

      final profile = await storedProfile();
      expect(profile?.totpFailedAttempts, 0);
      expect(profile?.totpLockedUntil, isNull);
    });

    test(
      'the lock stays positive with many failed attempts (no overflow)',
      () async {
        await enableTwoFactor();

        // A large attempt count guards against the exponential backoff
        // overflowing 64 bits, which would leave the lock unset or in the past
        // and silently disable brute-force protection.
        final profile = (await storedProfile())!;
        profile.totpFailedAttempts = 60;
        profile.totpLockedUntil = null;
        await AdminProfile.db.updateRow(sessionBuilder.build(), profile);

        await expectLater(
          endpoints.adminAuth.verifyTotp(
            builderFor('session-fresh'),
            '000000',
          ),
          throwsA(isA<AdminTotpException>()),
        );

        final lockedProfile = await storedProfile();
        expect(
          lockedProfile?.totpLockedUntil,
          isNotNull,
          reason: 'overflow never set the lock',
        );
        expect(
          lockedProfile!.totpLockedUntil!.isAfter(DateTime.now().toUtc()),
          isTrue,
          reason: 'the lock fell into the past',
        );

        await expectLater(
          endpoints.adminAuth.verifyTotp(
            builderFor('session-second'),
            await freshCodeFromStoredSecret(),
          ),
          throwsA(isA<AdminTotpException>()),
        );
      },
    );

    test(
      'the lock time never falls into the past and never exceeds the cap, even with many attempts',
      () async {
        await enableTwoFactor();

        for (final attempts in [10, 40, 56, 60, 64, 200, 100000]) {
          final profile = (await storedProfile())!;
          profile.totpFailedAttempts = attempts;
          profile.totpLockedUntil = null;
          await AdminProfile.db.updateRow(sessionBuilder.build(), profile);

          await expectLater(
            endpoints.adminAuth.verifyTotp(
              builderFor('session-probe-$attempts'),
              '000000',
            ),
            throwsA(isA<AdminTotpException>()),
            reason: 'attempts=$attempts did not set the lock',
          );

          final locked = await storedProfile();
          final until = locked!.totpLockedUntil;
          expect(until, isNotNull, reason: 'attempts=$attempts lock missing');
          expect(
            until!.isAfter(DateTime.now().toUtc()),
            isTrue,
            reason: 'attempts=$attempts lock stayed in the past',
          );
          expect(
            until.difference(DateTime.now().toUtc()) <=
                AdminTwoFactorService.lockoutCap,
            isTrue,
            reason: 'attempts=$attempts lock exceeded the cap',
          );
        }
      },
    );

    test('disabling deletes all of the user’s session verifications', () async {
      await enableTwoFactor();

      final a = builderFor('session-a');
      expect(
        await endpoints.adminAuth.verifyTotp(
          a,
          await freshCodeFromStoredSecret(),
        ),
        isTrue,
      );

      expect(
        await AdminTotpSession.db.count(sessionBuilder.build()),
        greaterThanOrEqualTo(2),
      );

      final b = builderFor('session-b');
      await endpoints.adminAuth.disableTotp(
        b,
        await freshCodeFromStoredSecret(),
      );

      final sessions = await AdminTotpSession.db.find(sessionBuilder.build());
      expect(sessions, isEmpty);
      expect(
        await AdminAuthService.requireAdmin(a.build()),
        isA<AdminProfile>(),
      );
      expect(
        await AdminAuthService.requireAdmin(b.build()),
        isA<AdminProfile>(),
      );
    });

    test('if a new secret is enabled after disabling, the old session '
        'is not counted as verified', () async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      await endpoints.adminAuth.confirmTotpSetup(
        adminBuilder,
        codeAt(setup.secret, -1),
      );
      final oldSession = builderFor('session-old');
      expect(
        await endpoints.adminAuth.verifyTotp(
          oldSession,
          await freshCodeFromStoredSecret(),
        ),
        isTrue,
      );

      await endpoints.adminAuth.disableTotp(
        adminBuilder,
        await freshCodeFromStoredSecret(),
      );
      final setup2 = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      await endpoints.adminAuth.confirmTotpSetup(
        adminBuilder,
        codeAt(setup2.secret, -1),
      );

      await expectLater(
        AdminAuthService.requireAdmin(oldSession.build()),
        throwsA(isA<NotAuthorizedException>()),
      );
    });

    test('expired verification rows can be purged', () async {
      await enableTwoFactor();

      final now = DateTime.now().toUtc();
      await AdminTotpSession.db.insertRow(
        sessionBuilder.build(),
        AdminTotpSession(
          userId: adminUserIdValue,
          sessionId: 'session-expired',
          verifiedUntil: now.subtract(const Duration(hours: 1)),
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
      );

      final live = builderFor('session-live');
      expect(
        await endpoints.adminAuth.verifyTotp(
          live,
          await freshCodeFromStoredSecret(),
        ),
        isTrue,
      );

      final deleted = await AdminTwoFactorService.purgeExpiredVerifications(
        sessionBuilder.build(),
      );
      expect(deleted, 1);

      final remaining = await AdminTotpSession.db.find(sessionBuilder.build());
      expect(
        remaining.map((r) => r.sessionId),
        unorderedEquals(['session-admin', 'session-live']),
      );
      expect(await AdminTwoFactorService.isVerified(live.build()), isTrue);
    });

    test('a recovery code verifies and is consumed', () async {
      final codes = await enableTwoFactor();

      final first = builderFor('session-first');
      expect(await endpoints.adminAuth.verifyTotp(first, codes.first), isTrue);

      final second = builderFor('session-second');
      expect(
        await endpoints.adminAuth.verifyTotp(second, codes.first),
        isFalse,
      );
      expect(await endpoints.adminAuth.verifyTotp(second, codes[1]), isTrue);
    });

    test(
      'a recovery code is accepted regardless of case and separators',
      () async {
        final codes = await enableTwoFactor();

        final messy = codes.first.toLowerCase().replaceAll('-', ' ');
        expect(
          await endpoints.adminAuth.verifyTotp(
            builderFor('session-lower'),
            messy,
          ),
          isTrue,
        );
      },
    );

    test('many wrong recovery code attempts lock the account', () async {
      await enableTwoFactor();
      final fresh = builderFor('session-fresh');

      for (var i = 0; i < AdminTwoFactorService.maxFailedAttempts - 1; i++) {
        expect(
          await endpoints.adminAuth.verifyTotp(fresh, 'AAAAA-AAAAA'),
          isFalse,
        );
      }
      await expectLater(
        endpoints.adminAuth.verifyTotp(fresh, 'AAAAA-AAAAA'),
        throwsA(isA<AdminTotpException>()),
      );
    });

    test('disabling verifies the code and resets the 2FA state', () async {
      final setup = await endpoints.adminAuth.startTotpSetup(adminBuilder);
      await endpoints.adminAuth.confirmTotpSetup(
        adminBuilder,
        codeAt(setup.secret, -1),
      );
      final secret = (await storedProfile())!.totpSecret!;
      expect(secret, isNotEmpty);

      await endpoints.adminAuth.disableTotp(
        builderFor('session-other'),
        await freshCodeFromStoredSecret(),
      );

      final profile = await storedProfile();
      expect(profile?.totpSecret, isNull);
      expect(profile?.recoveryCodes, isNull);
      expect(profile?.totpFailedAttempts, 0);
      expect(profile?.totpLockedUntil, isNull);

      final info = await endpoints.adminAuth.me(adminBuilder);
      expect(info.totpEnabled, isFalse);
      expect(
        await AdminAuthService.requireAdmin(builderFor('session-x').build()),
        isA<AdminProfile>(),
      );
    });

    test('disabling with a wrong code is rejected', () async {
      await enableTwoFactor();

      await expectLater(
        endpoints.adminAuth.disableTotp(
          builderFor('session-other'),
          '000000',
        ),
        throwsA(isA<AdminTotpException>()),
      );

      final profile = await storedProfile();
      expect(profile?.totpSecret, isNotNull);
    });

    test('disableTotp gives a clear error while 2FA is off', () async {
      await expectLater(
        endpoints.adminAuth.disableTotp(adminBuilder, '123456'),
        throwsA(isA<AdminTotpException>()),
      );
    });

    test('verification returns false instead of a raw error when the pepper is undefined', () async {
      await enableTwoFactor();

      TotpSecretCipher.debugPepper = '';
      PasswordHasher.debugPepper = '';

      final fresh = builderFor('session-fresh');
      expect(await endpoints.adminAuth.verifyTotp(fresh, '123456'), isFalse);
    });
  });
}
