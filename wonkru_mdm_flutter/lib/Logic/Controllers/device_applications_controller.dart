import 'dart:convert';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/device_repository.dart';
import 'Base/paged_table_controller.dart';

/// The endpoint does not paginate: the device's full app list arrives in one
/// call, so search, type filter, sorting and paging all happen in memory. The
/// list is refetched on every load so the toolbar refresh actually refreshes.
class DeviceApplicationsController extends PagedTableController<DeviceApplication> {
  DeviceApplicationsController(this.deviceId) : super(pageSize: 15);

  final int deviceId;

  @override
  Future<PagedResult<DeviceApplication>> fetch(ListQuery query) async {
    return buildPage(await DeviceRepository.applications(deviceId), query);
  }

  PagedResult<DeviceApplication> buildPage(
    List<DeviceApplication> all,
    ListQuery query,
  ) {
    final matched = filterBySystemFlag(
      searchFor(all, query.search),
      query.filters['isSystemApp'],
    );
    sortRows(matched, query.sortBy, query.sortAsc);

    final start = query.page * query.pageSize;
    return PagedResult(
      items: start >= matched.length
          ? const <DeviceApplication>[]
          : matched.sublist(
              start,
              (start + query.pageSize).clamp(0, matched.length),
            ),
      total: matched.length,
    );
  }

  /// `isSystemApp`: `null` = all, `true` = system, `false` = user.
  List<DeviceApplication> filterBySystemFlag(
    List<DeviceApplication> all,
    Object? isSystemApp,
  ) {
    if (isSystemApp is! bool) return all;
    return all.where((app) => app.isSystemApp == isSystemApp).toList();
  }

  List<DeviceApplication> searchFor(List<DeviceApplication> all, String? term) {
    final needle = term?.trim().toLowerCase();
    if (needle == null || needle.isEmpty) return all;

    return all
        .where(
          (app) => app.appName.toLowerCase().contains(needle) || app.packageName.toLowerCase().contains(needle),
        )
        .toList();
  }

  void sortRows(List<DeviceApplication> rows, String? sortBy, bool ascending) {
    int compare(DeviceApplication a, DeviceApplication b) =>
        switch (sortBy) {
          'packageName' => a.packageName.compareTo(b.packageName),
          'versionName' => (a.versionName ?? '').compareTo(b.versionName ?? ''),
          'isSystemApp' => (a.isSystemApp ? 1 : 0).compareTo(
            b.isSystemApp ? 1 : 0,
          ),
          'appName' => a.appName.toLowerCase().compareTo(
            b.appName.toLowerCase(),
          ),
          _ => null,
        } ??
        _defaultCompare(a, b);

    rows.sort((a, b) => ascending ? compare(a, b) : -compare(a, b));
  }

  int _defaultCompare(DeviceApplication a, DeviceApplication b) {
    final system = (a.isSystemApp ? 1 : 0).compareTo(b.isSystemApp ? 1 : 0);
    return system != 0 ? system : a.appName.toLowerCase().compareTo(b.appName.toLowerCase());
  }

  Future<DeviceCommandBulkStatus> sendPackageCommand(
    String action,
    String packageName,
  ) => DeviceRepository.sendCommand(
    [deviceId],
    action,
    jsonEncode({'package_name': packageName}),
  );
}
