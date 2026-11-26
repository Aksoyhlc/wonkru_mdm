import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/future_calls/device_offline_alert_future_call.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given DeviceOfflineAlertFutureCall',
    (sessionBuilder, endpoints) {
      const adminUserId = '55555555-5555-4555-8555-555555555555';

      Future<void> createAdmin() async {
        final session = sessionBuilder.build();
        await session.db.transaction((transaction) async {
          final id = UuidValue.fromString(adminUserId);
          await AuthUser.db.insertRow(
            session,
            AuthUser(id: id, scopeNames: const {}),
            transaction: transaction,
          );
          await UserProfile.db.insertRow(
            session,
            UserProfile(
              authUserId: id,
              email: 'ada@example.com',
              userName: 'Ada Lovelace',
              fullName: 'Ada Lovelace',
            ),
            transaction: transaction,
          );
          await AdminProfile.db.insertRow(
            session,
            AdminProfile(userId: id, status: AdminAccountStatus.active),
            transaction: transaction,
          );
        });
      }

      Future<void> setThresholds({
        required int offlineMinutes,
        required int duplicateHours,
      }) async {
        final session = sessionBuilder.build();
        await SettingService.save(
          session,
          'device_alerts_offline_minutes',
          '$offlineMinutes',
        );
        await SettingService.save(
          session,
          'device_alerts_duplicate_prevention_hours',
          '$duplicateHours',
        );
      }

      Future<Device> createDevice({
        required String code,
        DateTime? lastSeenAt,
      }) {
        final session = sessionBuilder.build();
        return Device.db.insertRow(
          session,
          Device(code: code, name: 'Device $code', lastSeenAt: lastSeenAt),
        );
      }

      Future<List<AdminNotification>> offlineAlerts() async {
        final session = sessionBuilder.build();
        return AdminNotification.db.find(
          session,
          where: (t) => t.type.equals(SystemAlertType.device_offline.name),
          orderBy: (t) => t.id,
        );
      }

      test('produces an alert for an offline device past the threshold', () async {
        await createAdmin();
        await setThresholds(offlineMinutes: 60, duplicateHours: 24);

        final now = DateTime.now().toUtc();
        final device = await createDevice(
          code: 'OFF1',
          lastSeenAt: now.subtract(const Duration(hours: 2)),
        );

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );

        final alerts = await offlineAlerts();
        expect(alerts, hasLength(1));
        expect(alerts.single.userId, UuidValue.fromString(adminUserId));
        expect(alerts.single.type, SystemAlertType.device_offline.name);
        expect(alerts.single.title, 'Device offline');
        expect(alerts.single.message, contains('Device OFF1'));

        final data = jsonDecode(alerts.single.data!) as Map<String, dynamic>;
        expect(data['device_id'], device.id);
        expect(data['offline_since'], isNotNull);
        expect(data['minutes'], greaterThanOrEqualTo(120));
      });

      test('produces no alert for a device within the threshold', () async {
        await createAdmin();
        await setThresholds(offlineMinutes: 60, duplicateHours: 24);

        final now = DateTime.now().toUtc();
        await createDevice(
          code: 'FRESH',
          lastSeenAt: now.subtract(const Duration(minutes: 30)),
        );

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );

        expect(await offlineAlerts(), isEmpty);
      });

      test(
        'does not re-alert a device alerted within the duplicate window',
        () async {
          await createAdmin();
          await setThresholds(offlineMinutes: 60, duplicateHours: 24);

          final now = DateTime.now().toUtc();
          final device = await createDevice(
            code: 'DUP',
            lastSeenAt: now.subtract(const Duration(hours: 2)),
          );

          final session = sessionBuilder.build();
          await AdminNotification.db.insertRow(
            session,
            AdminNotification(
              userId: UuidValue.fromString(adminUserId),
              type: SystemAlertType.device_offline.name,
              title: 'Device offline',
              message: 'previous alert',
              data: jsonEncode({'device_id': device.id}),
              createdAt: now,
            ),
          );

          await DeviceOfflineAlertFutureCall().markOfflineDevices(
            sessionBuilder.build(),
          );

          expect(await offlineAlerts(), hasLength(1));
        },
      );

      test('a never-seen device also counts as offline', () async {
        await createAdmin();
        await setThresholds(offlineMinutes: 60, duplicateHours: 24);
        await createDevice(code: 'NEVER');

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );

        expect(await offlineAlerts(), hasLength(1));
      });

      test(
        'produces an alert for each of several offline devices',
        () async {
          await createAdmin();
          await setThresholds(offlineMinutes: 60, duplicateHours: 24);

          final now = DateTime.now().toUtc();
          await createDevice(
            code: 'MULTI1',
            lastSeenAt: now.subtract(const Duration(hours: 3)),
          );
          await createDevice(
            code: 'MULTI2',
            lastSeenAt: now.subtract(const Duration(hours: 4)),
          );

          await DeviceOfflineAlertFutureCall().markOfflineDevices(
            sessionBuilder.build(),
          );

          expect(await offlineAlerts(), hasLength(2));
        },
      );

      test('duplicate suppression is per device', () async {
        await createAdmin();
        await setThresholds(offlineMinutes: 60, duplicateHours: 24);

        final now = DateTime.now().toUtc();
        final alerted = await createDevice(
          code: 'SEEN',
          lastSeenAt: now.subtract(const Duration(hours: 2)),
        );
        final notAlerted = await createDevice(
          code: 'NOTSEEN',
          lastSeenAt: now.subtract(const Duration(hours: 2)),
        );

        final session = sessionBuilder.build();
        await AdminNotification.db.insertRow(
          session,
          AdminNotification(
            userId: UuidValue.fromString(adminUserId),
            type: SystemAlertType.device_offline.name,
            title: 'Device offline',
            message: 'previous alert',
            data: jsonEncode({'device_id': alerted.id}),
            createdAt: now,
          ),
        );

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );

        final alerts = await offlineAlerts();
        expect(alerts, hasLength(2));
        final deviceIds = {
          for (final alert in alerts)
            (jsonDecode(alert.data!) as Map<String, dynamic>)['device_id'],
        };
        expect(deviceIds, {alerted.id, notAlerted.id});
      });

      test('repeat alerts are suppressed in mail-only routing too', () async {
        await createAdmin();
        await setThresholds(offlineMinutes: 60, duplicateHours: 24);

        // Mail-only routing writes no in-app row, so duplicate protection
        // relies on the marker setting alone.
        final base = await AdminSettingsService.read(sessionBuilder.build());
        await AdminSettingsService.persist(
          sessionBuilder.build(),
          base.copyWith(
            smtpEnabled: true,
            smtpHost: 'smtp.example.com',
            systemAlertTypeChannels: [
              AlertTypeChannels(
                type: SystemAlertType.device_offline,
                channels: const ['mail'],
              ),
            ],
          ),
        );

        final now = DateTime.now().toUtc();
        await createDevice(
          code: 'MAILONLY',
          lastSeenAt: now.subtract(const Duration(hours: 2)),
        );

        var sent = 0;
        final originalSender = DeviceOfflineAlertFutureCall.debugMailSender;
        DeviceOfflineAlertFutureCall.debugMailSender =
            (state, {required to, required subject, required body}) async {
              sent++;
            };
        addTearDown(
          () => DeviceOfflineAlertFutureCall.debugMailSender = originalSender,
        );

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );
        expect(sent, 1, reason: 'mail should have been sent on the first sweep');
        expect(await offlineAlerts(), isEmpty);

        await DeviceOfflineAlertFutureCall().markOfflineDevices(
          sessionBuilder.build(),
        );
        expect(
          sent,
          1,
          reason: 'the marker did not prevent a repeat alert on the second sweep',
        );
      });
    },
  );
}
