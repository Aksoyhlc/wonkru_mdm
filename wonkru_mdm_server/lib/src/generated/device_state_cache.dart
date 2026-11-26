/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import 'device.dart' as _ilo09f9g;
import 'device_sync.dart' as _ijb003y9;

abstract class DeviceStateCache
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceStateCache._({
    this.id,
    required this.deviceId,
    this.device,
    required this.deviceSyncId,
    this.deviceSync,
    required this.collectedAt,
    DateTime? updatedAt,
    this.manufacturer,
    this.model,
    this.brand,
    this.androidVersion,
    this.sdkInt,
    this.securityPatch,
    this.buildFingerprint,
    this.isPhysicalDevice,
    this.isLowRamDevice,
    this.batteryLevel,
    this.batteryState,
    this.isPowerSaveMode,
    this.isOnline,
    this.currentSsid,
    this.currentBssid,
    this.wifiRssi,
    this.wifiLinkSpeed,
    this.wifiFrequency,
    this.ipv4,
    this.ipv6,
    this.gateway,
    this.subnetMask,
    this.networkLastSsid,
    this.isRooted,
    this.adbEnabled,
    this.developerOptionsEnabled,
    this.unknownSourcesAllowed,
    this.encryptionStatus,
    this.playProtectStatus,
    this.passwordIsSufficient,
    this.passwordQuality,
    this.passwordComplexityLevel,
    this.hasSecureLock,
    this.isLocked,
    this.isDeviceOwner,
    this.totalStorageBytes,
    this.freeStorageBytes,
    this.usedStorageBytes,
    this.storageUsagePct,
    this.storageFreePct,
    this.totalInstalledApps,
    this.systemAppsCount,
    this.userAppsCount,
    this.managedAppsCount,
    this.installedCaCertCount,
    bool? hasWonkruMdmCa,
    bool? hasWonkruLocalCa,
    this.brightness,
    this.screenTimeoutMs,
    this.screenWidthPx,
    this.screenHeightPx,
    this.launcherModeEnabled,
    this.watchdogServiceEnabled,
    this.flutterAliveAt,
    this.bsDeviceUuid,
    this.bsDeviceCode,
    this.serverUrl,
    this.stDeviceUuid,
    this.stDeviceCode,
    this.lastPolicyUpdateAt,
    this.lastConfigFetchTime,
    this.stLastSyncAt,
    this.restrictionCount,
  }) : updatedAt = updatedAt ?? DateTime.now(),
       hasWonkruMdmCa = hasWonkruMdmCa ?? false,
       hasWonkruLocalCa = hasWonkruLocalCa ?? false;

  factory DeviceStateCache({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceSyncId,
    _ijb003y9.DeviceSync? deviceSync,
    required DateTime collectedAt,
    DateTime? updatedAt,
    String? manufacturer,
    String? model,
    String? brand,
    String? androidVersion,
    int? sdkInt,
    String? securityPatch,
    String? buildFingerprint,
    bool? isPhysicalDevice,
    bool? isLowRamDevice,
    int? batteryLevel,
    String? batteryState,
    bool? isPowerSaveMode,
    bool? isOnline,
    String? currentSsid,
    String? currentBssid,
    int? wifiRssi,
    int? wifiLinkSpeed,
    int? wifiFrequency,
    String? ipv4,
    String? ipv6,
    String? gateway,
    String? subnetMask,
    String? networkLastSsid,
    bool? isRooted,
    bool? adbEnabled,
    bool? developerOptionsEnabled,
    bool? unknownSourcesAllowed,
    String? encryptionStatus,
    bool? playProtectStatus,
    bool? passwordIsSufficient,
    int? passwordQuality,
    int? passwordComplexityLevel,
    bool? hasSecureLock,
    bool? isLocked,
    bool? isDeviceOwner,
    int? totalStorageBytes,
    int? freeStorageBytes,
    int? usedStorageBytes,
    double? storageUsagePct,
    double? storageFreePct,
    int? totalInstalledApps,
    int? systemAppsCount,
    int? userAppsCount,
    int? managedAppsCount,
    int? installedCaCertCount,
    bool? hasWonkruMdmCa,
    bool? hasWonkruLocalCa,
    int? brightness,
    int? screenTimeoutMs,
    int? screenWidthPx,
    int? screenHeightPx,
    bool? launcherModeEnabled,
    bool? watchdogServiceEnabled,
    DateTime? flutterAliveAt,
    String? bsDeviceUuid,
    String? bsDeviceCode,
    String? serverUrl,
    String? stDeviceUuid,
    String? stDeviceCode,
    DateTime? lastPolicyUpdateAt,
    String? lastConfigFetchTime,
    DateTime? stLastSyncAt,
    int? restrictionCount,
  }) = _DeviceStateCacheImpl;

  factory DeviceStateCache.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceStateCache(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      deviceSyncId: jsonSerialization['deviceSyncId'] as int,
      deviceSync: jsonSerialization['deviceSync'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ijb003y9.DeviceSync>(
              jsonSerialization['deviceSync'],
            ),
      collectedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['collectedAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      manufacturer: jsonSerialization['manufacturer'] as String?,
      model: jsonSerialization['model'] as String?,
      brand: jsonSerialization['brand'] as String?,
      androidVersion: jsonSerialization['androidVersion'] as String?,
      sdkInt: jsonSerialization['sdkInt'] as int?,
      securityPatch: jsonSerialization['securityPatch'] as String?,
      buildFingerprint: jsonSerialization['buildFingerprint'] as String?,
      isPhysicalDevice: jsonSerialization['isPhysicalDevice'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isPhysicalDevice'],
            ),
      isLowRamDevice: jsonSerialization['isLowRamDevice'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isLowRamDevice']),
      batteryLevel: jsonSerialization['batteryLevel'] as int?,
      batteryState: jsonSerialization['batteryState'] as String?,
      isPowerSaveMode: jsonSerialization['isPowerSaveMode'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isPowerSaveMode'],
            ),
      isOnline: jsonSerialization['isOnline'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isOnline']),
      currentSsid: jsonSerialization['currentSsid'] as String?,
      currentBssid: jsonSerialization['currentBssid'] as String?,
      wifiRssi: jsonSerialization['wifiRssi'] as int?,
      wifiLinkSpeed: jsonSerialization['wifiLinkSpeed'] as int?,
      wifiFrequency: jsonSerialization['wifiFrequency'] as int?,
      ipv4: jsonSerialization['ipv4'] as String?,
      ipv6: jsonSerialization['ipv6'] as String?,
      gateway: jsonSerialization['gateway'] as String?,
      subnetMask: jsonSerialization['subnetMask'] as String?,
      networkLastSsid: jsonSerialization['networkLastSsid'] as String?,
      isRooted: jsonSerialization['isRooted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isRooted']),
      adbEnabled: jsonSerialization['adbEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['adbEnabled']),
      developerOptionsEnabled:
          jsonSerialization['developerOptionsEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['developerOptionsEnabled'],
            ),
      unknownSourcesAllowed: jsonSerialization['unknownSourcesAllowed'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['unknownSourcesAllowed'],
            ),
      encryptionStatus: jsonSerialization['encryptionStatus'] as String?,
      playProtectStatus: jsonSerialization['playProtectStatus'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['playProtectStatus'],
            ),
      passwordIsSufficient: jsonSerialization['passwordIsSufficient'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['passwordIsSufficient'],
            ),
      passwordQuality: jsonSerialization['passwordQuality'] as int?,
      passwordComplexityLevel:
          jsonSerialization['passwordComplexityLevel'] as int?,
      hasSecureLock: jsonSerialization['hasSecureLock'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hasSecureLock']),
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      isDeviceOwner: jsonSerialization['isDeviceOwner'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDeviceOwner']),
      totalStorageBytes: jsonSerialization['totalStorageBytes'] as int?,
      freeStorageBytes: jsonSerialization['freeStorageBytes'] as int?,
      usedStorageBytes: jsonSerialization['usedStorageBytes'] as int?,
      storageUsagePct: (jsonSerialization['storageUsagePct'] as num?)
          ?.toDouble(),
      storageFreePct: (jsonSerialization['storageFreePct'] as num?)?.toDouble(),
      totalInstalledApps: jsonSerialization['totalInstalledApps'] as int?,
      systemAppsCount: jsonSerialization['systemAppsCount'] as int?,
      userAppsCount: jsonSerialization['userAppsCount'] as int?,
      managedAppsCount: jsonSerialization['managedAppsCount'] as int?,
      installedCaCertCount: jsonSerialization['installedCaCertCount'] as int?,
      hasWonkruMdmCa: jsonSerialization['hasWonkruMdmCa'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hasWonkruMdmCa']),
      hasWonkruLocalCa: jsonSerialization['hasWonkruLocalCa'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['hasWonkruLocalCa'],
            ),
      brightness: jsonSerialization['brightness'] as int?,
      screenTimeoutMs: jsonSerialization['screenTimeoutMs'] as int?,
      screenWidthPx: jsonSerialization['screenWidthPx'] as int?,
      screenHeightPx: jsonSerialization['screenHeightPx'] as int?,
      launcherModeEnabled: jsonSerialization['launcherModeEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['launcherModeEnabled'],
            ),
      watchdogServiceEnabled:
          jsonSerialization['watchdogServiceEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['watchdogServiceEnabled'],
            ),
      flutterAliveAt: jsonSerialization['flutterAliveAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['flutterAliveAt'],
            ),
      bsDeviceUuid: jsonSerialization['bsDeviceUuid'] as String?,
      bsDeviceCode: jsonSerialization['bsDeviceCode'] as String?,
      serverUrl: jsonSerialization['serverUrl'] as String?,
      stDeviceUuid: jsonSerialization['stDeviceUuid'] as String?,
      stDeviceCode: jsonSerialization['stDeviceCode'] as String?,
      lastPolicyUpdateAt: jsonSerialization['lastPolicyUpdateAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPolicyUpdateAt'],
            ),
      lastConfigFetchTime: jsonSerialization['lastConfigFetchTime'] as String?,
      stLastSyncAt: jsonSerialization['stLastSyncAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['stLastSyncAt'],
            ),
      restrictionCount: jsonSerialization['restrictionCount'] as int?,
    );
  }

  static final t = DeviceStateCacheTable();

  static const db = DeviceStateCacheRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  int deviceSyncId;

  _ijb003y9.DeviceSync? deviceSync;

  DateTime collectedAt;

  DateTime updatedAt;

  String? manufacturer;

  String? model;

  String? brand;

  String? androidVersion;

  int? sdkInt;

  String? securityPatch;

  String? buildFingerprint;

  bool? isPhysicalDevice;

  bool? isLowRamDevice;

  int? batteryLevel;

  String? batteryState;

  bool? isPowerSaveMode;

  bool? isOnline;

  String? currentSsid;

  String? currentBssid;

  int? wifiRssi;

  int? wifiLinkSpeed;

  int? wifiFrequency;

  String? ipv4;

  String? ipv6;

  String? gateway;

  String? subnetMask;

  String? networkLastSsid;

  bool? isRooted;

  bool? adbEnabled;

  bool? developerOptionsEnabled;

  bool? unknownSourcesAllowed;

  String? encryptionStatus;

  bool? playProtectStatus;

  bool? passwordIsSufficient;

  int? passwordQuality;

  int? passwordComplexityLevel;

  bool? hasSecureLock;

  bool? isLocked;

  bool? isDeviceOwner;

  int? totalStorageBytes;

  int? freeStorageBytes;

  int? usedStorageBytes;

  double? storageUsagePct;

  double? storageFreePct;

  int? totalInstalledApps;

  int? systemAppsCount;

  int? userAppsCount;

  int? managedAppsCount;

  int? installedCaCertCount;

  bool? hasWonkruMdmCa;

  bool? hasWonkruLocalCa;

  int? brightness;

  int? screenTimeoutMs;

  int? screenWidthPx;

  int? screenHeightPx;

  bool? launcherModeEnabled;

  bool? watchdogServiceEnabled;

  DateTime? flutterAliveAt;

  String? bsDeviceUuid;

  String? bsDeviceCode;

  String? serverUrl;

  String? stDeviceUuid;

  String? stDeviceCode;

  DateTime? lastPolicyUpdateAt;

  String? lastConfigFetchTime;

  DateTime? stLastSyncAt;

  int? restrictionCount;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceStateCache]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceStateCache copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceStateCache$device(),
    int? deviceSyncId,
    _ijb003y9.DeviceSync? deviceSync =
        const _UndefinedDeviceStateCache$deviceSync(),
    DateTime? collectedAt,
    DateTime? updatedAt,
    String? manufacturer,
    String? model,
    String? brand,
    String? androidVersion,
    int? sdkInt,
    String? securityPatch,
    String? buildFingerprint,
    bool? isPhysicalDevice,
    bool? isLowRamDevice,
    int? batteryLevel,
    String? batteryState,
    bool? isPowerSaveMode,
    bool? isOnline,
    String? currentSsid,
    String? currentBssid,
    int? wifiRssi,
    int? wifiLinkSpeed,
    int? wifiFrequency,
    String? ipv4,
    String? ipv6,
    String? gateway,
    String? subnetMask,
    String? networkLastSsid,
    bool? isRooted,
    bool? adbEnabled,
    bool? developerOptionsEnabled,
    bool? unknownSourcesAllowed,
    String? encryptionStatus,
    bool? playProtectStatus,
    bool? passwordIsSufficient,
    int? passwordQuality,
    int? passwordComplexityLevel,
    bool? hasSecureLock,
    bool? isLocked,
    bool? isDeviceOwner,
    int? totalStorageBytes,
    int? freeStorageBytes,
    int? usedStorageBytes,
    double? storageUsagePct,
    double? storageFreePct,
    int? totalInstalledApps,
    int? systemAppsCount,
    int? userAppsCount,
    int? managedAppsCount,
    int? installedCaCertCount,
    bool? hasWonkruMdmCa,
    bool? hasWonkruLocalCa,
    int? brightness,
    int? screenTimeoutMs,
    int? screenWidthPx,
    int? screenHeightPx,
    bool? launcherModeEnabled,
    bool? watchdogServiceEnabled,
    DateTime? flutterAliveAt = const _is.$UndefinedDateTime(),
    String? bsDeviceUuid,
    String? bsDeviceCode,
    String? serverUrl,
    String? stDeviceUuid,
    String? stDeviceCode,
    DateTime? lastPolicyUpdateAt = const _is.$UndefinedDateTime(),
    String? lastConfigFetchTime,
    DateTime? stLastSyncAt = const _is.$UndefinedDateTime(),
    int? restrictionCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceStateCache',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'deviceSyncId': deviceSyncId,
      if (deviceSync != null) 'deviceSync': deviceSync?.toJson(),
      'collectedAt': collectedAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (sdkInt != null) 'sdkInt': sdkInt,
      if (securityPatch != null) 'securityPatch': securityPatch,
      if (buildFingerprint != null) 'buildFingerprint': buildFingerprint,
      if (isPhysicalDevice != null) 'isPhysicalDevice': isPhysicalDevice,
      if (isLowRamDevice != null) 'isLowRamDevice': isLowRamDevice,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (batteryState != null) 'batteryState': batteryState,
      if (isPowerSaveMode != null) 'isPowerSaveMode': isPowerSaveMode,
      if (isOnline != null) 'isOnline': isOnline,
      if (currentSsid != null) 'currentSsid': currentSsid,
      if (currentBssid != null) 'currentBssid': currentBssid,
      if (wifiRssi != null) 'wifiRssi': wifiRssi,
      if (wifiLinkSpeed != null) 'wifiLinkSpeed': wifiLinkSpeed,
      if (wifiFrequency != null) 'wifiFrequency': wifiFrequency,
      if (ipv4 != null) 'ipv4': ipv4,
      if (ipv6 != null) 'ipv6': ipv6,
      if (gateway != null) 'gateway': gateway,
      if (subnetMask != null) 'subnetMask': subnetMask,
      if (networkLastSsid != null) 'networkLastSsid': networkLastSsid,
      if (isRooted != null) 'isRooted': isRooted,
      if (adbEnabled != null) 'adbEnabled': adbEnabled,
      if (developerOptionsEnabled != null)
        'developerOptionsEnabled': developerOptionsEnabled,
      if (unknownSourcesAllowed != null)
        'unknownSourcesAllowed': unknownSourcesAllowed,
      if (encryptionStatus != null) 'encryptionStatus': encryptionStatus,
      if (playProtectStatus != null) 'playProtectStatus': playProtectStatus,
      if (passwordIsSufficient != null)
        'passwordIsSufficient': passwordIsSufficient,
      if (passwordQuality != null) 'passwordQuality': passwordQuality,
      if (passwordComplexityLevel != null)
        'passwordComplexityLevel': passwordComplexityLevel,
      if (hasSecureLock != null) 'hasSecureLock': hasSecureLock,
      if (isLocked != null) 'isLocked': isLocked,
      if (isDeviceOwner != null) 'isDeviceOwner': isDeviceOwner,
      if (totalStorageBytes != null) 'totalStorageBytes': totalStorageBytes,
      if (freeStorageBytes != null) 'freeStorageBytes': freeStorageBytes,
      if (usedStorageBytes != null) 'usedStorageBytes': usedStorageBytes,
      if (storageUsagePct != null) 'storageUsagePct': storageUsagePct,
      if (storageFreePct != null) 'storageFreePct': storageFreePct,
      if (totalInstalledApps != null) 'totalInstalledApps': totalInstalledApps,
      if (systemAppsCount != null) 'systemAppsCount': systemAppsCount,
      if (userAppsCount != null) 'userAppsCount': userAppsCount,
      if (managedAppsCount != null) 'managedAppsCount': managedAppsCount,
      if (installedCaCertCount != null)
        'installedCaCertCount': installedCaCertCount,
      if (hasWonkruMdmCa != null) 'hasWonkruMdmCa': hasWonkruMdmCa,
      if (hasWonkruLocalCa != null) 'hasWonkruLocalCa': hasWonkruLocalCa,
      if (brightness != null) 'brightness': brightness,
      if (screenTimeoutMs != null) 'screenTimeoutMs': screenTimeoutMs,
      if (screenWidthPx != null) 'screenWidthPx': screenWidthPx,
      if (screenHeightPx != null) 'screenHeightPx': screenHeightPx,
      if (launcherModeEnabled != null)
        'launcherModeEnabled': launcherModeEnabled,
      if (watchdogServiceEnabled != null)
        'watchdogServiceEnabled': watchdogServiceEnabled,
      if (flutterAliveAt != null) 'flutterAliveAt': flutterAliveAt?.toJson(),
      if (bsDeviceUuid != null) 'bsDeviceUuid': bsDeviceUuid,
      if (bsDeviceCode != null) 'bsDeviceCode': bsDeviceCode,
      if (serverUrl != null) 'serverUrl': serverUrl,
      if (stDeviceUuid != null) 'stDeviceUuid': stDeviceUuid,
      if (stDeviceCode != null) 'stDeviceCode': stDeviceCode,
      if (lastPolicyUpdateAt != null)
        'lastPolicyUpdateAt': lastPolicyUpdateAt?.toJson(),
      if (lastConfigFetchTime != null)
        'lastConfigFetchTime': lastConfigFetchTime,
      if (stLastSyncAt != null) 'stLastSyncAt': stLastSyncAt?.toJson(),
      if (restrictionCount != null) 'restrictionCount': restrictionCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceStateCache',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'deviceSyncId': deviceSyncId,
      if (deviceSync != null) 'deviceSync': deviceSync?.toJsonForProtocol(),
      'collectedAt': collectedAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (sdkInt != null) 'sdkInt': sdkInt,
      if (securityPatch != null) 'securityPatch': securityPatch,
      if (buildFingerprint != null) 'buildFingerprint': buildFingerprint,
      if (isPhysicalDevice != null) 'isPhysicalDevice': isPhysicalDevice,
      if (isLowRamDevice != null) 'isLowRamDevice': isLowRamDevice,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (batteryState != null) 'batteryState': batteryState,
      if (isPowerSaveMode != null) 'isPowerSaveMode': isPowerSaveMode,
      if (isOnline != null) 'isOnline': isOnline,
      if (currentSsid != null) 'currentSsid': currentSsid,
      if (currentBssid != null) 'currentBssid': currentBssid,
      if (wifiRssi != null) 'wifiRssi': wifiRssi,
      if (wifiLinkSpeed != null) 'wifiLinkSpeed': wifiLinkSpeed,
      if (wifiFrequency != null) 'wifiFrequency': wifiFrequency,
      if (ipv4 != null) 'ipv4': ipv4,
      if (ipv6 != null) 'ipv6': ipv6,
      if (gateway != null) 'gateway': gateway,
      if (subnetMask != null) 'subnetMask': subnetMask,
      if (networkLastSsid != null) 'networkLastSsid': networkLastSsid,
      if (isRooted != null) 'isRooted': isRooted,
      if (adbEnabled != null) 'adbEnabled': adbEnabled,
      if (developerOptionsEnabled != null)
        'developerOptionsEnabled': developerOptionsEnabled,
      if (unknownSourcesAllowed != null)
        'unknownSourcesAllowed': unknownSourcesAllowed,
      if (encryptionStatus != null) 'encryptionStatus': encryptionStatus,
      if (playProtectStatus != null) 'playProtectStatus': playProtectStatus,
      if (passwordIsSufficient != null)
        'passwordIsSufficient': passwordIsSufficient,
      if (passwordQuality != null) 'passwordQuality': passwordQuality,
      if (passwordComplexityLevel != null)
        'passwordComplexityLevel': passwordComplexityLevel,
      if (hasSecureLock != null) 'hasSecureLock': hasSecureLock,
      if (isLocked != null) 'isLocked': isLocked,
      if (isDeviceOwner != null) 'isDeviceOwner': isDeviceOwner,
      if (totalStorageBytes != null) 'totalStorageBytes': totalStorageBytes,
      if (freeStorageBytes != null) 'freeStorageBytes': freeStorageBytes,
      if (usedStorageBytes != null) 'usedStorageBytes': usedStorageBytes,
      if (storageUsagePct != null) 'storageUsagePct': storageUsagePct,
      if (storageFreePct != null) 'storageFreePct': storageFreePct,
      if (totalInstalledApps != null) 'totalInstalledApps': totalInstalledApps,
      if (systemAppsCount != null) 'systemAppsCount': systemAppsCount,
      if (userAppsCount != null) 'userAppsCount': userAppsCount,
      if (managedAppsCount != null) 'managedAppsCount': managedAppsCount,
      if (installedCaCertCount != null)
        'installedCaCertCount': installedCaCertCount,
      if (hasWonkruMdmCa != null) 'hasWonkruMdmCa': hasWonkruMdmCa,
      if (hasWonkruLocalCa != null) 'hasWonkruLocalCa': hasWonkruLocalCa,
      if (brightness != null) 'brightness': brightness,
      if (screenTimeoutMs != null) 'screenTimeoutMs': screenTimeoutMs,
      if (screenWidthPx != null) 'screenWidthPx': screenWidthPx,
      if (screenHeightPx != null) 'screenHeightPx': screenHeightPx,
      if (launcherModeEnabled != null)
        'launcherModeEnabled': launcherModeEnabled,
      if (watchdogServiceEnabled != null)
        'watchdogServiceEnabled': watchdogServiceEnabled,
      if (flutterAliveAt != null) 'flutterAliveAt': flutterAliveAt?.toJson(),
      if (bsDeviceUuid != null) 'bsDeviceUuid': bsDeviceUuid,
      if (bsDeviceCode != null) 'bsDeviceCode': bsDeviceCode,
      if (serverUrl != null) 'serverUrl': serverUrl,
      if (stDeviceUuid != null) 'stDeviceUuid': stDeviceUuid,
      if (stDeviceCode != null) 'stDeviceCode': stDeviceCode,
      if (lastPolicyUpdateAt != null)
        'lastPolicyUpdateAt': lastPolicyUpdateAt?.toJson(),
      if (lastConfigFetchTime != null)
        'lastConfigFetchTime': lastConfigFetchTime,
      if (stLastSyncAt != null) 'stLastSyncAt': stLastSyncAt?.toJson(),
      if (restrictionCount != null) 'restrictionCount': restrictionCount,
    };
  }

  static DeviceStateCacheInclude include({
    _ilo09f9g.DeviceInclude? device,
    _ijb003y9.DeviceSyncInclude? deviceSync,
  }) {
    return DeviceStateCacheInclude._(
      device: device,
      deviceSync: deviceSync,
    );
  }

  static DeviceStateCacheIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    DeviceStateCacheInclude? include,
  }) {
    return DeviceStateCacheIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceStateCache$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceStateCache$device();
}

class _UndefinedDeviceStateCache$deviceSync extends _is.UndefinedSentinel
    implements _ijb003y9.DeviceSync {
  const _UndefinedDeviceStateCache$deviceSync();
}

class _DeviceStateCacheImpl extends DeviceStateCache {
  _DeviceStateCacheImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceSyncId,
    _ijb003y9.DeviceSync? deviceSync,
    required DateTime collectedAt,
    DateTime? updatedAt,
    String? manufacturer,
    String? model,
    String? brand,
    String? androidVersion,
    int? sdkInt,
    String? securityPatch,
    String? buildFingerprint,
    bool? isPhysicalDevice,
    bool? isLowRamDevice,
    int? batteryLevel,
    String? batteryState,
    bool? isPowerSaveMode,
    bool? isOnline,
    String? currentSsid,
    String? currentBssid,
    int? wifiRssi,
    int? wifiLinkSpeed,
    int? wifiFrequency,
    String? ipv4,
    String? ipv6,
    String? gateway,
    String? subnetMask,
    String? networkLastSsid,
    bool? isRooted,
    bool? adbEnabled,
    bool? developerOptionsEnabled,
    bool? unknownSourcesAllowed,
    String? encryptionStatus,
    bool? playProtectStatus,
    bool? passwordIsSufficient,
    int? passwordQuality,
    int? passwordComplexityLevel,
    bool? hasSecureLock,
    bool? isLocked,
    bool? isDeviceOwner,
    int? totalStorageBytes,
    int? freeStorageBytes,
    int? usedStorageBytes,
    double? storageUsagePct,
    double? storageFreePct,
    int? totalInstalledApps,
    int? systemAppsCount,
    int? userAppsCount,
    int? managedAppsCount,
    int? installedCaCertCount,
    bool? hasWonkruMdmCa,
    bool? hasWonkruLocalCa,
    int? brightness,
    int? screenTimeoutMs,
    int? screenWidthPx,
    int? screenHeightPx,
    bool? launcherModeEnabled,
    bool? watchdogServiceEnabled,
    DateTime? flutterAliveAt,
    String? bsDeviceUuid,
    String? bsDeviceCode,
    String? serverUrl,
    String? stDeviceUuid,
    String? stDeviceCode,
    DateTime? lastPolicyUpdateAt,
    String? lastConfigFetchTime,
    DateTime? stLastSyncAt,
    int? restrictionCount,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         deviceSyncId: deviceSyncId,
         deviceSync: deviceSync,
         collectedAt: collectedAt,
         updatedAt: updatedAt,
         manufacturer: manufacturer,
         model: model,
         brand: brand,
         androidVersion: androidVersion,
         sdkInt: sdkInt,
         securityPatch: securityPatch,
         buildFingerprint: buildFingerprint,
         isPhysicalDevice: isPhysicalDevice,
         isLowRamDevice: isLowRamDevice,
         batteryLevel: batteryLevel,
         batteryState: batteryState,
         isPowerSaveMode: isPowerSaveMode,
         isOnline: isOnline,
         currentSsid: currentSsid,
         currentBssid: currentBssid,
         wifiRssi: wifiRssi,
         wifiLinkSpeed: wifiLinkSpeed,
         wifiFrequency: wifiFrequency,
         ipv4: ipv4,
         ipv6: ipv6,
         gateway: gateway,
         subnetMask: subnetMask,
         networkLastSsid: networkLastSsid,
         isRooted: isRooted,
         adbEnabled: adbEnabled,
         developerOptionsEnabled: developerOptionsEnabled,
         unknownSourcesAllowed: unknownSourcesAllowed,
         encryptionStatus: encryptionStatus,
         playProtectStatus: playProtectStatus,
         passwordIsSufficient: passwordIsSufficient,
         passwordQuality: passwordQuality,
         passwordComplexityLevel: passwordComplexityLevel,
         hasSecureLock: hasSecureLock,
         isLocked: isLocked,
         isDeviceOwner: isDeviceOwner,
         totalStorageBytes: totalStorageBytes,
         freeStorageBytes: freeStorageBytes,
         usedStorageBytes: usedStorageBytes,
         storageUsagePct: storageUsagePct,
         storageFreePct: storageFreePct,
         totalInstalledApps: totalInstalledApps,
         systemAppsCount: systemAppsCount,
         userAppsCount: userAppsCount,
         managedAppsCount: managedAppsCount,
         installedCaCertCount: installedCaCertCount,
         hasWonkruMdmCa: hasWonkruMdmCa,
         hasWonkruLocalCa: hasWonkruLocalCa,
         brightness: brightness,
         screenTimeoutMs: screenTimeoutMs,
         screenWidthPx: screenWidthPx,
         screenHeightPx: screenHeightPx,
         launcherModeEnabled: launcherModeEnabled,
         watchdogServiceEnabled: watchdogServiceEnabled,
         flutterAliveAt: flutterAliveAt,
         bsDeviceUuid: bsDeviceUuid,
         bsDeviceCode: bsDeviceCode,
         serverUrl: serverUrl,
         stDeviceUuid: stDeviceUuid,
         stDeviceCode: stDeviceCode,
         lastPolicyUpdateAt: lastPolicyUpdateAt,
         lastConfigFetchTime: lastConfigFetchTime,
         stLastSyncAt: stLastSyncAt,
         restrictionCount: restrictionCount,
       );

  /// Returns a shallow copy of this [DeviceStateCache]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceStateCache copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceStateCache$device(),
    int? deviceSyncId,
    _ijb003y9.DeviceSync? deviceSync =
        const _UndefinedDeviceStateCache$deviceSync(),
    DateTime? collectedAt,
    DateTime? updatedAt,
    Object? manufacturer = _Undefined,
    Object? model = _Undefined,
    Object? brand = _Undefined,
    Object? androidVersion = _Undefined,
    Object? sdkInt = _Undefined,
    Object? securityPatch = _Undefined,
    Object? buildFingerprint = _Undefined,
    Object? isPhysicalDevice = _Undefined,
    Object? isLowRamDevice = _Undefined,
    Object? batteryLevel = _Undefined,
    Object? batteryState = _Undefined,
    Object? isPowerSaveMode = _Undefined,
    Object? isOnline = _Undefined,
    Object? currentSsid = _Undefined,
    Object? currentBssid = _Undefined,
    Object? wifiRssi = _Undefined,
    Object? wifiLinkSpeed = _Undefined,
    Object? wifiFrequency = _Undefined,
    Object? ipv4 = _Undefined,
    Object? ipv6 = _Undefined,
    Object? gateway = _Undefined,
    Object? subnetMask = _Undefined,
    Object? networkLastSsid = _Undefined,
    Object? isRooted = _Undefined,
    Object? adbEnabled = _Undefined,
    Object? developerOptionsEnabled = _Undefined,
    Object? unknownSourcesAllowed = _Undefined,
    Object? encryptionStatus = _Undefined,
    Object? playProtectStatus = _Undefined,
    Object? passwordIsSufficient = _Undefined,
    Object? passwordQuality = _Undefined,
    Object? passwordComplexityLevel = _Undefined,
    Object? hasSecureLock = _Undefined,
    Object? isLocked = _Undefined,
    Object? isDeviceOwner = _Undefined,
    Object? totalStorageBytes = _Undefined,
    Object? freeStorageBytes = _Undefined,
    Object? usedStorageBytes = _Undefined,
    Object? storageUsagePct = _Undefined,
    Object? storageFreePct = _Undefined,
    Object? totalInstalledApps = _Undefined,
    Object? systemAppsCount = _Undefined,
    Object? userAppsCount = _Undefined,
    Object? managedAppsCount = _Undefined,
    Object? installedCaCertCount = _Undefined,
    Object? hasWonkruMdmCa = _Undefined,
    Object? hasWonkruLocalCa = _Undefined,
    Object? brightness = _Undefined,
    Object? screenTimeoutMs = _Undefined,
    Object? screenWidthPx = _Undefined,
    Object? screenHeightPx = _Undefined,
    Object? launcherModeEnabled = _Undefined,
    Object? watchdogServiceEnabled = _Undefined,
    DateTime? flutterAliveAt = const _is.$UndefinedDateTime(),
    Object? bsDeviceUuid = _Undefined,
    Object? bsDeviceCode = _Undefined,
    Object? serverUrl = _Undefined,
    Object? stDeviceUuid = _Undefined,
    Object? stDeviceCode = _Undefined,
    DateTime? lastPolicyUpdateAt = const _is.$UndefinedDateTime(),
    Object? lastConfigFetchTime = _Undefined,
    DateTime? stLastSyncAt = const _is.$UndefinedDateTime(),
    Object? restrictionCount = _Undefined,
  }) {
    return DeviceStateCache(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      deviceSyncId: deviceSyncId ?? this.deviceSyncId,
      deviceSync: deviceSync is _is.UndefinedSentinel
          ? this.deviceSync?.copyWith()
          : deviceSync,
      collectedAt: collectedAt ?? this.collectedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      manufacturer: manufacturer is String? ? manufacturer : this.manufacturer,
      model: model is String? ? model : this.model,
      brand: brand is String? ? brand : this.brand,
      androidVersion: androidVersion is String?
          ? androidVersion
          : this.androidVersion,
      sdkInt: sdkInt is int? ? sdkInt : this.sdkInt,
      securityPatch: securityPatch is String?
          ? securityPatch
          : this.securityPatch,
      buildFingerprint: buildFingerprint is String?
          ? buildFingerprint
          : this.buildFingerprint,
      isPhysicalDevice: isPhysicalDevice is bool?
          ? isPhysicalDevice
          : this.isPhysicalDevice,
      isLowRamDevice: isLowRamDevice is bool?
          ? isLowRamDevice
          : this.isLowRamDevice,
      batteryLevel: batteryLevel is int? ? batteryLevel : this.batteryLevel,
      batteryState: batteryState is String? ? batteryState : this.batteryState,
      isPowerSaveMode: isPowerSaveMode is bool?
          ? isPowerSaveMode
          : this.isPowerSaveMode,
      isOnline: isOnline is bool? ? isOnline : this.isOnline,
      currentSsid: currentSsid is String? ? currentSsid : this.currentSsid,
      currentBssid: currentBssid is String? ? currentBssid : this.currentBssid,
      wifiRssi: wifiRssi is int? ? wifiRssi : this.wifiRssi,
      wifiLinkSpeed: wifiLinkSpeed is int? ? wifiLinkSpeed : this.wifiLinkSpeed,
      wifiFrequency: wifiFrequency is int? ? wifiFrequency : this.wifiFrequency,
      ipv4: ipv4 is String? ? ipv4 : this.ipv4,
      ipv6: ipv6 is String? ? ipv6 : this.ipv6,
      gateway: gateway is String? ? gateway : this.gateway,
      subnetMask: subnetMask is String? ? subnetMask : this.subnetMask,
      networkLastSsid: networkLastSsid is String?
          ? networkLastSsid
          : this.networkLastSsid,
      isRooted: isRooted is bool? ? isRooted : this.isRooted,
      adbEnabled: adbEnabled is bool? ? adbEnabled : this.adbEnabled,
      developerOptionsEnabled: developerOptionsEnabled is bool?
          ? developerOptionsEnabled
          : this.developerOptionsEnabled,
      unknownSourcesAllowed: unknownSourcesAllowed is bool?
          ? unknownSourcesAllowed
          : this.unknownSourcesAllowed,
      encryptionStatus: encryptionStatus is String?
          ? encryptionStatus
          : this.encryptionStatus,
      playProtectStatus: playProtectStatus is bool?
          ? playProtectStatus
          : this.playProtectStatus,
      passwordIsSufficient: passwordIsSufficient is bool?
          ? passwordIsSufficient
          : this.passwordIsSufficient,
      passwordQuality: passwordQuality is int?
          ? passwordQuality
          : this.passwordQuality,
      passwordComplexityLevel: passwordComplexityLevel is int?
          ? passwordComplexityLevel
          : this.passwordComplexityLevel,
      hasSecureLock: hasSecureLock is bool?
          ? hasSecureLock
          : this.hasSecureLock,
      isLocked: isLocked is bool? ? isLocked : this.isLocked,
      isDeviceOwner: isDeviceOwner is bool?
          ? isDeviceOwner
          : this.isDeviceOwner,
      totalStorageBytes: totalStorageBytes is int?
          ? totalStorageBytes
          : this.totalStorageBytes,
      freeStorageBytes: freeStorageBytes is int?
          ? freeStorageBytes
          : this.freeStorageBytes,
      usedStorageBytes: usedStorageBytes is int?
          ? usedStorageBytes
          : this.usedStorageBytes,
      storageUsagePct: storageUsagePct is double?
          ? storageUsagePct
          : this.storageUsagePct,
      storageFreePct: storageFreePct is double?
          ? storageFreePct
          : this.storageFreePct,
      totalInstalledApps: totalInstalledApps is int?
          ? totalInstalledApps
          : this.totalInstalledApps,
      systemAppsCount: systemAppsCount is int?
          ? systemAppsCount
          : this.systemAppsCount,
      userAppsCount: userAppsCount is int? ? userAppsCount : this.userAppsCount,
      managedAppsCount: managedAppsCount is int?
          ? managedAppsCount
          : this.managedAppsCount,
      installedCaCertCount: installedCaCertCount is int?
          ? installedCaCertCount
          : this.installedCaCertCount,
      hasWonkruMdmCa: hasWonkruMdmCa is bool?
          ? hasWonkruMdmCa
          : this.hasWonkruMdmCa,
      hasWonkruLocalCa: hasWonkruLocalCa is bool?
          ? hasWonkruLocalCa
          : this.hasWonkruLocalCa,
      brightness: brightness is int? ? brightness : this.brightness,
      screenTimeoutMs: screenTimeoutMs is int?
          ? screenTimeoutMs
          : this.screenTimeoutMs,
      screenWidthPx: screenWidthPx is int? ? screenWidthPx : this.screenWidthPx,
      screenHeightPx: screenHeightPx is int?
          ? screenHeightPx
          : this.screenHeightPx,
      launcherModeEnabled: launcherModeEnabled is bool?
          ? launcherModeEnabled
          : this.launcherModeEnabled,
      watchdogServiceEnabled: watchdogServiceEnabled is bool?
          ? watchdogServiceEnabled
          : this.watchdogServiceEnabled,
      flutterAliveAt: flutterAliveAt is _is.UndefinedSentinel
          ? this.flutterAliveAt
          : flutterAliveAt,
      bsDeviceUuid: bsDeviceUuid is String? ? bsDeviceUuid : this.bsDeviceUuid,
      bsDeviceCode: bsDeviceCode is String? ? bsDeviceCode : this.bsDeviceCode,
      serverUrl: serverUrl is String? ? serverUrl : this.serverUrl,
      stDeviceUuid: stDeviceUuid is String? ? stDeviceUuid : this.stDeviceUuid,
      stDeviceCode: stDeviceCode is String? ? stDeviceCode : this.stDeviceCode,
      lastPolicyUpdateAt: lastPolicyUpdateAt is _is.UndefinedSentinel
          ? this.lastPolicyUpdateAt
          : lastPolicyUpdateAt,
      lastConfigFetchTime: lastConfigFetchTime is String?
          ? lastConfigFetchTime
          : this.lastConfigFetchTime,
      stLastSyncAt: stLastSyncAt is _is.UndefinedSentinel
          ? this.stLastSyncAt
          : stLastSyncAt,
      restrictionCount: restrictionCount is int?
          ? restrictionCount
          : this.restrictionCount,
    );
  }
}

class DeviceStateCacheUpdateTable
    extends _is.UpdateTable<DeviceStateCacheTable> {
  DeviceStateCacheUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<int, int> deviceSyncId(int value) => _is.ColumnValue(
    table.deviceSyncId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> collectedAt(DateTime value) =>
      _is.ColumnValue(
        table.collectedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<String, String> manufacturer(String? value) =>
      _is.ColumnValue(
        table.manufacturer,
        value,
      );

  _is.ColumnValue<String, String> model(String? value) => _is.ColumnValue(
    table.model,
    value,
  );

  _is.ColumnValue<String, String> brand(String? value) => _is.ColumnValue(
    table.brand,
    value,
  );

  _is.ColumnValue<String, String> androidVersion(String? value) =>
      _is.ColumnValue(
        table.androidVersion,
        value,
      );

  _is.ColumnValue<int, int> sdkInt(int? value) => _is.ColumnValue(
    table.sdkInt,
    value,
  );

  _is.ColumnValue<String, String> securityPatch(String? value) =>
      _is.ColumnValue(
        table.securityPatch,
        value,
      );

  _is.ColumnValue<String, String> buildFingerprint(String? value) =>
      _is.ColumnValue(
        table.buildFingerprint,
        value,
      );

  _is.ColumnValue<bool, bool> isPhysicalDevice(bool? value) => _is.ColumnValue(
    table.isPhysicalDevice,
    value,
  );

  _is.ColumnValue<bool, bool> isLowRamDevice(bool? value) => _is.ColumnValue(
    table.isLowRamDevice,
    value,
  );

  _is.ColumnValue<int, int> batteryLevel(int? value) => _is.ColumnValue(
    table.batteryLevel,
    value,
  );

  _is.ColumnValue<String, String> batteryState(String? value) =>
      _is.ColumnValue(
        table.batteryState,
        value,
      );

  _is.ColumnValue<bool, bool> isPowerSaveMode(bool? value) => _is.ColumnValue(
    table.isPowerSaveMode,
    value,
  );

  _is.ColumnValue<bool, bool> isOnline(bool? value) => _is.ColumnValue(
    table.isOnline,
    value,
  );

  _is.ColumnValue<String, String> currentSsid(String? value) => _is.ColumnValue(
    table.currentSsid,
    value,
  );

  _is.ColumnValue<String, String> currentBssid(String? value) =>
      _is.ColumnValue(
        table.currentBssid,
        value,
      );

  _is.ColumnValue<int, int> wifiRssi(int? value) => _is.ColumnValue(
    table.wifiRssi,
    value,
  );

  _is.ColumnValue<int, int> wifiLinkSpeed(int? value) => _is.ColumnValue(
    table.wifiLinkSpeed,
    value,
  );

  _is.ColumnValue<int, int> wifiFrequency(int? value) => _is.ColumnValue(
    table.wifiFrequency,
    value,
  );

  _is.ColumnValue<String, String> ipv4(String? value) => _is.ColumnValue(
    table.ipv4,
    value,
  );

  _is.ColumnValue<String, String> ipv6(String? value) => _is.ColumnValue(
    table.ipv6,
    value,
  );

  _is.ColumnValue<String, String> gateway(String? value) => _is.ColumnValue(
    table.gateway,
    value,
  );

  _is.ColumnValue<String, String> subnetMask(String? value) => _is.ColumnValue(
    table.subnetMask,
    value,
  );

  _is.ColumnValue<String, String> networkLastSsid(String? value) =>
      _is.ColumnValue(
        table.networkLastSsid,
        value,
      );

  _is.ColumnValue<bool, bool> isRooted(bool? value) => _is.ColumnValue(
    table.isRooted,
    value,
  );

  _is.ColumnValue<bool, bool> adbEnabled(bool? value) => _is.ColumnValue(
    table.adbEnabled,
    value,
  );

  _is.ColumnValue<bool, bool> developerOptionsEnabled(bool? value) =>
      _is.ColumnValue(
        table.developerOptionsEnabled,
        value,
      );

  _is.ColumnValue<bool, bool> unknownSourcesAllowed(bool? value) =>
      _is.ColumnValue(
        table.unknownSourcesAllowed,
        value,
      );

  _is.ColumnValue<String, String> encryptionStatus(String? value) =>
      _is.ColumnValue(
        table.encryptionStatus,
        value,
      );

  _is.ColumnValue<bool, bool> playProtectStatus(bool? value) => _is.ColumnValue(
    table.playProtectStatus,
    value,
  );

  _is.ColumnValue<bool, bool> passwordIsSufficient(bool? value) =>
      _is.ColumnValue(
        table.passwordIsSufficient,
        value,
      );

  _is.ColumnValue<int, int> passwordQuality(int? value) => _is.ColumnValue(
    table.passwordQuality,
    value,
  );

  _is.ColumnValue<int, int> passwordComplexityLevel(int? value) =>
      _is.ColumnValue(
        table.passwordComplexityLevel,
        value,
      );

  _is.ColumnValue<bool, bool> hasSecureLock(bool? value) => _is.ColumnValue(
    table.hasSecureLock,
    value,
  );

  _is.ColumnValue<bool, bool> isLocked(bool? value) => _is.ColumnValue(
    table.isLocked,
    value,
  );

  _is.ColumnValue<bool, bool> isDeviceOwner(bool? value) => _is.ColumnValue(
    table.isDeviceOwner,
    value,
  );

  _is.ColumnValue<int, int> totalStorageBytes(int? value) => _is.ColumnValue(
    table.totalStorageBytes,
    value,
  );

  _is.ColumnValue<int, int> freeStorageBytes(int? value) => _is.ColumnValue(
    table.freeStorageBytes,
    value,
  );

  _is.ColumnValue<int, int> usedStorageBytes(int? value) => _is.ColumnValue(
    table.usedStorageBytes,
    value,
  );

  _is.ColumnValue<double, double> storageUsagePct(double? value) =>
      _is.ColumnValue(
        table.storageUsagePct,
        value,
      );

  _is.ColumnValue<double, double> storageFreePct(double? value) =>
      _is.ColumnValue(
        table.storageFreePct,
        value,
      );

  _is.ColumnValue<int, int> totalInstalledApps(int? value) => _is.ColumnValue(
    table.totalInstalledApps,
    value,
  );

  _is.ColumnValue<int, int> systemAppsCount(int? value) => _is.ColumnValue(
    table.systemAppsCount,
    value,
  );

  _is.ColumnValue<int, int> userAppsCount(int? value) => _is.ColumnValue(
    table.userAppsCount,
    value,
  );

  _is.ColumnValue<int, int> managedAppsCount(int? value) => _is.ColumnValue(
    table.managedAppsCount,
    value,
  );

  _is.ColumnValue<int, int> installedCaCertCount(int? value) => _is.ColumnValue(
    table.installedCaCertCount,
    value,
  );

  _is.ColumnValue<bool, bool> hasWonkruMdmCa(bool? value) => _is.ColumnValue(
    table.hasWonkruMdmCa,
    value,
  );

  _is.ColumnValue<bool, bool> hasWonkruLocalCa(bool? value) => _is.ColumnValue(
    table.hasWonkruLocalCa,
    value,
  );

  _is.ColumnValue<int, int> brightness(int? value) => _is.ColumnValue(
    table.brightness,
    value,
  );

  _is.ColumnValue<int, int> screenTimeoutMs(int? value) => _is.ColumnValue(
    table.screenTimeoutMs,
    value,
  );

  _is.ColumnValue<int, int> screenWidthPx(int? value) => _is.ColumnValue(
    table.screenWidthPx,
    value,
  );

  _is.ColumnValue<int, int> screenHeightPx(int? value) => _is.ColumnValue(
    table.screenHeightPx,
    value,
  );

  _is.ColumnValue<bool, bool> launcherModeEnabled(bool? value) =>
      _is.ColumnValue(
        table.launcherModeEnabled,
        value,
      );

  _is.ColumnValue<bool, bool> watchdogServiceEnabled(bool? value) =>
      _is.ColumnValue(
        table.watchdogServiceEnabled,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> flutterAliveAt(DateTime? value) =>
      _is.ColumnValue(
        table.flutterAliveAt,
        value,
      );

  _is.ColumnValue<String, String> bsDeviceUuid(String? value) =>
      _is.ColumnValue(
        table.bsDeviceUuid,
        value,
      );

  _is.ColumnValue<String, String> bsDeviceCode(String? value) =>
      _is.ColumnValue(
        table.bsDeviceCode,
        value,
      );

  _is.ColumnValue<String, String> serverUrl(String? value) => _is.ColumnValue(
    table.serverUrl,
    value,
  );

  _is.ColumnValue<String, String> stDeviceUuid(String? value) =>
      _is.ColumnValue(
        table.stDeviceUuid,
        value,
      );

  _is.ColumnValue<String, String> stDeviceCode(String? value) =>
      _is.ColumnValue(
        table.stDeviceCode,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastPolicyUpdateAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastPolicyUpdateAt,
        value,
      );

  _is.ColumnValue<String, String> lastConfigFetchTime(String? value) =>
      _is.ColumnValue(
        table.lastConfigFetchTime,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> stLastSyncAt(DateTime? value) =>
      _is.ColumnValue(
        table.stLastSyncAt,
        value,
      );

  _is.ColumnValue<int, int> restrictionCount(int? value) => _is.ColumnValue(
    table.restrictionCount,
    value,
  );
}

class DeviceStateCacheTable extends _is.Table<int?> {
  DeviceStateCacheTable({super.tableRelation})
    : super(tableName: 'device_state_cache') {
    updateTable = DeviceStateCacheUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    deviceSyncId = _is.ColumnInt(
      'deviceSyncId',
      this,
    );
    collectedAt = _is.ColumnDateTime(
      'collectedAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
    manufacturer = _is.ColumnString(
      'manufacturer',
      this,
    );
    model = _is.ColumnString(
      'model',
      this,
    );
    brand = _is.ColumnString(
      'brand',
      this,
    );
    androidVersion = _is.ColumnString(
      'androidVersion',
      this,
    );
    sdkInt = _is.ColumnInt(
      'sdkInt',
      this,
    );
    securityPatch = _is.ColumnString(
      'securityPatch',
      this,
    );
    buildFingerprint = _is.ColumnString(
      'buildFingerprint',
      this,
    );
    isPhysicalDevice = _is.ColumnBool(
      'isPhysicalDevice',
      this,
    );
    isLowRamDevice = _is.ColumnBool(
      'isLowRamDevice',
      this,
    );
    batteryLevel = _is.ColumnInt(
      'batteryLevel',
      this,
    );
    batteryState = _is.ColumnString(
      'batteryState',
      this,
    );
    isPowerSaveMode = _is.ColumnBool(
      'isPowerSaveMode',
      this,
    );
    isOnline = _is.ColumnBool(
      'isOnline',
      this,
    );
    currentSsid = _is.ColumnString(
      'currentSsid',
      this,
    );
    currentBssid = _is.ColumnString(
      'currentBssid',
      this,
    );
    wifiRssi = _is.ColumnInt(
      'wifiRssi',
      this,
    );
    wifiLinkSpeed = _is.ColumnInt(
      'wifiLinkSpeed',
      this,
    );
    wifiFrequency = _is.ColumnInt(
      'wifiFrequency',
      this,
    );
    ipv4 = _is.ColumnString(
      'ipv4',
      this,
    );
    ipv6 = _is.ColumnString(
      'ipv6',
      this,
    );
    gateway = _is.ColumnString(
      'gateway',
      this,
    );
    subnetMask = _is.ColumnString(
      'subnetMask',
      this,
    );
    networkLastSsid = _is.ColumnString(
      'networkLastSsid',
      this,
    );
    isRooted = _is.ColumnBool(
      'isRooted',
      this,
    );
    adbEnabled = _is.ColumnBool(
      'adbEnabled',
      this,
    );
    developerOptionsEnabled = _is.ColumnBool(
      'developerOptionsEnabled',
      this,
    );
    unknownSourcesAllowed = _is.ColumnBool(
      'unknownSourcesAllowed',
      this,
    );
    encryptionStatus = _is.ColumnString(
      'encryptionStatus',
      this,
    );
    playProtectStatus = _is.ColumnBool(
      'playProtectStatus',
      this,
    );
    passwordIsSufficient = _is.ColumnBool(
      'passwordIsSufficient',
      this,
    );
    passwordQuality = _is.ColumnInt(
      'passwordQuality',
      this,
    );
    passwordComplexityLevel = _is.ColumnInt(
      'passwordComplexityLevel',
      this,
    );
    hasSecureLock = _is.ColumnBool(
      'hasSecureLock',
      this,
    );
    isLocked = _is.ColumnBool(
      'isLocked',
      this,
    );
    isDeviceOwner = _is.ColumnBool(
      'isDeviceOwner',
      this,
    );
    totalStorageBytes = _is.ColumnInt(
      'totalStorageBytes',
      this,
    );
    freeStorageBytes = _is.ColumnInt(
      'freeStorageBytes',
      this,
    );
    usedStorageBytes = _is.ColumnInt(
      'usedStorageBytes',
      this,
    );
    storageUsagePct = _is.ColumnDouble(
      'storageUsagePct',
      this,
    );
    storageFreePct = _is.ColumnDouble(
      'storageFreePct',
      this,
    );
    totalInstalledApps = _is.ColumnInt(
      'totalInstalledApps',
      this,
    );
    systemAppsCount = _is.ColumnInt(
      'systemAppsCount',
      this,
    );
    userAppsCount = _is.ColumnInt(
      'userAppsCount',
      this,
    );
    managedAppsCount = _is.ColumnInt(
      'managedAppsCount',
      this,
    );
    installedCaCertCount = _is.ColumnInt(
      'installedCaCertCount',
      this,
    );
    hasWonkruMdmCa = _is.ColumnBool(
      'hasWonkruMdmCa',
      this,
    );
    hasWonkruLocalCa = _is.ColumnBool(
      'hasWonkruLocalCa',
      this,
    );
    brightness = _is.ColumnInt(
      'brightness',
      this,
    );
    screenTimeoutMs = _is.ColumnInt(
      'screenTimeoutMs',
      this,
    );
    screenWidthPx = _is.ColumnInt(
      'screenWidthPx',
      this,
    );
    screenHeightPx = _is.ColumnInt(
      'screenHeightPx',
      this,
    );
    launcherModeEnabled = _is.ColumnBool(
      'launcherModeEnabled',
      this,
    );
    watchdogServiceEnabled = _is.ColumnBool(
      'watchdogServiceEnabled',
      this,
    );
    flutterAliveAt = _is.ColumnDateTime(
      'flutterAliveAt',
      this,
    );
    bsDeviceUuid = _is.ColumnString(
      'bsDeviceUuid',
      this,
    );
    bsDeviceCode = _is.ColumnString(
      'bsDeviceCode',
      this,
    );
    serverUrl = _is.ColumnString(
      'serverUrl',
      this,
    );
    stDeviceUuid = _is.ColumnString(
      'stDeviceUuid',
      this,
    );
    stDeviceCode = _is.ColumnString(
      'stDeviceCode',
      this,
    );
    lastPolicyUpdateAt = _is.ColumnDateTime(
      'lastPolicyUpdateAt',
      this,
    );
    lastConfigFetchTime = _is.ColumnString(
      'lastConfigFetchTime',
      this,
    );
    stLastSyncAt = _is.ColumnDateTime(
      'stLastSyncAt',
      this,
    );
    restrictionCount = _is.ColumnInt(
      'restrictionCount',
      this,
    );
  }

  late final DeviceStateCacheUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnInt deviceSyncId;

  _ijb003y9.DeviceSyncTable? _deviceSync;

  late final _is.ColumnDateTime collectedAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnString manufacturer;

  late final _is.ColumnString model;

  late final _is.ColumnString brand;

  late final _is.ColumnString androidVersion;

  late final _is.ColumnInt sdkInt;

  late final _is.ColumnString securityPatch;

  late final _is.ColumnString buildFingerprint;

  late final _is.ColumnBool isPhysicalDevice;

  late final _is.ColumnBool isLowRamDevice;

  late final _is.ColumnInt batteryLevel;

  late final _is.ColumnString batteryState;

  late final _is.ColumnBool isPowerSaveMode;

  late final _is.ColumnBool isOnline;

  late final _is.ColumnString currentSsid;

  late final _is.ColumnString currentBssid;

  late final _is.ColumnInt wifiRssi;

  late final _is.ColumnInt wifiLinkSpeed;

  late final _is.ColumnInt wifiFrequency;

  late final _is.ColumnString ipv4;

  late final _is.ColumnString ipv6;

  late final _is.ColumnString gateway;

  late final _is.ColumnString subnetMask;

  late final _is.ColumnString networkLastSsid;

  late final _is.ColumnBool isRooted;

  late final _is.ColumnBool adbEnabled;

  late final _is.ColumnBool developerOptionsEnabled;

  late final _is.ColumnBool unknownSourcesAllowed;

  late final _is.ColumnString encryptionStatus;

  late final _is.ColumnBool playProtectStatus;

  late final _is.ColumnBool passwordIsSufficient;

  late final _is.ColumnInt passwordQuality;

  late final _is.ColumnInt passwordComplexityLevel;

  late final _is.ColumnBool hasSecureLock;

  late final _is.ColumnBool isLocked;

  late final _is.ColumnBool isDeviceOwner;

  late final _is.ColumnInt totalStorageBytes;

  late final _is.ColumnInt freeStorageBytes;

  late final _is.ColumnInt usedStorageBytes;

  late final _is.ColumnDouble storageUsagePct;

  late final _is.ColumnDouble storageFreePct;

  late final _is.ColumnInt totalInstalledApps;

  late final _is.ColumnInt systemAppsCount;

  late final _is.ColumnInt userAppsCount;

  late final _is.ColumnInt managedAppsCount;

  late final _is.ColumnInt installedCaCertCount;

  late final _is.ColumnBool hasWonkruMdmCa;

  late final _is.ColumnBool hasWonkruLocalCa;

  late final _is.ColumnInt brightness;

  late final _is.ColumnInt screenTimeoutMs;

  late final _is.ColumnInt screenWidthPx;

  late final _is.ColumnInt screenHeightPx;

  late final _is.ColumnBool launcherModeEnabled;

  late final _is.ColumnBool watchdogServiceEnabled;

  late final _is.ColumnDateTime flutterAliveAt;

  late final _is.ColumnString bsDeviceUuid;

  late final _is.ColumnString bsDeviceCode;

  late final _is.ColumnString serverUrl;

  late final _is.ColumnString stDeviceUuid;

  late final _is.ColumnString stDeviceCode;

  late final _is.ColumnDateTime lastPolicyUpdateAt;

  late final _is.ColumnString lastConfigFetchTime;

  late final _is.ColumnDateTime stLastSyncAt;

  late final _is.ColumnInt restrictionCount;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceStateCache.t.deviceId,
      foreignField: _ilo09f9g.Device.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ilo09f9g.DeviceTable(tableRelation: foreignTableRelation),
    );
    return _device!;
  }

  _ijb003y9.DeviceSyncTable get deviceSync {
    if (_deviceSync != null) return _deviceSync!;
    _deviceSync = _is.createRelationTable(
      relationFieldName: 'deviceSync',
      field: DeviceStateCache.t.deviceSyncId,
      foreignField: _ijb003y9.DeviceSync.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijb003y9.DeviceSyncTable(tableRelation: foreignTableRelation),
    );
    return _deviceSync!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    deviceId,
    deviceSyncId,
    collectedAt,
    updatedAt,
    manufacturer,
    model,
    brand,
    androidVersion,
    sdkInt,
    securityPatch,
    buildFingerprint,
    isPhysicalDevice,
    isLowRamDevice,
    batteryLevel,
    batteryState,
    isPowerSaveMode,
    isOnline,
    currentSsid,
    currentBssid,
    wifiRssi,
    wifiLinkSpeed,
    wifiFrequency,
    ipv4,
    ipv6,
    gateway,
    subnetMask,
    networkLastSsid,
    isRooted,
    adbEnabled,
    developerOptionsEnabled,
    unknownSourcesAllowed,
    encryptionStatus,
    playProtectStatus,
    passwordIsSufficient,
    passwordQuality,
    passwordComplexityLevel,
    hasSecureLock,
    isLocked,
    isDeviceOwner,
    totalStorageBytes,
    freeStorageBytes,
    usedStorageBytes,
    storageUsagePct,
    storageFreePct,
    totalInstalledApps,
    systemAppsCount,
    userAppsCount,
    managedAppsCount,
    installedCaCertCount,
    hasWonkruMdmCa,
    hasWonkruLocalCa,
    brightness,
    screenTimeoutMs,
    screenWidthPx,
    screenHeightPx,
    launcherModeEnabled,
    watchdogServiceEnabled,
    flutterAliveAt,
    bsDeviceUuid,
    bsDeviceCode,
    serverUrl,
    stDeviceUuid,
    stDeviceCode,
    lastPolicyUpdateAt,
    lastConfigFetchTime,
    stLastSyncAt,
    restrictionCount,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    if (relationField == 'deviceSync') {
      return deviceSync;
    }
    return null;
  }
}

class DeviceStateCacheInclude extends _is.IncludeObject {
  DeviceStateCacheInclude._({
    _ilo09f9g.DeviceInclude? device,
    _ijb003y9.DeviceSyncInclude? deviceSync,
  }) {
    _device = device;
    _deviceSync = deviceSync;
  }

  _ilo09f9g.DeviceInclude? _device;

  _ijb003y9.DeviceSyncInclude? _deviceSync;

  @override
  Map<String, _is.Include?> get includes => {
    'device': _device,
    'deviceSync': _deviceSync,
  };

  @override
  _is.Table<int?> get table => DeviceStateCache.t;
}

class DeviceStateCacheIncludeList extends _is.IncludeList {
  DeviceStateCacheIncludeList._({
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceStateCache.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceStateCache.t;
}

class DeviceStateCacheRepository {
  const DeviceStateCacheRepository._();

  final attachRow = const DeviceStateCacheAttachRowRepository._();

  /// Returns a list of [DeviceStateCache]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DeviceStateCache>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    _is.Transaction? transaction,
    DeviceStateCacheInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceStateCache>(
      where: where?.call(DeviceStateCache.t),
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceStateCache]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `DeviceStateCache.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<DeviceStateCache>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    DeviceStateCacheInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceStateCache>(
      where: where?.call(DeviceStateCache.t),
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceStateCache] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DeviceStateCache?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    _is.Transaction? transaction,
    DeviceStateCacheInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceStateCache>(
      where: where?.call(DeviceStateCache.t),
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceStateCache] by its [id] or null if no such row exists.
  Future<DeviceStateCache?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceStateCacheInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceStateCache>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceStateCache]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceStateCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> insert(
    _is.DatabaseSession session,
    List<DeviceStateCache> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceStateCache>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceStateCache] and returns the inserted row.
  ///
  /// The returned [DeviceStateCache] will have its `id` field set.
  Future<DeviceStateCache> insertRow(
    _is.DatabaseSession session,
    DeviceStateCache row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceStateCache>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceStateCache]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [DeviceStateCache]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> upsert(
    _is.DatabaseSession session,
    List<DeviceStateCache> rows, {
    required _is.ColumnSelections<DeviceStateCacheTable> conflictColumns,
    _is.ColumnSelections<DeviceStateCacheTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceStateCache>(
      rows,
      conflictColumns: conflictColumns(DeviceStateCache.t),
      updateColumns: updateColumns?.call(DeviceStateCache.t),
      updateWhere: updateWhere?.call(DeviceStateCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceStateCache] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [DeviceStateCache] will have its `id` field set.
  Future<DeviceStateCache?> upsertRow(
    _is.DatabaseSession session,
    DeviceStateCache row, {
    required _is.ColumnSelections<DeviceStateCacheTable> conflictColumns,
    _is.ColumnSelections<DeviceStateCacheTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceStateCache>(
      row,
      conflictColumns: conflictColumns(DeviceStateCache.t),
      updateColumns: updateColumns?.call(DeviceStateCache.t),
      updateWhere: updateWhere?.call(DeviceStateCache.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceStateCache]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> update(
    _is.DatabaseSession session,
    List<DeviceStateCache> rows, {
    _is.ColumnSelections<DeviceStateCacheTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceStateCache>(
      rows,
      columns: columns?.call(DeviceStateCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceStateCache]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceStateCache> updateRow(
    _is.DatabaseSession session,
    DeviceStateCache row, {
    _is.ColumnSelections<DeviceStateCacheTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceStateCache>(
      row,
      columns: columns?.call(DeviceStateCache.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceStateCache] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceStateCache?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceStateCacheUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceStateCache>(
      id,
      columnValues: columnValues(DeviceStateCache.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceStateCache]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceStateCacheUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeviceStateCacheTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceStateCache>(
      columnValues: columnValues(DeviceStateCache.t.updateTable),
      where: where(DeviceStateCache.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceStateCache]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> delete(
    _is.DatabaseSession session,
    List<DeviceStateCache> rows, {
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceStateCache>(
      rows,
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceStateCache].
  Future<DeviceStateCache> deleteRow(
    _is.DatabaseSession session,
    DeviceStateCache row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceStateCache>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceStateCache>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceStateCacheTable> where,
    _is.OrderByBuilder<DeviceStateCacheTable>? orderBy,
    _is.OrderByListBuilder<DeviceStateCacheTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceStateCache>(
      where: where(DeviceStateCache.t),
      orderBy: orderBy?.call(DeviceStateCache.t),
      orderByList: orderByList?.call(DeviceStateCache.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceStateCacheTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceStateCache>(
      where: where?.call(DeviceStateCache.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceStateCache] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceStateCacheTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceStateCache>(
      where: where(DeviceStateCache.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceStateCacheAttachRowRepository {
  const DeviceStateCacheAttachRowRepository._();

  /// Creates a relation between the given [DeviceStateCache] and [Device]
  /// by setting the [DeviceStateCache]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceStateCache deviceStateCache,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceStateCache.id == null) {
      throw ArgumentError.notNull('deviceStateCache.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceStateCache = deviceStateCache.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceStateCache>(
      $deviceStateCache,
      columns: [DeviceStateCache.t.deviceId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [DeviceStateCache] and [DeviceSync]
  /// by setting the [DeviceStateCache]'s foreign key `deviceSyncId` to refer to the [DeviceSync].
  Future<void> deviceSync(
    _is.DatabaseSession session,
    DeviceStateCache deviceStateCache,
    _ijb003y9.DeviceSync deviceSync, {
    _is.Transaction? transaction,
  }) async {
    if (deviceStateCache.id == null) {
      throw ArgumentError.notNull('deviceStateCache.id');
    }
    if (deviceSync.id == null) {
      throw ArgumentError.notNull('deviceSync.id');
    }

    var $deviceStateCache = deviceStateCache.copyWith(
      deviceSyncId: deviceSync.id,
    );
    await session.db.updateRow<DeviceStateCache>(
      $deviceStateCache,
      columns: [DeviceStateCache.t.deviceSyncId],
      transaction: transaction,
    );
  }
}
