import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_mdm_server/src/service/alert_routing_settings.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/backup_schedule_settings.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminSettingsEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createProfile() async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    SettingsFormState state({
      int? defaultPolicyId,
      bool smtpEnabled = false,
      String smtpHost = '127.0.0.1',
      int smtpPort = 1,
      SmtpEncryption smtpEncryption = SmtpEncryption.none,
      String smtpFromAddress = 'sender@example.com',
      List<String> cleanTimes = const ['01:00'],
      List<String> runTimes = const ['01:30'],
      List<String> monitorTimes = const ['04:00'],
      List<String> notifyUserIds = const [],
      Map<String, List<String>>? routing,
      int checkDelayMinutes = 30,
    }) {
      return SettingsFormState(
        defaultPolicyId: defaultPolicyId,
        deviceUploadMaxSizeKb: 51200,
        panelDefaultTheme: PanelTheme.dark,
        panelBrandName: 'Wonkru MDM',
        smtpEnabled: smtpEnabled,
        smtpHost: smtpHost,
        smtpPort: smtpPort,
        smtpUsername: '',
        smtpPassword: '',
        smtpEncryption: smtpEncryption,
        smtpFromAddress: smtpFromAddress,
        smtpFromName: 'Wonkru MDM',
        policyDefaultServerReportInterval: 600,
        policyDefaultMinTimeMs: 30000,
        policyDefaultMinDistanceMeters: 50,
        policyDevicesUpdatedCheckDelayMinutes: checkDelayMinutes,
        deviceAlertsOnlineMinutes: 5,
        offlineTimeout: 5,
        deviceAlertsOfflineMinutes: 1440,
        deviceAlertsDuplicatePreventionHours: 24,
        systemAlertTypeChannels: routing == null
            ? AlertRoutingSettings.normalizeRouting(null)
            : [
                for (final entry in routing.entries)
                  AlertTypeChannels(
                    type: SystemAlertType.fromJson(entry.key),
                    channels: entry.value,
                  ),
              ],
        backupScheduleCleanTimes: cleanTimes,
        backupScheduleRunTimes: runTimes,
        backupScheduleMonitorTimes: monitorTimes,
        backupNotifyUserIds: notifyUserIds,
        wlogConsoleMinLevel: 2,
        wlogDbMinLevel: 2,
        wlogRemoteMinLevel: 2,
        wlogMaxLocalEntries: 1000,
        wlogFlushThreshold: 50,
        wlogIdleFlushSeconds: 60,
        wlogRetentionDays: 7,
        wlogRemoteEnabled: false,
        wlogRemoteEndpoint: '',
        wlogRemoteAuthToken: '',
        wlogRemoteMaxRetries: 3,
      );
    }

    Map<String, List<String>> routingMap(List<AlertTypeChannels> routing) => {
      for (final entry in routing) entry.type.name: entry.channels,
    };

    group('get', () {
      test('when nothing is stored then every field falls back to its '
          'default.', () async {
        await createProfile();

        final state = await endpoints.adminSettings.get(adminBuilder);

        expect(state.defaultPolicyId, isNull);
        expect(state.deviceUploadMaxSizeKb, 51200);
        expect(state.panelDefaultTheme, PanelTheme.dark);
        expect(state.panelBrandName, isNotEmpty);
        expect(state.smtpEnabled, isFalse);
        expect(state.smtpPort, 587);
        expect(state.policyDefaultServerReportInterval, 600);
        expect(state.policyDevicesUpdatedCheckDelayMinutes, 30);
        expect(state.deviceAlertsOfflineMinutes, 1440);
        expect(state.backupScheduleCleanTimes, ['01:00']);
        expect(state.backupScheduleRunTimes, ['01:30']);
        expect(state.backupScheduleMonitorTimes, ['04:00']);
        expect(state.backupNotifyUserIds, isEmpty);
        expect(state.wlogRetentionDays, 7);
        expect(state.wlogRemoteMaxRetries, 3);
        expect(routingMap(state.systemAlertTypeChannels), {
          'device_offline': ['database'],
          'policy_update_pending': ['database'],
          'security_info': ['database'],
        });
      });

      test('when settings are stored then they are read back.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await SettingService.save(session, 'panel_brand_name', 'Fleet panel');
        await SettingService.save(session, 'offline_timeout', '17');
        await SettingService.save(session, 'smtp_enabled', '1');
        await SettingService.save(session, 'default_policy', '42');
        await SettingService.save(session, 'wlog_retention_days', '21');

        final state = await endpoints.adminSettings.get(adminBuilder);

        expect(state.panelBrandName, 'Fleet panel');
        expect(state.offlineTimeout, 17);
        expect(state.smtpEnabled, isTrue);
        expect(state.defaultPolicyId, 42);
        expect(state.wlogRetentionDays, 21);
      });

      test('when legacy alert keys are stored then they are '
          'remapped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await SettingService.save(
          session,
          AlertRoutingSettings.key,
          jsonEncode({
            'type_channels': {
              'AdbRootEnabled': ['mail', 'sms'],
              'device_offline': ['mail'],
              'unknown_type': ['mail'],
            },
          }),
        );

        final state = await endpoints.adminSettings.get(adminBuilder);
        final routing = routingMap(state.systemAlertTypeChannels);

        expect(routing['security_info'], ['mail', 'sms']);
        expect(routing['device_offline'], ['mail']);
        expect(routing['policy_update_pending'], ['database']);
        expect(routing.containsKey('unknown_type'), isFalse);
      });

      test('when an empty routing list is stored then the type falls back to '
          'the database.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await SettingService.save(
          session,
          AlertRoutingSettings.key,
          jsonEncode({
            'type_channels': {
              'device_offline': <String>[],
            },
          }),
        );

        final state = await endpoints.adminSettings.get(adminBuilder);

        expect(
          routingMap(state.systemAlertTypeChannels)['device_offline'],
          ['database'],
        );
      });

      test('when only the legacy backup times are stored then they are '
          'picked up.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await SettingService.save(
          session,
          BackupScheduleSettings.cleanAtKey,
          '02:15',
        );

        final state = await endpoints.adminSettings.get(adminBuilder);

        expect(state.backupScheduleCleanTimes, ['02:15']);
        expect(state.backupScheduleRunTimes, ['01:30']);
      });
    });

    group('save', () {
      test('when the state is saved then every key is written back.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await endpoints.adminSettings.save(
          adminBuilder,
          state(
            smtpEnabled: true,
            smtpHost: 'mail.example.com',
            smtpPort: 2525,
            notifyUserIds: ['user-1', 'user-2'],
            checkDelayMinutes: 45,
          ),
        );

        expect(await SettingService.raw(session, 'smtp_enabled'), '1');
        expect(
          await SettingService.raw(session, 'smtp_host'),
          'mail.example.com',
        );
        expect(await SettingService.raw(session, 'smtp_port'), '2525');
        expect(
          await SettingService.raw(
            session,
            'policy_devices_updated_check_delay_minutes',
          ),
          '45',
        );
        expect(
          jsonDecode(
            (await SettingService.raw(
              session,
              BackupScheduleSettings.notifyUserIdsKey,
            ))!,
          ),
          ['user-1', 'user-2'],
        );
      });

      test('when a toggle is turned off then the key is stored as the empty '
          'string.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await endpoints.adminSettings.save(
          adminBuilder,
          state(smtpEnabled: false),
        );

        expect(await SettingService.raw(session, 'smtp_enabled'), '');
        expect(
          await SettingService.getBool(session, 'smtp_enabled', fallback: true),
          isFalse,
        );
      });

      test(
        'when the check delay is out of range then it is clamped.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          await endpoints.adminSettings.save(
            adminBuilder,
            state(checkDelayMinutes: 999999),
          );
          expect(
            await SettingService.raw(
              session,
              AdminSettingsService.devicesUpdatedCheckDelayKey,
            ),
            '${AdminSettingsService.maxDevicesUpdatedCheckDelayMinutes}',
          );

          await endpoints.adminSettings.save(
            adminBuilder,
            state(checkDelayMinutes: -10),
          );
          expect(
            await SettingService.raw(
              session,
              AdminSettingsService.devicesUpdatedCheckDelayKey,
            ),
            '0',
          );
        },
      );

      test('when the backup times are invalid then only the valid ones are '
          'kept.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await endpoints.adminSettings.save(
          adminBuilder,
          state(cleanTimes: ['01:00', ' 01:00 ', 'nope', '25:00', '23:59']),
        );

        expect(
          jsonDecode(
            (await SettingService.raw(
              session,
              BackupScheduleSettings.cleanTimesKey,
            ))!,
          ),
          ['01:00', '23:59'],
        );
      });

      test(
        'when no backup time survives then the default is stored.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          await endpoints.adminSettings.save(
            adminBuilder,
            state(runTimes: const ['nope']),
          );

          expect(
            jsonDecode(
              (await SettingService.raw(
                session,
                BackupScheduleSettings.runTimesKey,
              ))!,
            ),
            ['01:30'],
          );
        },
      );

      test('when the state is saved then reading it back returns the same '
          'values.', () async {
        await createProfile();

        final saved = state(
          defaultPolicyId: 7,
          smtpEnabled: true,
          smtpHost: 'mail.example.com',
          smtpPort: 2525,
          routing: {
            'device_offline': ['mail'],
            'policy_update_pending': ['database', 'mail'],
            'security_info': ['database'],
          },
          checkDelayMinutes: 12,
        );

        await endpoints.adminSettings.save(adminBuilder, saved);
        final loaded = await endpoints.adminSettings.get(adminBuilder);

        expect(loaded.defaultPolicyId, 7);
        expect(loaded.smtpEnabled, isTrue);
        expect(loaded.smtpHost, 'mail.example.com');
        expect(loaded.smtpPort, 2525);
        expect(loaded.policyDevicesUpdatedCheckDelayMinutes, 12);
        expect(routingMap(loaded.systemAlertTypeChannels)['device_offline'], [
          'mail',
        ]);
        expect(
          routingMap(loaded.systemAlertTypeChannels)['policy_update_pending'],
          [
            'database',
            'mail',
          ],
        );
      });
    });

    group('sendSmtpTestMail', () {
      test(
        'when the recipient is not an address then it is rejected.',
        () async {
          await createProfile();

          final notices = await endpoints.adminSettings.sendSmtpTestMail(
            adminBuilder,
            state(),
            'not-an-address',
          );

          expect(notices, hasLength(1));
          expect(notices.single.status, 'invalid_email');
          expect(notices.single.severity, 'danger');
        },
      );

      test(
        'when SMTP is on without a host then the test is rejected.',
        () async {
          await createProfile();

          final notices = await endpoints.adminSettings.sendSmtpTestMail(
            adminBuilder,
            state(smtpEnabled: true, smtpHost: '   '),
            'ops@example.com',
          );

          expect(notices, hasLength(1));
          expect(notices.single.status, 'missing_host');
        },
      );

      test('when SMTP is off then the mailer warning precedes the failed '
          'attempt.', () async {
        await createProfile();

        final notices = await endpoints.adminSettings.sendSmtpTestMail(
          adminBuilder,
          state(smtpEnabled: false),
          'ops@example.com',
        );

        expect(notices, hasLength(2));
        expect(notices.first.status, 'mailer_not_smtp');
        expect(notices.first.severity, 'warning');
        expect(notices.last.status, 'failed');
        expect(notices.last.severity, 'danger');
        expect(notices.last.detail, isNotNull);
      });

      test(
        'when an SMTP server answers then the test is reported as sent.',
        () async {
          await createProfile();

          final server = await _FakeSmtpServer.start();
          addTearDown(server.stop);

          final notices = await endpoints.adminSettings.sendSmtpTestMail(
            adminBuilder,
            state(
              smtpEnabled: true,
              smtpHost: '127.0.0.1',
              smtpPort: server.port,
              smtpFromAddress: 'sender@example.com',
            ),
            'ops@example.com',
          );

          expect(notices, hasLength(1));
          expect(notices.single.status, 'sent');
          expect(notices.single.severity, 'success');
          expect(notices.single.detail, 'ops@example.com');
          expect(server.body.toString(), contains('SMTP test - Wonkru MDM'));
          expect(server.recipients, ['ops@example.com']);
        },
      );
    });
  });
}

class _FakeSmtpServer {
  _FakeSmtpServer._(this._server);

  final ServerSocket _server;

  final recipients = <String>[];
  final body = StringBuffer();

  int get port => _server.port;

  static Future<_FakeSmtpServer> start() async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final server = _FakeSmtpServer._(socket);

    socket.listen(server._handle);

    return server;
  }

  Future<void> stop() => _server.close();

  void _handle(Socket client) {
    var buffer = '';
    var inData = false;

    client.write('220 fake ESMTP\r\n');

    client.listen((bytes) {
      buffer += utf8.decode(bytes);

      while (buffer.contains('\r\n')) {
        final end = buffer.indexOf('\r\n');
        final line = buffer.substring(0, end);
        buffer = buffer.substring(end + 2);

        if (inData) {
          if (line == '.') {
            inData = false;
            client.write('250 2.0.0 queued\r\n');
          } else {
            body.writeln(line);
          }
          continue;
        }

        final command = line.toUpperCase();
        if (command.startsWith('EHLO')) {
          client.write('250-fake\r\n250-AUTH LOGIN PLAIN\r\n250 OK\r\n');
        } else if (command.startsWith('HELO')) {
          client.write('250 fake\r\n');
        } else if (command.startsWith('AUTH')) {
          client.write('235 authenticated\r\n');
        } else if (command.startsWith('MAIL FROM')) {
          client.write('250 OK\r\n');
        } else if (command.startsWith('RCPT TO')) {
          recipients.add(
            line.substring(line.indexOf('<') + 1, line.indexOf('>')),
          );
          client.write('250 OK\r\n');
        } else if (command == 'DATA') {
          inData = true;
          client.write('354 send the message\r\n');
        } else if (command == 'QUIT') {
          client.write('221 bye\r\n');
          client.destroy();
        } else {
          client.write('250 OK\r\n');
        }
      }
    });
  }
}
