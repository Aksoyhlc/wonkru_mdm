import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/future_calls/check_policy_devices_updated_future_call.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given CheckPolicyDevicesUpdatedFutureCall',
    (sessionBuilder, endpoints) {
      const adminUserId = '44444444-4444-4444-8444-444444444444';

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

      Future<Policy> createPolicy() {
        final session = sessionBuilder.build();
        return Policy.db.insertRow(
          session,
          Policy(name: 'Corporate', version: 3),
        );
      }

      Future<Device> createDevice({
        required String code,
        required int policyId,
        int? policyVersion,
      }) {
        final session = sessionBuilder.build();
        final now = DateTime.now().toUtc();
        return Device.db.insertRow(
          session,
          Device(
            code: code,
            name: 'Device $code',
            policyId: policyId,
            policyVersion: policyVersion,
            firstSeenAt: now,
            lastSeenAt: now,
            collectedAt: now,
          ),
        );
      }

      Future<List<AdminNotification>> policyAlerts() async {
        final session = sessionBuilder.build();
        return AdminNotification.db.find(
          session,
          where: (t) =>
              t.type.equals(SystemAlertType.policy_update_pending.name),
          orderBy: (t) => t.id,
        );
      }

      test('produces an alert for devices stuck on an old version', () async {
        await createAdmin();
        final policy = await createPolicy();
        final outdated = await createDevice(
          code: 'OLD1',
          policyId: policy.id!,
          policyVersion: 1,
        );
        final neverSynced = await createDevice(
          code: 'OLD2',
          policyId: policy.id!,
          policyVersion: null,
        );
        await createDevice(
          code: 'CURRENT',
          policyId: policy.id!,
          policyVersion: 3,
        );

        await CheckPolicyDevicesUpdatedFutureCall().check(
          sessionBuilder.build(),
          CheckPolicyDevicesCall(policyId: policy.id!, expectedVersion: 3),
        );

        final alerts = await policyAlerts();
        expect(alerts, hasLength(1));
        expect(alerts.single.userId, UuidValue.fromString(adminUserId));
        expect(
          alerts.single.title,
          'Policy update pending: Corporate (v3)',
        );
        expect(
          alerts.single.message,
          '2 devices have not received the policy update yet.\n'
          '- Device ${outdated.code} (id: ${outdated.id}, policy_version: 1)\n'
          '- Device ${neverSynced.code} (id: ${neverSynced.id}, '
          'policy_version: null)',
        );

        final data = jsonDecode(alerts.single.data!) as Map<String, dynamic>;
        expect(data['policy_id'], policy.id);
        expect(data['policy_version'], 3);
        expect(data['device_ids'], [outdated.id, neverSynced.id]);
      });

      test('no alert is produced when no device is on an old version', () async {
        await createAdmin();
        final policy = await createPolicy();
        await createDevice(
          code: 'CURRENT',
          policyId: policy.id!,
          policyVersion: 3,
        );

        await CheckPolicyDevicesUpdatedFutureCall().check(
          sessionBuilder.build(),
          CheckPolicyDevicesCall(policyId: policy.id!, expectedVersion: 3),
        );

        expect(await policyAlerts(), isEmpty);
      });

      test('no alert is produced when the policy is not found', () async {
        await createAdmin();

        await CheckPolicyDevicesUpdatedFutureCall().check(
          sessionBuilder.build(),
          CheckPolicyDevicesCall(policyId: 999999, expectedVersion: 2),
        );

        expect(await policyAlerts(), isEmpty);
      });
    },
  );
}
