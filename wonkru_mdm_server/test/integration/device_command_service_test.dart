import 'dart:async';
import 'dart:convert';

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

  withServerpod('Given DeviceCommandService', (sessionBuilder, endpoints) {
    Future<Device> createDevice(
      Session session, {
      String code = 'DEV',
      String? uuid = 'uuid-1',
    }) {
      return Device.db.insertRow(session, Device(code: code, uuid: uuid));
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

    group('enqueue', () {
      test('when devices are given then one pending row per device is '
          'written.', () async {
        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'A', uuid: 'uuid-a');
        final second = await createDevice(session, code: 'B', uuid: 'uuid-b');

        final count = await DeviceCommandService.enqueue(
          session,
          [first.id!, second.id!],
          DeviceAction.reboot,
          const {'delay': 5},
        );

        expect(count, 2);
        final rows = await DeviceCommand.db.find(
          session,
          where: (t) => t.deviceId.inSet({first.id!, second.id!}),
        );
        expect(rows, hasLength(2));
        expect(
          rows.map((row) => row.status),
          everyElement(DeviceCommandService.statusPending),
        );
        expect(
          rows.map((row) => row.commandId).toSet(),
          hasLength(2),
        );
        final params = jsonDecode(rows.first.params!) as Map<String, dynamic>;
        expect(params['delay'], 5);
      });

      test('when the device has no uuid then it is skipped.', () async {
        final session = sessionBuilder.build();
        final withoutUuid = await createDevice(
          session,
          code: 'NO-UUID',
          uuid: null,
        );
        final withUuid = await createDevice(
          session,
          code: 'WITH',
          uuid: 'uuid-x',
        );

        final count = await DeviceCommandService.enqueue(
          session,
          [withoutUuid.id!, withUuid.id!],
          DeviceAction.reboot,
          const {},
        );

        expect(count, 1);
        final rows = await DeviceCommand.db.find(
          session,
          where: (t) => t.deviceId.inSet({withUuid.id!, withoutUuid.id!}),
        );
        expect(rows.single.deviceId, withUuid.id);
        expect(rows.single.params, isNull);
      });

      test('when no device is given then nothing is written.', () async {
        final session = sessionBuilder.build();

        expect(
          await DeviceCommandService.enqueue(
            session,
            const [],
            DeviceAction.reboot,
            const {},
          ),
          0,
        );
        // Not checked table-wide for emptiness: the stream tests do not roll
        // back, so concurrent tests can commit rows while this one runs.
      });
    });

    group('flushPending', () {
      test('when the device is offline then nothing is sent and the row stays '
          'pending.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);

        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );

        expect(
          await DeviceCommandService.flushPending(session, device),
          0,
        );

        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(row!.status, DeviceCommandService.statusPending);
        expect(row.attempts, 0);
        expect(row.sentAt, isNull);
      });

      test('when the device is connected then the command is streamed and '
          'marked sent.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');

        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.send_notification,
          const {'title': 'Hi', 'body': 'There'},
        );

        final sent = await DeviceCommandService.flushPending(session, device);
        await Future<void>.delayed(Duration.zero);

        expect(sent, 1);
        expect(received, hasLength(1));
        final message = received.single;
        expect(message.type, 'command');
        expect(message.commandId, isNotEmpty);
        expect(message.sentAt, isNotNull);

        final payload = jsonDecode(message.payload!) as Map<String, dynamic>;
        expect(payload['action'], 'send_notification');
        expect(payload['params'], {'title': 'Hi', 'body': 'There'});

        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(row!.status, DeviceCommandService.statusSent);
        expect(row.attempts, 1);
        expect(row.sentAt, isNotNull);
      });

      test(
        'when a command was already sent then it is not sent again.',
        () async {
          final session = sessionBuilder.build();
          final device = await createDevice(session);
          final received = connectDevice('uuid-1');

          await DeviceCommandService.enqueue(
            session,
            [device.id!],
            DeviceAction.reboot,
            const {},
          );
          await DeviceCommandService.flushPending(session, device);
          await DeviceCommandService.flushPending(session, device);
          await Future<void>.delayed(Duration.zero);

          expect(received, hasLength(1));
        },
      );
    });

    group('flushAllFor', () {
      test('when only some devices are connected then only those are '
          'flushed.', () async {
        final session = sessionBuilder.build();
        final online = await createDevice(session, code: 'ON', uuid: 'uuid-on');
        final offline = await createDevice(
          session,
          code: 'OFF',
          uuid: 'uuid-off',
        );
        final received = connectDevice('uuid-on');

        await DeviceCommandService.enqueue(
          session,
          [online.id!, offline.id!],
          DeviceAction.reboot,
          const {},
        );

        final sent = await DeviceCommandService.flushAllFor(session, [
          online.id!,
          offline.id!,
        ]);
        await Future<void>.delayed(Duration.zero);

        expect(sent, 1);
        expect(received, hasLength(1));

        final onlineRow = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(online.id!),
        );
        final offlineRow = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(offline.id!),
        );
        expect(onlineRow!.status, DeviceCommandService.statusSent);
        expect(offlineRow!.status, DeviceCommandService.statusPending);
      });
    });

    group('acknowledge', () {
      test('when the command is known then it is marked acked with the '
          'response.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );
        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );

        final found = await DeviceCommandService.acknowledge(
          session,
          row!.commandId,
          deviceId: device.id!,
          response: '{"success":true}',
        );

        expect(found, isTrue);
        final updated = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(updated!.status, DeviceCommandService.statusAcked);
        expect(updated.ackedAt, isNotNull);
        expect(updated.response, '{"success":true}');
      });

      test('when error is set then it is marked error.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );
        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );

        await DeviceCommandService.acknowledge(
          session,
          row!.commandId,
          deviceId: device.id!,
          error: true,
        );

        final updated = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(updated!.status, DeviceCommandService.statusError);
      });

      test('when the command is unknown then nothing happens.', () async {
        final session = sessionBuilder.build();

        expect(
          await DeviceCommandService.acknowledge(
            session,
            'missing',
            deviceId: 1,
          ),
          isFalse,
        );
      });
    });

    group('markTimeouts', () {
      test('when a sent command is older than the timeout then it times '
          'out.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final now = DateTime.now().toUtc();

        await DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: 'old',
            action: DeviceAction.reboot,
            status: DeviceCommandService.statusSent,
            attempts: 1,
            sentAt: now.subtract(const Duration(minutes: 30)),
          ),
        );
        await DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: 'fresh',
            action: DeviceAction.reboot,
            status: DeviceCommandService.statusSent,
            attempts: 1,
            sentAt: now,
          ),
        );

        final timedOut = await DeviceCommandService.markTimeouts(
          session,
          timeout: const Duration(minutes: 10),
        );

        expect(timedOut, 1);
        final old = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.commandId.equals('old'),
        );
        final fresh = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.commandId.equals('fresh'),
        );
        expect(old!.status, DeviceCommandService.statusTimeout);
        expect(fresh!.status, DeviceCommandService.statusSent);
      });
    });

    group('delivery guarantees', () {
      Future<DeviceCommand> insertCommand(
        Session session,
        Device device, {
        required String commandId,
        DeviceAction action = DeviceAction.reboot,
        DeviceCommandStatus status = DeviceCommandService.statusSent,
        int attempts = 1,
        DateTime? createdAt,
        DateTime? sentAt,
      }) {
        final now = DateTime.now().toUtc();
        return DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: commandId,
            action: action,
            status: status,
            attempts: attempts,
            createdAt: createdAt ?? now,
            sentAt: sentAt,
          ),
        );
      }

      Future<DeviceCommand> reload(Session session, String commandId) async {
        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.commandId.equals(commandId),
        );
        return row!;
      }

      test('when two flushes run concurrently then each command is sent '
          'once.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );

        final results = await Future.wait([
          DeviceCommandService.flushPending(session, device),
          DeviceCommandService.flushPending(session, device),
          DeviceCommandService.flushPending(session, device),
        ]);
        await Future<void>.delayed(Duration.zero);

        expect(results.fold<int>(0, (a, b) => a + b), 1);
        expect(received, hasLength(1));
        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(row!.attempts, 1);
      });

      test('when the stream is gone at send time then the claimed row goes '
          'back to pending.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final controller = StreamController<DeviceStreamMessage>();
        registry.register('uuid-1', controller);
        unawaited(controller.close());

        await DeviceCommandService.enqueue(
          session,
          [device.id!],
          DeviceAction.reboot,
          const {},
        );
        expect(await DeviceCommandService.flushPending(session, device), 0);

        final row = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(row!.status, DeviceCommandService.statusPending);
        expect(row.attempts, 0);
        expect(row.sentAt, isNull);
      });

      test('when a normal flush runs then in-flight sent commands are not '
          're-sent.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        await insertCommand(
          session,
          device,
          commandId: 'in-flight',
          sentAt: DateTime.now().toUtc(),
        );

        expect(await DeviceCommandService.flushPending(session, device), 0);
        expect(
          await DeviceCommandService.flushPending(
            session,
            device,
            redeliverSent: true,
          ),
          1,
        );
        await Future<void>.delayed(Duration.zero);
        expect(received.single.commandId, 'in-flight');
        expect((await reload(session, 'in-flight')).attempts, 2);
      });

      test('when a pending command is older than the expiry then it is not '
          'sent and times out.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        await insertCommand(
          session,
          device,
          commandId: 'stale-pending',
          status: DeviceCommandService.statusPending,
          attempts: 0,
          createdAt: DateTime.now().toUtc().subtract(
            DeviceCommandService.pendingExpiry + const Duration(hours: 1),
          ),
        );

        expect(await DeviceCommandService.flushPending(session, device), 0);
        await Future<void>.delayed(Duration.zero);
        expect(received, isEmpty);

        expect(await DeviceCommandService.markTimeouts(session), 1);
        expect(
          (await reload(session, 'stale-pending')).status,
          DeviceCommandService.statusTimeout,
        );
      });

      test(
        'when the ack comes from another device then it is ignored.',
        () async {
          final session = sessionBuilder.build();
          final owner = await createDevice(session, code: 'OWN', uuid: 'u-own');
          final other = await createDevice(session, code: 'OTH', uuid: 'u-oth');
          await insertCommand(session, owner, commandId: 'owned');

          final found = await DeviceCommandService.acknowledge(
            session,
            'owned',
            deviceId: other.id!,
          );

          expect(found, isFalse);
          expect(
            (await reload(session, 'owned')).status,
            DeviceCommandService.statusSent,
          );
        },
      );

      test(
        'when a second ack arrives then the first result is kept.',
        () async {
          final session = sessionBuilder.build();
          final device = await createDevice(session);
          await insertCommand(session, device, commandId: 'dup');

          await DeviceCommandService.acknowledge(
            session,
            'dup',
            deviceId: device.id!,
            response: '{"success":true}',
          );
          await DeviceCommandService.acknowledge(
            session,
            'dup',
            deviceId: device.id!,
            response: '{"success":false}',
            error: true,
          );

          final row = await reload(session, 'dup');
          expect(row.status, DeviceCommandService.statusAcked);
          expect(row.response, '{"success":true}');
        },
      );

      test(
        'when an ack arrives after the timeout then it is recorded.',
        () async {
          final session = sessionBuilder.build();
          final device = await createDevice(session);
          await insertCommand(
            session,
            device,
            commandId: 'late',
            status: DeviceCommandService.statusTimeout,
          );

          await DeviceCommandService.acknowledge(
            session,
            'late',
            deviceId: device.id!,
            error: true,
          );

          final row = await reload(session, 'late');
          expect(row.status, DeviceCommandService.statusError);
          expect(row.ackedAt, isNotNull);
        },
      );

      test('when two reconnect flushes run concurrently then an unacked '
          'command is redelivered once.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        await insertCommand(session, device, commandId: 'retry', attempts: 1);

        final results = await Future.wait([
          DeviceCommandService.flushPending(
            session,
            device,
            redeliverSent: true,
          ),
          DeviceCommandService.flushPending(
            session,
            device,
            redeliverSent: true,
          ),
        ]);
        await Future<void>.delayed(Duration.zero);

        expect(results.fold<int>(0, (a, b) => a + b), 1);
        expect(received.map((m) => m.commandId), ['retry']);
        expect((await reload(session, 'retry')).attempts, 2);
      });

      test('when several commands are pending then they are streamed in '
          'queue order.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        for (final id in ['c-1', 'c-2', 'c-3']) {
          await insertCommand(
            session,
            device,
            commandId: id,
            status: DeviceCommandService.statusPending,
            attempts: 0,
          );
        }

        expect(await DeviceCommandService.flushPending(session, device), 3);
        await Future<void>.delayed(Duration.zero);

        expect(received.map((m) => m.commandId), ['c-1', 'c-2', 'c-3']);
      });

      test('when a pending row has no createdAt then it is still '
          'delivered.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final received = connectDevice('uuid-1');
        await DeviceCommand.db.insertRow(
          session,
          DeviceCommand(
            deviceId: device.id!,
            commandId: 'legacy',
            action: DeviceAction.reboot,
            status: DeviceCommandService.statusPending,
            attempts: 0,
          ),
        );

        expect(await DeviceCommandService.flushPending(session, device), 1);
        await Future<void>.delayed(Duration.zero);
        expect(received.map((m) => m.commandId), ['legacy']);
      });

      test('when the stream closes mid-flush then the rest stay pending with '
          'no attempt spent.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final controller = StreamController<DeviceStreamMessage>();
        addTearDown(controller.close);
        final received = <DeviceStreamMessage>[];
        controller.stream.listen((message) {
          received.add(message);
          unawaited(controller.close());
        });
        registry.register('uuid-1', controller);
        for (final id in ['m-1', 'm-2', 'm-3']) {
          await insertCommand(
            session,
            device,
            commandId: id,
            status: DeviceCommandService.statusPending,
            attempts: 0,
          );
        }

        expect(await DeviceCommandService.flushPending(session, device), 1);

        expect(received.map((m) => m.commandId), ['m-1']);
        expect(
          (await reload(session, 'm-1')).status,
          DeviceCommandService.statusSent,
        );
        for (final id in ['m-2', 'm-3']) {
          final row = await reload(session, id);
          expect(row.status, DeviceCommandService.statusPending, reason: id);
          expect(row.attempts, 0, reason: id);
          expect(row.sentAt, isNull, reason: id);
        }
      });

      test('when a long-running action exceeds its own timeout then it '
          'times out.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        await insertCommand(
          session,
          device,
          commandId: 'long-stale',
          action: DeviceAction.get_current_location,
          sentAt: DateTime.now().toUtc().subtract(
            DeviceCommandService.longTimeout + const Duration(minutes: 1),
          ),
        );

        expect(await DeviceCommandService.markTimeouts(session), 1);
        expect(
          (await reload(session, 'long-stale')).status,
          DeviceCommandService.statusTimeout,
        );
      });

      test('when the ack carries surrounding whitespace then it still '
          'matches.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        await insertCommand(session, device, commandId: 'spaced');

        expect(
          await DeviceCommandService.acknowledge(
            session,
            '  spaced \n',
            deviceId: device.id!,
          ),
          isTrue,
        );
        expect(
          (await reload(session, 'spaced')).status,
          DeviceCommandService.statusAcked,
        );
      });

      test('when no timeout is given then each action uses its own '
          'timeout.', () async {
        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final between = DateTime.now().toUtc().subtract(
          DeviceCommandService.defaultTimeout + const Duration(minutes: 1),
        );
        await insertCommand(
          session,
          device,
          commandId: 'short',
          sentAt: between,
        );
        await insertCommand(
          session,
          device,
          commandId: 'long',
          action: DeviceAction.get_current_location,
          sentAt: between,
        );

        expect(await DeviceCommandService.markTimeouts(session), 1);
        expect(
          (await reload(session, 'short')).status,
          DeviceCommandService.statusTimeout,
        );
        expect(
          (await reload(session, 'long')).status,
          DeviceCommandService.statusSent,
        );
      });
    });
  });
}
