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
import '../device_log.dart' as _iu263nm6;

abstract class DeviceLogRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLogRow._({
    required this.log,
    this.deviceLabel,
  });

  factory DeviceLogRow({
    required _iu263nm6.DeviceLog log,
    String? deviceLabel,
  }) = _DeviceLogRowImpl;

  factory DeviceLogRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogRow(
      log: _icclvb2d.Protocol().deserialize<_iu263nm6.DeviceLog>(
        jsonSerialization['log'],
      ),
      deviceLabel: jsonSerialization['deviceLabel'] as String?,
    );
  }

  _iu263nm6.DeviceLog log;

  /// `name (code)`, or just the code when the device has no name.
  String? deviceLabel;

  /// Returns a shallow copy of this [DeviceLogRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLogRow copyWith({
    _iu263nm6.DeviceLog? log,
    String? deviceLabel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLogRow',
      'log': log.toJson(),
      if (deviceLabel != null) 'deviceLabel': deviceLabel,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLogRow',
      'log': log.toJsonForProtocol(),
      if (deviceLabel != null) 'deviceLabel': deviceLabel,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceLogRowImpl extends DeviceLogRow {
  _DeviceLogRowImpl({
    required _iu263nm6.DeviceLog log,
    String? deviceLabel,
  }) : super._(
         log: log,
         deviceLabel: deviceLabel,
       );

  /// Returns a shallow copy of this [DeviceLogRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLogRow copyWith({
    _iu263nm6.DeviceLog? log,
    Object? deviceLabel = _Undefined,
  }) {
    return DeviceLogRow(
      log: log ?? this.log.copyWith(),
      deviceLabel: deviceLabel is String? ? deviceLabel : this.deviceLabel,
    );
  }
}
