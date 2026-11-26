import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../enums/storage_area.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/application_service.dart';
import '../../service/application_version_service.dart';
import '../../util/apk_package.dart';
import '../../util/like_pattern.dart';
import '../../util/csv.dart';
import 'admin_audit.dart';

/// Every write runs in a transaction with its service call so policy versions
/// stay in step, rolling both back on failure.
class AdminApplicationEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  static const exportHeaders = <String>[
    'id',
    'packageName',
    'appName',
    'developerName',
    'category',
    'sourceType',
    'isSystemApp',
  ];

  static const storageArea = StorageArea.applications;

  static const storagePrefix = 'applications';

  static const _nameLength = 40;

  static const _nameAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  static final _random = Random.secure();

  Future<ApplicationPage> listApplications(
    Session session,
    ApplicationListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final where = _whereBuilder(request);

    final total = await Application.db.count(session, where: where);
    final items = await Application.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _applicationOrderBy(request),
    );

    final versionCounts = await _versionCounts(session, [
      for (final item in items)
        if (item.id != null) item.id!,
    ]);

    return ApplicationPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
      versionCounts: versionCounts,
    );
  }

  /// Total version count per application, including inactive versions.
  static Future<Map<int, int>> _versionCounts(
    Session session,
    List<int> applicationIds,
  ) async {
    if (applicationIds.isEmpty) return const <int, int>{};
    final versions = await ApplicationVersion.db.find(
      session,
      where: (t) => t.applicationId.inSet(applicationIds.toSet()),
    );
    final counts = <int, int>{};
    for (final version in versions) {
      final id = version.applicationId;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    return counts;
  }

  /// The CSV is built from every matching row, not just the current page.
  Future<ByteData> export(
    Session session,
    ApplicationListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final rows = await Application.db.find(
      session,
      where: _whereBuilder(request),
      limit: PageParams.maxExportRows,
      orderByList: _applicationOrderBy(request),
    );

    await audit(session, action: 'application.export');

    return csvBytes(_toCsv(rows));
  }

  Future<Application> getApplication(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final application = await _requireApplication(session, id);

    await audit(
      session,
      action: 'application.view',
      targetType: 'application',
      targetId: id,
    );

    return application;
  }

  /// A package name may only be registered once; a clash throws
  /// [ApplicationConflictException] carrying the existing row.
  Future<Application> createApplication(
    Session session,
    Application application,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    application
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final existing = await _findByPackageName(
      session,
      application.packageName,
    );
    if (existing != null) {
      throw ApplicationConflictException(
        message: _packageTakenMessage(application.packageName),
        existingApplication: existing,
      );
    }

    try {
      final created = await Application.db.insertRow(session, application);

      await audit(
        session,
        action: 'application.create',
        targetType: 'application',
        targetId: created.id,
      );

      return created;
    } on DatabaseUniqueViolationException {
      // Race: the same package was written between this check and the insert.
      throw ApplicationConflictException(
        message: _packageTakenMessage(application.packageName),
        existingApplication: await _findByPackageName(
          session,
          application.packageName,
        ),
      );
    }
  }

  Future<Application> updateApplication(
    Session session,
    Application application,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final applicationId = application.id;
    if (applicationId == null) {
      throw Exception(
        'An application id is required to update an application.',
      );
    }

    final saved = await session.db.transaction((transaction) async {
      final stored = await Application.db.findById(
        session,
        applicationId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Application $applicationId does not exist.');
      }

      // Creation time belongs to the server; a client-sent value is ignored.
      application
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final updated = await Application.db.updateRow(
        session,
        application,
        transaction: transaction,
      );

      await ApplicationService.bumpAffectedPolicies(
        session,
        applicationId,
        transaction: transaction,
      );

      return updated;
    });

    await audit(
      session,
      action: 'application.update',
      targetType: 'application',
      targetId: applicationId,
    );

    return saved;
  }

  Future<void> deleteApplication(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);
    await _deleteApplication(session, id);

    await audit(
      session,
      action: 'application.delete',
      targetType: 'application',
      targetId: id,
    );
  }

  /// Deletes each application in its own transaction, so one failure leaves the
  /// others deleted; returns the count removed.
  Future<int> deleteApplications(Session session, List<int> ids) async {
    await AdminAuthService.requireAdmin(session);

    var deleted = 0;
    for (final id in ids.toSet()) {
      await _deleteApplication(session, id);
      deleted++;
    }

    await audit(
      session,
      action: 'application.delete',
      targetType: 'application',
      targetId: null,
      data: {'ids': ids.toSet().toList(), 'count': deleted},
    );

    return deleted;
  }

  Future<void> _deleteApplication(Session session, int id) async {
    await session.db.transaction((transaction) async {
      final stored = await Application.db.findById(
        session,
        id,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Application $id does not exist.');
      }

      await ApplicationService.onDeleting(
        session,
        id,
        transaction: transaction,
      );

      await Application.db.deleteRow(
        session,
        stored,
        transaction: transaction,
      );
    });
  }

  Future<ApplicationVersionPage> listVersions(
    Session session,
    int applicationId,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    Expression scope(ApplicationVersionTable t) =>
        search == null || search.isEmpty
        ? t.applicationId.equals(applicationId)
        : t.applicationId.equals(applicationId) &
              t.versionName.ilike(likeContains(search));

    final total = await ApplicationVersion.db.count(session, where: scope);
    final items = await ApplicationVersion.db.find(
      session,
      where: scope,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _versionOrderBy(request),
    );

    return ApplicationVersionPage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<ApplicationVersion> getVersion(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final version = await _requireVersion(session, id);

    await audit(
      session,
      action: 'application_version.view',
      targetType: 'application_version',
      targetId: id,
    );

    return version;
  }

  /// The APK's manifest package must match the application it joins (unreadable
  /// manifests pass). `(applicationId, versionCode)` is unique, so a clash throws
  /// [ApplicationConflictException].
  Future<ApplicationVersion> createVersion(
    Session session,
    ApplicationVersion version,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final application = await _requireApplication(
      session,
      version.applicationId,
    );
    final filePath = version.filePath;
    if (filePath != null) {
      await _requireStoredApkMatches(session, application, filePath);
    }

    final duplicate = await ApplicationVersion.db.findFirstRow(
      session,
      where: (t) =>
          t.applicationId.equals(version.applicationId) &
          t.versionCode.equals(version.versionCode),
    );
    if (duplicate != null) {
      throw ApplicationConflictException(
        message:
            'Version code ${version.versionCode} already exists for this '
            'application.',
      );
    }

    version.id = null;

    final created = await session.db.transaction(
      (transaction) => _createVersion(session, version, transaction),
    );

    await audit(
      session,
      action: 'application_version.create',
      targetType: 'application_version',
      targetId: created.id,
      data: {'applicationId': created.applicationId},
    );

    return created;
  }

  Future<ApplicationVersion> updateVersion(
    Session session,
    ApplicationVersion version,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final versionId = version.id;
    if (versionId == null) {
      throw Exception('A version id is required to update a version.');
    }

    final saved = await session.db.transaction((transaction) async {
      final stored = await ApplicationVersion.db.findById(
        session,
        versionId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Application version $versionId does not exist.');
      }

      // Verify the APK matches its new owner only when the file or its
      // application changed; metadata-only updates never read the file.
      final filePath = version.filePath;
      final movedApplication = version.applicationId != stored.applicationId;
      final replacedFile = filePath != null && filePath != stored.filePath;
      if (filePath != null && (movedApplication || replacedFile)) {
        final application = await _requireApplication(
          session,
          version.applicationId,
          transaction: transaction,
        );
        await _requireStoredApkMatches(session, application, filePath);
      }

      return _updateVersion(
        session,
        version,
        wasDefault: stored.isDefault,
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'application_version.update',
      targetType: 'application_version',
      targetId: versionId,
    );

    return saved;
  }

  /// Unpins the entries on this version, then hands the default flag to the
  /// newest remaining version.
  Future<void> deleteVersion(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    await session.db.transaction((transaction) async {
      final stored = await ApplicationVersion.db.findById(
        session,
        id,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Application version $id does not exist.');
      }

      await ApplicationVersionService.onDeleting(
        session,
        stored,
        transaction: transaction,
      );

      await ApplicationVersion.db.deleteRow(
        session,
        stored,
        transaction: transaction,
      );

      await ApplicationVersionService.onDeleted(
        session,
        stored,
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'application_version.delete',
      targetType: 'application_version',
      targetId: id,
    );
  }

  /// Stores an uploaded APK and creates or refreshes its version. Upserts on
  /// `(applicationId, versionCode)`: re-uploading replaces the file.
  Future<ApplicationVersion> uploadVersion(
    Session session,
    AdminApplicationVersionUploadRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final bytes = _bytes(request.byteData);
    final path = storageArea.pathFor(
      '${_randomName()}${_extension(request.fileName)}',
    );

    final saved = await session.db.transaction((transaction) async {
      final application = await Application.db.findById(
        session,
        request.applicationId,
        transaction: transaction,
      );
      if (application == null) {
        throw Exception('Application ${request.applicationId} does not exist.');
      }

      _requireMatchingPackage(application, apkPackageName(bytes));

      await session.storage.storeFile(
        storageId: storageArea.defaultDisk,
        path: path,
        byteData: request.byteData,
      );

      final checksum = sha256.convert(bytes).toString();
      final permissions = request.permissions == null
          ? null
          : jsonEncode(request.permissions);

      final existing = await ApplicationVersion.db.findFirstRow(
        session,
        where: (t) =>
            t.applicationId.equals(request.applicationId) &
            t.versionCode.equals(request.versionCode),
        transaction: transaction,
      );

      if (existing == null) {
        return _createVersion(
          session,
          ApplicationVersion(
            applicationId: request.applicationId,
            versionName: request.versionName,
            versionCode: request.versionCode,
            filePath: path,
            fileSizeBytes: bytes.lengthInBytes,
            checksumSha256: checksum,
            minSdkVersion: request.minSdkVersion,
            targetSdkVersion: request.targetSdkVersion,
            permissions: permissions,
            isActive: true,
          ),
          transaction,
        );
      }

      final wasDefault = existing.isDefault;
      existing
        ..versionName = request.versionName
        ..filePath = path
        ..fileSizeBytes = bytes.lengthInBytes
        ..checksumSha256 = checksum
        ..minSdkVersion = request.minSdkVersion
        ..targetSdkVersion = request.targetSdkVersion
        ..permissions = permissions
        ..isActive = true;

      return _updateVersion(
        session,
        existing,
        wasDefault: wasDefault,
        transaction: transaction,
      );
    });

    await audit(
      session,
      action: 'application_version.upload',
      targetType: 'application_version',
      targetId: saved.id,
      data: {'applicationId': saved.applicationId},
    );

    return saved;
  }

  static Future<ApplicationVersion> _createVersion(
    Session session,
    ApplicationVersion version,
    Transaction transaction,
  ) async {
    final now = DateTime.now().toUtc();
    version
      ..createdAt = now
      ..updatedAt = now;

    await ApplicationVersionService.clearOtherDefaults(
      session,
      version,
      transaction: transaction,
    );

    final saved = await ApplicationVersion.db.insertRow(
      session,
      version,
      transaction: transaction,
    );

    await ApplicationVersionService.onCreated(
      session,
      saved,
      transaction: transaction,
    );

    return saved;
  }

  static Future<ApplicationVersion> _updateVersion(
    Session session,
    ApplicationVersion version, {
    required bool wasDefault,
    required Transaction transaction,
  }) async {
    version.updatedAt = DateTime.now().toUtc();

    await ApplicationVersionService.clearOtherDefaults(
      session,
      version,
      transaction: transaction,
    );

    final saved = await ApplicationVersion.db.updateRow(
      session,
      version,
      transaction: transaction,
    );

    await ApplicationVersionService.onUpdated(
      session,
      saved,
      becameNonDefault: wasDefault && !saved.isDefault,
      transaction: transaction,
    );

    return saved;
  }

  /// Null when nothing filters the list, letting the ORM skip the where clause.
  static WhereExpressionBuilder<ApplicationTable>? _whereBuilder(
    ApplicationListRequest request,
  ) {
    final search = request.search?.trim();
    final hasSearch = search != null && search.isNotEmpty;
    final sourceType = _sourceType(request.sourceType);
    final hasSourceType = sourceType != null;
    final category = request.category?.trim();
    final hasCategory = category != null && category.isNotEmpty;
    final hasSystemApp = request.isSystemApp != null;

    if (!hasSearch && !hasSourceType && !hasCategory && !hasSystemApp) {
      return null;
    }

    return (t) {
      final expressions = <Expression>[];
      if (hasSearch) {
        expressions.add(
          t.packageName.ilike(likeContains(search)) |
              t.appName.ilike(likeContains(search)),
        );
      }
      if (hasSourceType) {
        expressions.add(t.sourceType.equals(sourceType));
      }
      if (hasCategory) {
        expressions.add(t.category.equals(category));
      }
      if (hasSystemApp) {
        expressions.add(t.isSystemApp.equals(request.isSystemApp));
      }

      return expressions.reduce((left, right) => left & right);
    };
  }

  static AppSourceType? _sourceType(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final type in AppSourceType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return null;
  }

  static String _toCsv(List<Application> applications) =>
      csvDocument(exportHeaders, [
        for (final application in applications)
          [
            application.id?.toString() ?? '',
            application.packageName,
            application.appName,
            application.developerName ?? '',
            application.category ?? '',
            application.sourceType?.name ?? '',
            application.isSystemApp.toString(),
          ],
      ]);

  static OrderByListBuilder<ApplicationTable> _applicationOrderBy(
    ApplicationListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'packageName' => [
        descending ? t.packageName.desc() : t.packageName.asc(),
      ],
      'appName' => [descending ? t.appName.desc() : t.appName.asc()],
      'updatedAt' => [descending ? t.updatedAt.desc() : t.updatedAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static OrderByListBuilder<ApplicationVersionTable> _versionOrderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'versionName' => [
        descending ? t.versionName.desc() : t.versionName.asc(),
      ],
      'versionCode' => [
        descending ? t.versionCode.desc() : t.versionCode.asc(),
      ],
      'createdAt' => [descending ? t.createdAt.desc() : t.createdAt.asc()],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<Application> _requireApplication(
    Session session,
    int id, {
    Transaction? transaction,
  }) async {
    final application = await Application.db.findById(
      session,
      id,
      transaction: transaction,
    );
    if (application == null) {
      throw Exception('Application $id does not exist.');
    }

    return application;
  }

  static Future<Application?> _findByPackageName(
    Session session,
    String packageName,
  ) => Application.db.findFirstRow(
    session,
    where: (t) => t.packageName.equals(packageName),
  );

  static String _packageTakenMessage(String packageName) =>
      'An application with package "$packageName" already exists.';

  /// Throws when the stored APK does not match [application]. Missing/unreadable
  /// files and unresolvable package names deliberately pass, so only a readable
  /// mismatch is rejected.
  static Future<void> _requireStoredApkMatches(
    Session session,
    Application application,
    String filePath,
  ) async {
    if (!storageArea.owns(filePath)) return;

    final String? apkPackage;
    try {
      final data = await session.storage.retrieveFile(
        storageId: storageArea.defaultDisk,
        path: filePath,
      );
      apkPackage = apkPackageName(_bytes(data));
    } catch (_) {
      return;
    }

    _requireMatchingPackage(application, apkPackage);
  }

  static void _requireMatchingPackage(
    Application application,
    String? apkPackage,
  ) {
    if (apkPackage == null || apkPackage == application.packageName) return;

    throw Exception(
      'The uploaded APK is for "$apkPackage", but this application is '
      '"${application.packageName}".',
    );
  }

  static Future<ApplicationVersion> _requireVersion(
    Session session,
    int id,
  ) async {
    final version = await ApplicationVersion.db.findById(session, id);
    if (version == null) {
      throw Exception('Application version $id does not exist.');
    }

    return version;
  }

  static Uint8List _bytes(ByteData data) =>
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  static String _extension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return '.apk';
    }

    return fileName.substring(dot).toLowerCase();
  }

  static String _randomName() {
    final buffer = StringBuffer();
    for (var i = 0; i < _nameLength; i++) {
      buffer.write(_nameAlphabet[_random.nextInt(_nameAlphabet.length)]);
    }

    return buffer.toString();
  }
}
