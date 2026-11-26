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
import '../admin_api/device_notification_delivery_row.dart' as _iwg0604h;
import '../device_notification.dart' as _il2ss9ii;

abstract class AdminDeviceNotificationCreateResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminDeviceNotificationCreateResponse._({
    required this.notification,
    required this.deliveries,
  });

  factory AdminDeviceNotificationCreateResponse({
    required _il2ss9ii.DeviceNotification notification,
    required List<_iwg0604h.DeviceNotificationDeliveryRow> deliveries,
  }) = _AdminDeviceNotificationCreateResponseImpl;

  factory AdminDeviceNotificationCreateResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDeviceNotificationCreateResponse(
      notification: _ij1wyujj.Protocol()
          .deserialize<_il2ss9ii.DeviceNotification>(
            jsonSerialization['notification'],
          ),
      deliveries: _ij1wyujj.Protocol()
          .deserialize<List<_iwg0604h.DeviceNotificationDeliveryRow>>(
            jsonSerialization['deliveries'],
          ),
    );
  }

  _il2ss9ii.DeviceNotification notification;

  List<_iwg0604h.DeviceNotificationDeliveryRow> deliveries;

  /// Returns a shallow copy of this [AdminDeviceNotificationCreateResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminDeviceNotificationCreateResponse copyWith({
    _il2ss9ii.DeviceNotification? notification,
    List<_iwg0604h.DeviceNotificationDeliveryRow>? deliveries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDeviceNotificationCreateResponse',
      'notification': notification.toJson(),
      'deliveries': deliveries.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDeviceNotificationCreateResponse',
      'notification': notification.toJsonForProtocol(),
      'deliveries': deliveries.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminDeviceNotificationCreateResponseImpl
    extends AdminDeviceNotificationCreateResponse {
  _AdminDeviceNotificationCreateResponseImpl({
    required _il2ss9ii.DeviceNotification notification,
    required List<_iwg0604h.DeviceNotificationDeliveryRow> deliveries,
  }) : super._(
         notification: notification,
         deliveries: deliveries,
       );

  /// Returns a shallow copy of this [AdminDeviceNotificationCreateResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminDeviceNotificationCreateResponse copyWith({
    _il2ss9ii.DeviceNotification? notification,
    List<_iwg0604h.DeviceNotificationDeliveryRow>? deliveries,
  }) {
    return AdminDeviceNotificationCreateResponse(
      notification: notification ?? this.notification.copyWith(),
      deliveries:
          deliveries ?? this.deliveries.map((e0) => e0.copyWith()).toList(),
    );
  }
}
