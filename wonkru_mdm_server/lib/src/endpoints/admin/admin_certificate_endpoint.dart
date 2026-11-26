import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../enums/storage_area.dart';
import '../../enums/upload_limit.dart';
import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/certificate_parse_service.dart';
import '../../service/certificate_service.dart';
import '../../service/storage_url_service.dart';
import '../../util/like_pattern.dart';
import '../../util/page_params.dart';
import 'admin_audit.dart';

/// PKCS12 bundles carry private keys, so certificates live on the private disk
/// and are served only through signed, expiring URLs.
class AdminCertificateEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  static const storageArea = StorageArea.certificates;

  static const storagePrefix = 'certificates';

  static const allowedExtensions = <String>{
    'pem',
    'crt',
    'cer',
    'der',
    'p12',
    'pfx',
    'p7b',
    'p7c',
  };

  static const _nameLength = 40;

  static const _nameAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  static final _random = Random.secure();

  Future<CertificatePage> list(
    Session session,
    AdminListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);
    final search = request.search?.trim();

    final WhereExpressionBuilder<CertificateTable>? where = search == null || search.isEmpty
        ? null
        : (t) =>
              t.name.ilike(likeContains(search)) |
              t.issuer.ilike(likeContains(search)) |
              t.subject.ilike(likeContains(search));

    final total = await Certificate.db.count(session, where: where);
    final items = await Certificate.db.find(
      session,
      where: where,
      limit: params.perPage,
      offset: params.offset,
      orderByList: _orderBy(request),
    );

    return CertificatePage(
      items: items,
      total: total,
      page: params.page,
      perPage: params.perPage,
    );
  }

  Future<Certificate> get(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final certificate = await _require(session, id);

    await audit(
      session,
      action: 'certificate.view',
      targetType: 'certificate',
      targetId: id,
    );

    return certificate;
  }

  Future<CertificateInfo> parse(
    Session session,
    String certificateData, {
    String? password,
  }) async {
    await AdminAuthService.requireAdmin(session);

    try {
      final info = CertificateParseService.parse(
        certificateData,
        password: password,
      );

      await audit(
        session,
        action: 'certificate.parse',
        targetType: 'certificate',
      );

      return info;
    } on FormatException catch (error, stackTrace) {
      session.log(
        'Certificate could not be parsed',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
      throw CertificateParseException(
        message: error.message.isEmpty ? 'Certificate could not be parsed.' : error.message,
      );
    } catch (error, stackTrace) {
      session.log(
        'Certificate could not be parsed',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      throw CertificateParseException(
        message: 'Certificate could not be parsed.',
      );
    }
  }

  Future<Certificate> create(Session session, Certificate certificate) async {
    await AdminAuthService.requireAdmin(session);

    final now = DateTime.now().toUtc();
    certificate
      ..id = null
      ..createdAt = now
      ..updatedAt = now;

    final saved = await Certificate.db.insertRow(session, certificate);

    await audit(
      session,
      action: 'certificate.create',
      targetType: 'certificate',
      targetId: saved.id,
    );

    return saved;
  }

  Future<Certificate> update(Session session, Certificate certificate) async {
    await AdminAuthService.requireAdmin(session);

    final certificateId = certificate.id;
    if (certificateId == null) {
      throw Exception(
        'A certificate id is required to update a certificate.',
      );
    }

    final updated = await session.db.transaction((transaction) async {
      final stored = await Certificate.db.findById(
        session,
        certificateId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Certificate $certificateId does not exist.');
      }

      certificate
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await Certificate.db.updateRow(
        session,
        certificate,
        transaction: transaction,
      );

      await CertificateService.bumpAffectedPolicies(
        session,
        certificateId,
        transaction: transaction,
      );

      return saved;
    });

    await audit(
      session,
      action: 'certificate.update',
      targetType: 'certificate',
      targetId: certificateId,
    );

    return updated;
  }

  Future<int> delete(Session session, List<int> certificateIds) async {
    await AdminAuthService.requireAdmin(session);

    if (certificateIds.isEmpty) {
      return 0;
    }

    final deletedCount = await session.db.transaction((transaction) async {
      var deleted = 0;

      for (final certificateId in certificateIds) {
        final stored = await Certificate.db.findById(
          session,
          certificateId,
          transaction: transaction,
        );
        if (stored == null) {
          continue;
        }

        await CertificateService.bumpAffectedPolicies(
          session,
          certificateId,
          transaction: transaction,
        );

        await Certificate.db.deleteRow(
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
      action: 'certificate.delete',
      targetType: 'certificate',
      data: {
        'ids': certificateIds,
        'count': deletedCount,
      },
    );

    return deletedCount;
  }

  Future<AdminCertificateUploadResponse> uploadFile(
    Session session,
    AdminCertificateUploadRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final bytes = _bytes(request.byteData);
    if (bytes.lengthInBytes > await UploadLimit.certificate.maxBytes(session)) {
      throw Exception('Certificate file is too large.');
    }

    final extension = _extension(request.fileName);
    if (!allowedExtensions.contains(extension)) {
      throw Exception('Unsupported certificate file type.');
    }

    final path = storageArea.pathFor('${_randomName()}.$extension');

    await session.storage.storeFile(
      storageId: storageArea.defaultDisk,
      path: path,
      byteData: request.byteData,
    );

    final response = AdminCertificateUploadResponse(
      filePath: path,
      fileHash: sha256.convert(bytes).toString(),
      sizeBytes: bytes.lengthInBytes,
      publicUrl: await StorageUrlService.signedUrl(
        session,
        path,
        lifetime: StorageUrlService.panelLinkLifetime,
      ),
    );

    await audit(
      session,
      action: 'certificate.upload',
      targetType: 'certificate',
      data: {
        'fileName': request.fileName,
        'filePath': response.filePath,
      },
    );

    return response;
  }

  Future<String?> downloadUrl(Session session, int id) async {
    await AdminAuthService.requireAdmin(session);

    final filePath = (await _require(session, id)).filePath;
    if (filePath == null || filePath.isEmpty) {
      return null;
    }

    await audit(
      session,
      action: 'certificate.download',
      targetType: 'certificate',
      targetId: id,
    );

    return StorageUrlService.signedUrl(
      session,
      filePath,
      lifetime: StorageUrlService.panelLinkLifetime,
    );
  }

  static OrderByListBuilder<CertificateTable> _orderBy(
    AdminListRequest request,
  ) {
    final descending = request.sortDesc;

    return (t) => switch (request.sortBy) {
      'name' => [descending ? t.name.desc() : t.name.asc()],
      'validUntil' => [
        descending ? t.validUntil.desc() : t.validUntil.asc(),
      ],
      'certificateType' => [
        descending ? t.certificateType.desc() : t.certificateType.asc(),
      ],
      _ => [t.createdAt.desc(), t.id.desc()],
    };
  }

  static Future<Certificate> _require(Session session, int id) async {
    final certificate = await Certificate.db.findById(session, id);
    if (certificate == null) {
      throw Exception('Certificate $id does not exist.');
    }

    return certificate;
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
