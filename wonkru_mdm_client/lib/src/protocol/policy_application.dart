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
import 'application.dart' as _ice4s91e;
import 'application_version.dart' as _il9v10p8;
import 'policy.dart' as _if7d246m;

abstract class PolicyApplication
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PolicyApplication._({
    this.id,
    required this.policyId,
    this.policy,
    int? sort,
    required this.applicationId,
    this.application,
    this.targetVersionId,
    this.targetVersion,
    required this.action,
    bool? showLauncher,
    this.customAppName,
    bool? runOnBoot,
    this.updatePolicy,
    bool? startAfterInstall,
    bool? uninstallBlock,
    this.createdAt,
    this.updatedAt,
  }) : sort = sort ?? 0,
       showLauncher = showLauncher ?? true,
       runOnBoot = runOnBoot ?? false,
       startAfterInstall = startAfterInstall ?? false,
       uninstallBlock = uninstallBlock ?? false;

  factory PolicyApplication({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? sort,
    required int applicationId,
    _ice4s91e.Application? application,
    int? targetVersionId,
    _il9v10p8.ApplicationVersion? targetVersion,
    required _inc4d0tr.PolicyApplicationAction action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _inc4d0tr.AppAutoUpdatePolicy? updatePolicy,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PolicyApplicationImpl;

  factory PolicyApplication.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolicyApplication(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      sort: jsonSerialization['sort'] as int?,
      applicationId: jsonSerialization['applicationId'] as int,
      application: jsonSerialization['application'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ice4s91e.Application>(
              jsonSerialization['application'],
            ),
      targetVersionId: jsonSerialization['targetVersionId'] as int?,
      targetVersion: jsonSerialization['targetVersion'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_il9v10p8.ApplicationVersion>(
              jsonSerialization['targetVersion'],
            ),
      action: _inc4d0tr.PolicyApplicationAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      showLauncher: jsonSerialization['showLauncher'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['showLauncher']),
      customAppName: jsonSerialization['customAppName'] as String?,
      runOnBoot: jsonSerialization['runOnBoot'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['runOnBoot']),
      updatePolicy: jsonSerialization['updatePolicy'] == null
          ? null
          : _inc4d0tr.AppAutoUpdatePolicy.fromJson(
              (jsonSerialization['updatePolicy'] as String),
            ),
      startAfterInstall: jsonSerialization['startAfterInstall'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['startAfterInstall'],
            ),
      uninstallBlock: jsonSerialization['uninstallBlock'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['uninstallBlock'],
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

  int sort;

  int applicationId;

  _ice4s91e.Application? application;

  int? targetVersionId;

  /// Removing a version keeps the pivot row and only clears the reference,
  /// matching the manual nulling in `ApplicationVersionService.onDeleting`.
  _il9v10p8.ApplicationVersion? targetVersion;

  _inc4d0tr.PolicyApplicationAction action;

  bool showLauncher;

  String? customAppName;

  bool runOnBoot;

  _inc4d0tr.AppAutoUpdatePolicy? updatePolicy;

  bool startAfterInstall;

  bool uninstallBlock;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [PolicyApplication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PolicyApplication copyWith({
    int? id,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyApplication$policy(),
    int? sort,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedPolicyApplication$application(),
    int? targetVersionId,
    _il9v10p8.ApplicationVersion? targetVersion =
        const _UndefinedPolicyApplication$targetVersion(),
    _inc4d0tr.PolicyApplicationAction? action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _inc4d0tr.AppAutoUpdatePolicy? updatePolicy,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolicyApplication',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      'sort': sort,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJson(),
      if (targetVersionId != null) 'targetVersionId': targetVersionId,
      if (targetVersion != null) 'targetVersion': targetVersion?.toJson(),
      'action': action.toJson(),
      'showLauncher': showLauncher,
      if (customAppName != null) 'customAppName': customAppName,
      'runOnBoot': runOnBoot,
      if (updatePolicy != null) 'updatePolicy': updatePolicy?.toJson(),
      'startAfterInstall': startAfterInstall,
      'uninstallBlock': uninstallBlock,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolicyApplication',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      'sort': sort,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJsonForProtocol(),
      if (targetVersionId != null) 'targetVersionId': targetVersionId,
      if (targetVersion != null)
        'targetVersion': targetVersion?.toJsonForProtocol(),
      'action': action.toJson(),
      'showLauncher': showLauncher,
      if (customAppName != null) 'customAppName': customAppName,
      'runOnBoot': runOnBoot,
      if (updatePolicy != null) 'updatePolicy': updatePolicy?.toJson(),
      'startAfterInstall': startAfterInstall,
      'uninstallBlock': uninstallBlock,
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

class _UndefinedPolicyApplication$policy extends _isc.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedPolicyApplication$policy();
}

class _UndefinedPolicyApplication$application extends _isc.UndefinedSentinel
    implements _ice4s91e.Application {
  const _UndefinedPolicyApplication$application();
}

class _UndefinedPolicyApplication$targetVersion extends _isc.UndefinedSentinel
    implements _il9v10p8.ApplicationVersion {
  const _UndefinedPolicyApplication$targetVersion();
}

class _PolicyApplicationImpl extends PolicyApplication {
  _PolicyApplicationImpl({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? sort,
    required int applicationId,
    _ice4s91e.Application? application,
    int? targetVersionId,
    _il9v10p8.ApplicationVersion? targetVersion,
    required _inc4d0tr.PolicyApplicationAction action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _inc4d0tr.AppAutoUpdatePolicy? updatePolicy,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         sort: sort,
         applicationId: applicationId,
         application: application,
         targetVersionId: targetVersionId,
         targetVersion: targetVersion,
         action: action,
         showLauncher: showLauncher,
         customAppName: customAppName,
         runOnBoot: runOnBoot,
         updatePolicy: updatePolicy,
         startAfterInstall: startAfterInstall,
         uninstallBlock: uninstallBlock,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PolicyApplication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PolicyApplication copyWith({
    Object? id = _Undefined,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyApplication$policy(),
    int? sort,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedPolicyApplication$application(),
    Object? targetVersionId = _Undefined,
    _il9v10p8.ApplicationVersion? targetVersion =
        const _UndefinedPolicyApplication$targetVersion(),
    _inc4d0tr.PolicyApplicationAction? action,
    bool? showLauncher,
    Object? customAppName = _Undefined,
    bool? runOnBoot,
    Object? updatePolicy = _Undefined,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return PolicyApplication(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _isc.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      sort: sort ?? this.sort,
      applicationId: applicationId ?? this.applicationId,
      application: application is _isc.UndefinedSentinel
          ? this.application?.copyWith()
          : application,
      targetVersionId: targetVersionId is int?
          ? targetVersionId
          : this.targetVersionId,
      targetVersion: targetVersion is _isc.UndefinedSentinel
          ? this.targetVersion?.copyWith()
          : targetVersion,
      action: action ?? this.action,
      showLauncher: showLauncher ?? this.showLauncher,
      customAppName: customAppName is String?
          ? customAppName
          : this.customAppName,
      runOnBoot: runOnBoot ?? this.runOnBoot,
      updatePolicy: updatePolicy is _inc4d0tr.AppAutoUpdatePolicy?
          ? updatePolicy
          : this.updatePolicy,
      startAfterInstall: startAfterInstall ?? this.startAfterInstall,
      uninstallBlock: uninstallBlock ?? this.uninstallBlock,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
