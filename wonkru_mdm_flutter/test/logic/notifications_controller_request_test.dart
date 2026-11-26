import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/alert_enums.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/notifications_controller.dart';

void main() {
  group('NotificationsController.buildRequest', () {
    test('page is converted to a 1-based backend page', () {
      final first = NotificationsController.buildRequest(
        const ListQuery(page: 0),
      );
      final third = NotificationsController.buildRequest(
        const ListQuery(page: 2),
      );

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sorting are passed through directly', () {
      final request = NotificationsController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'maintenance',
          sortBy: 'sentAt',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'maintenance');
      expect(request.sortBy, 'sentAt');
      expect(request.sortDesc, isTrue);
    });

    test('sortAsc true yields sortDesc false', () {
      final request = NotificationsController.buildRequest(const ListQuery());

      expect(request.sortDesc, isFalse);
    });
  });

  group('NotificationsController.buildCreateRequest', () {
    test('blank Extra keys are dropped, empty map becomes null', () {
      final withBlanks = NotificationsController.buildCreateRequest(
        title: ' Maintenance ',
        message: ' Message ',
        type: 'normal',
        extra: const {'': 'x', '  ': 'y', 'host': 'srv-1'},
        deviceIds: const [1, 2],
      );

      expect(withBlanks.title, 'Maintenance');
      expect(withBlanks.message, 'Message');
      expect(withBlanks.extra, {'host': 'srv-1'});
      expect(withBlanks.deviceIds, [1, 2]);

      final withoutExtra = NotificationsController.buildCreateRequest(
        title: 't',
        message: 'm',
        type: 'normal',
        extra: const {},
        deviceIds: const [7],
      );

      expect(withoutExtra.extra, isNull);
    });

    test('blank type becomes normal, filled type is preserved', () {
      final blank = NotificationsController.buildCreateRequest(
        title: 't',
        message: 'm',
        type: '  ',
        extra: const {},
        deviceIds: const [1],
      );
      final custom = NotificationsController.buildCreateRequest(
        title: 't',
        message: 'm',
        type: ' urgent ',
        extra: const {},
        deviceIds: const [1],
      );

      expect(blank.type, 'normal');
      expect(custom.type, 'urgent');
    });
  });

  group('NotificationsController labels', () {
    test('type label formats normal and unknown values', () {
      expect(NotificationsController.typeLabel('normal'), 'Normal');
      expect(NotificationsController.typeLabel(null), 'Normal');
      expect(NotificationsController.typeLabel('acil'), 'acil');
    });

    test('delivery status label and tone mapping', () {
      expect(
        NotificationsController.deliveryStatusLabel(
          NotificationDeliveryStatus.sent,
        ),
        'Sent',
      );
      expect(
        NotificationsController.deliveryStatusLabel(
          NotificationDeliveryStatus.received,
        ),
        'Received',
      );
      expect(
        NotificationsController.deliveryStatusLabel(
          NotificationDeliveryStatus.pending,
        ),
        'Pending',
      );
      expect(
        NotificationsController.deliveryStatusLabel(
          NotificationDeliveryStatus.failed,
        ),
        'Failed',
      );

      expect(
        NotificationsController.deliveryStatusTone(
          NotificationDeliveryStatus.received,
        ),
        UiAlertTone.success,
      );
      expect(
        NotificationsController.deliveryStatusTone(
          NotificationDeliveryStatus.pending,
        ),
        UiAlertTone.warning,
      );
      expect(
        NotificationsController.deliveryStatusTone(
          NotificationDeliveryStatus.failed,
        ),
        UiAlertTone.danger,
      );
    });
  });
}
