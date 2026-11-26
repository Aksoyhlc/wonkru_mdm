import 'dart:async';

import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';

void main() {
  group('Given DeviceConnectionRegistry', () {
    final registry = DeviceConnectionRegistry.instance;

    setUp(registry.clear);
    tearDown(registry.clear);

    test('when a controller is registered then the device is online.', () {
      final controller = StreamController<DeviceStreamMessage>();
      // A listener-less controller never completes its close() future, so it
      // must not be awaited.
      addTearDown(() => unawaited(controller.close()));

      registry.register('device-1', controller);

      expect(registry.isOnline('device-1'), isTrue);
      expect(registry.onlineUuids, contains('device-1'));
      expect(registry.isOnline('device-2'), isFalse);
    });

    test(
      'when a message is sent then it reaches the registered controller.',
      () async {
        final controller = StreamController<DeviceStreamMessage>();
        // A listener-less controller never completes its close() future, so it
        // must not be awaited.
        addTearDown(() => unawaited(controller.close()));
        final received = <DeviceStreamMessage>[];
        final subscription = controller.stream.listen(received.add);
        addTearDown(() => subscription.cancel());

        registry.register('device-1', controller);
        final sent = registry.send(
          'device-1',
          DeviceStreamMessage(type: 'heartbeat'),
        );
        await Future<void>.delayed(Duration.zero);

        expect(sent, isTrue);
        expect(received.single.type, 'heartbeat');
      },
    );

    test('when the device is unknown then send returns false.', () {
      expect(
        registry.send('device-1', DeviceStreamMessage(type: 'heartbeat')),
        isFalse,
      );
    });

    test('when unregistered then the device is offline.', () {
      final controller = StreamController<DeviceStreamMessage>();
      // A listener-less controller never completes its close() future, so it
      // must not be awaited.
      addTearDown(() => unawaited(controller.close()));

      registry.register('device-1', controller);
      registry.unregister('device-1', controller);

      expect(registry.isOnline('device-1'), isFalse);
    });

    test('when a stale controller unregisters then the new one stays.', () {
      final oldController = StreamController<DeviceStreamMessage>();
      final newController = StreamController<DeviceStreamMessage>();
      addTearDown(() => unawaited(oldController.close()));
      addTearDown(() => unawaited(newController.close()));

      registry.register('device-1', oldController);
      registry.register('device-1', newController);
      registry.unregister('device-1', oldController);

      expect(registry.isOnline('device-1'), isTrue);
    });

    DeviceStreamController open() {
      final controller = StreamController<DeviceStreamMessage>();
      // A listener-less controller never completes its close() future, so it
      // must not be awaited.
      addTearDown(() => unawaited(controller.close()));
      return controller;
    }

    test('when the device reconnects then the previous controller is closed '
        'and only the new one is current.', () async {
      final previous = open();
      final current = open();

      registry.register('device-1', previous);
      registry.register('device-1', current);
      await Future<void>.delayed(Duration.zero);

      expect(previous.isClosed, isTrue);
      expect(current.isClosed, isFalse);
      expect(registry.isCurrent('device-1', current), isTrue);
      expect(registry.isCurrent('device-1', previous), isFalse);
    });

    test('when the same controller registers twice then it is not closed.', () {
      final controller = open();

      registry.register('device-1', controller);
      registry.register('device-1', controller);

      expect(controller.isClosed, isFalse);
      expect(registry.isOnline('device-1'), isTrue);
    });

    test('when unregister reports ownership then only the real owner gets '
        'true.', () {
      final previous = open();
      final current = open();
      registry.register('device-1', previous);
      registry.register('device-1', current);

      expect(registry.unregister('device-1', previous), isFalse);
      expect(registry.unregister('device-1', current), isTrue);
      expect(registry.unregister('device-1', current), isFalse);
    });

    test('when disconnected then the controller is closed and the device is '
        'offline.', () {
      final controller = open();
      registry.register('device-1', controller);

      expect(registry.disconnect('device-1'), isTrue);
      expect(controller.isClosed, isTrue);
      expect(registry.isOnline('device-1'), isFalse);
      expect(registry.disconnect('device-1'), isFalse);
    });

    test('when the registered controller is already closed then send returns '
        'false.', () async {
      final controller = open();
      registry.register('device-1', controller);
      unawaited(controller.close());

      expect(
        registry.send('device-1', DeviceStreamMessage(type: 'heartbeat')),
        isFalse,
      );
    });
  });
}
