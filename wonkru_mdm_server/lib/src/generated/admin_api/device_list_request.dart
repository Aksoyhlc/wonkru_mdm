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
import 'package:serverpod/serverpod.dart' as _is;

abstract class DeviceListRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.policyId,
    this.deviceGroupId,
    this.isOnline,
    this.isRooted,
    this.isLauncherMode,
    this.brand,
    this.manufacturer,
    this.androidVersion,
    this.criticalBattery,
    this.criticalStorage,
    this.notSeen24h,
    this.noPolicy,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory DeviceListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? policyId,
    int? deviceGroupId,
    bool? isOnline,
    bool? isRooted,
    bool? isLauncherMode,
    String? brand,
    String? manufacturer,
    String? androidVersion,
    bool? criticalBattery,
    bool? criticalStorage,
    bool? notSeen24h,
    bool? noPolicy,
  }) = _DeviceListRequestImpl;

  factory DeviceListRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      policyId: jsonSerialization['policyId'] as int?,
      deviceGroupId: jsonSerialization['deviceGroupId'] as int?,
      isOnline: jsonSerialization['isOnline'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isOnline']),
      isRooted: jsonSerialization['isRooted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isRooted']),
      isLauncherMode: jsonSerialization['isLauncherMode'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isLauncherMode']),
      brand: jsonSerialization['brand'] as String?,
      manufacturer: jsonSerialization['manufacturer'] as String?,
      androidVersion: jsonSerialization['androidVersion'] as String?,
      criticalBattery: jsonSerialization['criticalBattery'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['criticalBattery'],
            ),
      criticalStorage: jsonSerialization['criticalStorage'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['criticalStorage'],
            ),
      notSeen24h: jsonSerialization['notSeen24h'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['notSeen24h']),
      noPolicy: jsonSerialization['noPolicy'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['noPolicy']),
    );
  }

  int page;

  int perPage;

  String? search;

  String? sortBy;

  bool sortDesc;

  int? policyId;

  int? deviceGroupId;

  /// `true` keeps devices seen within the offline timeout, `false` the rest.
  bool? isOnline;

  bool? isRooted;

  bool? isLauncherMode;

  String? brand;

  String? manufacturer;

  String? androidVersion;

  /// `true` keeps devices with a critical battery, `false` the rest.
  bool? criticalBattery;

  /// `true` keeps devices with critical storage, `false` the rest.
  bool? criticalStorage;

  /// `true` keeps devices not seen in the last 24 hours, `false` the rest.
  bool? notSeen24h;

  /// `true` keeps devices without a policy, `false` the rest.
  bool? noPolicy;

  /// Returns a shallow copy of this [DeviceListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? policyId,
    int? deviceGroupId,
    bool? isOnline,
    bool? isRooted,
    bool? isLauncherMode,
    String? brand,
    String? manufacturer,
    String? androidVersion,
    bool? criticalBattery,
    bool? criticalStorage,
    bool? notSeen24h,
    bool? noPolicy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (policyId != null) 'policyId': policyId,
      if (deviceGroupId != null) 'deviceGroupId': deviceGroupId,
      if (isOnline != null) 'isOnline': isOnline,
      if (isRooted != null) 'isRooted': isRooted,
      if (isLauncherMode != null) 'isLauncherMode': isLauncherMode,
      if (brand != null) 'brand': brand,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (criticalBattery != null) 'criticalBattery': criticalBattery,
      if (criticalStorage != null) 'criticalStorage': criticalStorage,
      if (notSeen24h != null) 'notSeen24h': notSeen24h,
      if (noPolicy != null) 'noPolicy': noPolicy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (policyId != null) 'policyId': policyId,
      if (deviceGroupId != null) 'deviceGroupId': deviceGroupId,
      if (isOnline != null) 'isOnline': isOnline,
      if (isRooted != null) 'isRooted': isRooted,
      if (isLauncherMode != null) 'isLauncherMode': isLauncherMode,
      if (brand != null) 'brand': brand,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (criticalBattery != null) 'criticalBattery': criticalBattery,
      if (criticalStorage != null) 'criticalStorage': criticalStorage,
      if (notSeen24h != null) 'notSeen24h': notSeen24h,
      if (noPolicy != null) 'noPolicy': noPolicy,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceListRequestImpl extends DeviceListRequest {
  _DeviceListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? policyId,
    int? deviceGroupId,
    bool? isOnline,
    bool? isRooted,
    bool? isLauncherMode,
    String? brand,
    String? manufacturer,
    String? androidVersion,
    bool? criticalBattery,
    bool? criticalStorage,
    bool? notSeen24h,
    bool? noPolicy,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         policyId: policyId,
         deviceGroupId: deviceGroupId,
         isOnline: isOnline,
         isRooted: isRooted,
         isLauncherMode: isLauncherMode,
         brand: brand,
         manufacturer: manufacturer,
         androidVersion: androidVersion,
         criticalBattery: criticalBattery,
         criticalStorage: criticalStorage,
         notSeen24h: notSeen24h,
         noPolicy: noPolicy,
       );

  /// Returns a shallow copy of this [DeviceListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    Object? policyId = _Undefined,
    Object? deviceGroupId = _Undefined,
    Object? isOnline = _Undefined,
    Object? isRooted = _Undefined,
    Object? isLauncherMode = _Undefined,
    Object? brand = _Undefined,
    Object? manufacturer = _Undefined,
    Object? androidVersion = _Undefined,
    Object? criticalBattery = _Undefined,
    Object? criticalStorage = _Undefined,
    Object? notSeen24h = _Undefined,
    Object? noPolicy = _Undefined,
  }) {
    return DeviceListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      policyId: policyId is int? ? policyId : this.policyId,
      deviceGroupId: deviceGroupId is int? ? deviceGroupId : this.deviceGroupId,
      isOnline: isOnline is bool? ? isOnline : this.isOnline,
      isRooted: isRooted is bool? ? isRooted : this.isRooted,
      isLauncherMode: isLauncherMode is bool?
          ? isLauncherMode
          : this.isLauncherMode,
      brand: brand is String? ? brand : this.brand,
      manufacturer: manufacturer is String? ? manufacturer : this.manufacturer,
      androidVersion: androidVersion is String?
          ? androidVersion
          : this.androidVersion,
      criticalBattery: criticalBattery is bool?
          ? criticalBattery
          : this.criticalBattery,
      criticalStorage: criticalStorage is bool?
          ? criticalStorage
          : this.criticalStorage,
      notSeen24h: notSeen24h is bool? ? notSeen24h : this.notSeen24h,
      noPolicy: noPolicy is bool? ? noPolicy : this.noPolicy,
    );
  }
}
