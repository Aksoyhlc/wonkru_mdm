import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Logging/wlog.dart';
import '../../Data/Repositories/device_sync_repository.dart';

class DeviceSyncDetailController extends GetxController {
  DeviceSyncDetailController(this.syncId);

  final int syncId;

  final loading = true.obs;
  final detail = Rxn<DeviceSyncDetail>();

  Future<void> load() async {
    loading.value = true;
    try {
      detail.value = await DeviceSyncRepository.get(syncId);
    } catch (e, stackTrace) {
      WLog.e(
        'DeviceSyncDetail',
        'load failed',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      loading.value = false;
    }
  }
}
