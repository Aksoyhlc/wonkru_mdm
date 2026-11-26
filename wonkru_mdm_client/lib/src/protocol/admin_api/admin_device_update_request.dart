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

/// The panel submits every field at once: null clears the column unless a
/// field documents otherwise.
abstract class AdminDeviceUpdateRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminDeviceUpdateRequest._({
    required this.deviceId,
    this.name,
    this.code,
    this.policyId,
    this.userId,
    this.mustUseApplications,
    this.deviceGroupIds,
  });

  factory AdminDeviceUpdateRequest({
    required int deviceId,
    String? name,
    String? code,
    int? policyId,
    _isc.UuidValue? userId,
    String? mustUseApplications,
    List<int>? deviceGroupIds,
  }) = _AdminDeviceUpdateRequestImpl;

  factory AdminDeviceUpdateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDeviceUpdateRequest(
      deviceId: jsonSerialization['deviceId'] as int,
      name: jsonSerialization['name'] as String?,
      code: jsonSerialization['code'] as String?,
      policyId: jsonSerialization['policyId'] as int?,
      userId: jsonSerialization['userId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      mustUseApplications: jsonSerialization['mustUseApplications'] as String?,
      deviceGroupIds: jsonSerialization['deviceGroupIds'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<List<int>>(
              jsonSerialization['deviceGroupIds'],
            ),
    );
  }

  int deviceId;

  String? name;

  /// Null keeps the stored code, because the column is not nullable.
  String? code;

  /// Null clears the assignment, handing the device back to the default policy.
  int? policyId;

  _isc.UuidValue? userId;

  /// Serialized JSON list of applications the user must keep running.
  String? mustUseApplications;

  /// Null leaves the group memberships alone, an empty list removes them all.
  List<int>? deviceGroupIds;

  /// Returns a shallow copy of this [AdminDeviceUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminDeviceUpdateRequest copyWith({
    int? deviceId,
    String? name,
    String? code,
    int? policyId,
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    String? mustUseApplications,
    List<int>? deviceGroupIds = const _isc.$UndefinedList<int>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDeviceUpdateRequest',
      'deviceId': deviceId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (policyId != null) 'policyId': policyId,
      if (userId != null) 'userId': userId?.toJson(),
      if (mustUseApplications != null)
        'mustUseApplications': mustUseApplications,
      if (deviceGroupIds != null) 'deviceGroupIds': deviceGroupIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDeviceUpdateRequest',
      'deviceId': deviceId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (policyId != null) 'policyId': policyId,
      if (userId != null) 'userId': userId?.toJson(),
      if (mustUseApplications != null)
        'mustUseApplications': mustUseApplications,
      if (deviceGroupIds != null) 'deviceGroupIds': deviceGroupIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminDeviceUpdateRequestImpl extends AdminDeviceUpdateRequest {
  _AdminDeviceUpdateRequestImpl({
    required int deviceId,
    String? name,
    String? code,
    int? policyId,
    _isc.UuidValue? userId,
    String? mustUseApplications,
    List<int>? deviceGroupIds,
  }) : super._(
         deviceId: deviceId,
         name: name,
         code: code,
         policyId: policyId,
         userId: userId,
         mustUseApplications: mustUseApplications,
         deviceGroupIds: deviceGroupIds,
       );

  /// Returns a shallow copy of this [AdminDeviceUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminDeviceUpdateRequest copyWith({
    int? deviceId,
    Object? name = _Undefined,
    Object? code = _Undefined,
    Object? policyId = _Undefined,
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    Object? mustUseApplications = _Undefined,
    List<int>? deviceGroupIds = const _isc.$UndefinedList<int>(),
  }) {
    return AdminDeviceUpdateRequest(
      deviceId: deviceId ?? this.deviceId,
      name: name is String? ? name : this.name,
      code: code is String? ? code : this.code,
      policyId: policyId is int? ? policyId : this.policyId,
      userId: userId is _isc.UndefinedSentinel ? this.userId : userId,
      mustUseApplications: mustUseApplications is String?
          ? mustUseApplications
          : this.mustUseApplications,
      deviceGroupIds: deviceGroupIds is _isc.UndefinedSentinel
          ? this.deviceGroupIds?.map((e0) => e0).toList()
          : deviceGroupIds,
    );
  }
}
