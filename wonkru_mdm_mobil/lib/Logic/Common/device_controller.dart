import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';
import 'package:wonkrumdm/Data/Repositories/device_repository.dart';

import '../../Core/Constants/Enums/storage_keys.dart';
import '../../Core/Managers/config_manager.dart';

class DeviceController extends GetxController {
  static DeviceController to = Get.find<DeviceController>();
  final _repo = DeviceRepository();

  var config = DeviceConfig().obs;

  @override
  void onInit() {
    super.onInit();
    loadFromLocal();
  }

  bool isConfigLoaded() => config.value.id != null;

  /// Loads the local config. If it cannot be read the current (last valid) value
  /// is kept, rather than falling back to an empty [DeviceConfig].
  void loadFromLocal() {
    final local = _repo.getConfig();
    if (local != null) config.value = local;
  }

  Future<void> applyLatestConfig({bool forceUpdate = false, bool applyConfiguration = true}) async {
    var newPolicy = await _repo.syncConfig(forceUpdate: forceUpdate);
    loadFromLocal();
    if (newPolicy != null) {
      config.value = newPolicy;

      if (applyConfiguration) {
        if (forceUpdate) {
          StorageHelper.instance.remove(Sk.lastPolicyVersion.name);
        }
        await ConfigManager().applyConfigurationWithOptions(newPolicy, bypassThrottle: forceUpdate);
        // After applying the policy, report the current state (launcher mode,
        // policy version) to the server; otherwise the panel shows the
        // pre-application values.
        await _repo.fullSync();
      }
    }
  }

  /// For an explicit command (`update_policy` / `policy_change`): fetches the
  /// latest policy from the server, applies it and returns the real result.
  ///
  /// Unlike [applyLatestConfig] it does not re-apply the local copy when the
  /// server is unreachable but reports the failure; it bypasses the throttle and
  /// waits for an in-flight apply.
  Future<ConfigApplyResult> applyLatestConfigForCommand() async {
    final (newPolicy, error) = await _repo.fetchConfigFromServer();
    loadFromLocal();
    if (newPolicy == null) return error ?? ConfigApplyResult.fetchFailed;
    config.value = newPolicy;
    StorageHelper.instance.remove(Sk.lastPolicyVersion.name);
    final result = await ConfigManager().applyConfigurationWithOptions(
      newPolicy,
      bypassThrottle: true,
      waitIfBusy: true,
    );
    if (result == ConfigApplyResult.applied ||
        result == ConfigApplyResult.partial) {
      await _repo.fullSync();
    }
    return result;
  }
}
