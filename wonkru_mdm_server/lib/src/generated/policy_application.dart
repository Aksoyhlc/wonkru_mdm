/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_core_server/wonkru_core_server.dart' as _i3xu12wm;
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import 'application.dart' as _ice4s91e;
import 'application_version.dart' as _il9v10p8;
import 'policy.dart' as _if7d246m;

abstract class PolicyApplication
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _i3xu12wm.PolicyApplicationAction action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _i3xu12wm.AppAutoUpdatePolicy? updatePolicy,
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
          : _ij1wyujj.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      sort: jsonSerialization['sort'] as int?,
      applicationId: jsonSerialization['applicationId'] as int,
      application: jsonSerialization['application'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ice4s91e.Application>(
              jsonSerialization['application'],
            ),
      targetVersionId: jsonSerialization['targetVersionId'] as int?,
      targetVersion: jsonSerialization['targetVersion'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_il9v10p8.ApplicationVersion>(
              jsonSerialization['targetVersion'],
            ),
      action: _i3xu12wm.PolicyApplicationAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      showLauncher: jsonSerialization['showLauncher'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['showLauncher']),
      customAppName: jsonSerialization['customAppName'] as String?,
      runOnBoot: jsonSerialization['runOnBoot'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['runOnBoot']),
      updatePolicy: jsonSerialization['updatePolicy'] == null
          ? null
          : _i3xu12wm.AppAutoUpdatePolicy.fromJson(
              (jsonSerialization['updatePolicy'] as String),
            ),
      startAfterInstall: jsonSerialization['startAfterInstall'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['startAfterInstall'],
            ),
      uninstallBlock: jsonSerialization['uninstallBlock'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['uninstallBlock']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PolicyApplicationTable();

  static const db = PolicyApplicationRepository._();

  @override
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

  _i3xu12wm.PolicyApplicationAction action;

  bool showLauncher;

  String? customAppName;

  bool runOnBoot;

  _i3xu12wm.AppAutoUpdatePolicy? updatePolicy;

  bool startAfterInstall;

  bool uninstallBlock;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PolicyApplication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    _i3xu12wm.PolicyApplicationAction? action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _i3xu12wm.AppAutoUpdatePolicy? updatePolicy,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
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

  static PolicyApplicationInclude include({
    _if7d246m.PolicyInclude? policy,
    _ice4s91e.ApplicationInclude? application,
    _il9v10p8.ApplicationVersionInclude? targetVersion,
  }) {
    return PolicyApplicationInclude._(
      policy: policy,
      application: application,
      targetVersion: targetVersion,
    );
  }

  static PolicyApplicationIncludeList includeList({
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    PolicyApplicationInclude? include,
  }) {
    return PolicyApplicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedPolicyApplication$policy extends _is.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedPolicyApplication$policy();
}

class _UndefinedPolicyApplication$application extends _is.UndefinedSentinel
    implements _ice4s91e.Application {
  const _UndefinedPolicyApplication$application();
}

class _UndefinedPolicyApplication$targetVersion extends _is.UndefinedSentinel
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
    required _i3xu12wm.PolicyApplicationAction action,
    bool? showLauncher,
    String? customAppName,
    bool? runOnBoot,
    _i3xu12wm.AppAutoUpdatePolicy? updatePolicy,
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
  @_is.useResult
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
    _i3xu12wm.PolicyApplicationAction? action,
    bool? showLauncher,
    Object? customAppName = _Undefined,
    bool? runOnBoot,
    Object? updatePolicy = _Undefined,
    bool? startAfterInstall,
    bool? uninstallBlock,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return PolicyApplication(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _is.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      sort: sort ?? this.sort,
      applicationId: applicationId ?? this.applicationId,
      application: application is _is.UndefinedSentinel
          ? this.application?.copyWith()
          : application,
      targetVersionId: targetVersionId is int?
          ? targetVersionId
          : this.targetVersionId,
      targetVersion: targetVersion is _is.UndefinedSentinel
          ? this.targetVersion?.copyWith()
          : targetVersion,
      action: action ?? this.action,
      showLauncher: showLauncher ?? this.showLauncher,
      customAppName: customAppName is String?
          ? customAppName
          : this.customAppName,
      runOnBoot: runOnBoot ?? this.runOnBoot,
      updatePolicy: updatePolicy is _i3xu12wm.AppAutoUpdatePolicy?
          ? updatePolicy
          : this.updatePolicy,
      startAfterInstall: startAfterInstall ?? this.startAfterInstall,
      uninstallBlock: uninstallBlock ?? this.uninstallBlock,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class PolicyApplicationUpdateTable
    extends _is.UpdateTable<PolicyApplicationTable> {
  PolicyApplicationUpdateTable(super.table);

  _is.ColumnValue<int, int> policyId(int value) => _is.ColumnValue(
    table.policyId,
    value,
  );

  _is.ColumnValue<int, int> sort(int value) => _is.ColumnValue(
    table.sort,
    value,
  );

  _is.ColumnValue<int, int> applicationId(int value) => _is.ColumnValue(
    table.applicationId,
    value,
  );

  _is.ColumnValue<int, int> targetVersionId(int? value) => _is.ColumnValue(
    table.targetVersionId,
    value,
  );

  _is.ColumnValue<
    _i3xu12wm.PolicyApplicationAction,
    _i3xu12wm.PolicyApplicationAction
  >
  action(_i3xu12wm.PolicyApplicationAction value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<bool, bool> showLauncher(bool value) => _is.ColumnValue(
    table.showLauncher,
    value,
  );

  _is.ColumnValue<String, String> customAppName(String? value) =>
      _is.ColumnValue(
        table.customAppName,
        value,
      );

  _is.ColumnValue<bool, bool> runOnBoot(bool value) => _is.ColumnValue(
    table.runOnBoot,
    value,
  );

  _is.ColumnValue<_i3xu12wm.AppAutoUpdatePolicy, _i3xu12wm.AppAutoUpdatePolicy>
  updatePolicy(_i3xu12wm.AppAutoUpdatePolicy? value) => _is.ColumnValue(
    table.updatePolicy,
    value,
  );

  _is.ColumnValue<bool, bool> startAfterInstall(bool value) => _is.ColumnValue(
    table.startAfterInstall,
    value,
  );

  _is.ColumnValue<bool, bool> uninstallBlock(bool value) => _is.ColumnValue(
    table.uninstallBlock,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class PolicyApplicationTable extends _is.Table<int?> {
  PolicyApplicationTable({super.tableRelation})
    : super(tableName: 'policy_applications') {
    updateTable = PolicyApplicationUpdateTable(this);
    policyId = _is.ColumnInt(
      'policyId',
      this,
    );
    sort = _is.ColumnInt(
      'sort',
      this,
    );
    applicationId = _is.ColumnInt(
      'applicationId',
      this,
    );
    targetVersionId = _is.ColumnInt(
      'targetVersionId',
      this,
    );
    action = _is.ColumnEnum(
      'action',
      this,
      _is.EnumSerialization.byName,
    );
    showLauncher = _is.ColumnBool(
      'showLauncher',
      this,
    );
    customAppName = _is.ColumnString(
      'customAppName',
      this,
    );
    runOnBoot = _is.ColumnBool(
      'runOnBoot',
      this,
    );
    updatePolicy = _is.ColumnEnum(
      'updatePolicy',
      this,
      _is.EnumSerialization.byName,
    );
    startAfterInstall = _is.ColumnBool(
      'startAfterInstall',
      this,
    );
    uninstallBlock = _is.ColumnBool(
      'uninstallBlock',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final PolicyApplicationUpdateTable updateTable;

  late final _is.ColumnInt policyId;

  _if7d246m.PolicyTable? _policy;

  late final _is.ColumnInt sort;

  late final _is.ColumnInt applicationId;

  _ice4s91e.ApplicationTable? _application;

  late final _is.ColumnInt targetVersionId;

  /// Removing a version keeps the pivot row and only clears the reference,
  /// matching the manual nulling in `ApplicationVersionService.onDeleting`.
  _il9v10p8.ApplicationVersionTable? _targetVersion;

  late final _is.ColumnEnum<_i3xu12wm.PolicyApplicationAction> action;

  late final _is.ColumnBool showLauncher;

  late final _is.ColumnString customAppName;

  late final _is.ColumnBool runOnBoot;

  late final _is.ColumnEnum<_i3xu12wm.AppAutoUpdatePolicy> updatePolicy;

  late final _is.ColumnBool startAfterInstall;

  late final _is.ColumnBool uninstallBlock;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _if7d246m.PolicyTable get policy {
    if (_policy != null) return _policy!;
    _policy = _is.createRelationTable(
      relationFieldName: 'policy',
      field: PolicyApplication.t.policyId,
      foreignField: _if7d246m.Policy.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _if7d246m.PolicyTable(tableRelation: foreignTableRelation),
    );
    return _policy!;
  }

  _ice4s91e.ApplicationTable get application {
    if (_application != null) return _application!;
    _application = _is.createRelationTable(
      relationFieldName: 'application',
      field: PolicyApplication.t.applicationId,
      foreignField: _ice4s91e.Application.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ice4s91e.ApplicationTable(tableRelation: foreignTableRelation),
    );
    return _application!;
  }

  _il9v10p8.ApplicationVersionTable get targetVersion {
    if (_targetVersion != null) return _targetVersion!;
    _targetVersion = _is.createRelationTable(
      relationFieldName: 'targetVersion',
      field: PolicyApplication.t.targetVersionId,
      foreignField: _il9v10p8.ApplicationVersion.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _il9v10p8.ApplicationVersionTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _targetVersion!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    policyId,
    sort,
    applicationId,
    targetVersionId,
    action,
    showLauncher,
    customAppName,
    runOnBoot,
    updatePolicy,
    startAfterInstall,
    uninstallBlock,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'policy') {
      return policy;
    }
    if (relationField == 'application') {
      return application;
    }
    if (relationField == 'targetVersion') {
      return targetVersion;
    }
    return null;
  }
}

class PolicyApplicationInclude extends _is.IncludeObject {
  PolicyApplicationInclude._({
    _if7d246m.PolicyInclude? policy,
    _ice4s91e.ApplicationInclude? application,
    _il9v10p8.ApplicationVersionInclude? targetVersion,
  }) {
    _policy = policy;
    _application = application;
    _targetVersion = targetVersion;
  }

  _if7d246m.PolicyInclude? _policy;

  _ice4s91e.ApplicationInclude? _application;

  _il9v10p8.ApplicationVersionInclude? _targetVersion;

  @override
  Map<String, _is.Include?> get includes => {
    'policy': _policy,
    'application': _application,
    'targetVersion': _targetVersion,
  };

  @override
  _is.Table<int?> get table => PolicyApplication.t;
}

class PolicyApplicationIncludeList extends _is.IncludeList {
  PolicyApplicationIncludeList._({
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PolicyApplication.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PolicyApplication.t;
}

class PolicyApplicationRepository {
  const PolicyApplicationRepository._();

  final attachRow = const PolicyApplicationAttachRowRepository._();

  final detachRow = const PolicyApplicationDetachRowRepository._();

  /// Returns a list of [PolicyApplication]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<PolicyApplication>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    _is.Transaction? transaction,
    PolicyApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PolicyApplication>(
      where: where?.call(PolicyApplication.t),
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PolicyApplication]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `PolicyApplication.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<PolicyApplication>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    PolicyApplicationInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PolicyApplication>(
      where: where?.call(PolicyApplication.t),
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PolicyApplication] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<PolicyApplication?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    int? offset,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    _is.Transaction? transaction,
    PolicyApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PolicyApplication>(
      where: where?.call(PolicyApplication.t),
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PolicyApplication] by its [id] or null if no such row exists.
  Future<PolicyApplication?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PolicyApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PolicyApplication>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PolicyApplication]s in the list and returns the inserted rows.
  ///
  /// The returned [PolicyApplication]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> insert(
    _is.DatabaseSession session,
    List<PolicyApplication> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PolicyApplication>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PolicyApplication] and returns the inserted row.
  ///
  /// The returned [PolicyApplication] will have its `id` field set.
  Future<PolicyApplication> insertRow(
    _is.DatabaseSession session,
    PolicyApplication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PolicyApplication>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PolicyApplication]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [PolicyApplication]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> upsert(
    _is.DatabaseSession session,
    List<PolicyApplication> rows, {
    required _is.ColumnSelections<PolicyApplicationTable> conflictColumns,
    _is.ColumnSelections<PolicyApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyApplicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PolicyApplication>(
      rows,
      conflictColumns: conflictColumns(PolicyApplication.t),
      updateColumns: updateColumns?.call(PolicyApplication.t),
      updateWhere: updateWhere?.call(PolicyApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PolicyApplication] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [PolicyApplication] will have its `id` field set.
  Future<PolicyApplication?> upsertRow(
    _is.DatabaseSession session,
    PolicyApplication row, {
    required _is.ColumnSelections<PolicyApplicationTable> conflictColumns,
    _is.ColumnSelections<PolicyApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyApplicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PolicyApplication>(
      row,
      conflictColumns: conflictColumns(PolicyApplication.t),
      updateColumns: updateColumns?.call(PolicyApplication.t),
      updateWhere: updateWhere?.call(PolicyApplication.t),
      transaction: transaction,
    );
  }

  /// Updates all [PolicyApplication]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> update(
    _is.DatabaseSession session,
    List<PolicyApplication> rows, {
    _is.ColumnSelections<PolicyApplicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PolicyApplication>(
      rows,
      columns: columns?.call(PolicyApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PolicyApplication]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PolicyApplication> updateRow(
    _is.DatabaseSession session,
    PolicyApplication row, {
    _is.ColumnSelections<PolicyApplicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PolicyApplication>(
      row,
      columns: columns?.call(PolicyApplication.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PolicyApplication] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PolicyApplication?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PolicyApplicationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PolicyApplication>(
      id,
      columnValues: columnValues(PolicyApplication.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PolicyApplication]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PolicyApplicationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PolicyApplicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PolicyApplication>(
      columnValues: columnValues(PolicyApplication.t.updateTable),
      where: where(PolicyApplication.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PolicyApplication]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> delete(
    _is.DatabaseSession session,
    List<PolicyApplication> rows, {
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PolicyApplication>(
      rows,
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PolicyApplication].
  Future<PolicyApplication> deleteRow(
    _is.DatabaseSession session,
    PolicyApplication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PolicyApplication>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyApplication>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyApplicationTable> where,
    _is.OrderByBuilder<PolicyApplicationTable>? orderBy,
    _is.OrderByListBuilder<PolicyApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PolicyApplication>(
      where: where(PolicyApplication.t),
      orderBy: orderBy?.call(PolicyApplication.t),
      orderByList: orderByList?.call(PolicyApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyApplicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PolicyApplication>(
      where: where?.call(PolicyApplication.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PolicyApplication] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyApplicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PolicyApplication>(
      where: where(PolicyApplication.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PolicyApplicationAttachRowRepository {
  const PolicyApplicationAttachRowRepository._();

  /// Creates a relation between the given [PolicyApplication] and [Policy]
  /// by setting the [PolicyApplication]'s foreign key `policyId` to refer to the [Policy].
  Future<void> policy(
    _is.DatabaseSession session,
    PolicyApplication policyApplication,
    _if7d246m.Policy policy, {
    _is.Transaction? transaction,
  }) async {
    if (policyApplication.id == null) {
      throw ArgumentError.notNull('policyApplication.id');
    }
    if (policy.id == null) {
      throw ArgumentError.notNull('policy.id');
    }

    var $policyApplication = policyApplication.copyWith(policyId: policy.id);
    await session.db.updateRow<PolicyApplication>(
      $policyApplication,
      columns: [PolicyApplication.t.policyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PolicyApplication] and [Application]
  /// by setting the [PolicyApplication]'s foreign key `applicationId` to refer to the [Application].
  Future<void> application(
    _is.DatabaseSession session,
    PolicyApplication policyApplication,
    _ice4s91e.Application application, {
    _is.Transaction? transaction,
  }) async {
    if (policyApplication.id == null) {
      throw ArgumentError.notNull('policyApplication.id');
    }
    if (application.id == null) {
      throw ArgumentError.notNull('application.id');
    }

    var $policyApplication = policyApplication.copyWith(
      applicationId: application.id,
    );
    await session.db.updateRow<PolicyApplication>(
      $policyApplication,
      columns: [PolicyApplication.t.applicationId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PolicyApplication] and [ApplicationVersion]
  /// by setting the [PolicyApplication]'s foreign key `targetVersionId` to refer to the [ApplicationVersion].
  Future<void> targetVersion(
    _is.DatabaseSession session,
    PolicyApplication policyApplication,
    _il9v10p8.ApplicationVersion targetVersion, {
    _is.Transaction? transaction,
  }) async {
    if (policyApplication.id == null) {
      throw ArgumentError.notNull('policyApplication.id');
    }
    if (targetVersion.id == null) {
      throw ArgumentError.notNull('targetVersion.id');
    }

    var $policyApplication = policyApplication.copyWith(
      targetVersionId: targetVersion.id,
    );
    await session.db.updateRow<PolicyApplication>(
      $policyApplication,
      columns: [PolicyApplication.t.targetVersionId],
      transaction: transaction,
    );
  }
}

class PolicyApplicationDetachRowRepository {
  const PolicyApplicationDetachRowRepository._();

  /// Detaches the relation between this [PolicyApplication] and the [ApplicationVersion] set in `targetVersion`
  /// by setting the [PolicyApplication]'s foreign key `targetVersionId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> targetVersion(
    _is.DatabaseSession session,
    PolicyApplication policyApplication, {
    _is.Transaction? transaction,
  }) async {
    if (policyApplication.id == null) {
      throw ArgumentError.notNull('policyApplication.id');
    }

    var $policyApplication = policyApplication.copyWith(targetVersionId: null);
    await session.db.updateRow<PolicyApplication>(
      $policyApplication,
      columns: [PolicyApplication.t.targetVersionId],
      transaction: transaction,
    );
  }
}
