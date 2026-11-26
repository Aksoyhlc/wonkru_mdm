import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query_request.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';

void main() {
  test('toAdminListRequest converts to 1-based page and descending flag', () {
    final request = const ListQuery(
      page: 2,
      pageSize: 25,
      search: 'abc',
      sortBy: 'name',
      sortAsc: false,
    ).toAdminListRequest();

    expect(request.page, 3);
    expect(request.perPage, 25);
    expect(request.search, 'abc');
    expect(request.sortBy, 'name');
    expect(request.sortDesc, isTrue);
  });

  test('textFilter trims and treats missing or blank values as null', () {
    const query = ListQuery(filters: {'a': ' x ', 'b': '', 'c': ' '});

    expect(query.textFilter('a'), 'x');
    expect(query.textFilter('b'), isNull);
    expect(query.textFilter('c'), isNull);
    expect(query.textFilter('missing'), isNull);
  });
}
