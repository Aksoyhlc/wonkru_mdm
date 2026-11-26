import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../../enums/rate_limit_scope.dart';

import '../../storage/local_file_cloud_storage.dart';
import '../../storage/storage_signature.dart';
import '../rate_limit_guard.dart';

/// Direct upload endpoint for [LocalFileCloudStorage].
///
/// Serverpod's built-in upload route only works with database storage, so
/// disk-backed storage needs its own route.
///
/// Authorization comes from a signed query token: path, size limit and expected
/// length are taken from the token, not from the client. Bytes are streamed to
/// disk while sha256 is computed in the same pass, so the payload is not read
/// twice.
///
/// `OPTIONS` is accepted because the router rejects unlisted methods with 405
/// before middleware runs, which blocked the browser preflight. An `OPTIONS`
/// reaching this handler comes from a disallowed origin.
class StorageUploadRoute extends Route {
  StorageUploadRoute({required this.storages, required this.signature})
    : super(methods: const {Method.post, Method.options});

  final Map<String, LocalFileCloudStorage> storages;

  final StorageSignature signature;

  @override
  Future<Response> handleCall(Session session, Request request) async {
    if (request.method == Method.options) return Response.forbidden();

    // Rate limit before signature verification, so per-IP limiting applies
    // before expensive body processing starts.
    final limited = rateLimitResponse(request, RateLimitScope.webUpload);
    if (limited != null) return limited;

    final token = request.url.queryParameters['token'];
    if (token == null) return Response.forbidden();

    final claims = signature.verify(token, action: 'upload');
    if (claims == null) return Response.forbidden();

    final storage = storages[claims['s']];
    final path = claims['p'];
    if (storage == null || path is! String) return Response.forbidden();

    final maxSize = claims['m'] as int;
    final expectedLength = claims['c'] as int?;
    final preventOverwrite = claims['o'] == true;

    final file = storage.fileFor(path);
    if (preventOverwrite && file.existsSync()) {
      return Response(409);
    }

    await file.parent.create(recursive: true);

    // Write to a temporary name first so a half-finished upload cannot corrupt
    // the real file.
    final temporary = File('${file.path}.part');
    final sink = temporary.openWrite();
    final digest = AccumulatorSink<Digest>();
    final hasher = sha256.startChunkedConversion(digest);

    var written = 0;
    try {
      await for (final chunk in request.read()) {
        written += chunk.length;
        if (written > maxSize) {
          await sink.close();
          await temporary.delete();
          return Response(413);
        }
        hasher.add(chunk);
        sink.add(chunk);
      }
      await sink.flush();
      await sink.close();
    } catch (e, stackTrace) {
      await sink.close();
      if (temporary.existsSync()) await temporary.delete();
      session.log(
        'Upload could not be written: $path',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      return Response.internalServerError();
    }

    if (expectedLength != null && written != expectedLength) {
      await temporary.delete();
      return Response.badRequest();
    }

    hasher.close();
    await temporary.rename(file.path);

    await storage.writeMetadata(
      path: path,
      metadata: FileMetadata(
        contentType: request.headers['content-type']?.first,
      ),
      checksumSha256: digest.events.single.toString(),
      size: written,
    );

    return Response.ok();
  }
}
