import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_auth_service.dart';
import 'package:wonkru_mdm_server/src/service/device_command_service.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  final registry = DeviceConnectionRegistry.instance;

  setUp(registry.clear);
  tearDown(registry.clear);

  // The stream session handles inbound messages concurrently in the
  // background, which a test transaction does not allow, so rollback is off
  // and rows are deleted manually in tearDown.
  withServerpod(
    'Given the device stream',
    rollbackDatabase: RollbackDatabase.disabled,
    (
      sessionBuilder,
      endpoints,
    ) {
      final createdUuids = <String>{};
      final createdPolicyIds = <int>{};
      final createdAdminIds = <UuidValue>{};

      tearDown(() async {
        final session = sessionBuilder.build();
        if (createdUuids.isNotEmpty) {
          await Device.db.deleteWhere(
            session,
            where: (t) => t.uuid.inSet(createdUuids),
          );
        }
        if (createdPolicyIds.isNotEmpty) {
          await Policy.db.deleteWhere(
            session,
            where: (t) => t.id.inSet(createdPolicyIds),
          );
        }
        if (createdAdminIds.isNotEmpty) {
          await AdminProfile.db.deleteWhere(
            session,
            where: (t) => t.userId.inSet(createdAdminIds),
          );
        }
        createdUuids.clear();
        createdPolicyIds.clear();
        createdAdminIds.clear();
      });

      Future<DeviceRegisterResponse> register(String model) async {
        final registered = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: model),
        );
        createdUuids.add(registered.uuid);
        return registered;
      }

      Future<Policy> createPolicy(String name, {int? version}) async {
        final policy = await Policy.db.insertRow(
          sessionBuilder.build(),
          version == null
              ? Policy(name: name)
              : Policy(name: name, version: version),
        );
        createdPolicyIds.add(policy.id!);
        return policy;
      }

      Future<Connection> connect(String token) async {
        final inbound = StreamController<DeviceStreamMessage>();
        addTearDown(inbound.close);
        final received = <DeviceStreamMessage>[];
        final done = Completer<void>();
        final subscription = endpoints.device
            .connect(sessionBuilder, token, inbound.stream)
            .listen(
              received.add,
              onDone: () {
                if (!done.isCompleted) done.complete();
              },
              onError: (Object _) {
                if (!done.isCompleted) done.complete();
              },
            );
        addTearDown(subscription.cancel);
        await flushEventQueue();
        return Connection(inbound, received, done);
      }

      Future<void> eventually(FutureOr<bool> Function() condition) async {
        for (var i = 0; i < 100; i++) {
          if (await condition()) return;
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
        fail('Condition was not met in time.');
      }

      Future<Device> deviceOf(DeviceRegisterResponse registered) async {
        final device = await Device.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.uuid.equals(registered.uuid),
        );
        return device!;
      }

      Future<void> sync(
        DeviceRegisterResponse registered,
        Map<String, dynamic> payload, {
        String syncType = 'full',
      }) {
        return endpoints.device.sync(
          sessionBuilder,
          DeviceSyncRequest(
            deviceUuid: registered.uuid,
            token: registered.token,
            syncType: syncType,
            payload: jsonEncode(payload),
          ),
        );
      }

      test('when a heartbeat arrives after the panel changed the device then '
          'only lastSeenAt is written.', () async {
        final session = sessionBuilder.build();
        final registered = await register('hb');
        final connection = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));

        final policy = await createPolicy('P');
        final fresh = await deviceOf(registered);
        final seenBefore = fresh.lastSeenAt;
        await Device.db.updateRow(
          session,
          fresh
            ..name = 'Renamed'
            ..policyId = policy.id,
        );

        connection.inbound.add(DeviceStreamMessage(type: 'heartbeat'));
        await eventually(
          () async => (await deviceOf(registered)).lastSeenAt != seenBefore,
        );

        final after = await deviceOf(registered);
        expect(after.name, 'Renamed');
        expect(after.policyId, policy.id);
      });

      test(
        'when a dynamic sync omits sections then the stored values stay.',
        () async {
          final registered = await register('sync');

          await sync(registered, {
            'policy_version': 4,
            'device': {
              'manufacturer': 'Acme',
              'model': 'X1',
              'version': {'release': '14', 'sdkInt': 34},
            },
            'battery': {'level': 80},
            'systemSettings': {
              'security': {'isRooted': true},
            },
            'bs': {'launcher_mode_enabled': true},
            'storage': {'totalStorageBytes': 1000, 'freeStorageBytes': 400},
          });

          await sync(registered, {
            'battery': {'level': 55},
          }, syncType: 'dynamic');

          final device = await deviceOf(registered);
          expect(device.batteryLevel, 55);
          expect(device.policyVersion, 4);
          expect(device.manufacturer, 'Acme');
          expect(device.androidVersion, '14');
          expect(device.sdkVersion, 34);
          expect(device.isRooted, isTrue);
          expect(device.isLauncherMode, isTrue);
          expect(device.totalStorageBytes, 1000);

          final cache = await DeviceStateCache.db.findFirstRow(
            sessionBuilder.build(),
            where: (t) => t.deviceId.equals(device.id!),
          );
          expect(cache!.batteryLevel, 55);
          expect(cache.manufacturer, 'Acme');
          expect(cache.isRooted, isTrue);
          expect(cache.launcherModeEnabled, isTrue);
          expect(cache.totalStorageBytes, 1000);
        },
      );

      test(
        'when a sync runs then panel owned columns are not written.',
        () async {
          final session = sessionBuilder.build();
          final registered = await register('owned');
          final policy = await createPolicy('Own');
          final device = await deviceOf(registered);
          await Device.db.updateRow(
            session,
            device
              ..name = 'Kept'
              ..policyId = policy.id,
          );

          await sync(registered, {
            'battery': {'level': 10},
          });

          final after = await deviceOf(registered);
          expect(after.name, 'Kept');
          expect(after.policyId, policy.id);
          expect(after.batteryLevel, 10);
        },
      );

      test('when the device reconnects then the old stream closes and presence '
          'stays online.', () async {
        final registered = await register('reconnect');
        await sync(registered, {
          'network': {'isOnline': true},
        });
        final device = await deviceOf(registered);

        final first = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));
        final second = await connect(registered.token);

        await first.done.future.timeout(const Duration(seconds: 5));
        await flushEventQueue();

        expect(registry.isOnline(registered.uuid), isTrue);
        final cache = await DeviceStateCache.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(cache!.isOnline, isTrue);
        expect(second.done.isCompleted, isFalse);
      });

      test('when the device is deleted by the panel then its stream is '
          'closed.', () async {
        const adminUserId = '11111111-1111-4111-8111-111111111111';
        final session = sessionBuilder.build();
        createdAdminIds.add(UuidValue.fromString(adminUserId));
        await AdminProfile.db.insertRow(
          session,
          AdminProfile(
            userId: UuidValue.fromString(adminUserId),
            status: AdminAccountStatus.active,
          ),
        );
        final adminBuilder = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            adminUserId,
            {Scope('admin')},
          ),
        );

        final registered = await register('delete');
        final connection = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));
        final device = await deviceOf(registered);

        await endpoints.adminDevice.delete(adminBuilder, [device.id!]);

        await connection.done.future.timeout(const Duration(seconds: 5));
        expect(registry.isOnline(registered.uuid), isFalse);
      });

      test('when an inbound message arrives for a removed device then the '
          'stream is closed.', () async {
        final registered = await register('gone');
        final connection = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));

        final device = await deviceOf(registered);
        await Device.db.deleteRow(sessionBuilder.build(), device);

        connection.inbound.add(DeviceStreamMessage(type: 'heartbeat'));
        await connection.done.future.timeout(const Duration(seconds: 5));
      });

      test('when the device reconnects then unacked sent commands are '
          're-delivered with the same commandId.', () async {
        final session = sessionBuilder.build();
        final registered = await register('redeliver');
        final device = await deviceOf(registered);

        await DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: 'lost-1',
            action: DeviceAction.reboot,
            status: DeviceCommandService.statusSent,
            attempts: 1,
            createdAt: DateTime.now().toUtc(),
            sentAt: DateTime.now().toUtc(),
          ),
        );
        await DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: 'exhausted',
            action: DeviceAction.reboot,
            status: DeviceCommandService.statusSent,
            attempts: DeviceCommandService.maxDeliveryAttempts,
            createdAt: DateTime.now().toUtc(),
            sentAt: DateTime.now().toUtc(),
          ),
        );

        final connection = await connect(registered.token);
        await eventually(
          () => connection.received.any((m) => m.type == 'command'),
        );

        final commands = connection.received.where((m) => m.type == 'command');
        expect(commands.map((m) => m.commandId), ['lost-1']);

        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.commandId.equals('lost-1'),
        );
        expect(row!.status, DeviceCommandService.statusSent);
        expect(row.attempts, 2);
      });

      test('when the device acks over the stream then the command of that '
          'device is acked.', () async {
        final session = sessionBuilder.build();
        final registered = await register('ack');
        final device = await deviceOf(registered);
        final connection = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));

        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );
        await DeviceCommandService.flushPending(session, device);
        await eventually(
          () => connection.received.any((m) => m.type == 'command'),
        );
        final commandId = connection.received
            .firstWhere((m) => m.type == 'command')
            .commandId;

        connection.inbound.add(
          DeviceStreamMessage(
            type: 'ack',
            commandId: commandId,
            payload: '{"success":true}',
          ),
        );

        await eventually(() async {
          final row = await DeviceCommand.db.findFirstRow(
            session,
            where: (t) => t.commandId.equals(commandId!),
          );
          return row!.status == DeviceCommandService.statusAcked;
        });
      });

      Future<String> pushCommand(Device device, Connection connection) async {
        final session = sessionBuilder.build();
        final before = connection.received.where((m) => m.type == 'command');
        final seen = before.length;
        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );
        await DeviceCommandService.flushPending(session, device);
        await eventually(
          () =>
              connection.received.where((m) => m.type == 'command').length >
              seen,
        );
        return connection.received
            .where((m) => m.type == 'command')
            .last
            .commandId!;
      }

      Future<DeviceCommand> commandRow(String commandId) async =>
          (await DeviceCommand.db.findFirstRow(
            sessionBuilder.build(),
            where: (t) => t.commandId.equals(commandId),
          ))!;

      group('connect authentication', () {
        for (final token in ['', 'unknown-token']) {
          test('when the token is "$token" then the stream fails as '
              'unauthenticated and nothing is registered.', () async {
            final errors = <Object>[];
            final done = Completer<void>();
            final inbound = StreamController<DeviceStreamMessage>();
            addTearDown(inbound.close);
            endpoints.device
                .connect(sessionBuilder, token, inbound.stream)
                .listen(
                  (_) {},
                  onError: errors.add,
                  onDone: done.complete,
                );
            await done.future.timeout(const Duration(seconds: 5));

            // The test harness also reports the connection close as an error;
            // the first error is the decisive one.
            expect(errors.first, isA<DeviceUnauthenticatedException>());
            expect(registry.onlineUuids, isEmpty);
          });
        }

        test('when the device token is rotated while connected then the next '
            'inbound message closes the stream.', () async {
          final registered = await register('rotate');
          final connection = await connect(registered.token);
          await eventually(() => registry.isOnline(registered.uuid));

          final device = await deviceOf(registered);
          await Device.db.updateRow(
            sessionBuilder.build(),
            device..authToken = DeviceAuthService.hashToken('new-token'),
          );

          connection.inbound.add(DeviceStreamMessage(type: 'heartbeat'));
          await connection.done.future.timeout(const Duration(seconds: 5));
          expect(registry.isOnline(registered.uuid), isFalse);
        });
      });

      group('acks over the stream', () {
        test('when the agent reports a failure then the command is marked '
            'error with the response.', () async {
          for (final payload in [
            '{"success":false,"message":"permission denied"}',
            '{"error":true}',
          ]) {
            final registered = await register('fail-${payload.length}');
            final device = await deviceOf(registered);
            final connection = await connect(registered.token);
            await eventually(() => registry.isOnline(registered.uuid));
            final commandId = await pushCommand(device, connection);

            connection.inbound.add(
              DeviceStreamMessage(
                type: 'ack',
                commandId: commandId,
                payload: payload,
              ),
            );

            await eventually(
              () async =>
                  (await commandRow(commandId)).status !=
                  DeviceCommandService.statusSent,
            );
            final row = await commandRow(commandId);
            expect(
              row.status,
              DeviceCommandService.statusError,
              reason: payload,
            );
            expect(row.response, payload);
          }
        });

        test('when the payload is not a failure map then the command is '
            'acked.', () async {
          for (final payload in [null, '', 'plain text', '[false]', '{}']) {
            final registered = await register('ok-${payload?.length}');
            final device = await deviceOf(registered);
            final connection = await connect(registered.token);
            await eventually(() => registry.isOnline(registered.uuid));
            final commandId = await pushCommand(device, connection);

            connection.inbound.add(
              DeviceStreamMessage(
                type: 'ack',
                commandId: commandId,
                payload: payload,
              ),
            );

            await eventually(
              () async =>
                  (await commandRow(commandId)).status ==
                  DeviceCommandService.statusAcked,
            );
          }
        });

        test('when an ack names an unknown or empty commandId then pending '
            'work is untouched and the stream stays open.', () async {
          final registered = await register('unknown-ack');
          final device = await deviceOf(registered);
          final connection = await connect(registered.token);
          await eventually(() => registry.isOnline(registered.uuid));
          final commandId = await pushCommand(device, connection);

          for (final id in ['no-such-command', '', '   ', null]) {
            connection.inbound.add(
              DeviceStreamMessage(type: 'ack', commandId: id),
            );
          }
          // A stream processes in order, so once the next real ack is handled
          // the preceding ones were handled too.
          connection.inbound.add(
            DeviceStreamMessage(type: 'ack', commandId: commandId),
          );
          await eventually(
            () async =>
                (await commandRow(commandId)).status ==
                DeviceCommandService.statusAcked,
          );

          expect(connection.done.isCompleted, isFalse);
          expect(registry.isOnline(registered.uuid), isTrue);
        });

        test('when a device acks another device\'s commandId then that '
            'command stays sent.', () async {
          final owner = await register('owner');
          final ownerDevice = await deviceOf(owner);
          final ownerConnection = await connect(owner.token);
          await eventually(() => registry.isOnline(owner.uuid));
          final commandId = await pushCommand(ownerDevice, ownerConnection);

          final intruder = await register('intruder');
          final intruderConnection = await connect(intruder.token);
          await eventually(() => registry.isOnline(intruder.uuid));
          final intruderDevice = await deviceOf(intruder);
          final probe = await pushCommand(intruderDevice, intruderConnection);

          intruderConnection.inbound
            ..add(DeviceStreamMessage(type: 'ack', commandId: commandId))
            ..add(DeviceStreamMessage(type: 'ack', commandId: probe));
          await eventually(
            () async =>
                (await commandRow(probe)).status ==
                DeviceCommandService.statusAcked,
          );

          expect(
            (await commandRow(commandId)).status,
            DeviceCommandService.statusSent,
          );
        });
      });

      test('when the agent closes the stream then the registry entry and the '
          'cached presence go offline.', () async {
        final registered = await register('bye');
        await sync(registered, {
          'network': {'isOnline': true},
        });
        final device = await deviceOf(registered);
        final connection = await connect(registered.token);
        await eventually(() => registry.isOnline(registered.uuid));

        await connection.inbound.close();
        await connection.done.future.timeout(const Duration(seconds: 5));

        expect(registry.isOnline(registered.uuid), isFalse);
        await eventually(() async {
          final cache = await DeviceStateCache.db.findFirstRow(
            sessionBuilder.build(),
            where: (t) => t.deviceId.equals(device.id!),
          );
          return cache!.isOnline == false;
        });
      });

      group('policyChange RPC', () {
        test('when the requested policy is the assigned one then it is '
            'confirmed without a write.', () async {
          final session = sessionBuilder.build();
          final registered = await register('pc');
          final policy = await createPolicy('Assigned', version: 3);
          final device = await deviceOf(registered);
          await Device.db.updateRow(session, device..policyId = policy.id);

          final ok = await endpoints.device.policyChange(
            sessionBuilder,
            DevicePolicyChangeRequest(
              deviceUuid: registered.uuid,
              token: registered.token,
              policyId: policy.id!,
            ),
          );

          expect(ok, isTrue);
          final after = await deviceOf(registered);
          expect(after.policyId, policy.id);
          expect(after.policyVersion, isNull);
        });

        test('when another policy is requested then it is rejected and nothing '
            'is written.', () async {
          final session = sessionBuilder.build();
          final registered = await register('pc2');
          final assigned = await createPolicy('Assigned');
          final other = await createPolicy('Other');
          final device = await deviceOf(registered);
          await Device.db.updateRow(session, device..policyId = assigned.id);

          final ok = await endpoints.device.policyChange(
            sessionBuilder,
            DevicePolicyChangeRequest(
              deviceUuid: registered.uuid,
              token: registered.token,
              policyId: other.id!,
            ),
          );

          expect(ok, isFalse);
          expect((await deviceOf(registered)).policyId, assigned.id);
        });
      });
    },
  );
}

final class Connection {
  Connection(this.inbound, this.received, this.done);

  final StreamController<DeviceStreamMessage> inbound;
  final List<DeviceStreamMessage> received;
  final Completer<void> done;
}
