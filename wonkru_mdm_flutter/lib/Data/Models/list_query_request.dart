import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import 'list_query.dart';

extension ListQueryRequest on ListQuery {
  /// Backend pages are 1-based.
  int get apiPage => page + 1;

  bool get sortDesc => !sortAsc;

  AdminListRequest toAdminListRequest() => AdminListRequest(
    page: apiPage,
    perPage: pageSize,
    search: search,
    sortBy: sortBy,
    sortDesc: sortDesc,
  );

  /// The string filter under [key], or null when it is missing or empty.
  String? textFilter(String key) {
    final value = (filters[key] as String?)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
