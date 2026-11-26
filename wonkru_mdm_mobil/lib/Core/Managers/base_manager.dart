import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Mixins/safe_executor.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

abstract class BaseManager<TConfig> with SafeExecutor {
  final st = StorageHelper();

  Future<void> initialize() async {}

  Future<void> applyConfiguration(TConfig config);

  Future<Map<String, dynamic>> getData();

  Future<void> applyRestriction(OnOff? policy, Future<bool> Function(bool) nativeAction) async {
    if (policy == null || policy == OnOff.def) return;
    await nativeAction(policy.isRestricted);
  }

  Future<void> applyFeature({
    required OnOff? policy,
    required Future<void> Function(bool) onEnableChange,
    required Future<void> Function(bool) onLockChange,
  }) async {
    if (policy == null) return;

    switch (policy) {
      case OnOff.on:
        await onEnableChange(true);
        await onLockChange(true);
        break;
      case OnOff.off:
        await onEnableChange(false);
        await onLockChange(true);
        break;
      case OnOff.def:
        await onLockChange(false);
        break;
    }
  }
}