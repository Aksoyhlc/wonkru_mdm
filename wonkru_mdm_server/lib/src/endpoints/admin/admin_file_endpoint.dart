import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../config/storage_config.dart';
import '../../enums/storage_area.dart';
import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/file_asset_service.dart';
import '../../service/file_group_service.dart';
import '../../service/storage_url_service.dart';
import '../../util/like_pattern.dart';
import '../../util/page_params.dart';
import 'admin_audit.dart';

class AdminFileEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  static const storageArea = StorageArea.files;

  static const storagePrefix = 'files';

  static const defaultDisk = StorageConfig.privateDisk;

  static const _nameLength = 40;

  static const _nameAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  static final _random = Random.secure();

  /// No display-name sort: it needs `COALESCE(custom_name, name)`, which the
  /// query builder cannot express.
  Future<FilePage> list(Session session, FileListRequest request) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);

    final search = _trimmed(request.search);
    final extensions = _clean(request.extensions);
    final mimeTypes = _clean(request.mimeTypes);

    final fileGroupIds = request.fileGroupIds;
    final groupFilter = fileGroupIds == null || fileGroupIds.isEmpty
        ? null
        : await FileGroupService.fileIdsInGroups(session, fileGroupIds);

    final hasFilters = search != null || extensions != null || mimeTypes != null || groupFilter != null;

    final WhereExpressionBuilder<FileAssetTable>? where = hasFilters
        ? (t) => _filters(
            t,
            search: search,
            extensions: extensions,
            mimeTypes: mimeTypes,
            fileIds: groupFilter,
          ).reduce((left, right) => left & right)
        : null;

    final total = await FileAsset.db.count(session, where: where);
    final items = await FileAsset.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    return FilePage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<FileAsset> get(Session session, int fileId) async {
    await AdminAuthService.requireAdmin(session);

    final file = await _require(session, fileId);

    await audit(
      session,
      action: 'file.view',
      targetType: 'file',
      targetId: fileId,
    );

    return file;
  }

  Future<List<int>> groupIds(Session session, int fileId) async {
    await AdminAuthService.requireAdmin(session);

    return FileGroupService.groupIdsForFile(session, fileId);
  }

  /// Fetched in one call for the visible rows, avoiding a query per row.
  Future<List<FileGroupMember>> groupMembersForFiles(
    Session session,
    List<int> fileIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final ids = fileIds.toSet();
    if (ids.isEmpty) {
      return const [];
    }

    return FileGroupMember.db.find(
      session,
      where: (t) => t.fileId.inSet(ids),
    );
  }

  /// Private files get a ten-minute signed URL named after the file; null when
  /// the file or its object is unreadable.
  Future<String?> downloadUrl(Session session, int fileId) async {
    await AdminAuthService.requireAdmin(session);

    final file = await FileAsset.db.findById(session, fileId);
    if (file == null || file.filePath.isEmpty) {
      return null;
    }

    final storageId = FileAssetService.storageIdFor(file.disk);

    try {
      final url = storageId == StorageConfig.publicDisk
          ? await session.storage.publicDownloadUrl(
              storageId: storageId,
              path: file.filePath,
            )
          : await session.storage.temporaryDownloadUrl(
              storageId: storageId,
              path: file.filePath,
              options: TemporaryDownloadUrlOptions(
                expirationDuration: const Duration(minutes: 10),
                downloadFileName: file.name,
              ),
            );

      final downloadUrl = url.toString();

      await audit(
        session,
        action: 'file.download',
        targetType: 'file',
        targetId: fileId,
      );

      return downloadUrl;
    } catch (_) {
      return null;
    }
  }

  Future<FileAsset> create(Session session, FileAsset file) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    file
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final saved = await session.db.transaction((transaction) async {
      final saved = await FileAsset.db.insertRow(
        session,
        file,
        transaction: transaction,
      );

      await FileAssetService.bumpAffectedPolicies(
        session,
        saved.id!,
        transaction: transaction,
      );

      return saved;
    });

    await audit(
      session,
      action: 'file.create',
      targetType: 'file',
      targetId: saved.id,
    );

    return saved;
  }

  Future<FileAsset> update(Session session, FileAsset file) async {
    await AdminAuthService.requireAdmin(session);

    final fileId = file.id;
    if (fileId == null) {
      throw Exception('A file id is required to update a file.');
    }

    final updated = await session.db.transaction((transaction) async {
      final stored = await _require(
        session,
        fileId,
        transaction: transaction,
      );

      file
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await FileAsset.db.updateRow(
        session,
        file,
        transaction: transaction,
      );

      await FileAssetService.bumpAffectedPolicies(
        session,
        fileId,
        transaction: transaction,
      );

      return saved;
    });

    await audit(
      session,
      action: 'file.update',
      targetType: 'file',
      targetId: fileId,
    );

    return updated;
  }

  /// Deletes files, their bytes and the policies shipping them.
  Future<int> delete(Session session, List<int> fileIds) async {
    await AdminAuthService.requireAdmin(session);

    if (fileIds.isEmpty) {
      return 0;
    }

    final deletedCount = await session.db.transaction((transaction) async {
      var deleted = 0;

      for (final fileId in fileIds) {
        final stored = await FileAsset.db.findById(
          session,
          fileId,
          transaction: transaction,
        );
        if (stored == null) {
          continue;
        }

        await FileAssetService.onDeleting(
          session,
          stored,
          transaction: transaction,
        );

        await FileAsset.db.deleteRow(
          session,
          stored,
          transaction: transaction,
        );

        deleted++;
      }

      return deleted;
    });

    await audit(
      session,
      action: 'file.delete',
      targetType: 'file',
      data: {
        'ids': fileIds,
        'count': deletedCount,
      },
    );

    return deletedCount;
  }

  Future<int> assignGroups(
    Session session,
    List<int> fileIds,
    List<int> fileGroupIds,
  ) async {
    await AdminAuthService.requireAdmin(session);

    if (fileIds.isEmpty) {
      return 0;
    }

    final assigned = await session.db.transaction((transaction) async {
      for (final fileId in fileIds) {
        await FileGroupService.syncFileGroups(
          session,
          fileId,
          fileGroupIds,
          transaction: transaction,
        );
      }

      return fileIds.length;
    });

    await audit(
      session,
      action: 'file.assign_groups',
      targetType: 'file',
      targetId: fileIds.length == 1 ? fileIds.single : null,
      data: {
        'fileIds': fileIds,
        'fileGroupIds': fileGroupIds,
        'count': assigned,
      },
    );

    return assigned;
  }

  Future<AdminFileUploadResponse> uploadFile(
    Session session,
    AdminFileUploadRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final disk = storageArea.diskFor(request.disk);

    final bytes = _bytes(request.byteData);
    final extension = _extension(request.fileName);
    final path = storageArea.pathFor(
      '${_randomName()}${extension.isEmpty ? '' : '.$extension'}',
    );

    await session.storage.storeFile(
      storageId: disk,
      path: path,
      byteData: request.byteData,
    );

    final response = AdminFileUploadResponse(
      filePath: path,
      disk: disk,
      fileHashSha256: sha256.convert(bytes).toString(),
      sizeBytes: bytes.lengthInBytes,
      fileExtension: extension.isEmpty ? null : extension,
      mimeType: _trimmed(request.mimeType),
      publicUrl: disk == StorageConfig.publicDisk ? await StorageUrlService.publicUrl(session, path) : null,
    );

    await audit(
      session,
      action: 'file.upload',
      targetType: 'file',
      data: {
        'fileName': request.fileName,
        'filePath': response.filePath,
        'disk': response.disk,
      },
    );

    return response;
  }

  static List<Expression> _filters(
    FileAssetTable t, {
    required String? search,
    required Set<String>? extensions,
    required Set<String>? mimeTypes,
    required Set<int>? fileIds,
  }) {
    final expressions = <Expression>[];

    if (search != null) {
      expressions.add(
        t.name.ilike(likeContains(search)) |
            t.customName.ilike(likeContains(search)) |
            t.filePath.ilike(likeContains(search)) |
            t.publicUrl.ilike(likeContains(search)) |
            t.fileHashSha256.ilike(likeContains(search)),
      );
    }

    if (extensions != null) {
      expressions.add(t.fileExtension.inSet(extensions));
    }

    if (mimeTypes != null) {
      expressions.add(t.mimeType.inSet(mimeTypes));
    }

    if (fileIds != null) {
      expressions.add(fileIds.isEmpty ? t.id.equals(-1) : t.id.inSet(fileIds));
    }

    return expressions;
  }

  static OrderByListBuilder<FileAssetTable> _orderBy(FileListRequest request) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'fileExtension' => [
        descending ? t.fileExtension.desc() : t.fileExtension.asc(),
      ],
      'sizeBytes' => [descending ? t.sizeBytes.desc() : t.sizeBytes.asc()],
      'disk' => [descending ? t.disk.desc() : t.disk.asc()],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      'updatedAt' => [descending ? t.updatedAt.desc() : t.updatedAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<FileAsset> _require(
    Session session,
    int fileId, {
    Transaction? transaction,
  }) async {
    final file = await FileAsset.db.findById(
      session,
      fileId,
      transaction: transaction,
    );
    if (file == null) {
      throw Exception('File $fileId does not exist.');
    }

    return file;
  }

  static String? _trimmed(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static Set<String>? _clean(List<String>? values) {
    if (values == null) {
      return null;
    }

    final cleaned = <String>{};
    for (final value in values) {
      final trimmed = _trimmed(value);
      if (trimmed != null) {
        cleaned.add(trimmed);
      }
    }

    return cleaned.isEmpty ? null : cleaned;
  }

  static Uint8List _bytes(ByteData data) => data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  static String _extension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return '';
    }

    return fileName.substring(dot + 1).toLowerCase();
  }

  static String _randomName() {
    final buffer = StringBuffer();
    for (var i = 0; i < _nameLength; i++) {
      buffer.write(_nameAlphabet[_random.nextInt(_nameAlphabet.length)]);
    }

    return buffer.toString();
  }
}
