/// Row cap for the helper lists behind pickers and name lookups; these lists
/// are not paged.
const lookupPageSize = 200;

class ListQuery {
  const ListQuery({
    this.page = 0,
    this.pageSize = 20,
    this.search,
    this.sortBy,
    this.sortAsc = true,
    this.filters = const {},
  });

  /// Sentinel distinguishing "argument omitted" from "set to null" in [copyWith].
  static const Object _unset = Object();

  final int page;
  final int pageSize;
  final String? search;
  final String? sortBy;
  final bool sortAsc;
  final Map<String, dynamic> filters;

  /// [search]/[sortBy] can be cleared with an explicit `null`; omitting the
  /// argument keeps the current value.
  ListQuery copyWith({
    int? page,
    int? pageSize,
    Object? search = _unset,
    Object? sortBy = _unset,
    bool? sortAsc,
    Map<String, dynamic>? filters,
  }) => ListQuery(
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    search: identical(search, _unset) ? this.search : search as String?,
    sortBy: identical(sortBy, _unset) ? this.sortBy : sortBy as String?,
    sortAsc: sortAsc ?? this.sortAsc,
    filters: filters ?? this.filters,
  );
}
