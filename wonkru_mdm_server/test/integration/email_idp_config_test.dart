import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';
import 'package:wonkru_mdm_server/src/service/email_idp_sender.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given EmailIdpSender', (sessionBuilder, endpoints) {
    const recipientEmail = 'user@example.com';
    final accountRequestId = UuidValue.fromString(
      '11111111-1111-4111-8111-111111111111',
    );
    final passwordResetRequestId = UuidValue.fromString(
      '22222222-2222-4222-8222-222222222222',
    );

    late List<({String to, String subject, String body})> smtpSends;
    late List<String> cloudRegistrationSends;
    late List<String> cloudPasswordResetSends;

    setUp(() {
      smtpSends = [];
      cloudRegistrationSends = [];
      cloudPasswordResetSends = [];
    });

    Future<void> saveSetting(String key, String value) async {
      await SettingService.save(sessionBuilder.build(), key, value);
    }

    EmailIdpConfig cloudFallback() => EmailIdpConfig(
      secretHashPepper: 'test-pepper',
      sendRegistrationVerificationCode:
          (
            final Session session, {
            required final String email,
            required final UuidValue accountRequestId,
            required final String verificationCode,
            required final Transaction? transaction,
          }) {
            cloudRegistrationSends.add(email);
          },
      sendPasswordResetVerificationCode:
          (
            final Session session, {
            required final String email,
            required final UuidValue passwordResetRequestId,
            required final String verificationCode,
            required final Transaction? transaction,
          }) {
            cloudPasswordResetSends.add(email);
          },
    );

    EmailIdpConfigFromPasswords buildConfig({
      EmailIdpConfig? cloud,
      SmtpVerificationCodeSender? sendOverSmtp,
      SmtpSettingsReader? readSettings,
      Duration? timeout,
    }) => EmailIdpSender.config(
      cloudFallback: cloud ?? cloudFallback(),
      sendOverSmtp:
          sendOverSmtp ??
          (state, {required to, required subject, required body}) async {
            smtpSends.add((to: to, subject: subject, body: body));
          },
      readSettings: readSettings ?? AdminSettingsService.read,
      timeout: timeout,
    );

    Future<void> startRegistration(EmailIdpConfigFromPasswords config) async {
      await config.sendRegistrationVerificationCode!(
        sessionBuilder.build(),
        email: recipientEmail,
        accountRequestId: accountRequestId,
        verificationCode: 'ABC123',
        transaction: null,
      );
    }

    Future<void> startPasswordReset(EmailIdpConfigFromPasswords config) async {
      await config.sendPasswordResetVerificationCode!(
        sessionBuilder.build(),
        email: recipientEmail,
        passwordResetRequestId: passwordResetRequestId,
        verificationCode: 'XYZ789',
        transaction: null,
      );
    }

    test('registration code is sent over SMTP when SMTP is enabled', () async {
      await saveSetting('smtp_enabled', 'true');
      await saveSetting('smtp_host', 'smtp.example.com');
      await saveSetting('panel_brand_name', 'Wonkru MDM');

      await startRegistration(buildConfig());

      expect(smtpSends, hasLength(1));
      expect(smtpSends.single.to, recipientEmail);
      expect(smtpSends.single.subject, contains('Wonkru MDM'));
      expect(smtpSends.single.body, contains('ABC123'));
      expect(cloudRegistrationSends, isEmpty);
    });

    test('password reset code is sent over SMTP when SMTP is enabled', () async {
      await saveSetting('smtp_enabled', 'true');
      await saveSetting('smtp_host', 'smtp.example.com');

      await startPasswordReset(buildConfig());

      expect(smtpSends, hasLength(1));
      expect(smtpSends.single.to, recipientEmail);
      expect(smtpSends.single.subject, contains('password reset'));
      expect(smtpSends.single.body, contains('XYZ789'));
      expect(cloudPasswordResetSends, isEmpty);
    });

    test(
      'registration code falls back to Serverpod Cloud without SMTP settings',
      () async {
      await startRegistration(buildConfig());

      expect(smtpSends, isEmpty);
      expect(cloudRegistrationSends, [recipientEmail]);
    });

    test(
      'password reset code falls back to Serverpod Cloud without SMTP settings',
      () async {
        await startPasswordReset(buildConfig());

        expect(smtpSends, isEmpty);
        expect(cloudPasswordResetSends, [recipientEmail]);
      },
    );

    test(
      'falls back to Serverpod Cloud when SMTP is enabled but the address is empty',
      () async {
        await saveSetting('smtp_enabled', 'true');
        await saveSetting('smtp_host', '');

        await startRegistration(buildConfig());

        expect(smtpSends, isEmpty);
        expect(cloudRegistrationSends, [recipientEmail]);
      },
    );

    test(
      'does not raise an error and falls back to Cloud when settings cannot be read',
      () async {
        final config = buildConfig(
          readSettings: (session, {transaction}) async =>
              throw StateError('settings could not be read'),
        );

        await expectLater(startRegistration(config), completes);

        expect(smtpSends, isEmpty);
        expect(cloudRegistrationSends, [recipientEmail]);
      },
    );

    test(
      'does not raise an error and does not try Cloud when SMTP sending fails',
      () async {
        await saveSetting('smtp_enabled', 'true');
        await saveSetting('smtp_host', 'smtp.example.com');

        final config = buildConfig(
          sendOverSmtp:
              (state, {required to, required subject, required body}) =>
                  Future<void>.error(StateError('smtp unavailable')),
        );

        await expectLater(startRegistration(config), completes);

        expect(smtpSends, isEmpty);
        expect(cloudRegistrationSends, isEmpty);
      },
    );

    test('does not raise an error when SMTP sending times out', () async {
      await saveSetting('smtp_enabled', 'true');
      await saveSetting('smtp_host', 'smtp.example.com');

      final pending = Completer<void>();
      final config = buildConfig(
        cloud: EmailIdpConfig(secretHashPepper: 'test-pepper'),
        sendOverSmtp: (state, {required to, required subject, required body}) =>
            pending.future,
        timeout: const Duration(milliseconds: 20),
      );

      await expectLater(startRegistration(config), completes);

      // Complete the leaked future so it does not keep the test alive at
      // teardown.
      pending.complete();
      expect(cloudRegistrationSends, isEmpty);
    });
  });
}
