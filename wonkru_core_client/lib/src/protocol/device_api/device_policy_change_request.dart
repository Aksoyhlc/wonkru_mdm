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

abstract class DevicePolicyChangeRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DevicePolicyChangeRequest._({
    required this.deviceUuid,
    required this.token,
    required this.policyId,
  });

  factory DevicePolicyChangeRequest({
    required String deviceUuid,
    required String token,
    required int policyId,
  }) = _DevicePolicyChangeRequestImpl;

  factory DevicePolicyChangeRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DevicePolicyChangeRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      policyId: jsonSerialization['policyId'] as int,
    );
  }

  String deviceUuid;

  String token;

  int policyId;

  /// Returns a shallow copy of this [DevicePolicyChangeRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DevicePolicyChangeRequest copyWith({
    String? deviceUuid,
    String? token,
    int? policyId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DevicePolicyChangeRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'policyId': policyId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DevicePolicyChangeRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'policyId': policyId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DevicePolicyChangeRequestImpl extends DevicePolicyChangeRequest {
  _DevicePolicyChangeRequestImpl({
    required String deviceUuid,
    required String token,
    required int policyId,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         policyId: policyId,
       );

  /// Returns a shallow copy of this [DevicePolicyChangeRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DevicePolicyChangeRequest copyWith({
    String? deviceUuid,
    String? token,
    int? policyId,
  }) {
    return DevicePolicyChangeRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      policyId: policyId ?? this.policyId,
    );
  }
}
