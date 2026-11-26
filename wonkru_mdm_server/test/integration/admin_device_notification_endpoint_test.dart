import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_device_notification_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_command_service.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';
import 'package:wonkru_mdm_server/src/service/device_notification_service.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  final registry = DeviceConnectionRegistry.instance;

  setUp(registry.clear);
  tearDown(registry.clear);

  withServerpod('Given AdminDeviceNotificationEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
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

    Future<Device> createDevice(
      Session session, {
      required String code,
      String? uuid,
      String? name,
    }) {
      return Device.db.insertRow(
        session,
        Device(code: code, uuid: uuid, name: name),
      );
    }

    AdminDeviceNotificationCreateRequest createRequest({
      String title = 'Reboot tonight',
      List<int> deviceIds = const [],
      Map<String, String>? extra,
    }) {
      return AdminDeviceNotificationCreateRequest(
        title: title,
        message: 'Please reboot after hours.',
        type: 'normal',
        extra: extra,
        deviceIds: deviceIds,
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

    group('list', () {
      test('when notifications exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final base = DateTime.now().toUtc();
        for (var index = 1; index <= 5; index++) {
          await DeviceNotification.db.insertRow(
            session,
            DeviceNotification(
              title: 'Notice $index',
              message: 'Body',
              type: NotificationType.normal,
              createdAt: base.add(Duration(seconds: index)),
            ),
          );
        }

        final page = await endpoints.adminDeviceNotification.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2, sortBy: 'createdAt'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((row) => row.notification.title), [
          'Notice 3',
          'Notice 4',
        ]);
      });

      test('when a search is given then the title is matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await DeviceNotification.db.insertRow(
          session,
          DeviceNotification(
            title: 'Reboot tonight',
            message: 'Body',
            type: NotificationType.normal,
          ),
        );
        await DeviceNotification.db.insertRow(
          session,
          DeviceNotification(
            title: 'Wipe device',
            message: 'Reboot was mentioned in the body',
            type: NotificationType.normal,
          ),
        );

        final page = await endpoints.adminDeviceNotification.list(
          adminBuilder,
          AdminListRequest(search: 'Reboot'),
        );

        expect(page.total, 1);
        expect(page.items.single.notification.title, 'Reboot tonight');
      });

      test('when a notification was sent then the row carries its delivery '
          'count.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'COUNTED',
          uuid: 'uuid-counted',
        );

        await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [device.id!]),
        );

        final page = await endpoints.adminDeviceNotification.list(
          adminBuilder,
          AdminListRequest(),
        );

        expect(page.items.single.deviceCount, 1);
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminDeviceNotification.list(
          adminBuilder,
          AdminListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminDeviceNotificationEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the notification exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final stored = await DeviceNotification.db.insertRow(
          session,
          DeviceNotification(
            title: 'Lookup',
            message: 'Body',
            type: NotificationType.normal,
          ),
        );

        final fetched = await endpoints.adminDeviceNotification.get(
          adminBuilder,
          stored.id!,
        );

        expect(fetched.title, 'Lookup');
      });

      test(
        'when the notification does not exist then it is rejected.',
        () async {
          await createProfile();

          await expectLater(
            endpoints.adminDeviceNotification.get(adminBuilder, 987654),
            throwsExceptionWith('Notification 987654 does not exist.'),
          );
        },
      );
    });

    group('create', () {
      test('when devices with a uuid are selected then the command is queued '
          'and the delivery is marked sent.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'REACHABLE',
          uuid: 'uuid-reachable',
          name: 'Field phone',
        );
        final received = connectDevice('uuid-reachable');

        final response = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(
            deviceIds: [device.id!],
            extra: {'channel': 'ops'},
          ),
        );
        await Future<void>.delayed(Duration.zero);

        final notification = response.notification;
        expect(notification.id, greaterThan(0));
        expect(notification.uuid, isNotEmpty);
        expect(notification.sentAt, isNotNull);

        final extra = jsonDecode(notification.extra!) as Map<String, dynamic>;
        expect(extra['channel'], 'ops');
        expect(extra['notification_uuid'], notification.uuid);

        expect(response.deliveries, hasLength(1));
        final delivery = response.deliveries.single;
        expect(delivery.delivery.status, DeviceNotificationService.statusSent);
        expect(delivery.delivery.sentAt, isNotNull);
        expect(delivery.device?.code, 'REACHABLE');

        expect(received, hasLength(1));
        final payload =
            jsonDecode(received.single.payload!) as Map<String, dynamic>;
        expect(payload['action'], 'send_notification');
        final params = payload['params'] as Map<String, dynamic>;
        expect(params['title'], 'Reboot tonight');
        expect(params['body'], 'Please reboot after hours.');

        final command = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(device.id!),
        );
        expect(command!.action, DeviceAction.send_notification);
        expect(command.status, DeviceCommandService.statusSent);

        final commandParams =
            jsonDecode(command.params!) as Map<String, dynamic>;
        expect(commandParams, contains('notification_uuid'));
        expect(commandParams, contains('body'));
        expect(commandParams['notification_uuid'], notification.uuid);
        expect(commandParams['body'], 'Please reboot after hours.');
      });

      test('when a device has no uuid then its delivery fails without a '
          'command.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'NO-UUID');

        final response = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [device.id!]),
        );

        expect(response.deliveries, hasLength(1));
        expect(
          response.deliveries.single.delivery.status,
          DeviceNotificationService.statusFailed,
        );
        expect(response.deliveries.single.delivery.sentAt, isNotNull);
        expect(
          await DeviceCommand.db.find(
            session,
            where: (t) => t.deviceId.equals(device.id!),
          ),
          isEmpty,
        );
      });

      test('when no device is selected then nothing is queued.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final response = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(),
        );

        expect(response.notification.sentAt, isNull);
        expect(response.deliveries, isEmpty);
        expect(
          await DeviceCommand.db.find(
            session,
            where: (t) => t.action.equals(DeviceAction.send_notification),
          ),
          isEmpty,
        );
      });

      test('when a device is offline then its command stays pending while the '
          'connected one is sent.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final offline = await createDevice(
          session,
          code: 'OFFLINE',
          uuid: 'uuid-offline',
        );
        final healthy = await createDevice(
          session,
          code: 'HEALTHY',
          uuid: 'uuid-healthy',
        );
        final received = connectDevice('uuid-healthy');

        final response = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [offline.id!, healthy.id!]),
        );
        await Future<void>.delayed(Duration.zero);

        final byDevice = {
          for (final row in response.deliveries) row.device!.code: row.delivery,
        };
        expect(
          byDevice['OFFLINE']!.status,
          DeviceNotificationService.statusSent,
        );
        expect(
          byDevice['HEALTHY']!.status,
          DeviceNotificationService.statusSent,
        );
        expect(received, hasLength(1));

        final offlineCommand = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(offline.id!),
        );
        final healthyCommand = await DeviceCommand.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(healthy.id!),
        );
        expect(offlineCommand!.status, DeviceCommandService.statusPending);
        expect(healthyCommand!.status, DeviceCommandService.statusSent);
      });

      test('when the device already confirmed then the delivery is not '
          'rewritten to sent.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'FAST-ACK',
          uuid: 'uuid-fast-ack',
        );

        final created = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [device.id!]),
        );
        final deliveryId = created.deliveries.single.delivery.id!;

        final confirmed = await DeviceNotificationDevice.db.findById(
          session,
          deliveryId,
        );
        confirmed!
          ..status = DeviceNotificationService.statusReceived
          ..receivedAt = DateTime.now().toUtc();
        await DeviceNotificationDevice.db.updateRow(session, confirmed);

        await DeviceNotificationService.markSentUnlessReceived(
          session,
          deliveryId,
          DateTime.now().toUtc(),
        );

        final after = await DeviceNotificationDevice.db.findById(
          session,
          deliveryId,
        );
        expect(after!.status, DeviceNotificationService.statusReceived);
        expect(after.receivedAt, isNotNull);
      });
    });

    group('deliveries', () {
      test('when the notification was sent then the rows carry the device and '
          'its groups.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'GROUPED',
          uuid: 'uuid-grouped',
        );
        final group = await DeviceGroup.db.insertRow(
          session,
          DeviceGroup(name: 'Field team'),
        );
        await DeviceDeviceGroup.db.insertRow(
          session,
          DeviceDeviceGroup(deviceId: device.id!, deviceGroupId: group.id!),
        );

        final created = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [device.id!]),
        );

        final rows = await endpoints.adminDeviceNotification.deliveries(
          adminBuilder,
          created.notification.id!,
        );

        expect(rows, hasLength(1));
        expect(rows.single.device?.code, 'GROUPED');
        expect(rows.single.groupNames, ['Field team']);
      });
    });

    group('delete', () {
      test('when a notification is deleted then its deliveries go '
          'with it.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DELETED',
          uuid: 'uuid-deleted',
        );
        final created = await endpoints.adminDeviceNotification.create(
          adminBuilder,
          createRequest(deviceIds: [device.id!]),
        );
        final notificationId = created.notification.id!;

        final deleted = await endpoints.adminDeviceNotification.delete(
          adminBuilder,
          [notificationId],
        );

        expect(deleted, 1);
        expect(
          await DeviceNotification.db.findById(session, notificationId),
          isNull,
        );
        expect(
          await DeviceNotificationDevice.db.find(
            session,
            where: (t) => t.deviceNotificationId.equals(notificationId),
          ),
          isEmpty,
        );
      });

      test('when no notification is given then nothing is deleted.', () async {
        await createProfile();

        expect(
          await endpoints.adminDeviceNotification.delete(adminBuilder, []),
          0,
        );
      });
    });
  });
}
