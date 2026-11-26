import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/future_calls.dart';
import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/policy_application_service.dart';
import '../../service/policy_certificate_service.dart';
import '../../service/policy_clone_service.dart';
import '../../service/policy_file_service.dart';
import '../../service/policy_payload_service.dart';
import '../../service/policy_service.dart';
import '../../service/policy_slug_service.dart';
import '../../service/setting_service.dart';
import '../../util/app_date_time.dart';
import '../../util/csv.dart';
import '../../util/like_pattern.dart';
import '../../util/page_params.dart';
import 'admin_audit.dart';

class AdminPolicyEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  static const exportHeaders = <String>[
    'id',
    'name',
    'slug',
    'is_active',
    'default_policy',
    'version',
    'updated_at',
  ];

  Future<PolicyPage> list(Session session, PolicyListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final where = _whereBuilder(request);

    final total = await Policy.db.count(session, where: where);
    final items = await Policy.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    return PolicyPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<ByteData> export(Session session, PolicyListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final rows = await Policy.db.find(
      session,
      where: _whereBuilder(request),
      limit: PageParams.maxExportRows,
      orderByList: _orderBy(request),
    );

    await audit(session, action: 'policy.export');

    return csvBytes(_toCsv(rows));
  }

  Future<int> sendToDevices(Session session, int policyId) async {
    await AdminAuthService.requireAdmin(session);

    await _require(session, policyId);

    final count = await Device.db.count(
      session,
      where: (t) => t.policyId.equals(policyId),
    );

    await session.serverpod.futureCalls
        .callWithDelay(Duration.zero)
        .sendPolicy
        .send(SendPolicyCall(policyId: policyId));

    await audit(
      session,
      action: 'policy.send_to_devices',
      targetType: 'policy',
      targetId: policyId,
      data: {'device_count': count},
    );

    return count;
  }

  Future<Policy> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);
    final policy = await _require(session, id);
    await audit(
      session,
      action: 'policy.view',
      targetType: 'policy',
      targetId: id,
    );
    return policy;
  }

  Future<Policy> create(Session session, Policy policy) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    policy
      ..id = null
      ..createdAt = now
      ..updatedAt = now;
    PolicyService.validateSettings(policy);
    await PolicyService.applySavingRules(policy);
    policy.slug = await _resolveSlug(session, policy.name, policy.slug);

    final created = await Policy.db.insertRow(session, policy);

    await audit(
      session,
      action: 'policy.create',
      targetType: 'policy',
      targetId: created.id,
      data: {'slug': created.slug},
    );

    return created;
  }

  Future<Policy> update(Session session, Policy policy) async {
    await AdminAuthService.requireAdmin(session);

    final policyId = policy.id;
    if (policyId == null) {
      throw Exception('A policy id is required to update a policy.');
    }
    PolicyService.validateSettings(policy);

    final updated = await session.db.transaction((transaction) async {
      final stored = await Policy.db.findById(
        session,
        policyId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Policy $policyId does not exist.');
      }

      await PolicyService.applySavingRules(policy, previous: stored);

      policy.slug = await _resolveSlug(
        session,
        policy.name,
        policy.slug,
        transaction: transaction,
        exceptPolicyId: policyId,
        fallback: stored.slug,
      );

      policy
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await Policy.db.updateRow(
        session,
        policy,
        transaction: transaction,
      );

      await PolicyService.onUpdated(session, saved, previous: stored);
      return saved;
    });

    await audit(
      session,
      action: 'policy.update',
      targetType: 'policy',
      targetId: policyId,
      data: {'slug': updated.slug},
    );

    return updated;
  }

  Future<void> delete(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    await session.db.transaction((transaction) async {
      final stored = await Policy.db.findById(
        session,
        id,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Policy $id does not exist.');
      }

      await PolicyService.onDeleting(session, stored, transaction: transaction);
      await Policy.db.deleteRow(session, stored, transaction: transaction);
    });

    await audit(
      session,
      action: 'policy.delete',
      targetType: 'policy',
      targetId: id,
    );
  }

  /// Saving invalidates both the previous and the new policy via [SettingService].
  Future<void> setDefault(Session session, int policyId) async {
    await AdminAuthService.requireAdmin(session);

    final target = await _require(session, policyId);

    await session.db.transaction((transaction) async {
      await Policy.db.updateWhere(
        session,
        where: (t) => t.defaultPolicy.equals(true) & t.id.notEquals(policyId),
        columnValues: (t) => [t.defaultPolicy(false)],
        transaction: transaction,
      );

      if (!target.defaultPolicy) {
        target
          ..defaultPolicy = true
          ..updatedAt = DateTime.now().toUtc();
        await Policy.db.updateRow(session, target, transaction: transaction);
      }

      await SettingService.save(
        session,
        SettingService.defaultPolicyKey,
        policyId.toString(),
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'policy.set_default',
      targetType: 'policy',
      targetId: policyId,
    );
  }

  Future<Policy> duplicate(Session session, int id, {String? newName}) async {
    await AdminAuthService.requireAdmin(session);

    final policy = await _require(session, id);

    final duplicated = await session.db.transaction(
      (transaction) => PolicyCloneService.duplicate(
        session,
        policy,
        newName: newName,
        transaction: transaction,
      ),
    );

    await audit(
      session,
      action: 'policy.duplicate',
      targetType: 'policy',
      targetId: duplicated.id,
    );

    return duplicated;
  }

  Future<String> preview(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);
    final payload = await PolicyPayloadService.buildJson(
      session,
      await _require(session, id),
    );
    await audit(
      session,
      action: 'policy.preview',
      targetType: 'policy',
      targetId: id,
    );
    return payload;
  }

  Future<List<PolicyApplication>> applications(
    Session session,
    int policyId,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return PolicyApplication.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      orderBy: (t) => t.sort,
      include: PolicyApplication.include(application: Application.include()),
    );
  }

  Future<List<PolicyFile>> files(Session session, int policyId) async {
    await AdminAuthService.requireAdmin(session);

    return PolicyFile.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      orderBy: (t) => t.id,
    );
  }

  Future<List<PolicyCertificate>> certificates(
    Session session,
    int policyId,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return PolicyCertificate.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      orderBy: (t) => t.id,
    );
  }

  Future<PolicyApplication> attachApplication(
    Session session,
    PolicyApplication entry,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final attached = await PolicyApplicationService.attach(session, entry);

    await audit(
      session,
      action: 'policy.application_attach',
      targetType: 'policy',
      targetId: attached.policyId,
      data: {'application_id': attached.applicationId},
    );

    return attached;
  }

  Future<PolicyApplication> updateApplication(
    Session session,
    PolicyApplication entry,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final updated = await PolicyApplicationService.update(session, entry);

    await audit(
      session,
      action: 'policy.application_update',
      targetType: 'policy',
      targetId: updated.policyId,
      data: {'pivot_id': updated.id},
    );

    return updated;
  }

  Future<void> detachApplication(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final affectedPolicyId = await PolicyApplicationService.detach(session, id);

    await audit(
      session,
      action: 'policy.application_detach',
      targetType: 'policy',
      targetId: affectedPolicyId,
      data: {'pivot_id': id},
    );
  }

  Future<void> reorderApplications(
    Session session,
    int policyId,
    List<int> entryIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    await PolicyApplicationService.reorder(session, policyId, entryIds);
  }

  /// Upserts on the `(policyId, fileId)` unique index; a blind insert would raise
  /// a raw Postgres violation.
  Future<PolicyFile> attachFile(Session session, PolicyFile entry) async {
    await AdminAuthService.requireAdmin(session);

    final attached = await PolicyFileService.attach(session, entry);

    await audit(
      session,
      action: 'policy.file_attach',
      targetType: 'policy',
      targetId: attached.policyId,
      data: {'file_id': attached.fileId},
    );

    return attached;
  }

  Future<PolicyFile> updateFile(Session session, PolicyFile entry) async {
    await AdminAuthService.requireAdmin(session);

    final updated = await PolicyFileService.update(session, entry);

    await audit(
      session,
      action: 'policy.file_update',
      targetType: 'policy',
      targetId: updated.policyId,
      data: {'pivot_id': updated.id},
    );

    return updated;
  }

  Future<void> detachFile(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final affectedPolicyId = await PolicyFileService.detach(session, id);

    await audit(
      session,
      action: 'policy.file_detach',
      targetType: 'policy',
      targetId: affectedPolicyId,
      data: {'pivot_id': id},
    );
  }

  Future<PolicyCertificate> attachCertificate(
    Session session,
    PolicyCertificate entry,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final attached = await PolicyCertificateService.attach(session, entry);

    await audit(
      session,
      action: 'policy.certificate_attach',
      targetType: 'policy',
      targetId: attached.policyId,
      data: {'certificate_id': attached.certificateId},
    );

    return attached;
  }

  Future<PolicyCertificate> updateCertificate(
    Session session,
    PolicyCertificate entry,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final updated = await PolicyCertificateService.update(session, entry);

    await audit(
      session,
      action: 'policy.certificate_update',
      targetType: 'policy',
      targetId: updated.policyId,
      data: {'pivot_id': updated.id},
    );

    return updated;
  }

  Future<void> detachCertificate(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final affectedPolicyId = await PolicyCertificateService.detach(session, id);

    await audit(
      session,
      action: 'policy.certificate_detach',
      targetType: 'policy',
      targetId: affectedPolicyId,
      data: {'pivot_id': id},
    );
  }

  static OrderByListBuilder<PolicyTable> _orderBy(PolicyListRequest request) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'slug' => [descending ? t.slug.desc() : t.slug.asc()],
      'version' => [descending ? t.version.desc() : t.version.asc()],
      'updatedAt' => [descending ? t.updatedAt.desc() : t.updatedAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<String> _resolveSlug(
    Session session,
    String name,
    String? provided, {
    Transaction? transaction,
    int? exceptPolicyId,
    String? fallback,
  }) async {
    final trimmed = provided?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      if (fallback != null && fallback.isNotEmpty) {
        return fallback;
      }

      return PolicySlugService.unique(
        session,
        name,
        transaction: transaction,
        exceptPolicyId: exceptPolicyId,
      );
    }

    if (await PolicySlugService.isTaken(
      session,
      trimmed,
      transaction: transaction,
      exceptPolicyId: exceptPolicyId,
    )) {
      throw Exception('Slug "$trimmed" is already in use.');
    }

    return trimmed;
  }

  /// Null when nothing filters the list, letting the ORM skip the where clause.
  static WhereExpressionBuilder<PolicyTable>? _whereBuilder(
    PolicyListRequest request,
  ) {
    final search = request.search?.trim();
    final hasSearch = search != null && search.isNotEmpty;
    final hasActive = request.isActive != null;
    final hasDefault = request.defaultPolicy != null;

    if (!hasSearch && !hasActive && !hasDefault) {
      return null;
    }

    return (t) {
      final expressions = <Expression>[];
      if (hasSearch) {
        expressions.add(
          t.name.ilike(likeContains(search)) | t.slug.ilike(likeContains(search)),
        );
      }
      if (hasActive) {
        expressions.add(t.isActive.equals(request.isActive));
      }
      if (hasDefault) {
        expressions.add(t.defaultPolicy.equals(request.defaultPolicy));
      }

      return expressions.reduce((left, right) => left & right);
    };
  }

  static String _toCsv(List<Policy> policies) => csvDocument(exportHeaders, [
    for (final policy in policies)
      [
        policy.id?.toString() ?? '',
        policy.name,
        policy.slug ?? '',
        policy.isActive.toString(),
        policy.defaultPolicy.toString(),
        policy.version.toString(),
        formatDateTime(policy.updatedAt),
      ],
  ]);

  static Future<Policy> _require(Session session, int id) async {
    final policy = await Policy.db.findById(session, id);
    if (policy == null) {
      throw Exception('Policy $id does not exist.');
    }

    return policy;
  }
}
