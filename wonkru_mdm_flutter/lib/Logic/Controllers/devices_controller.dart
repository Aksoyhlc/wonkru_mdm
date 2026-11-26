import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/dashboard_repository.dart';
import '../../Data/Repositories/device_group_repository.dart';
import '../../Data/Repositories/device_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/settings_repository.dart';
import 'Base/paged_table_controller.dart';

class DevicesController extends PagedTableController<Device> {
  DevicesController() : super(pageSize: 25);

  final policies = <Policy>[].obs;
  final groups = <DeviceGroupRow>[].obs;
  final optionsLoaded = false.obs;
  final onlineMinutes = SettingsRepository.defaultOfflineTimeoutMinutes.obs;

  /// Fleet-wide counters for the summary cards; not affected by table filters.
  final deviceStats = Rxn<DashboardDeviceStats>();
  final alertStats = Rxn<DashboardAlertStats>();
  final summaryLoading = false.obs;
  final summaryLoaded = false.obs;
  final summaryUpdatedAt = Rxn<DateTime>();

  @override
  Future<PagedResult<Device>> fetch(ListQuery query) async {
    final page = await DeviceRepository.list(_request(query));

    return PagedResult(items: page.items, total: page.total);
  }

  DeviceListRequest _request(ListQuery query) {
    return DeviceListRequest(
      page: query.apiPage,
      perPage: query.pageSize,
      search: query.search,
      sortBy: query.sortBy,
      sortDesc: query.sortDesc,
      policyId: query.filters['policyId'] as int?,
      deviceGroupId: query.filters['deviceGroupId'] as int?,
      isOnline: query.filters['isOnline'] as bool?,
      isRooted: query.filters['isRooted'] as bool?,
      manufacturer: query.textFilter('manufacturer'),
      androidVersion: query.textFilter('androidVersion'),
      criticalBattery: query.filters['criticalBattery'] as bool?,
      criticalStorage: query.filters['criticalStorage'] as bool?,
      notSeen24h: query.filters['notSeen24h'] as bool?,
      noPolicy: query.filters['noPolicy'] as bool?,
    );
  }

  /// CSV of every row matching the filter, not just the current page.
  Future<ByteData> export() => DeviceRepository.export(_request(query));

  Future<void> loadOnlineMinutes() async {
    onlineMinutes.value = await SettingsRepository.offlineTimeout();
  }

  /// Loads the fleet counters shown in the summary cards. Skips while a call is
  /// already in flight; on failure keeps the last good values.
  Future<void> refreshSummary() async {
    if (summaryLoading.value) return;

    summaryLoading.value = true;
    try {
      final results = await Future.wait<Object>([
        DashboardRepository.deviceStats(),
        DashboardRepository.alertStats(),
      ]);

      deviceStats.value = results[0] as DashboardDeviceStats;
      alertStats.value = results[1] as DashboardAlertStats;
      summaryUpdatedAt.value = DateTime.now();
      summaryLoaded.value = true;
    } catch (_) {
      // Keep the previous counters; only the first load has nothing to show.
    } finally {
      summaryLoading.value = false;
    }
  }

  Future<void> ensureOptionsLoaded() async {
    if (optionsLoaded.value) return;
    try {
      policies.assignAll(await PolicyRepository.lookup());
      groups.assignAll(await DeviceGroupRepository.lookup());
      optionsLoaded.value = true;
      // Cells resolve names from these lists; refresh the grid.
      refreshCells();
    } catch (_) {}
  }

  String policyName(int? policyId) =>
      policyId == null ? '—' : policyById(policyId)?.name ?? '#$policyId';

  Policy? policyById(int? policyId) => policyId == null
      ? null
      : policies.firstWhereOrNull((policy) => policy.id == policyId);

  DeviceGroupRow? groupById(int id) =>
      groups.firstWhereOrNull((group) => group.group.id == id);

  Future<int> assignPolicyToSelected(int policyId) =>
      applyToSelected((ids) => DeviceRepository.assignPolicy(ids, policyId));

  Future<int> assignGroupsToSelected(List<int> groupIds) =>
      applyToSelected((ids) => DeviceRepository.assignGroups(ids, groupIds));

  Future<int> sendPolicyUpdateToSelected() =>
      applyToSelected(DeviceRepository.sendPolicyUpdate);

  Future<int> deleteSelected() => applyToSelected(DeviceRepository.delete);

  Future<List<Device>> searchDevices(String? search) async {
    final page = await DeviceRepository.list(
      DeviceListRequest(perPage: lookupPageSize, search: search),
    );
    return page.items;
  }

  Future<Map<int, String>> groupNames() async => {
    for (final row in await DeviceGroupRepository.lookup())
      if (row.group.id != null) row.group.id!: row.group.name,
  };

  Future<DeviceCommandBulkStatus> sendCommand(
    List<int> deviceIds,
    String action,
    String? paramsJson,
  ) => DeviceRepository.sendCommand(deviceIds, action, paramsJson);

  Future<(DeviceCommandBulkStatus, List<DeviceCommand>)> bulkProgress(
    String bulkId,
  ) => (
    DeviceRepository.bulkStatus(bulkId),
    DeviceRepository.bulkCommands(bulkId),
  ).wait;
}
