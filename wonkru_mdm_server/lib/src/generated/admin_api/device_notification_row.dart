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
import '../device_notification.dart' as _il2ss9ii;

abstract class DeviceNotificationRow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceNotificationRow._({
    required this.notification,
    required this.deviceCount,
  });

  factory DeviceNotificationRow({
    required _il2ss9ii.DeviceNotification notification,
    required int deviceCount,
  }) = _DeviceNotificationRowImpl;

  factory DeviceNotificationRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceNotificationRow(
      notification: _ij1wyujj.Protocol()
          .deserialize<_il2ss9ii.DeviceNotification>(
            jsonSerialization['notification'],
          ),
      deviceCount: jsonSerialization['deviceCount'] as int,
    );
  }

  _il2ss9ii.DeviceNotification notification;

  int deviceCount;

  /// Returns a shallow copy of this [DeviceNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceNotificationRow copyWith({
    _il2ss9ii.DeviceNotification? notification,
    int? deviceCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotificationRow',
      'notification': notification.toJson(),
      'deviceCount': deviceCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotificationRow',
      'notification': notification.toJsonForProtocol(),
      'deviceCount': deviceCount,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DeviceNotificationRowImpl extends DeviceNotificationRow {
  _DeviceNotificationRowImpl({
    required _il2ss9ii.DeviceNotification notification,
    required int deviceCount,
  }) : super._(
         notification: notification,
         deviceCount: deviceCount,
       );

  /// Returns a shallow copy of this [DeviceNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceNotificationRow copyWith({
    _il2ss9ii.DeviceNotification? notification,
    int? deviceCount,
  }) {
    return DeviceNotificationRow(
      notification: notification ?? this.notification.copyWith(),
      deviceCount: deviceCount ?? this.deviceCount,
    );
  }
}
