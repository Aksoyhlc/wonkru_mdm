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

abstract class DeviceNotificationAckRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceNotificationAckRequest._({
    required this.deviceUuid,
    required this.token,
    required this.notificationUuid,
  });

  factory DeviceNotificationAckRequest({
    required String deviceUuid,
    required String token,
    required String notificationUuid,
  }) = _DeviceNotificationAckRequestImpl;

  factory DeviceNotificationAckRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceNotificationAckRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      notificationUuid: jsonSerialization['notificationUuid'] as String,
    );
  }

  String deviceUuid;

  String token;

  String notificationUuid;

  /// Returns a shallow copy of this [DeviceNotificationAckRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceNotificationAckRequest copyWith({
    String? deviceUuid,
    String? token,
    String? notificationUuid,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceNotificationAckRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'notificationUuid': notificationUuid,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceNotificationAckRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'notificationUuid': notificationUuid,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceNotificationAckRequestImpl extends DeviceNotificationAckRequest {
  _DeviceNotificationAckRequestImpl({
    required String deviceUuid,
    required String token,
    required String notificationUuid,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         notificationUuid: notificationUuid,
       );

  /// Returns a shallow copy of this [DeviceNotificationAckRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceNotificationAckRequest copyWith({
    String? deviceUuid,
    String? token,
    String? notificationUuid,
  }) {
    return DeviceNotificationAckRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      notificationUuid: notificationUuid ?? this.notificationUuid,
    );
  }
}
