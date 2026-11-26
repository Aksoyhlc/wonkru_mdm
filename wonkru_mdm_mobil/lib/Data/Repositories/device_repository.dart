import 'package:flutter/foundation.dart';
import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Local/config.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';

import 'base.dart';

const _tag = 'DeviceRepository';

class DeviceRepository extends BaseRepository {
  final deviceAPI = DeviceAPI();
  final _local = LocalConfig();
  final _st = StorageHelper();

  Future<DeviceConfig?> syncConfig({bool forceUpdate = true}) async {
    if (!forceUpdate && hasValidCache(Sk.lastConfigFetchTime.name, minutes: kConfigFetchIntervalMinutes)) {
      final localData = _local.getConfig();
      if (localData?.id != null) {
        WLog.d(_tag, 'Config is current (Cache), no API call made');
        return localData;
      }
    }

    try {
      final data = await deviceAPI.getConfig();

      if (data.$1 && data.$2.isNotEmpty) {
        final (config, _) = await _acceptRemote(data.$2);
        return config ?? _local.getConfig();
      }

      // If the server returned `policy: null` (policy removed), the local config
      // is deliberately kept: the device stays on the last applied settings.
      return _local.getConfig();
    } catch (e) {
      return _local.getConfig();
    }
  }

  /// Parses the raw policy **before** storing it; it is persisted only on
  /// success. An unparsable payload is logged, not stored, and the last valid
  /// config is kept.
  Future<(DeviceConfig?, ConfigApplyResult?)> _acceptRemote(Map<String, dynamic> data) {
    return acceptRemoteConfig(
      data,
      persist: (raw) async {
        await _local.saveConfig(raw);
        _st.setString(Sk.lastConfigFetchTime.name, DateTime.now().toIso8601String());
      },
    );
  }

  /// Pure core of [_acceptRemote]: calls [persist] and returns the config when
  /// [parse] succeeds; writes nothing and returns [ConfigApplyResult.invalidPolicy]
  /// otherwise.
  @visibleForTesting
  static Future<(DeviceConfig?, ConfigApplyResult?)> acceptRemoteConfig(
    Map<String, dynamic> data, {
    required Future<void> Function(Map<String, dynamic> raw) persist,
    DeviceConfig? Function(Map<String, dynamic> raw) parse = LocalConfig.parse,
  }) async {
    final config = parse(data);
    if (config == null) {
      WLog.e(_tag, 'Server policy could not be parsed; keeping last valid config');
      return (null, ConfigApplyResult.invalidPolicy);
    }
    await persist(data);
    return (config, null);
  }

  DeviceConfig? getConfig() {
    return _local.getConfig();
  }

  /// Fetches the policy from the server without consulting the cache and does
  /// not hide the outcome.
  ///
  /// Unlike [syncConfig] it does not fall back to the local copy on error and
  /// reports why it failed. Used so explicit commands (`update_policy`,
  /// `policy_change`) can ack the real result.
  /// Returns `(config, error)`: on success error is `null`; `noPolicy` means the
  /// server returned no policy.
  Future<(DeviceConfig?, ConfigApplyResult?)> fetchConfigFromServer() async {
    try {
      final (ok, data) = await deviceAPI.getConfig();
      if (!ok || data.isEmpty) {
        final noPolicy = deviceAPI.lastMessage == DeviceAPI.noPolicyMessage;
        return (null, noPolicy ? ConfigApplyResult.noPolicy : ConfigApplyResult.fetchFailed);
      }
      return await _acceptRemote(data);
    } catch (e, st) {
      WLog.w(_tag, 'fetchConfigFromServer failed', error: e, stackTrace: st);
      return (null, ConfigApplyResult.fetchFailed);
    }
  }

  Future<bool> fullSync() async {
    try {
      final (ok, _) = await deviceAPI.sync();
      if (ok) {
        // Also flush logs queued since the last send along with the sync: logs
        // normally go out on lifecycle/threshold, and flushing here makes them
        // show up in the panel without delay.
        await WLog.flush();
      }
      return ok;
    } catch (e, st) {
      WLog.w(_tag, 'fullSync failed', error: e, stackTrace: st);
      return false;
    }
  }

  bool needsSync(int maxIntervalMinutes) {
    final lastMs = _st.getInt(Sk.lastSync.name);
    if (lastMs == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    return DateTime.now().difference(last).inMinutes >= maxIntervalMinutes;
  }

  DateTime? lastSyncTime() {
    final lastMs = _st.getInt(Sk.lastSync.name);
    if (lastMs == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastMs);
  }
}
