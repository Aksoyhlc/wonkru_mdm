import 'package:get/get.dart';

import '../../../Core/Errors/server_error_message.dart';
import '../../../Data/Models/list_query.dart';
import '../../../Data/Models/paged_result.dart';

abstract class PagedTableController<T> extends GetxController {
  PagedTableController({int pageSize = 20}) : pageSize = pageSize.obs;

  final RxInt pageSize;

  final rows = <T>[].obs;
  final total = 0.obs;
  final page = 0.obs;
  final loading = false.obs;
  final error = RxnString();
  final search = ''.obs;
  final sortBy = RxnString();
  final sortAsc = true.obs;
  final filters = <String, dynamic>{}.obs;

  final selected = <int>{}.obs;

  void setSelection(Set<int> ids) {
    selected
      ..clear()
      ..addAll(ids);
  }

  void clearSelection() => selected.clear();

  List<int> get selectedIds => selected.toList();

  bool _hasLoaded = false;
  int _requestToken = 0;

  bool get hasLoaded => _hasLoaded;

  int get pageCount => total.value == 0 ? 1 : ((total.value + pageSize.value - 1) ~/ pageSize.value);

  Future<PagedResult<T>> fetch(ListQuery query);

  ListQuery get query => ListQuery(
    page: page.value,
    pageSize: pageSize.value,
    search: search.value.isEmpty ? null : search.value,
    sortBy: sortBy.value,
    sortAsc: sortAsc.value,
    // Don't leak the live RxMap; the query carries its own copy.
    filters: Map.of(filters),
  );

  Future<void> load() async {
    _hasLoaded = true;
    final token = ++_requestToken;
    loading.value = true;
    error.value = null;
    try {
      final result = await fetch(query);
      if (token != _requestToken) return;
      rows.assignAll(result.items);
      total.value = result.total;
    } catch (e) {
      if (token != _requestToken) return;
      error.value = serverErrorMessage(e);
    } finally {
      if (token == _requestToken) loading.value = false;
    }
  }

  Future<void> setPage(int value) async {
    if (value == page.value) return;
    page.value = value;
    await load();
  }

  Future<void> setSearch(String value) async {
    search.value = value;
    page.value = 0;
    await load();
  }

  Future<void> setSort(String? key, bool ascending) async {
    sortBy.value = key;
    sortAsc.value = ascending;
    page.value = 0;
    await load();
  }

  Future<void> setFilter(String key, Object? value) async {
    if (value == null) {
      filters.remove(key);
    } else {
      filters[key] = value;
    }
    page.value = 0;
    await load();
  }

  Future<void> clearFilters() async {
    filters.clear();
    page.value = 0;
    await load();
  }

  Future<void> setPageSize(int value) async {
    if (value <= 0 || value == pageSize.value) return;
    pageSize.value = value;
    page.value = 0;
    await load();
  }

  /// Redraws the table after helper lists (policies, groups…) load; the rows
  /// didn't change, so [AppDataTable] wouldn't refresh on its own.
  void refreshCells() => rows.refresh();

  /// Named to avoid the protected `refresh` on [GetxController].
  Future<void> reload() => load();

  Future<R> reloadAfter<R>(Future<R> Function() action) async {
    final result = await action();
    await reload();
    return result;
  }

  Future<int> applyToSelected(
    Future<int> Function(List<int> ids) action,
  ) async {
    final count = await action(selectedIds);
    clearSelection();
    await reload();
    return count;
  }

  Future<int> deleteSelectedEach(Future<void> Function(int id) delete) async {
    final ids = selectedIds;
    try {
      for (final id in ids) {
        await delete(id);
      }
      return ids.length;
    } finally {
      clearSelection();
      await reload();
    }
  }
}
