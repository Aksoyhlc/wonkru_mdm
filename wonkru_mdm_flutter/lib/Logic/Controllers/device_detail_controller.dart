import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Errors/server_error_message.dart';
import '../../Core/Logging/wlog.dart';
import '../../Data/Repositories/device_group_repository.dart';
import '../../Data/Repositories/device_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/user_repository.dart';

const _tag = 'DeviceDetail';

class DeviceDetailController extends GetxController {
  DeviceDetailController(this.deviceId);

  final int deviceId;

  final loading = true.obs;
  final device = Rxn<Device>();
  final groupIds = <int>[].obs;

  final state = Rxn<DeviceStateCache>();
  final policies = <Policy>[].obs;
  final groups = <DeviceGroupRow>[].obs;

  final users = <AdminUserRow>[].obs;

  final reports = <DeviceReport>[].obs;
  final reportsLoading = false.obs;
  final reportsError = RxnString();

  bool _reportsLoaded = false;
  bool _usersLoaded = false;

  /// Only a failed device fetch fails the page; the helper lists degrade to
  /// ids and empty pickers.
  Future<void> load() async {
    loading.value = true;
    try {
      device.value = await DeviceRepository.get(deviceId);
    } catch (e, stackTrace) {
      WLog.e(_tag, 'device load failed', error: e, stackTrace: stackTrace);
      loading.value = false;
      return;
    }

    await Future.wait([
      _loadQuietly(() async {
        groupIds.assignAll(await DeviceRepository.groupIds(deviceId));
      }),
      _loadState(),
      _loadQuietly(() async {
        policies.assignAll(await PolicyRepository.lookup());
      }),
      _loadQuietly(() async {
        groups.assignAll(await DeviceGroupRepository.lookup());
      }),
      ensureUsersLoaded(),
    ]);
    loading.value = false;
  }

  Future<void> _loadQuietly(Future<void> Function() load) async {
    try {
      await load();
    } catch (e, stackTrace) {
      WLog.e(_tag, 'lookup load failed', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _loadState() async {
    try {
      state.value = await DeviceRepository.stateCache(deviceId);
    } catch (_) {
      state.value = null;
    }
  }

  Future<void> ensureUsersLoaded() async {
    if (_usersLoaded) return;
    try {
      users.assignAll(await UserRepository.lookup());
      _usersLoaded = true;
    } catch (_) {}
  }

  Future<void> ensureReportsLoaded() async {
    if (_reportsLoaded) return;
    await loadReports();
  }

  Future<void> loadReports() async {
    reportsLoading.value = true;
    reportsError.value = null;
    try {
      reports.assignAll(await DeviceRepository.reports(deviceId));
      _reportsLoaded = true;
    } catch (e) {
      reportsError.value = serverErrorMessage(e);
    } finally {
      reportsLoading.value = false;
    }
  }

  String policyName(int? policyId) {
    if (policyId == null) return '—';
    final policy = policies.firstWhereOrNull((policy) => policy.id == policyId);
    return policy?.name ?? '#$policyId';
  }

  List<String> groupNames() {
    return [
      for (final id in groupIds)
        groups
            .firstWhere(
              (row) => row.group.id == id,
              orElse: () => DeviceGroupRow(
                group: DeviceGroup(name: '#$id'),
                deviceCount: 0,
              ),
            )
            .group
            .name,
    ];
  }

  Future<void> updateDevice(AdminDeviceUpdateRequest request) async {
    device.value = await DeviceRepository.update(request);
    await load();
  }

  Future<int> sendPolicyUpdate() => DeviceRepository.sendPolicyUpdate([deviceId]);

  Future<ByteData> reportPdf() => DeviceRepository.reportPdf(deviceId, Get.locale?.languageCode);

  Future<Policy> duplicatePolicy() async {
    final copy = await DeviceRepository.duplicatePolicy(deviceId);
    await load();
    return copy;
  }

  Future<int> deleteDevice() => DeviceRepository.delete([deviceId]);
}
