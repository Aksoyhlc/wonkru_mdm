import 'dart:async';

import 'package:cron/cron.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Extensions/string.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Data/Models/Features/sync_settings_config.dart';
import 'package:wonkrumdm/Data/Repositories/device_repository.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'SyncSchedulerService';

/// Order: full sync → apply config → status sync.
///
/// The first sync carries the pre-apply state; a second status sync is needed
/// after the policy is applied so the admin panel sees applied settings such as
/// launcher mode and policy version. If the first sync fails, apply is skipped
/// and the second sync does not run.
Future<void> runFullSyncAndApplySequence({
  required Future<bool> Function() sync,
  required Future<void> Function() apply,
}) async {
  if (!await sync()) {
    return;
  }
  await apply();
  await sync();
}

class SyncSchedulerService extends GetxService {
  static SyncSchedulerService get to => Get.find<SyncSchedulerService>();
  static const _configCheckInterval = Duration(seconds: 5);

  Cron? _cron;
  bool _scheduled = false;
  final _repo = DeviceRepository();

  @override
  void onClose() {
    stopSchedules();
    super.onClose();
  }

  Future<void> _waitForConfigAndSchedule() async {
    while (true) {
      final syncSettings = _getSyncSettings();
      if (syncSettings == null) {
        await Future<void>.delayed(_configCheckInterval);
        continue;
      }
      final fullSyncCron = syncSettings.fullSyncCron;

      if (_repo.needsSync(syncSettings.maxIntervalMinutes)) {
        await _runFullSyncAndApply();
      }

      if (fullSyncCron.isNotNullOrEmpty) {
        _scheduleFullSync(fullSyncCron!);
      }

      return;
    }
  }

  SyncSettingsConfig? _getSyncSettings() {
    if (!Get.isRegistered<DeviceController>()) return null;
    return Get.find<DeviceController>().config.value.syncSettings;
  }

  void _scheduleFullSync(String fullSyncCronExpression) {
    if (_scheduled) return;
    if (fullSyncCronExpression.isEmpty) return;

    try {
      final schedule = Schedule.parse(fullSyncCronExpression);
      _cron = Cron();
      _cron!.schedule(schedule, () async {
        WLog.i(_tag, 'Running full sync');
        await _runFullSyncAndApply();
      });
      _scheduled = true;
    } catch (_) {}
  }

  Future<void> startSchedules() async {
    await stopSchedules();
    await _waitForConfigAndSchedule();
  }

  stopSchedules() async {
    await _cron?.close();
    _scheduled = false;
  }

  Future<void> _runFullSyncAndApply() async {
    await runFullSyncAndApplySequence(
      sync: () async {
        final ok = await _repo.fullSync();
        if (!ok) {
          WLog.w(_tag, 'Full sync failed, skipping config apply');
        }
        return ok;
      },
      apply: () => DeviceController.to.applyLatestConfig(forceUpdate: true),
    );
  }
}
