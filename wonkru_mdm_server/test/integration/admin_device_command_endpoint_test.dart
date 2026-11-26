import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_command_service.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  final registry = DeviceConnectionRegistry.instance;

  setUp(registry.clear);
  tearDown(registry.clear);

  withServerpod('Given AdminDeviceEndpoint.sendCommand', (
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

    Map<String, dynamic> payloadOf(DeviceStreamMessage message) =>
        jsonDecode(message.payload!) as Map<String, dynamic>;

    group('validation', () {
      test('when the action is unknown then a typed validation error is '
          'thrown.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDevice.sendCommand(
            adminBuilder,
            const [1],
            'nope',
            null,
          ),
          throwsA(isA<DeviceCommandValidationException>()),
        );
      });

      test('when the action is unknown then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDevice.sendCommand(
            adminBuilder,
            const [1],
            'nope',
            null,
          ),
          throwsExceptionWith('Unknown action "nope".'),
        );
      });

      test('when a non-bulk action targets several devices then it is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDevice.sendCommand(
            adminBuilder,
            const [1, 2],
            'launch_app',
            '{"package_name":"com.example"}',
          ),
          throwsExceptionWith(
            'Action "launch_app" cannot be sent to multiple devices.',
          ),
        );
      });

      test(
        'when a package action has no package then it is rejected.',
        () async {
          await createProfile();

          await expectLater(
            endpoints.adminDevice.sendCommand(
              adminBuilder,
              const [1],
              'launch_app',
              '{}',
            ),
            throwsExceptionWith(
              'The "package_name" parameter is required for "launch_app".',
            ),
          );
        },
      );

      test(
        'when paramsJson is not a JSON object then it is rejected.',
        () async {
          await createProfile();

          await expectLater(
            endpoints.adminDevice.sendCommand(
              adminBuilder,
              const [1],
              'reboot',
              '[]',
            ),
            throwsExceptionWith('paramsJson must be a JSON object.'),
          );
        },
      );
    });

    group('queue', () {
      test('when one device is connected then the command is streamed and '
          'marked sent.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'ONE',
          uuid: 'uuid-one',
        );
        final received = connectDevice('uuid-one');

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [device.id!],
          'send_notification',
          '{"title":"Hi","body":"There"}',
        );
        await Future<void>.delayed(Duration.zero);

        expect(status.total, 1);
        expect(status.bulkId, isNotEmpty);
        expect(received, hasLength(1));

        final payload = payloadOf(received.single);
        expect(payload['action'], 'send_notification');
        final params = payload['params'] as Map<String, dynamic>;
        expect(params['title'], 'Hi');
        expect(params['body'], 'There');

        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(row!.status, DeviceCommandService.statusSent);
        expect(row.attempts, 1);
      });

      test('when policy_change is sent then the server assigns the policy '
          'before queueing.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final policy = await Policy.db.insertRow(session, Policy(name: 'New'));
        final device = await createDevice(
          session,
          code: 'PC',
          uuid: 'uuid-pc',
        );

        await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [device.id!],
          'policy_change',
          '{"policy_id":${policy.id}}',
        );

        final updated = await Device.db.findById(session, device.id!);
        expect(updated!.policyId, policy.id);
        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        final params = jsonDecode(row!.params!) as Map<String, dynamic>;
        expect(params['policy_id'], '${policy.id}');
      });

      test('when policy_change has no valid policy then nothing is '
          'queued.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'PC2',
          uuid: 'uuid-pc2',
        );

        await expectLater(
          endpoints.adminDevice.sendCommand(
            adminBuilder,
            [device.id!],
            'policy_change',
            '{"policy_id":999999}',
          ),
          throwsExceptionWith('Policy 999999 does not exist.'),
        );
        await expectLater(
          endpoints.adminDevice.sendCommand(
            adminBuilder,
            [device.id!],
            'policy_change',
            null,
          ),
          throwsExceptionWith(
            'The "policy_id" parameter is required for "policy_change".',
          ),
        );
        expect(
          await DeviceCommand.db.find(
            session,
            where: (t) => t.deviceId.equals(device.id!),
          ),
          isEmpty,
        );
      });

      test('when defaults are missing then they are filled in.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DEFAULTS',
          uuid: 'uuid-defaults',
        );
        final received = connectDevice('uuid-defaults');

        await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [device.id!],
          'get_installed_apps',
          null,
        );
        await Future<void>.delayed(Duration.zero);

        final params =
            payloadOf(received.single)['params'] as Map<String, dynamic>;
        expect(params['include_system_apps'], '0');
      });

      test(
        'when several devices are given then each one is queued.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final first = await createDevice(
            session,
            code: 'A',
            uuid: 'uuid-a',
          );
          final second = await createDevice(
            session,
            code: 'B',
            uuid: 'uuid-b',
          );
          final firstReceived = connectDevice('uuid-a');
          final secondReceived = connectDevice('uuid-b');

          final status = await endpoints.adminDevice.sendCommand(
            adminBuilder,
            [first.id!, second.id!],
            'reboot',
            null,
          );
          await Future<void>.delayed(Duration.zero);

          expect(status.total, 2);
          expect(firstReceived, hasLength(1));
          expect(secondReceived, hasLength(1));
        },
      );

      test('when a device has no uuid then it is skipped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final withoutUuid = await createDevice(session, code: 'NO-UUID');
        final withUuid = await createDevice(
          session,
          code: 'WITH-UUID',
          uuid: 'uuid-present',
        );
        final received = connectDevice('uuid-present');

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [withoutUuid.id!, withUuid.id!],
          'reboot',
          null,
        );
        await Future<void>.delayed(Duration.zero);

        expect(status.total, 1);
        expect(received, hasLength(1));
        expect(
          await DeviceCommand.db.find(
            session,
            where: (t) => t.deviceId.inSet({withUuid.id!, withoutUuid.id!}),
          ),
          hasLength(1),
        );
      });

      test(
        'when a device is offline then the command stays pending.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final offline = await createDevice(
            session,
            code: 'OFFLINE',
            uuid: 'uuid-offline',
          );

          final status = await endpoints.adminDevice.sendCommand(
            adminBuilder,
            [offline.id!],
            'reboot',
            null,
          );

          expect(status.total, 1);
          expect(status.pending, 1);
          final row = await DeviceCommand.db.findFirstRow(
            session,
            where: (t) => t.deviceId.equals(offline.id!),
          );
          expect(row!.status, DeviceCommandService.statusPending);
          expect(row.sentAt, isNull);
        },
      );
    });

    group('command history', () {
      Future<DeviceCommand> createCommand(
        Session session, {
        required int deviceId,
        required String commandId,
        DeviceCommandStatus status = DeviceCommandService.statusPending,
        String? response,
        DateTime? createdAt,
      }) {
        return DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: deviceId,
            commandId: commandId,
            action: DeviceAction.reboot,
            status: status,
            attempts: 0,
            response: response,
            createdAt: createdAt ?? DateTime.now().toUtc(),
          ),
        );
      }

      test('commands returns only the given device, newest first.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'FIRST');
        final second = await createDevice(session, code: 'SECOND');
        final base = DateTime.now().toUtc();

        await createCommand(
          session,
          deviceId: first.id!,
          commandId: 'a',
          createdAt: base.subtract(const Duration(minutes: 2)),
        );
        await createCommand(
          session,
          deviceId: first.id!,
          commandId: 'b',
          status: DeviceCommandService.statusAcked,
          response: '{"ok":true}',
          createdAt: base,
        );
        await createCommand(session, deviceId: second.id!, commandId: 'c');

        final page = await endpoints.adminDevice.commands(
          adminBuilder,
          first.id!,
          AdminListRequest(perPage: 50),
        );

        expect(page.total, 2);
        expect(page.page, 1);
        expect(page.perPage, 50);
        expect(page.items.map((command) => command.commandId).toList(), [
          'b',
          'a',
        ]);
        expect(page.items.first.response, '{"ok":true}');
      });

      test('recentCommands returns commands across every device, newest '
          'first.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'FIRST');
        final second = await createDevice(session, code: 'SECOND');
        final base = DateTime.now().toUtc();

        await createCommand(
          session,
          deviceId: first.id!,
          commandId: 'a',
          createdAt: base.subtract(const Duration(minutes: 2)),
        );
        await createCommand(
          session,
          deviceId: second.id!,
          commandId: 'b',
          createdAt: base.subtract(const Duration(minutes: 1)),
        );
        await createCommand(
          session,
          deviceId: first.id!,
          commandId: 'c',
          createdAt: base,
        );

        final page = await endpoints.adminDevice.recentCommands(
          adminBuilder,
          AdminListRequest(perPage: 50),
        );

        expect(page.total, 3);
        expect(page.items.map((command) => command.commandId).toList(), [
          'c',
          'b',
          'a',
        ]);
      });

      test('when the user has no admin profile then the history is '
          'rejected.', () async {
        await expectLater(
          endpoints.adminDevice.recentCommands(
            outsiderBuilder,
            AdminListRequest(),
          ),
          throwsA(isA<ServerpodInsufficientAccessException>()),
        );
      });
    });
  });
}
