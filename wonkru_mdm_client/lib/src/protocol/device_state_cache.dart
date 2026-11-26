/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import 'device.dart' as _ilo09f9g;
import 'device_sync.dart' as _ijb003y9;

abstract class DeviceStateCache
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      deviceSyncId: jsonSerialization['deviceSyncId'] as int,
      deviceSync: jsonSerialization['deviceSync'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ijb003y9.DeviceSync>(
              jsonSerialization['deviceSync'],
            ),
      collectedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['collectedAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      manufacturer: jsonSerialization['manufacturer'] as String?,
      model: jsonSerialization['model'] as String?,
      brand: jsonSerialization['brand'] as String?,
      androidVersion: jsonSerialization['androidVersion'] as String?,
      sdkInt: jsonSerialization['sdkInt'] as int?,
      securityPatch: jsonSerialization['securityPatch'] as String?,
      buildFingerprint: jsonSerialization['buildFingerprint'] as String?,
      isPhysicalDevice: jsonSerialization['isPhysicalDevice'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isPhysicalDevice'],
            ),
      isLowRamDevice: jsonSerialization['isLowRamDevice'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isLowRamDevice'],
            ),
      batteryLevel: jsonSerialization['batteryLevel'] as int?,
      batteryState: jsonSerialization['batteryState'] as String?,
      isPowerSaveMode: jsonSerialization['isPowerSaveMode'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isPowerSaveMode'],
            ),
      isOnline: jsonSerialization['isOnline'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isOnline']),
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
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isRooted']),
      adbEnabled: jsonSerialization['adbEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['adbEnabled']),
      developerOptionsEnabled:
          jsonSerialization['developerOptionsEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['developerOptionsEnabled'],
            ),
      unknownSourcesAllowed: jsonSerialization['unknownSourcesAllowed'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['unknownSourcesAllowed'],
            ),
      encryptionStatus: jsonSerialization['encryptionStatus'] as String?,
      playProtectStatus: jsonSerialization['playProtectStatus'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['playProtectStatus'],
            ),
      passwordIsSufficient: jsonSerialization['passwordIsSufficient'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['passwordIsSufficient'],
            ),
      passwordQuality: jsonSerialization['passwordQuality'] as int?,
      passwordComplexityLevel:
          jsonSerialization['passwordComplexityLevel'] as int?,
      hasSecureLock: jsonSerialization['hasSecureLock'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hasSecureLock']),
      isLocked: jsonSerialization['isLocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isLocked']),
      isDeviceOwner: jsonSerialization['isDeviceOwner'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDeviceOwner']),
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
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['hasWonkruMdmCa'],
            ),
      hasWonkruLocalCa: jsonSerialization['hasWonkruLocalCa'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['hasWonkruLocalCa'],
            ),
      brightness: jsonSerialization['brightness'] as int?,
      screenTimeoutMs: jsonSerialization['screenTimeoutMs'] as int?,
      screenWidthPx: jsonSerialization['screenWidthPx'] as int?,
      screenHeightPx: jsonSerialization['screenHeightPx'] as int?,
      launcherModeEnabled: jsonSerialization['launcherModeEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['launcherModeEnabled'],
            ),
      watchdogServiceEnabled:
          jsonSerialization['watchdogServiceEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['watchdogServiceEnabled'],
            ),
      flutterAliveAt: jsonSerialization['flutterAliveAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['flutterAliveAt'],
            ),
      bsDeviceUuid: jsonSerialization['bsDeviceUuid'] as String?,
      bsDeviceCode: jsonSerialization['bsDeviceCode'] as String?,
      serverUrl: jsonSerialization['serverUrl'] as String?,
      stDeviceUuid: jsonSerialization['stDeviceUuid'] as String?,
      stDeviceCode: jsonSerialization['stDeviceCode'] as String?,
      lastPolicyUpdateAt: jsonSerialization['lastPolicyUpdateAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPolicyUpdateAt'],
            ),
      lastConfigFetchTime: jsonSerialization['lastConfigFetchTime'] as String?,
      stLastSyncAt: jsonSerialization['stLastSyncAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['stLastSyncAt'],
            ),
      restrictionCount: jsonSerialization['restrictionCount'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [DeviceStateCache]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    DateTime? flutterAliveAt = const _isc.$UndefinedDateTime(),
    String? bsDeviceUuid,
    String? bsDeviceCode,
    String? serverUrl,
    String? stDeviceUuid,
    String? stDeviceCode,
    DateTime? lastPolicyUpdateAt = const _isc.$UndefinedDateTime(),
    String? lastConfigFetchTime,
    DateTime? stLastSyncAt = const _isc.$UndefinedDateTime(),
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceStateCache$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceStateCache$device();
}

class _UndefinedDeviceStateCache$deviceSync extends _isc.UndefinedSentinel
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
  @_isc.useResult
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
    DateTime? flutterAliveAt = const _isc.$UndefinedDateTime(),
    Object? bsDeviceUuid = _Undefined,
    Object? bsDeviceCode = _Undefined,
    Object? serverUrl = _Undefined,
    Object? stDeviceUuid = _Undefined,
    Object? stDeviceCode = _Undefined,
    DateTime? lastPolicyUpdateAt = const _isc.$UndefinedDateTime(),
    Object? lastConfigFetchTime = _Undefined,
    DateTime? stLastSyncAt = const _isc.$UndefinedDateTime(),
    Object? restrictionCount = _Undefined,
  }) {
    return DeviceStateCache(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      deviceSyncId: deviceSyncId ?? this.deviceSyncId,
      deviceSync: deviceSync is _isc.UndefinedSentinel
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
      flutterAliveAt: flutterAliveAt is _isc.UndefinedSentinel
          ? this.flutterAliveAt
          : flutterAliveAt,
      bsDeviceUuid: bsDeviceUuid is String? ? bsDeviceUuid : this.bsDeviceUuid,
      bsDeviceCode: bsDeviceCode is String? ? bsDeviceCode : this.bsDeviceCode,
      serverUrl: serverUrl is String? ? serverUrl : this.serverUrl,
      stDeviceUuid: stDeviceUuid is String? ? stDeviceUuid : this.stDeviceUuid,
      stDeviceCode: stDeviceCode is String? ? stDeviceCode : this.stDeviceCode,
      lastPolicyUpdateAt: lastPolicyUpdateAt is _isc.UndefinedSentinel
          ? this.lastPolicyUpdateAt
          : lastPolicyUpdateAt,
      lastConfigFetchTime: lastConfigFetchTime is String?
          ? lastConfigFetchTime
          : this.lastConfigFetchTime,
      stLastSyncAt: stLastSyncAt is _isc.UndefinedSentinel
          ? this.stLastSyncAt
          : stLastSyncAt,
      restrictionCount: restrictionCount is int?
          ? restrictionCount
          : this.restrictionCount,
    );
  }
}
