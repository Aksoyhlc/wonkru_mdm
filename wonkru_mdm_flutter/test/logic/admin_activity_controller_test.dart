import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/admin_activity_controller.dart';

void main() {
  group('AdminActivityController.buildRequest', () {
    test('page is converted to a 1-based backend page', () {
      final first = AdminActivityController.buildRequest(
        const ListQuery(page: 0),
      );
      final third = AdminActivityController.buildRequest(
        const ListQuery(page: 2),
      );

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sort are passed through', () {
      final request = AdminActivityController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'device',
          sortBy: 'action',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'device');
      expect(request.sortBy, 'action');
      expect(request.sortDesc, isTrue);
    });

    test('action, actor and date filters are mapped', () {
      final actorId = UuidValue.fromString(
        '11111111-1111-4111-8111-111111111111',
      );
      final from = DateTime(2026, 9, 1);
      final to = DateTime(2026, 9, 20, 23, 59, 59);

      final request = AdminActivityController.buildRequest(
        ListQuery(
          filters: {
            'action': 'device.delete',
            'actorUserId': actorId,
            'from': from,
            'to': to,
          },
        ),
      );

      expect(request.action, 'device.delete');
      expect(request.actorUserId, actorId);
      expect(request.from, from);
      expect(request.to, to);
    });

    test('an empty filter map leaves all filters null', () {
      final request = AdminActivityController.buildRequest(const ListQuery());

      expect(request.action, isNull);
      expect(request.actorUserId, isNull);
      expect(request.from, isNull);
      expect(request.to, isNull);
    });
  });
}
