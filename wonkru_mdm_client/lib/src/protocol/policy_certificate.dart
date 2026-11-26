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
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import 'certificate.dart' as _i0cezxmz;
import 'policy.dart' as _if7d246m;

abstract class PolicyCertificate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PolicyCertificate._({
    this.id,
    required this.policyId,
    this.policy,
    required this.certificateId,
    this.certificate,
    this.action,
    this.createdAt,
    this.updatedAt,
  });

  factory PolicyCertificate({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    required int certificateId,
    _i0cezxmz.Certificate? certificate,
    _inc4d0tr.CertificateAction? action,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PolicyCertificateImpl;

  factory PolicyCertificate.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolicyCertificate(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      certificateId: jsonSerialization['certificateId'] as int,
      certificate: jsonSerialization['certificate'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i0cezxmz.Certificate>(
              jsonSerialization['certificate'],
            ),
      action: jsonSerialization['action'] == null
          ? null
          : _inc4d0tr.CertificateAction.fromJson(
              (jsonSerialization['action'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int policyId;

  _if7d246m.Policy? policy;

  int certificateId;

  _i0cezxmz.Certificate? certificate;

  _inc4d0tr.CertificateAction? action;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [PolicyCertificate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PolicyCertificate copyWith({
    int? id,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyCertificate$policy(),
    int? certificateId,
    _i0cezxmz.Certificate? certificate =
        const _UndefinedPolicyCertificate$certificate(),
    _inc4d0tr.CertificateAction? action,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolicyCertificate',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      'certificateId': certificateId,
      if (certificate != null) 'certificate': certificate?.toJson(),
      if (action != null) 'action': action?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolicyCertificate',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      'certificateId': certificateId,
      if (certificate != null) 'certificate': certificate?.toJsonForProtocol(),
      if (action != null) 'action': action?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedPolicyCertificate$policy extends _isc.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedPolicyCertificate$policy();
}

class _UndefinedPolicyCertificate$certificate extends _isc.UndefinedSentinel
    implements _i0cezxmz.Certificate {
  const _UndefinedPolicyCertificate$certificate();
}

class _PolicyCertificateImpl extends PolicyCertificate {
  _PolicyCertificateImpl({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    required int certificateId,
    _i0cezxmz.Certificate? certificate,
    _inc4d0tr.CertificateAction? action,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         certificateId: certificateId,
         certificate: certificate,
         action: action,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PolicyCertificate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PolicyCertificate copyWith({
    Object? id = _Undefined,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyCertificate$policy(),
    int? certificateId,
    _i0cezxmz.Certificate? certificate =
        const _UndefinedPolicyCertificate$certificate(),
    Object? action = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return PolicyCertificate(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _isc.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      certificateId: certificateId ?? this.certificateId,
      certificate: certificate is _isc.UndefinedSentinel
          ? this.certificate?.copyWith()
          : certificate,
      action: action is _inc4d0tr.CertificateAction? ? action : this.action,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
