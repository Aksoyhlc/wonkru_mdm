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

abstract class DeviceSyncRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceSyncRequest._({
    required this.deviceUuid,
    required this.token,
    this.syncType,
    required this.payload,
  });

  factory DeviceSyncRequest({
    required String deviceUuid,
    required String token,
    String? syncType,
    required String payload,
  }) = _DeviceSyncRequestImpl;

  factory DeviceSyncRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceSyncRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      syncType: jsonSerialization['syncType'] as String?,
      payload: jsonSerialization['payload'] as String,
    );
  }

  String deviceUuid;

  String token;

  /// Either `full` or `dynamic`.
  String? syncType;

  /// Serialized JSON snapshot of the sync body.
  String payload;

  /// Returns a shallow copy of this [DeviceSyncRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceSyncRequest copyWith({
    String? deviceUuid,
    String? token,
    String? syncType,
    String? payload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceSyncRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      if (syncType != null) 'syncType': syncType,
      'payload': payload,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceSyncRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      if (syncType != null) 'syncType': syncType,
      'payload': payload,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceSyncRequestImpl extends DeviceSyncRequest {
  _DeviceSyncRequestImpl({
    required String deviceUuid,
    required String token,
    String? syncType,
    required String payload,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         syncType: syncType,
         payload: payload,
       );

  /// Returns a shallow copy of this [DeviceSyncRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceSyncRequest copyWith({
    String? deviceUuid,
    String? token,
    Object? syncType = _Undefined,
    String? payload,
  }) {
    return DeviceSyncRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      syncType: syncType is String? ? syncType : this.syncType,
      payload: payload ?? this.payload,
    );
  }
}
