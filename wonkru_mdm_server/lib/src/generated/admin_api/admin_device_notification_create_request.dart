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

abstract class AdminDeviceNotificationCreateRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminDeviceNotificationCreateRequest._({
    required this.title,
    required this.message,
    required this.type,
    this.extra,
    required this.deviceIds,
  });

  factory AdminDeviceNotificationCreateRequest({
    required String title,
    required String message,
    required String type,
    Map<String, String>? extra,
    required List<int> deviceIds,
  }) = _AdminDeviceNotificationCreateRequestImpl;

  factory AdminDeviceNotificationCreateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDeviceNotificationCreateRequest(
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: jsonSerialization['type'] as String,
      extra: jsonSerialization['extra'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['extra'],
            ),
      deviceIds: _ij1wyujj.Protocol().deserialize<List<int>>(
        jsonSerialization['deviceIds'],
      ),
    );
  }

  String title;

  String message;

  /// Raw string; the service maps it via `NotificationType.fromJson`.
  String type;

  /// Extra key/value pairs stored as JSON; blank keys are dropped.
  Map<String, String>? extra;

  /// At least one required; a delivery row is stored per device.
  List<int> deviceIds;

  /// Returns a shallow copy of this [AdminDeviceNotificationCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminDeviceNotificationCreateRequest copyWith({
    String? title,
    String? message,
    String? type,
    Map<String, String>? extra = const _is.$UndefinedMap<String, String>(),
    List<int>? deviceIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDeviceNotificationCreateRequest',
      'title': title,
      'message': message,
      'type': type,
      if (extra != null) 'extra': extra?.toJson(),
      'deviceIds': deviceIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDeviceNotificationCreateRequest',
      'title': title,
      'message': message,
      'type': type,
      if (extra != null) 'extra': extra?.toJson(),
      'deviceIds': deviceIds.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminDeviceNotificationCreateRequestImpl
    extends AdminDeviceNotificationCreateRequest {
  _AdminDeviceNotificationCreateRequestImpl({
    required String title,
    required String message,
    required String type,
    Map<String, String>? extra,
    required List<int> deviceIds,
  }) : super._(
         title: title,
         message: message,
         type: type,
         extra: extra,
         deviceIds: deviceIds,
       );

  /// Returns a shallow copy of this [AdminDeviceNotificationCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminDeviceNotificationCreateRequest copyWith({
    String? title,
    String? message,
    String? type,
    Map<String, String>? extra = const _is.$UndefinedMap<String, String>(),
    List<int>? deviceIds,
  }) {
    return AdminDeviceNotificationCreateRequest(
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      extra: extra is _is.UndefinedSentinel
          ? this.extra?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : extra,
      deviceIds: deviceIds ?? this.deviceIds.map((e0) => e0).toList(),
    );
  }
}
