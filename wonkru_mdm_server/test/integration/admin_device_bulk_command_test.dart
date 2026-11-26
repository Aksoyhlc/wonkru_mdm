import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_command_service.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final registry = DeviceConnectionRegistry.instance;

  setUp(registry.clear);
  tearDown(registry.clear);

  withServerpod('Given AdminDeviceEndpoint bulk command tracking', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const outsiderUserId = '22222222-2222-4222-8222-222222222222';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    final outsiderBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        outsiderUserId,
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

    Future<Device> createDevice(
      Session session, {
      required String code,
      String? uuid,
    }) {
      return Device.db.insertRow(
        session,
        Device(code: code, uuid: uuid),
      );
    }

    List<DeviceStreamMessage> connectDevice(String uuid) {
      final controller = StreamController<DeviceStreamMessage>();
      addTearDown(controller.close);
      final received = <DeviceStreamMessage>[];
      final subscription = controller.stream.listen(received.add);
      addTearDown(subscription.cancel);
      registry.register(uuid, controller);
      return received;
    }

    group('sendCommand', () {
      test('generates a new bulkId and is the total device count.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(
          session,
          code: 'BULK-A',
          uuid: 'uuid-bulk-a',
        );
        final second = await createDevice(
          session,
          code: 'BULK-B',
          uuid: 'uuid-bulk-b',
        );
        connectDevice('uuid-bulk-a');
        connectDevice('uuid-bulk-b');

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [first.id!, second.id!],
          'reboot',
          null,
        );

        expect(status.bulkId, isNotEmpty);
        expect(status.total, 2);
        expect(status.sent, 2);
        expect(status.pending, 0);

        final rows = await DeviceCommand.db.find(
          session,
          where: (t) => t.deviceId.inSet({first.id!, second.id!}),
        );
        expect(rows, hasLength(2));
        expect(
          rows.map((row) => row.bulkId).toSet(),
          {status.bulkId},
        );
      });

      test('a device without a uuid is not counted in the total.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final withoutUuid = await createDevice(session, code: 'BULK-NO-UUID');
        final withUuid = await createDevice(
          session,
          code: 'BULK-WITH-UUID',
          uuid: 'uuid-bulk-present',
        );
        connectDevice('uuid-bulk-present');

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [withoutUuid.id!, withUuid.id!],
          'reboot',
          null,
        );

        expect(status.total, 1);
        expect(status.sent, 1);
      });
    });

    group('bulkStatus', () {
      test('reflects the acked/timeout/sent counts.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(
          session,
          code: 'STAT-A',
          uuid: 'uuid-stat-a',
        );
        final second = await createDevice(
          session,
          code: 'STAT-B',
          uuid: 'uuid-stat-b',
        );
        final third = await createDevice(
          session,
          code: 'STAT-C',
          uuid: 'uuid-stat-c',
        );
        connectDevice('uuid-stat-a');
        connectDevice('uuid-stat-b');
        connectDevice('uuid-stat-c');

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [first.id!, second.id!, third.id!],
          'reboot',
          null,
        );
        expect(status.total, 3);
        expect(status.sent, 3);

        final rows = await DeviceCommand.db.find(
          session,
          where: (t) => t.bulkId.equals(status.bulkId),
          orderBy: (t) => t.id,
        );

        await DeviceCommandService.acknowledge(
          session,
          rows[0].commandId,
          deviceId: rows[0].deviceId,
          response: '{"ok":true}',
        );

        rows[1].sentAt = DateTime.now().toUtc().subtract(
          const Duration(hours: 1),
        );
        await DeviceCommand.db.updateRow(session, rows[1]);
        await DeviceCommandService.markTimeouts(
          session,
          timeout: const Duration(minutes: 10),
        );

        final progress = await endpoints.adminDevice.bulkStatus(
          adminBuilder,
          status.bulkId,
        );

        expect(progress.total, 3);
        expect(progress.acked, 1);
        expect(progress.timeout, 1);
        expect(progress.sent, 1);
        expect(progress.pending, 0);
        expect(progress.error, 0);
      });

      test('a row with an unknown status is counted in the total too.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'ODD',
          uuid: 'uuid-odd',
        );

        await session.db.unsafeExecute('''
          INSERT INTO "device_commands"
            ("deviceId", "commandId", "bulkId", "action", "status", "attempts",
             "createdAt")
          VALUES (${device.id!}, 'odd-command', 'bulk-odd', 'reboot',
                  'delivered', 0, NOW())
        ''');

        final progress = await endpoints.adminDevice.bulkStatus(
          adminBuilder,
          'bulk-odd',
        );

        expect(progress.total, 1);
        expect(progress.pending + progress.sent, 0);
      });

      test('returns zero counts for an unknown bulkId.', () async {
        await createProfile();

        final progress = await endpoints.adminDevice.bulkStatus(
          adminBuilder,
          'bulk-does-not-exist',
        );

        expect(progress.bulkId, 'bulk-does-not-exist');
        expect(progress.total, 0);
      });

      test('an unauthorized user is rejected.', () async {
        await expectLater(
          endpoints.adminDevice.bulkStatus(outsiderBuilder, 'bulk-any'),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });
  });
}
