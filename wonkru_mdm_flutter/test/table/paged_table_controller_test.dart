import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Data/Models/paged_result.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/Base/paged_table_controller.dart';

class _FakeController extends PagedTableController<int> {
  _FakeController({required this.calls});
  final List<ListQuery> calls;

  @override
  Future<PagedResult<int>> fetch(ListQuery query) async {
    calls.add(query);
    return PagedResult(
      items: [query.page * 100, query.page * 100 + 1],
      total: 45,
    );
  }
}

class _RaceController extends PagedTableController<int> {
  final List<Completer<PagedResult<int>>> completers = [];

  @override
  Future<PagedResult<int>> fetch(ListQuery query) {
    final completer = Completer<PagedResult<int>>();
    completers.add(completer);
    return completer.future;
  }
}

void main() {
  test('load sets rows and pageCount; setPage fetches again', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls);
    await c.load();
    expect(c.rows, [0, 1]);
    expect(c.total.value, 45);
    expect(c.pageCount, 3);
    await c.setPage(1);
    expect(calls.last.page, 1);
  });

  test('setSearch resets page to zero', () async {
    final c = _FakeController(calls: []);
    await c.setPage(2);
    await c.setSearch('abc');
    expect(c.page.value, 0);
    expect(c.query.search, 'abc');
  });

  test('reload fetches the current query again', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls);
    await c.load();
    await c.reload();
    expect(calls.length, 2);
    expect(calls.last.page, 0);
  });

  test('setFilter updates filters, resets page, and copies the map', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls);
    await c.setPage(2);

    await c.setFilter('status', 'active');

    expect(c.page.value, 0);
    expect(c.query.filters['status'], 'active');
    expect(calls.last.filters['status'], 'active');

    // The query must not share the live RxMap; later mutations must not leak.
    c.filters['status'] = 'changed';
    expect(calls.last.filters['status'], 'active');
  });

  test('setFilter with null removes the key', () async {
    final c = _FakeController(calls: []);
    await c.setFilter('status', 'active');
    await c.setFilter('status', null);

    expect(c.filters.containsKey('status'), isFalse);
    expect(c.query.filters.containsKey('status'), isFalse);
  });

  test('clearFilters empties filters and resets page', () async {
    final c = _FakeController(calls: []);
    await c.setFilter('a', 1);
    await c.setFilter('b', 2);
    await c.setPage(3);

    await c.clearFilters();

    expect(c.filters, isEmpty);
    expect(c.page.value, 0);
    expect(c.query.filters, isEmpty);
  });

  test(
    'setPageSize updates size, resets page, and recomputes pageCount',
    () async {
      final calls = <ListQuery>[];
      final c = _FakeController(calls: calls);
      await c.setPage(2);

      await c.setPageSize(10);

      expect(c.pageSize.value, 10);
      expect(c.page.value, 0);
      expect(calls.last.pageSize, 10);
      expect(c.pageCount, 5);
    },
  );

  test('a slow earlier fetch does not overwrite a newer result', () async {
    final c = _RaceController();

    final first = c.load();
    final second = c.load();
    expect(c.completers.length, 2);

    c.completers[1].complete(const PagedResult(items: [2], total: 1));
    await second;
    expect(c.rows, [2]);
    expect(c.total.value, 1);

    c.completers[0].complete(const PagedResult(items: [1], total: 9));
    await first;
    expect(c.rows, [2]);
    expect(c.total.value, 1);
    expect(c.loading.value, isFalse);
  });

  test('reloadAfter runs the action, reloads and returns its result', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls);
    final result = await c.reloadAfter(() async {
      expect(calls, isEmpty);
      return 7;
    });
    expect(result, 7);
    expect(calls.length, 1);
  });

  test('applyToSelected passes ids, clears selection and reloads', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls)..setSelection({3, 5});
    List<int>? passed;
    final count = await c.applyToSelected((ids) async {
      passed = ids;
      return ids.length;
    });
    expect(passed, unorderedEquals([3, 5]));
    expect(count, 2);
    expect(c.selected, isEmpty);
    expect(calls.length, 1);
  });

  test('applyToSelected keeps the selection when deletion fails', () async {
    final calls = <ListQuery>[];
    final c = _FakeController(calls: calls)..setSelection({3});
    await expectLater(
      c.applyToSelected((_) async => throw StateError('boom')),
      throwsStateError,
    );
    expect(c.selected, {3});
    expect(calls, isEmpty);
  });

  test(
    'deleteSelectedEach clears and reloads even when a delete fails',
    () async {
      final calls = <ListQuery>[];
      final c = _FakeController(calls: calls)..setSelection({1, 2, 3});
      final deleted = <int>[];
      await expectLater(
        c.deleteSelectedEach((id) async {
          if (id == 2) throw StateError('boom');
          deleted.add(id);
        }),
        throwsStateError,
      );
      expect(deleted, [1]);
      expect(c.selected, isEmpty);
      expect(calls.length, 1);
    },
  );
}
