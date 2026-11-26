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
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import '../admin_api/device_sync_row.dart' as _iuds7uxt;
import '../device_state_cache.dart' as _i6wrjell;

abstract class DeviceSyncDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceSyncDetail._({
    required this.row,
    required this.state,
  });

  factory DeviceSyncDetail({
    required _iuds7uxt.DeviceSyncRow row,
    required _i6wrjell.DeviceStateCache state,
  }) = _DeviceSyncDetailImpl;

  factory DeviceSyncDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceSyncDetail(
      row: _ij1wyujj.Protocol().deserialize<_iuds7uxt.DeviceSyncRow>(
        jsonSerialization['row'],
      ),
      state: _ij1wyujj.Protocol().deserialize<_i6wrjell.DeviceStateCache>(
        jsonSerialization['state'],
      ),
    );
  }

  _iuds7uxt.DeviceSyncRow row;

  /// Flattened state of this snapshot.
  _i6wrjell.DeviceStateCache state;

  /// Returns a shallow copy of this [DeviceSyncDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceSyncDetail copyWith({
    _iuds7uxt.DeviceSyncRow? row,
    _i6wrjell.DeviceStateCache? state,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceSyncDetail',
      'row': row.toJson(),
      'state': state.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceSyncDetail',
      'row': row.toJsonForProtocol(),
      'state': state.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DeviceSyncDetailImpl extends DeviceSyncDetail {
  _DeviceSyncDetailImpl({
    required _iuds7uxt.DeviceSyncRow row,
    required _i6wrjell.DeviceStateCache state,
  }) : super._(
         row: row,
         state: state,
       );

  /// Returns a shallow copy of this [DeviceSyncDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceSyncDetail copyWith({
    _iuds7uxt.DeviceSyncRow? row,
    _i6wrjell.DeviceStateCache? state,
  }) {
    return DeviceSyncDetail(
      row: row ?? this.row.copyWith(),
      state: state ?? this.state.copyWith(),
    );
  }
}
