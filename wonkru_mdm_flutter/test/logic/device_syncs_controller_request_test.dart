import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/device_syncs_controller.dart';

void main() {
  group('DeviceSyncsController.buildRequest', () {
    test('page is converted to a 1-based backend page', () {
      final first = DeviceSyncsController.buildRequest(
        const ListQuery(page: 0),
      );
      final third = DeviceSyncsController.buildRequest(
        const ListQuery(page: 2),
      );

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sort are passed through', () {
      final request = DeviceSyncsController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'mdm-1',
          sortBy: 'syncType',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'mdm-1');
      expect(request.sortBy, 'syncType');
      expect(request.sortDesc, isTrue);
    });

    test('device filter is passed to the deviceId field', () {
      final request = DeviceSyncsController.buildRequest(
        const ListQuery(filters: {'deviceId': 42}),
      );

      expect(request.deviceId, 42);
    });

    test('deviceId is null when there is no filter', () {
      final request = DeviceSyncsController.buildRequest(const ListQuery());

      expect(request.deviceId, isNull);
    });

    test('date range is passed to the from/to fields', () {
      final from = DateTime.utc(2026, 1, 1);
      final to = DateTime.utc(2026, 1, 31, 23, 59, 59);
      final request = DeviceSyncsController.buildRequest(
        ListQuery(filters: {'from': from, 'to': to}),
      );

      expect(request.from, from);
      expect(request.to, to);
    });

    test('from/to are null when there is no date filter', () {
      final request = DeviceSyncsController.buildRequest(const ListQuery());

      expect(request.from, isNull);
      expect(request.to, isNull);
    });
  });
}
