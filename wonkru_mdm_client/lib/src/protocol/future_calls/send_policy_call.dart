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

abstract class SendPolicyCall
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SendPolicyCall._({
    required this.policyId,
    this.deviceIds,
  });

  factory SendPolicyCall({
    required int policyId,
    List<int>? deviceIds,
  }) = _SendPolicyCallImpl;

  factory SendPolicyCall.fromJson(Map<String, dynamic> jsonSerialization) {
    return SendPolicyCall(
      policyId: jsonSerialization['policyId'] as int,
      deviceIds: jsonSerialization['deviceIds'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<List<int>>(
              jsonSerialization['deviceIds'],
            ),
    );
  }

  int policyId;

  /// When empty, every device on the policy is notified.
  List<int>? deviceIds;

  /// Returns a shallow copy of this [SendPolicyCall]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SendPolicyCall copyWith({
    int? policyId,
    List<int>? deviceIds = const _isc.$UndefinedList<int>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SendPolicyCall',
      'policyId': policyId,
      if (deviceIds != null) 'deviceIds': deviceIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SendPolicyCall',
      'policyId': policyId,
      if (deviceIds != null) 'deviceIds': deviceIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SendPolicyCallImpl extends SendPolicyCall {
  _SendPolicyCallImpl({
    required int policyId,
    List<int>? deviceIds,
  }) : super._(
         policyId: policyId,
         deviceIds: deviceIds,
       );

  /// Returns a shallow copy of this [SendPolicyCall]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SendPolicyCall copyWith({
    int? policyId,
    List<int>? deviceIds = const _isc.$UndefinedList<int>(),
  }) {
    return SendPolicyCall(
      policyId: policyId ?? this.policyId,
      deviceIds: deviceIds is _isc.UndefinedSentinel
          ? this.deviceIds?.map((e0) => e0).toList()
          : deviceIds,
    );
  }
}
