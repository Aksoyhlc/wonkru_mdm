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

abstract class DeviceVersionInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceVersionInfo._({
    this.release,
    this.sdkInt,
  });

  factory DeviceVersionInfo({
    String? release,
    int? sdkInt,
  }) = _DeviceVersionInfoImpl;

  factory DeviceVersionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceVersionInfo(
      release: jsonSerialization['release'] as String?,
      sdkInt: jsonSerialization['sdkInt'] as int?,
    );
  }

  /// Android release, e.g. `14`.
  String? release;

  /// Android SDK level, e.g. `34`.
  int? sdkInt;

  /// Returns a shallow copy of this [DeviceVersionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceVersionInfo copyWith({
    String? release,
    int? sdkInt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceVersionInfo',
      if (release != null) 'release': release,
      if (sdkInt != null) 'sdkInt': sdkInt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceVersionInfo',
      if (release != null) 'release': release,
      if (sdkInt != null) 'sdkInt': sdkInt,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceVersionInfoImpl extends DeviceVersionInfo {
  _DeviceVersionInfoImpl({
    String? release,
    int? sdkInt,
  }) : super._(
         release: release,
         sdkInt: sdkInt,
       );

  /// Returns a shallow copy of this [DeviceVersionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceVersionInfo copyWith({
    Object? release = _Undefined,
    Object? sdkInt = _Undefined,
  }) {
    return DeviceVersionInfo(
      release: release is String? ? release : this.release,
      sdkInt: sdkInt is int? ? sdkInt : this.sdkInt,
    );
  }
}
