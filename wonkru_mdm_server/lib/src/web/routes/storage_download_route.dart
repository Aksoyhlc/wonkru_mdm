import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../../enums/storage_area.dart';
import '../../enums/rate_limit_scope.dart';

import '../../storage/local_file_cloud_storage.dart';
import '../../storage/storage_signature.dart';
import '../rate_limit_guard.dart';

/// Serves files from [LocalFileCloudStorage].
///
/// Path format: `/storage/file/<storageId>/<file path>`.
///
/// Files in `public` storage are open. `private` storage requires a signed,
/// unexpired token produced by `temporaryDownloadUrl`. Areas marked
/// [StorageArea.privateOnly] (certificates, device uploads) are never served
/// without a token, even when they exist on a public disk.
class StorageDownloadRoute extends Route {
  StorageDownloadRoute({required this.storages, required this.signature})
    : super(methods: const {Method.get}, path: '/**');

  final Map<String, LocalFileCloudStorage> storages;

  static const publicStorages = {'public'};

  final StorageSignature signature;

  @override
  Future<Response> handleCall(Session session, Request request) async {
    // Public files are tokenless, so limit abuse per IP.
    final limited = rateLimitResponse(request, RateLimitScope.webDownload);
    if (limited != null) return limited;

    final segments = request.url.pathSegments
        .skipWhile((segment) => segment != 'file')
        .skip(1)
        .toList();
    if (segments.length < 2) return Response.notFound();

    final storageId = segments.first;
    final path = segments.skip(1).join('/');

    final storage = storages[storageId];
    if (storage == null) return Response.notFound();

    if (publicStorages.contains(storageId) &&
        (StorageArea.forPath(path)?.privateOnly ?? false)) {
      return Response.notFound();
    }

    if (!publicStorages.contains(storageId)) {
      final token = request.url.queryParameters['token'];
      final claims = token == null
          ? null
          : signature.verify(token, action: 'download');
      // The signed path must match the requested path, so a token cannot be
      // reused for another file.
      if (claims == null || claims['s'] != storageId || claims['p'] != path) {
        return Response.forbidden();
      }
    }

    final File file;
    try {
      file = storage.fileFor(path);
    } on CloudStorageException {
      return Response.notFound();
    }
    if (!file.existsSync()) return Response.notFound();

    final metadata = await storage.readMetadata(path);
    final contentType = metadata['contentType'];

    return Response.ok(
      body: Body.fromDataStream(
        file.openRead().map((chunk) => chunk as Uint8List),
        mimeType: contentType is String && contentType.isNotEmpty
            ? MimeType.parse(contentType)
            : MimeType.octetStream,
        contentLength: await file.length(),
      ),
    );
  }
}
