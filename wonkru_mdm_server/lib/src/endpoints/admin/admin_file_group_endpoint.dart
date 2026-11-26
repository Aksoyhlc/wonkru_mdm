import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/file_group_service.dart';
import '../../util/like_pattern.dart';
import '../../util/page_params.dart';
import 'admin_audit.dart';

class AdminFileGroupEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<FileGroupPage> list(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final WhereExpressionBuilder<FileGroupTable>? where = search == null || search.isEmpty
        ? null
        : (t) => t.name.ilike(likeContains(search)) | t.description.ilike(likeContains(search));

    final total = await FileGroup.db.count(session, where: where);
    final items = await FileGroup.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    final counts = await FileGroupService.fileCounts(
      session,
      items.map((group) => group.id!),
    );

    return FileGroupPage(
      items: [
        for (final group in items) FileGroupRow(group: group, fileCount: counts[group.id] ?? 0),
      ],
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<FileGroup> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final fileGroup = await _require(session, id);

    await audit(
      session,
      action: 'file_group.view',
      targetType: 'file_group',
      targetId: id,
    );

    return fileGroup;
  }

  Future<List<int>> fileIds(Session session, int fileGroupId) async {
    await AdminAuthService.requireAdmin(session);

    final files = await FileGroupService.fileIdsInGroups(session, [
      fileGroupId,
    ]);

    return files.toList();
  }

  Future<FileGroup> create(Session session, FileGroup fileGroup) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    fileGroup
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final saved = await FileGroup.db.insertRow(session, fileGroup);

    await audit(
      session,
      action: 'file_group.create',
      targetType: 'file_group',
      targetId: saved.id,
    );

    return saved;
  }

  Future<FileGroup> update(Session session, FileGroup fileGroup) async {
    await AdminAuthService.requireAdmin(session);

    final groupId = fileGroup.id;
    if (groupId == null) {
      throw Exception('A file group id is required to update a group.');
    }

    final stored = await _require(session, groupId);

    fileGroup
      ..createdAt = stored.createdAt
      ..updatedAt = DateTime.now().toUtc();

    final updated = await FileGroup.db.updateRow(session, fileGroup);

    await audit(
      session,
      action: 'file_group.update',
      targetType: 'file_group',
      targetId: groupId,
    );

    return updated;
  }

  Future<int> delete(Session session, List<int> fileGroupIds) async {
    await AdminAuthService.requireAdmin(session);

    if (fileGroupIds.isEmpty) {
      return 0;
    }

    final deleted = await FileGroup.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(fileGroupIds.toSet()),
    );

    await audit(
      session,
      action: 'file_group.delete',
      targetType: 'file_group',
      data: {
        'ids': fileGroupIds,
        'count': deleted.length,
      },
    );

    return deleted.length;
  }

  Future<int> assignFiles(
    Session session,
    int fileGroupId,
    List<int> fileIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    await _require(session, fileGroupId);

    await session.db.transaction(
      (transaction) => FileGroupService.syncGroupFiles(
        session,
        fileGroupId,
        fileIds,
        transaction: transaction,
      ),
    );

    await audit(
      session,
      action: 'file_group.assign_files',
      targetType: 'file_group',
      targetId: fileGroupId,
      data: {
        'fileIds': fileIds,
        'count': fileIds.length,
      },
    );

    return fileIds.length;
  }

  static OrderByListBuilder<FileGroupTable> _orderBy(
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

  static Future<FileGroup> _require(Session session, int id) async {
    final fileGroup = await FileGroup.db.findById(session, id);
    if (fileGroup == null) {
      throw Exception('File group $id does not exist.');
    }

    return fileGroup;
  }
}
