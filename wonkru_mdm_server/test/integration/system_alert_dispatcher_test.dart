import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';
import 'package:wonkru_mdm_server/src/service/system_alert_dispatcher.dart';

import '../support/settings_form_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

class _RecordedMail {
  _RecordedMail({
    required this.to,
    required this.subject,
    required this.body,
  });

  final String to;
  final String subject;
  final String body;
}

void main() {
  withServerpod('Given SystemAlertDispatcher', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const peerUserId = '22222222-2222-4222-8222-222222222222';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> setRouting(Map<SystemAlertType, List<String>> typeChannels) {
      return AdminSettingsService.persist(
        sessionBuilder.build(),
        validSettingsForm().copyWith(
          deviceUploadMaxSizeKb: 10240,
          panelBrandName: 'Wonkru',
          smtpEnabled: true,
          smtpHost: 'smtp.example.com',
          smtpUsername: 'mailer',
          smtpPassword: 'secret',
          smtpEncryption: SmtpEncryption.tls,
          smtpFromAddress: 'panel@example.com',
          smtpFromName: 'Wonkru Panel',
          systemAlertTypeChannels: [
            for (final type in SystemAlertType.values)
              AlertTypeChannels(
                type: type,
                channels: typeChannels[type] ?? const ['database'],
              ),
          ],
          backupScheduleCleanTimes: const ['01:00'],
          backupScheduleRunTimes: const ['01:30'],
          backupScheduleMonitorTimes: const ['04:00'],
        ),
      );
    }

    Future<void> createAdmin(
      String userId, {
      String? email,
      String name = 'Ada Lovelace',
      AdminAccountStatus status = AdminAccountStatus.active,
    }) {
      final session = sessionBuilder.build();
      return session.db.transaction((transaction) async {
        final id = UuidValue.fromString(userId);
        await AuthUser.db.insertRow(
          session,
          AuthUser(id: id, scopeNames: const {}),
          transaction: transaction,
        );
        await UserProfile.db.insertRow(
          session,
          UserProfile(
            authUserId: id,
            email: email,
            userName: name,
            fullName: name,
          ),
          transaction: transaction,
        );
        await AdminProfile.db.insertRow(
          session,
          AdminProfile(userId: id, status: status),
          transaction: transaction,
        );
      });
    }

    group('dispatch', () {
      test('when no channel is defined then nothing is written or sent and a '
          'warning is logged.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        // normalizeRouting fills an empty list with `database`, so a channel-less
        // scenario can only be set up by stubbing the settings read.
        final base = await AdminSettingsService.read(sessionBuilder.build());

        var mailSent = 0;
        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.device_offline,
          title: 'Device offline',
          message: 'A device went offline.',
          userIds: [UuidValue.fromString(adminUserId)],
          readSettings: (session, {transaction}) async =>
              base.copyWith(systemAlertTypeChannels: const []),
          mailSender:
              (
                state, {
                required to,
                required subject,
                required body,
              }) async {
                mailSent++;
              },
        );

        expect(count, 0);
        expect(mailSent, 0);
        expect(await AdminNotification.db.count(sessionBuilder.build()), 0);
      });

      test('when the database channel is routed then one row is written per '
          'recipient.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');
        await createAdmin(peerUserId, email: 'peer@example.com');

        final ids = [
          UuidValue.fromString(adminUserId),
          UuidValue.fromString(peerUserId),
        ];
        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.device_offline,
          title: 'Device offline',
          message: 'A device went offline.',
          data: {'url': '/devices/7'},
          userIds: ids,
        );

        expect(count, 2);

        final session = sessionBuilder.build();
        final rows = await AdminNotification.db.find(
          session,
          orderBy: (t) => t.id,
        );
        expect(rows, hasLength(2));
        expect(rows.map((row) => row.userId), ids);
        expect(rows.map((row) => row.type), [
          SystemAlertType.device_offline.name,
          SystemAlertType.device_offline.name,
        ]);
        expect(rows.first.title, 'Device offline');
        expect(rows.first.message, 'A device went offline.');
        expect(rows.first.data, '{"url":"/devices/7"}');
        expect(rows.first.readAt, isNull);
        expect(rows.first.createdAt, isNotNull);
      });

      test(
        'when userIds is omitted then the current admin is targeted.',
        () async {
          await createAdmin(adminUserId, email: 'ada@example.com');

          final count = await SystemAlertDispatcher.dispatch(
            adminBuilder.build(),
            type: SystemAlertType.security_info,
            title: 'Security notice',
            message: 'ADB root was enabled.',
          );

          expect(count, 1);

          final session = sessionBuilder.build();
          final rows = await AdminNotification.db.find(session);
          expect(rows, hasLength(1));
          expect(rows.single.userId, UuidValue.fromString(adminUserId));
        },
      );

      test('when userIds is empty then no row is written.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.device_offline,
          title: 'Device offline',
          message: 'A device went offline.',
          userIds: const [],
        );

        expect(count, 0);
        expect(await AdminNotification.db.count(sessionBuilder.build()), 0);
      });

      test('when the mail channel is routed then the mail path is called for '
          'every recipient with an email.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');
        await createAdmin(peerUserId);

        await setRouting({
          SystemAlertType.policy_update_pending: ['mail'],
        });

        final sent = <_RecordedMail>[];
        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.policy_update_pending,
          title: 'Policy update pending',
          message: '3 devices are on an older policy version.',
          data: {'url': 'https://panel.example.com/policies/7'},
          userIds: [
            UuidValue.fromString(adminUserId),
            UuidValue.fromString(peerUserId),
          ],
          mailSender:
              (
                state, {
                required to,
                required subject,
                required body,
              }) async {
                sent.add(
                  _RecordedMail(to: to, subject: subject, body: body),
                );
              },
        );

        expect(count, 2);
        expect(sent, hasLength(1));
        expect(sent.single.to, 'ada@example.com');
        expect(sent.single.subject, '[Wonkru] Policy update pending');
        expect(
          sent.single.body,
          contains('3 devices are on an older policy version.'),
        );
        expect(
          sent.single.body,
          contains('https://panel.example.com/policies/7'),
        );
        expect(await AdminNotification.db.count(sessionBuilder.build()), 0);
      });

      test('when both channels are routed then a row is written and mail is '
          'sent.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        await setRouting({
          SystemAlertType.device_offline: ['database', 'mail'],
        });

        var mailSent = 0;
        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.device_offline,
          title: 'Device offline',
          message: 'A device went offline.',
          mailSender:
              (
                state, {
                required to,
                required subject,
                required body,
              }) async {
                mailSent++;
              },
        );

        expect(count, 1);
        expect(mailSent, 1);
        expect(await AdminNotification.db.count(sessionBuilder.build()), 1);
      });

      test('when SMTP is disabled then mail is skipped while the row is '
          'written.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        await setRouting({
          SystemAlertType.device_offline: ['database', 'mail'],
        });
        final session = sessionBuilder.build();
        await SettingService.save(session, 'smtp_enabled', '');

        var mailSent = 0;
        final count = await SystemAlertDispatcher.dispatch(
          sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  adminUserId,
                  {Scope('admin')},
                ),
              )
              .build(),
          type: SystemAlertType.device_offline,
          title: 'Device offline',
          message: 'A device went offline.',
          mailSender:
              (
                state, {
                required to,
                required subject,
                required body,
              }) async {
                mailSent++;
              },
        );

        expect(count, 1);
        expect(mailSent, 0);
        expect(await AdminNotification.db.count(session), 1);
      });

      test('when the sms channel is routed then it is skipped with a warning '
          'while other channels still run.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        await setRouting({
          SystemAlertType.security_info: ['database', 'sms'],
        });

        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.security_info,
          title: 'Security notice',
          message: 'ADB root was enabled.',
        );

        expect(count, 1);
        expect(await AdminNotification.db.count(sessionBuilder.build()), 1);
      });

      test('when only the sms channel is routed then nothing is delivered and '
          'the delivered count is 0.', () async {
        await createAdmin(adminUserId, email: 'ada@example.com');

        await setRouting({
          SystemAlertType.security_info: ['sms'],
        });

        final count = await SystemAlertDispatcher.dispatch(
          adminBuilder.build(),
          type: SystemAlertType.security_info,
          title: 'Security notice',
          message: 'ADB root was enabled.',
        );

        expect(count, 0);
        expect(await AdminNotification.db.count(sessionBuilder.build()), 0);
      });
    });
  });
}
