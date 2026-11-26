import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/enrollment_key_service.dart';
import '../../service/provisioning_profile_service.dart';
import '../../service/setting_service.dart';
import '../../util/like_pattern.dart';
import 'admin_audit.dart';

class AdminProvisioningProfileEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<ProvisioningProfilePage> list(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final WhereExpressionBuilder<ProvisioningProfileTable>? where =
        search == null || search.isEmpty
        ? null
        : (t) => t.name.ilike(likeContains(search));

    final total = await ProvisioningProfile.db.count(session, where: where);
    final items = await ProvisioningProfile.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    final key = await EnrollmentKeyService.current(session);
    final initial = await _initialProfileId(session);
    for (final item in items) {
      await _render(session, item, key, initial);
    }

    return ProvisioningProfilePage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<ProvisioningProfile> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);
    final profile = await _render(
      session,
      await _require(session, id),
      await EnrollmentKeyService.current(session),
      await _initialProfileId(session),
    );
    await audit(
      session,
      action: 'provisioning_profile.view',
      targetType: 'provisioning_profile',
      targetId: id,
    );
    return profile;
  }

  Future<String> defaultConfig(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return ProvisioningProfileService.defaultConfig(session);
  }

  Future<ProvisioningProfile> create(
    Session session,
    ProvisioningProfile profile,
  ) async {
    final admin = await AdminAuthService.requireAdmin(session);
    ProvisioningProfileService.validateWifi(profile.config);
    final now = DateTime.now().toUtc();

    profile
      ..id = null
      ..createdById = admin.userId
      ..createdAt = now
      ..updatedAt = now
      ..config = ProvisioningProfileService.withEnrollmentKey(
        profile.config,
        null,
      );

    final created = _injectKey(
      await ProvisioningProfile.db.insertRow(session, profile),
      await EnrollmentKeyService.current(session),
    );

    await audit(
      session,
      action: 'provisioning_profile.create',
      targetType: 'provisioning_profile',
      targetId: created.id,
    );

    return created;
  }

  Future<ProvisioningProfile> update(
    Session session,
    ProvisioningProfile profile,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final profileId = profile.id;
    if (profileId == null) {
      throw Exception('A provisioning profile id is required to update it.');
    }

    ProvisioningProfileService.validateWifi(profile.config);

    final key = await EnrollmentKeyService.current(session);

    final updated = await session.db.transaction((transaction) async {
      final stored = await ProvisioningProfile.db.findById(
        session,
        profileId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Provisioning profile $profileId does not exist.');
      }

      stored
        ..name = profile.name
        ..description = profile.description
        ..config = ProvisioningProfileService.withEnrollmentKey(
          profile.config,
          null,
        )
        ..isActive = profile.isActive
        ..updatedAt = DateTime.now().toUtc();

      return ProvisioningProfile.db.updateRow(
        session,
        stored,
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'provisioning_profile.update',
      targetType: 'provisioning_profile',
      targetId: profileId,
    );

    return _render(session, updated, key, await _initialProfileId(session));
  }

  static Future<int?> _initialProfileId(Session session) =>
      SettingService.getInt(
        session,
        ProvisioningProfileService.initialProfileSetting,
      );

  static Future<ProvisioningProfile> _render(
    Session session,
    ProvisioningProfile profile,
    String key,
    int? initialId,
  ) async {
    if (initialId == null || profile.id != initialId) {
      return _injectKey(profile, key);
    }
    profile.config = await ProvisioningProfileService.resolveInitialTemplate(
      session,
      profile.config,
      key,
    );
    return profile;
  }

  static ProvisioningProfile _injectKey(
    ProvisioningProfile profile,
    String key,
  ) => profile
    ..config = ProvisioningProfileService.withEnrollmentKey(
      profile.config,
      key,
    );

  Future<int> delete(Session session, List<int> profileIds) async {
    await AdminAuthService.requireAdmin(session);

    if (profileIds.isEmpty) {
      return 0;
    }

    final deleted = await ProvisioningProfile.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(profileIds.toSet()),
    );

    await audit(
      session,
      action: 'provisioning_profile.delete',
      targetType: 'provisioning_profile',
      data: {'ids': profileIds, 'count': deleted.length},
    );

    return deleted.length;
  }

  static OrderByListBuilder<ProvisioningProfileTable> _orderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'isActive' => [descending ? t.isActive.desc() : t.isActive.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<ProvisioningProfile> _require(
    Session session,
    int id, {
    Transaction? transaction,
  }) async {
    final profile = await ProvisioningProfile.db.findById(
      session,
      id,
      transaction: transaction,
    );
    if (profile == null) {
      throw Exception('Provisioning profile $id does not exist.');
    }

    return profile;
  }
}
