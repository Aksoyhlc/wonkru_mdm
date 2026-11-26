import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Data/Models/device_log_trend_chart.dart';
import 'package:wonkru_mdm_flutter/Data/Models/device_log_level_chart.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/device_logs_controller.dart';

void main() {
  group('DeviceLogsController.buildRequest', () {
    test('page is converted to a 1-based backend page', () {
      final first = DeviceLogsController.buildRequest(const ListQuery(page: 0));
      final third = DeviceLogsController.buildRequest(const ListQuery(page: 2));

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sort are passed through', () {
      final request = DeviceLogsController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'error',
          sortBy: 'level',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'error');
      expect(request.sortBy, 'level');
      expect(request.sortDesc, isTrue);
    });

    test('level is wrapped in a single-element list', () {
      final request = DeviceLogsController.buildRequest(
        const ListQuery(filters: {'level': 4}),
      );

      expect(request.levels, [4]);
    });

    test('period, session and stacktrace filters are mapped', () {
      final request = DeviceLogsController.buildRequest(
        const ListQuery(
          filters: {
            'period': 'this_week',
            'sessionId': 'sess-42',
            'hasStacktrace': true,
          },
        ),
      );

      expect(request.period, 'this_week');
      expect(request.sessionId, 'sess-42');
      expect(request.hasStacktrace, isTrue);
    });

    test('hasStacktrace false is distinguished from null', () {
      final request = DeviceLogsController.buildRequest(
        const ListQuery(filters: {'hasStacktrace': false}),
      );

      expect(request.hasStacktrace, isFalse);
    });

    test('date range is passed through', () {
      final from = DateTime(2026, 9, 1);
      final until = DateTime(2026, 9, 20, 23, 59, 59);

      final request = DeviceLogsController.buildRequest(
        ListQuery(filters: {'loggedFrom': from, 'loggedUntil': until}),
      );

      expect(request.loggedFrom, from);
      expect(request.loggedUntil, until);
    });

    test('blank text filters become null, an empty filter map stays empty', () {
      final blank = DeviceLogsController.buildRequest(
        const ListQuery(
          filters: {'tag': '  ', 'sessionId': '', 'period': ''},
        ),
      );

      expect(blank.tag, isNull);
      expect(blank.sessionId, isNull);
      expect(blank.period, isNull);

      final empty = DeviceLogsController.buildRequest(const ListQuery());
      expect(empty.tag, isNull);
      expect(empty.sessionId, isNull);
      expect(empty.period, isNull);
      expect(empty.hasStacktrace, isNull);
      expect(empty.loggedFrom, isNull);
      expect(empty.loggedUntil, isNull);
    });
  });

  group('log chart mapping', () {
    test('level slices map to labels/values/colors', () {
      final chart = [
        DeviceLogLevelSlice(
          label: 'INFO',
          level: 2,
          count: 12,
          color: '#0ea5e9',
        ),
        DeviceLogLevelSlice(
          label: 'ERROR',
          level: 4,
          count: 3,
          color: '#ef4444',
        ),
      ].toChart();

      expect(chart.labels, ['INFO', 'ERROR']);
      expect(chart.values, [12, 3]);
      expect(chart.colors, ['#0ea5e9', '#ef4444']);
    });

    test('trend labels and totals are preserved', () {
      final chart = DeviceLogTrend(
        labels: ['01.09', '02.09'],
        totals: [5, 9],
        errors: [1, 2],
      ).toChart();

      expect(chart.labels, ['01.09', '02.09']);
      expect(chart.values, [5, 9]);
      expect(chart.colors, isNull);
    });
  });
}
