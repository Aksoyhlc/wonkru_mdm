import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_security_alert_service.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Given DeviceSecurityAlertService', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '33333333-3333-4333-8333-333333333333';

    tearDown(() {
      DeviceSecurityAlertService.debugSender = null;
    });

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

    Future<void> syncSecurity(
      DeviceRegisterResponse device,
      Map<String, dynamic> security,
    ) {
      return endpoints.device.sync(
        sessionBuilder,
        DeviceSyncRequest(
          deviceUuid: device.uuid,
          token: device.token,
          syncType: 'full',
          payload: jsonEncode({
            'systemSettings': {
              'security': security,
            },
          }),
        ),
      );
    }

    Future<Device> deviceByUuid(String uuid) async {
      final session = sessionBuilder.build();
      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(uuid),
      );
      return device!;
    }

    Future<void> assignPolicy(String uuid, Policy policy) async {
      final session = sessionBuilder.build();
      final device = await deviceByUuid(uuid);
      device.policyId = policy.id;
      await Device.db.updateRow(session, device);
    }

    Future<List<AdminNotification>> securityAlerts() async {
      final session = sessionBuilder.build();
      return AdminNotification.db.find(
        session,
        where: (t) => t.type.equals(SystemAlertType.security_info.name),
        orderBy: (t) => t.id,
      );
    }

    test('produces an alert for newly enabled ADB USB debugging', () async {
      await createAdmin();
      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'security-adb'),
      );

      await syncSecurity(device, {
        'adbEnabled': false,
        'developerOptionsEnabled': false,
        'isRooted': false,
      });
      expect(await securityAlerts(), isEmpty);

      await syncSecurity(device, {
        'adbEnabled': true,
        'developerOptionsEnabled': false,
        'isRooted': false,
      });

      final alerts = await securityAlerts();
      expect(alerts, hasLength(1));
      expect(alerts.single.userId, UuidValue.fromString(adminUserId));
      expect(alerts.single.type, SystemAlertType.security_info.name);
      expect(alerts.single.title, startsWith('Security change:'));
      expect(
        alerts.single.message,
        'USB debugging (ADB) was enabled.',
      );

      final data = jsonDecode(alerts.single.data!) as Map<String, dynamic>;
      expect(data['device_id'], isNotNull);
      expect(data['device_sync_id'], isNotNull);

      // The alert is emitted from the previous state; updateFromSync runs
      // afterwards, so the cache already holds the new state.
      final session = sessionBuilder.build();
      final row = await deviceByUuid(device.uuid);
      final cache = await DeviceStateCache.db.findFirstRow(
        session,
        where: (t) => t.deviceId.equals(row.id!),
      );
      expect(cache!.adbEnabled, isTrue);
    });

    test(
      'produces an alert when root becomes enabled, not when it turns off',
      () async {
      await createAdmin();
      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'security-root'),
      );

      await syncSecurity(device, {'isRooted': false});
      expect(await securityAlerts(), isEmpty);

      await syncSecurity(device, {'isRooted': true});
      final opened = await securityAlerts();
      expect(opened, hasLength(1));
      expect(
        opened.single.message,
        'Root / security scan: isRooted is now positive.',
      );

      await syncSecurity(device, {'isRooted': false});
      expect(await securityAlerts(), hasLength(1));

      await syncSecurity(device, {'isRooted': true});
      expect(await securityAlerts(), hasLength(2));
    });

    test('produces no alert when there is no change', () async {
      await createAdmin();
      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'security-quiet'),
      );

      await syncSecurity(device, {
        'adbEnabled': true,
        'developerOptionsEnabled': true,
        'isRooted': true,
      });
      expect(await securityAlerts(), isEmpty);

      await syncSecurity(device, {
        'adbEnabled': true,
        'developerOptionsEnabled': true,
        'isRooted': true,
      });
      expect(await securityAlerts(), isEmpty);

      await syncSecurity(device, {
        'adbEnabled': false,
        'developerOptionsEnabled': false,
        'isRooted': false,
      });
      expect(await securityAlerts(), isEmpty);
    });

    test(
      'produces an alert for an accessibility app not allowed by the policy',
      () async {
        await createAdmin();
        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(
          session,
          Policy(
            name: 'Corporate',
            securitySettings: jsonEncode({
              'allowed_accessibility_apps': ['com.allowed'],
            }),
          ),
        );

        final device = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'security-accessibility'),
        );
        await assignPolicy(device.uuid, policy);

        await syncSecurity(device, {
          'enabledAccessibilityApps': ['com.allowed', 'com.forbidden'],
        });

        final alerts = await securityAlerts();
        expect(alerts, hasLength(1));
        expect(
          alerts.single.message,
          'Accessibility app not allowed by policy: com.forbidden',
        );
      },
    );

    test(
      'no violation is reported when the policy has no accessibility list',
      () async {
      await createAdmin();
      final session = sessionBuilder.build();
      final policy = await Policy.db.insertRow(
        session,
        Policy(name: 'Free'),
      );

      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'security-no-list'),
      );
      await assignPolicy(device.uuid, policy);

      await syncSecurity(device, {
        'isRooted': false,
        'enabledAccessibilityApps': ['com.any'],
      });

      expect(await securityAlerts(), isEmpty);
    });

    test('a delivery failure does not stop the sync flow', () async {
      await createAdmin();
      final device = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'security-fail'),
      );

      await syncSecurity(device, {'adbEnabled': false});
      expect(await securityAlerts(), isEmpty);

      var ranOutsideSyncTransaction = false;
      DeviceSecurityAlertService.debugSender =
          (
            session, {
            required title,
            required message,
            required data,
          }) async {
            // Untransactioned DB access while the sync transaction is open
            // throws ConcurrentTransactionsException, so a successful call
            // here proves delivery runs outside that transaction.
            await AdminNotification.db.count(session);
            ranOutsideSyncTransaction = true;
            throw StateError('alert delivery failed');
          };

      await syncSecurity(device, {'adbEnabled': true});

      expect(ranOutsideSyncTransaction, isTrue);
      expect(await securityAlerts(), isEmpty);

      final session = sessionBuilder.build();
      final row = await deviceByUuid(device.uuid);
      final cache = await DeviceStateCache.db.findFirstRow(
        session,
        where: (t) => t.deviceId.equals(row.id!),
      );
      expect(cache!.adbEnabled, isTrue);
    });
  });
}
