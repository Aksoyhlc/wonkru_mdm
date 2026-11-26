import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/device_enrollment.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given device.notificationAck', (sessionBuilder, endpoints) {
    late DeviceRegisterResponse alpha;
    late DeviceRegisterResponse beta;
    late DeviceNotification notification;

    Future<int> deviceIdOf(DeviceRegisterResponse registered) async =>
        (await Device.db.findFirstRow(
          sessionBuilder.build(),
          where: (t) => t.uuid.equals(registered.uuid),
        ))!.id!;

    Future<DeviceNotificationDevice> deliveryOf(
      DeviceRegisterResponse registered,
    ) async {
      final deviceId = await deviceIdOf(registered);
      return (await DeviceNotificationDevice.db.findFirstRow(
        sessionBuilder.build(),
        where: (t) =>
            t.deviceNotificationId.equals(notification.id!) &
            t.deviceId.equals(deviceId),
      ))!;
    }

    Future<bool> ack(
      DeviceRegisterResponse caller, {
      String? notificationUuid,
    }) => endpoints.device.notificationAck(
      sessionBuilder,
      DeviceNotificationAckRequest(
        deviceUuid: caller.uuid,
        token: caller.token,
        notificationUuid: notificationUuid ?? notification.uuid!,
      ),
    );

    setUp(() async {
      final session = sessionBuilder.build();
      alpha = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'alpha'),
      );
      beta = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'beta'),
      );
      notification = await DeviceNotification.db.insertRow(
        session,
        DeviceNotification(
          uuid: 'notification-1',
          title: 'Title',
          message: 'Body',
          type: NotificationType.normal,
        ),
      );
      for (final registered in [alpha, beta]) {
        await DeviceNotificationDevice.db.insertRow(
          session,
          DeviceNotificationDevice(
            deviceNotificationId: notification.id!,
            deviceId: await deviceIdOf(registered),
            status: NotificationDeliveryStatus.sent,
          ),
        );
      }
    });

    test('marks its own delivery as received and records the time', () async {
      expect(await ack(alpha), isTrue);

      final delivery = await deliveryOf(alpha);
      expect(delivery.status, NotificationDeliveryStatus.received);
      expect(delivery.receivedAt, isNotNull);
      expect(
        (await deliveryOf(beta)).status,
        NotificationDeliveryStatus.sent,
        reason: 'the other device\'s delivery must not change',
      );
    });

    test('a device without a delivery cannot ack another device notification', () async {
      final gamma = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'gamma'),
      );

      expect(await ack(gamma), isFalse);
      expect((await deliveryOf(alpha)).status, NotificationDeliveryStatus.sent);
      expect((await deliveryOf(beta)).status, NotificationDeliveryStatus.sent);
    });

    test('an unknown notification returns false', () async {
      expect(await ack(alpha, notificationUuid: 'none'), isFalse);
      expect((await deliveryOf(alpha)).status, NotificationDeliveryStatus.sent);
    });

    test('a call with another device uuid is an identity mismatch', () async {
      await expectLater(
        endpoints.device.notificationAck(
          sessionBuilder,
          DeviceNotificationAckRequest(
            deviceUuid: beta.uuid,
            token: alpha.token,
            notificationUuid: notification.uuid!,
          ),
        ),
        throwsA(isA<DeviceIdentityMismatchException>()),
      );
      expect((await deliveryOf(beta)).status, NotificationDeliveryStatus.sent);
    });
  });
}
