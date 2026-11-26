import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/alert_enums.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/admin_notifications_controller.dart';

AdminNotification _notification({
  String type = 'security_info',
  DateTime? readAt,
}) => AdminNotification(
  id: 1,
  userId: UuidValue.fromString('11111111-1111-4111-8111-111111111111'),
  type: type,
  title: 'Title',
  message: 'Message',
  readAt: readAt,
  createdAt: DateTime.utc(2026, 9, 22),
);

void main() {
  group('AdminNotificationsController.buildRequest', () {
    test('page is converted to a 1-based backend page', () {
      final first = AdminNotificationsController.buildRequest(
        const ListQuery(page: 0),
      );
      final third = AdminNotificationsController.buildRequest(
        const ListQuery(page: 2),
      );

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sort are passed through', () {
      final request = AdminNotificationsController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'security',
          sortBy: 'createdAt',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'security');
      expect(request.sortBy, 'createdAt');
      expect(request.sortDesc, isTrue);
    });

    test('sortAsc true produces sortDesc false', () {
      final request = AdminNotificationsController.buildRequest(
        const ListQuery(),
      );

      expect(request.sortDesc, isFalse);
    });
  });

  group('AdminNotificationsController labels', () {
    test('type label formats known, empty and unknown values', () {
      expect(
        AdminNotificationsController.typeLabel('device_offline'),
        'Device offline',
      );
      expect(
        AdminNotificationsController.typeLabel('policy_update_pending'),
        'Policy update pending',
      );
      expect(
        AdminNotificationsController.typeLabel('security_info'),
        'Security information',
      );
      expect(AdminNotificationsController.typeLabel(null), 'Notification');
      expect(AdminNotificationsController.typeLabel('  '), 'Notification');
      expect(
        AdminNotificationsController.typeLabel('custom_type'),
        'custom_type',
      );
    });

    test('type tones are mapped by alert severity', () {
      expect(
        AdminNotificationsController.typeTone('security_info'),
        UiAlertTone.danger,
      );
      expect(
        AdminNotificationsController.typeTone('device_offline'),
        UiAlertTone.warning,
      );
      expect(
        AdminNotificationsController.typeTone('policy_update_pending'),
        UiAlertTone.info,
      );
      expect(
        AdminNotificationsController.typeTone('unknown'),
        UiAlertTone.info,
      );
      expect(AdminNotificationsController.typeTone(null), UiAlertTone.info);
    });

    test('read status is determined by readAt', () {
      expect(
        AdminNotificationsController.isRead(_notification()),
        isFalse,
      );
      expect(
        AdminNotificationsController.isRead(
          _notification(readAt: DateTime.utc(2026, 9, 22, 12)),
        ),
        isTrue,
      );
    });
  });
}
