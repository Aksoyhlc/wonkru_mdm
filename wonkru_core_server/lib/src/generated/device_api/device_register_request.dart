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
import 'package:wonkru_core_server/src/generated/protocol.dart' as _isn6ihzf;
import '../device_api/device_version_info.dart' as _imobfjxf;

abstract class DeviceRegisterRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceRegisterRequest._({
    this.deviceCode,
    this.manufacturer,
    this.model,
    this.brand,
    this.serialNo,
    this.version,
    this.enrollmentKey,
  });

  factory DeviceRegisterRequest({
    String? deviceCode,
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    _imobfjxf.DeviceVersionInfo? version,
    String? enrollmentKey,
  }) = _DeviceRegisterRequestImpl;

  factory DeviceRegisterRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceRegisterRequest(
      deviceCode: jsonSerialization['deviceCode'] as String?,
      manufacturer: jsonSerialization['manufacturer'] as String?,
      model: jsonSerialization['model'] as String?,
      brand: jsonSerialization['brand'] as String?,
      serialNo: jsonSerialization['serialNo'] as String?,
      version: jsonSerialization['version'] == null
          ? null
          : _isn6ihzf.Protocol().deserialize<_imobfjxf.DeviceVersionInfo>(
              jsonSerialization['version'],
            ),
      enrollmentKey: jsonSerialization['enrollmentKey'] as String?,
    );
  }

  /// Optional client-provided code; ignored when already taken.
  String? deviceCode;

  String? manufacturer;

  String? model;

  String? brand;

  String? serialNo;

  _imobfjxf.DeviceVersionInfo? version;

  /// Global enrollment key from the provisioning QR or the install page.
  /// Nullable only so older agents deserialize and get a typed rejection.
  String? enrollmentKey;

  /// Returns a shallow copy of this [DeviceRegisterRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceRegisterRequest copyWith({
    String? deviceCode,
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    _imobfjxf.DeviceVersionInfo? version =
        const _UndefinedDeviceRegisterRequest$version(),
    String? enrollmentKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceRegisterRequest',
      if (deviceCode != null) 'deviceCode': deviceCode,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (serialNo != null) 'serialNo': serialNo,
      if (version != null) 'version': version?.toJson(),
      if (enrollmentKey != null) 'enrollmentKey': enrollmentKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceRegisterRequest',
      if (deviceCode != null) 'deviceCode': deviceCode,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (serialNo != null) 'serialNo': serialNo,
      if (version != null) 'version': version?.toJsonForProtocol(),
      if (enrollmentKey != null) 'enrollmentKey': enrollmentKey,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceRegisterRequest$version extends _is.UndefinedSentinel
    implements _imobfjxf.DeviceVersionInfo {
  const _UndefinedDeviceRegisterRequest$version();
}

class _DeviceRegisterRequestImpl extends DeviceRegisterRequest {
  _DeviceRegisterRequestImpl({
    String? deviceCode,
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    _imobfjxf.DeviceVersionInfo? version,
    String? enrollmentKey,
  }) : super._(
         deviceCode: deviceCode,
         manufacturer: manufacturer,
         model: model,
         brand: brand,
         serialNo: serialNo,
         version: version,
         enrollmentKey: enrollmentKey,
       );

  /// Returns a shallow copy of this [DeviceRegisterRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceRegisterRequest copyWith({
    Object? deviceCode = _Undefined,
    Object? manufacturer = _Undefined,
    Object? model = _Undefined,
    Object? brand = _Undefined,
    Object? serialNo = _Undefined,
    _imobfjxf.DeviceVersionInfo? version =
        const _UndefinedDeviceRegisterRequest$version(),
    Object? enrollmentKey = _Undefined,
  }) {
    return DeviceRegisterRequest(
      deviceCode: deviceCode is String? ? deviceCode : this.deviceCode,
      manufacturer: manufacturer is String? ? manufacturer : this.manufacturer,
      model: model is String? ? model : this.model,
      brand: brand is String? ? brand : this.brand,
      serialNo: serialNo is String? ? serialNo : this.serialNo,
      version: version is _is.UndefinedSentinel
          ? this.version?.copyWith()
          : version,
      enrollmentKey: enrollmentKey is String?
          ? enrollmentKey
          : this.enrollmentKey,
    );
  }
}
