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

abstract class CheckPolicyDevicesCall
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CheckPolicyDevicesCall._({
    required this.policyId,
    required this.expectedVersion,
  });

  factory CheckPolicyDevicesCall({
    required int policyId,
    required int expectedVersion,
  }) = _CheckPolicyDevicesCallImpl;

  factory CheckPolicyDevicesCall.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CheckPolicyDevicesCall(
      policyId: jsonSerialization['policyId'] as int,
      expectedVersion: jsonSerialization['expectedVersion'] as int,
    );
  }

  int policyId;

  int expectedVersion;

  /// Returns a shallow copy of this [CheckPolicyDevicesCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CheckPolicyDevicesCall copyWith({
    int? policyId,
    int? expectedVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckPolicyDevicesCall',
      'policyId': policyId,
      'expectedVersion': expectedVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckPolicyDevicesCall',
      'policyId': policyId,
      'expectedVersion': expectedVersion,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CheckPolicyDevicesCallImpl extends CheckPolicyDevicesCall {
  _CheckPolicyDevicesCallImpl({
    required int policyId,
    required int expectedVersion,
  }) : super._(
         policyId: policyId,
         expectedVersion: expectedVersion,
       );

  /// Returns a shallow copy of this [CheckPolicyDevicesCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CheckPolicyDevicesCall copyWith({
    int? policyId,
    int? expectedVersion,
  }) {
    return CheckPolicyDevicesCall(
      policyId: policyId ?? this.policyId,
      expectedVersion: expectedVersion ?? this.expectedVersion,
    );
  }
}
