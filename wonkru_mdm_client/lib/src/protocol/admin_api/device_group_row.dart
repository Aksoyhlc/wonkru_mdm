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
import '../device_group.dart' as _icymuwlo;

abstract class DeviceGroupRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceGroupRow._({
    required this.group,
    required this.deviceCount,
  });

  factory DeviceGroupRow({
    required _icymuwlo.DeviceGroup group,
    required int deviceCount,
  }) = _DeviceGroupRowImpl;

  factory DeviceGroupRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceGroupRow(
      group: _icclvb2d.Protocol().deserialize<_icymuwlo.DeviceGroup>(
        jsonSerialization['group'],
      ),
      deviceCount: jsonSerialization['deviceCount'] as int,
    );
  }

  _icymuwlo.DeviceGroup group;

  int deviceCount;

  /// Returns a shallow copy of this [DeviceGroupRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceGroupRow copyWith({
    _icymuwlo.DeviceGroup? group,
    int? deviceCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceGroupRow',
      'group': group.toJson(),
      'deviceCount': deviceCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceGroupRow',
      'group': group.toJsonForProtocol(),
      'deviceCount': deviceCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceGroupRowImpl extends DeviceGroupRow {
  _DeviceGroupRowImpl({
    required _icymuwlo.DeviceGroup group,
    required int deviceCount,
  }) : super._(
         group: group,
         deviceCount: deviceCount,
       );

  /// Returns a shallow copy of this [DeviceGroupRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceGroupRow copyWith({
    _icymuwlo.DeviceGroup? group,
    int? deviceCount,
  }) {
    return DeviceGroupRow(
      group: group ?? this.group.copyWith(),
      deviceCount: deviceCount ?? this.deviceCount,
    );
  }
}
