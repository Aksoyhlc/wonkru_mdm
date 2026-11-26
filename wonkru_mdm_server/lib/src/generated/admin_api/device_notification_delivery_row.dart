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
import '../device.dart' as _in9db4vh;
import '../device_notification_device.dart' as _i3tteojl;

abstract class DeviceNotificationDeliveryRow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceNotificationDeliveryRow._({
    required this.delivery,
    this.device,
    required this.groupNames,
  });

  factory DeviceNotificationDeliveryRow({
    required _i3tteojl.DeviceNotificationDevice delivery,
    _in9db4vh.Device? device,
    required List<String> groupNames,
  }) = _DeviceNotificationDeliveryRowImpl;

  factory DeviceNotificationDeliveryRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceNotificationDeliveryRow(
      delivery: _ij1wyujj.Protocol()
          .deserialize<_i3tteojl.DeviceNotificationDevice>(
            jsonSerialization['delivery'],
          ),
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_in9db4vh.Device>(
              jsonSerialization['device'],
            ),
      groupNames: _ij1wyujj.Protocol().deserialize<List<String>>(
        jsonSerialization['groupNames'],
      ),
    );
  }

  _i3tteojl.DeviceNotificationDevice delivery;

  /// Target device; null only when the row outlived it.
  _in9db4vh.Device? device;

  List<String> groupNames;

  /// Returns a shallow copy of this [DeviceNotificationDeliveryRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceNotificationDeliveryRow copyWith({
    _i3tteojl.DeviceNotificationDevice? delivery,
    _in9db4vh.Device? device =
        const _UndefinedDeviceNotificationDeliveryRow$device(),
    List<String>? groupNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotificationDeliveryRow',
      'delivery': delivery.toJson(),
      if (device != null) 'device': device?.toJson(),
      'groupNames': groupNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotificationDeliveryRow',
      'delivery': delivery.toJsonForProtocol(),
      if (device != null) 'device': device?.toJsonForProtocol(),
      'groupNames': groupNames.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedDeviceNotificationDeliveryRow$device
    extends _is.UndefinedSentinel
    implements _in9db4vh.Device {
  const _UndefinedDeviceNotificationDeliveryRow$device();
}

class _DeviceNotificationDeliveryRowImpl extends DeviceNotificationDeliveryRow {
  _DeviceNotificationDeliveryRowImpl({
    required _i3tteojl.DeviceNotificationDevice delivery,
    _in9db4vh.Device? device,
    required List<String> groupNames,
  }) : super._(
         delivery: delivery,
         device: device,
         groupNames: groupNames,
       );

  /// Returns a shallow copy of this [DeviceNotificationDeliveryRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceNotificationDeliveryRow copyWith({
    _i3tteojl.DeviceNotificationDevice? delivery,
    _in9db4vh.Device? device =
        const _UndefinedDeviceNotificationDeliveryRow$device(),
    List<String>? groupNames,
  }) {
    return DeviceNotificationDeliveryRow(
      delivery: delivery ?? this.delivery.copyWith(),
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      groupNames: groupNames ?? this.groupNames.map((e0) => e0).toList(),
    );
  }
}
