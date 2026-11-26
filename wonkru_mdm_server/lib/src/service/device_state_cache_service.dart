import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/json_utils.dart';

class DeviceStateCacheService {
  const DeviceStateCacheService._();

  static Future<void> updateFromSync(
    Session session,
    DeviceSync sync, {
    Transaction? transaction,
  }) async {
    final data = extract(sync);

    final existing = await DeviceStateCache.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(sync.deviceId),
      transaction: transaction,
    );

    if (existing == null) {
      await DeviceStateCache.db.insertRow(
        session,
        data,
        transaction: transaction,
      );
      return;
    }

    data.id = existing.id;
    await DeviceStateCache.db.updateRow(
      session,
      data,
      columns: (t) => presentColumns(t, sync),
      transaction: transaction,
    );
  }

  /// Cache columns belonging to the sections present in [sync].
  ///
  /// A section present in the payload (`device`, `battery`, `network`…) writes
  /// all of its columns; a `null` inside a section is a real value (the SSID
  /// when Wi-Fi drops, say). A missing section leaves its columns untouched.
  static List<Column> presentColumns(DeviceStateCacheTable t, DeviceSync sync) {
    final pairs = <(String?, List<Column>)>[
      (
        sync.deviceInfo,
        [
          t.manufacturer,
          t.model,
          t.brand,
          t.androidVersion,
          t.sdkInt,
          t.securityPatch,
          t.buildFingerprint,
          t.isPhysicalDevice,
          t.isLowRamDevice,
        ],
      ),
      (sync.batteryInfo, [t.batteryLevel, t.batteryState, t.isPowerSaveMode]),
      (
        sync.networkInfo,
        [
          t.isOnline,
          t.currentSsid,
          t.currentBssid,
          t.wifiRssi,
          t.wifiLinkSpeed,
          t.wifiFrequency,
          t.ipv4,
          t.ipv6,
          t.gateway,
          t.subnetMask,
        ],
      ),
      (
        sync.systemInfo,
        [
          t.isRooted,
          t.adbEnabled,
          t.developerOptionsEnabled,
          t.unknownSourcesAllowed,
          t.encryptionStatus,
          t.playProtectStatus,
        ],
      ),
      (
        sync.securityInfo,
        [
          t.passwordIsSufficient,
          t.passwordQuality,
          t.passwordComplexityLevel,
          t.hasSecureLock,
          t.isLocked,
          t.isDeviceOwner,
        ],
      ),
      (
        sync.storageInfo,
        [
          t.totalStorageBytes,
          t.freeStorageBytes,
          t.usedStorageBytes,
          t.storageUsagePct,
          t.storageFreePct,
        ],
      ),
      (
        sync.appsInfo,
        [
          t.totalInstalledApps,
          t.systemAppsCount,
          t.userAppsCount,
          t.managedAppsCount,
        ],
      ),
      (
        sync.certificatesInfo,
        [t.installedCaCertCount, t.hasWonkruMdmCa, t.hasWonkruLocalCa],
      ),
      (
        sync.displayInfo,
        [t.brightness, t.screenTimeoutMs, t.screenWidthPx, t.screenHeightPx],
      ),
      (
        sync.bsInfo,
        [
          t.launcherModeEnabled,
          t.watchdogServiceEnabled,
          t.flutterAliveAt,
          t.bsDeviceUuid,
          t.bsDeviceCode,
          t.serverUrl,
        ],
      ),
      (
        sync.stInfo,
        [
          t.networkLastSsid,
          t.stDeviceUuid,
          t.stDeviceCode,
          t.lastPolicyUpdateAt,
          t.lastConfigFetchTime,
          t.stLastSyncAt,
        ],
      ),
      (sync.restrictionsInfo, [t.restrictionCount]),
    ];

    return [
      t.deviceSyncId,
      t.collectedAt,
      t.updatedAt,
      for (final (raw, columns) in pairs)
        if (raw != null) ...columns,
    ];
  }

  static DeviceStateCache extract(DeviceSync sync) {
    final device = decodeJsonMap(sync.deviceInfo);
    final apps = decodeJsonMap(sync.appsInfo);
    final battery = decodeJsonMap(sync.batteryInfo);
    final certificates = decodeJsonMap(sync.certificatesInfo);
    final display = decodeJsonMap(sync.displayInfo);
    final network = decodeJsonMap(sync.networkInfo);
    final security = decodeJsonMap(sync.securityInfo);
    final storage = decodeJsonMap(sync.storageInfo);
    final system = decodeJsonMap(sync.systemInfo);
    final restrictions = decodeJsonMap(sync.restrictionsInfo);
    final bs = decodeJsonMap(sync.bsInfo);
    final st = decodeJsonMap(sync.stInfo);

    final caCertificates = asList(
      certificates['installedCaCertificates'],
    ).map((value) => value.toString()).toList();

    return DeviceStateCache(
      deviceId: sync.deviceId,
      deviceSyncId: sync.id!,
      collectedAt: sync.collectedAt,
      manufacturer: asString(deepGet(device, 'manufacturer')),
      model: asString(deepGet(device, 'model')),
      brand: asString(deepGet(device, 'brand')),
      androidVersion: asString(deepGet(device, 'version.release')),
      sdkInt: asInt(deepGet(device, 'version.sdkInt')),
      securityPatch: asString(deepGet(device, 'version.securityPatch')),
      buildFingerprint: asString(deepGet(device, 'fingerprint')),
      isPhysicalDevice: asBoolOrNull(deepGet(device, 'isPhysicalDevice')),
      isLowRamDevice: asBoolOrNull(deepGet(device, 'isLowRamDevice')),
      batteryLevel: asInt(deepGet(battery, 'level')),
      batteryState: asString(deepGet(battery, 'state')),
      isPowerSaveMode: asBoolOrNull(deepGet(battery, 'isPowerSaveMode')),
      isOnline: asBoolOrNull(deepGet(network, 'isOnline')),
      currentSsid: asString(deepGet(network, 'wifi.ssid')),
      currentBssid: asString(deepGet(network, 'wifi.bssid')),
      wifiRssi: asInt(deepGet(network, 'wifi.rssi')),
      wifiLinkSpeed: asInt(deepGet(network, 'wifi.linkSpeed')),
      wifiFrequency: asInt(deepGet(network, 'wifi.frequency')),
      ipv4: asString(deepGet(network, 'ipInfo.ipv4')),
      ipv6: asString(deepGet(network, 'ipInfo.ipv6')),
      gateway: asString(deepGet(network, 'ipInfo.gateway')),
      subnetMask: asString(deepGet(network, 'ipInfo.subnetMask')),
      networkLastSsid: asString(deepGet(st, 'network_last_connected_ssid')),
      isRooted: asBoolOrNull(deepGet(system, 'security.isRooted')),
      adbEnabled: asBoolOrNull(deepGet(system, 'security.adbEnabled')),
      developerOptionsEnabled: asBoolOrNull(
        deepGet(system, 'security.developerOptionsEnabled'),
      ),
      unknownSourcesAllowed: asBoolOrNull(
        deepGet(system, 'security.unknownSourcesAllowed'),
      ),
      encryptionStatus: asString(deepGet(system, 'security.encryptionStatus')),
      playProtectStatus: asBoolOrNull(
        deepGet(system, 'security.playProtectStatus'),
      ),
      passwordIsSufficient: asBoolOrNull(
        deepGet(security, 'password.isSufficient'),
      ),
      passwordQuality: asInt(deepGet(security, 'password.policy.quality')),
      passwordComplexityLevel: asInt(
        deepGet(security, 'password.policy.complexityLevel'),
      ),
      hasSecureLock: asBoolOrNull(deepGet(security, 'keyguard.hasSecureLock')),
      isLocked: asBoolOrNull(deepGet(security, 'keyguard.isLocked')),
      isDeviceOwner: asBoolOrNull(deepGet(security, 'keyguard.isDeviceOwner')),
      totalStorageBytes: asInt(deepGet(storage, 'totalStorageBytes')),
      freeStorageBytes: asInt(deepGet(storage, 'freeStorageBytes')),
      usedStorageBytes: asInt(deepGet(storage, 'usedStorageBytes')),
      storageUsagePct: asDouble(deepGet(storage, 'usagePercentage')),
      storageFreePct: asDouble(deepGet(storage, 'freePercentage')),
      totalInstalledApps: asInt(deepGet(apps, 'totalInstalled')),
      systemAppsCount: asInt(deepGet(apps, 'systemAppsCount')),
      userAppsCount: asInt(deepGet(apps, 'userAppsCount')),
      managedAppsCount: asInt(deepGet(apps, 'managedAppsCount')),
      installedCaCertCount: asInt(
        deepGet(certificates, 'installedCaCertificateCount'),
      ),
      hasWonkruMdmCa: caCertificates.contains('Wonkru MDM CA'),
      hasWonkruLocalCa: caCertificates.contains('WonkruMDM Local CA'),
      brightness: asInt(deepGet(display, 'brightness')),
      screenTimeoutMs: asInt(deepGet(display, 'screenTimeoutMs')),
      screenWidthPx: asInt(deepGet(display, 'info.widthPixels')),
      screenHeightPx: asInt(deepGet(display, 'info.heightPixels')),
      // Agents write the new key; `kiosk_enabled` is the fallback for older ones.
      launcherModeEnabled:
          asBoolOrNull(deepGet(bs, 'launcher_mode_enabled')) ??
          asBoolOrNull(deepGet(bs, 'kiosk_enabled')),
      watchdogServiceEnabled: asBoolOrNull(
        deepGet(bs, 'watchdog_service_enabled'),
      ),
      flutterAliveAt: _timestamp(deepGet(bs, 'flutter_alive_timestamp')),
      bsDeviceUuid: asString(deepGet(bs, 'deviceUuid')),
      bsDeviceCode: asString(deepGet(bs, 'deviceCode')),
      serverUrl: asString(deepGet(bs, 'server_url')),
      stDeviceUuid: asString(deepGet(st, 'deviceUuid')),
      stDeviceCode: asString(deepGet(st, 'deviceCode')),
      lastPolicyUpdateAt: _timestamp(deepGet(st, 'lastPolicyUpdate')),
      lastConfigFetchTime: asString(deepGet(st, 'lastConfigFetchTime')),
      stLastSyncAt: _timestamp(deepGet(st, 'lastSync')),
      restrictionCount: asInt(deepGet(restrictions, 'restrictionCount')),
    );
  }

  static DateTime? _timestamp(dynamic value) {
    final millis = asInt(value);
    if (millis == null || millis == 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }
}
