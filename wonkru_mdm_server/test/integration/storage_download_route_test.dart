import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/storage/local_file_cloud_storage.dart';
import 'package:wonkru_mdm_server/src/storage/storage_signature.dart';
import 'package:wonkru_mdm_server/src/web/routes/storage_download_route.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given StorageDownloadRoute', (sessionBuilder, endpoints) {
    late Directory root;
    late StorageSignature signature;
    late LocalFileCloudStorage private;
    late LocalFileCloudStorage public;
    late StorageDownloadRoute route;

    const path = 'files/panel.pdf';
    final bytes = utf8.encode('pdf contents');

    setUp(() async {
      root = Directory.systemTemp.createTempSync('wonkru-download-');
      signature = StorageSignature.generate();
      private = LocalFileCloudStorage(
        'private',
        publicBaseUrl: Uri.parse('http://localhost:8082'),
        signature: signature,
        root: root,
      );
      public = LocalFileCloudStorage(
        'public',
        publicBaseUrl: Uri.parse('http://localhost:8082'),
        signature: signature,
        root: root,
      );
      route = StorageDownloadRoute(
        storages: {'private': private, 'public': public},
        signature: signature,
      );

      final file = private.fileFor(path);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      await private.writeMetadata(
        path: path,
        metadata: FileMetadata(contentType: 'application/pdf'),
        checksumSha256: 'test',
        size: bytes.length,
      );
    });

    tearDown(() => root.deleteSync(recursive: true));

    Request get(String url) => RequestInternal.create(
      Method.get,
      Uri.parse(url),
      Object(),
    );

    Future<List<int>> bodyOf(Response response) async {
      final chunks = await response.read().toList();
      return chunks.expand((chunk) => chunk).toList();
    }

    test('a private file downloads with a signed token for its own path', () async {
      final token = signature.signDownload(
        storageId: 'private',
        path: path,
        expiration: DateTime.now().add(const Duration(minutes: 5)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path?token=$token'),
      );

      expect(response.statusCode, 200);
      expect(await bodyOf(response), bytes);
      final mime = response.body.bodyType?.mimeType;
      expect(mime?.primaryType, 'application');
      expect(mime?.subType, 'pdf');
    });

    test('a private file does not download without a token', () async {
      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path'),
      );

      expect(response.statusCode, 403);
    });

    test('a token signed for a different path is rejected', () async {
      final token = signature.signDownload(
        storageId: 'private',
        path: 'files/other.pdf',
        expiration: DateTime.now().add(const Duration(minutes: 5)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path?token=$token'),
      );

      expect(response.statusCode, 403);
    });

    test('an expired token is rejected', () async {
      final token = signature.signDownload(
        storageId: 'private',
        path: path,
        expiration: DateTime.now().subtract(const Duration(seconds: 1)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path?token=$token'),
      );

      expect(response.statusCode, 403);
    });

    test('a token signed for a different storage is rejected', () async {
      final token = signature.signDownload(
        storageId: 'public',
        path: path,
        expiration: DateTime.now().add(const Duration(minutes: 5)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path?token=$token'),
      );

      expect(response.statusCode, 403);
    });

    test('an upload token cannot be used for download', () async {
      final token = signature.signUpload(
        storageId: 'private',
        path: path,
        maxSize: 1024,
        contentLength: null,
        expiration: DateTime.now().add(const Duration(minutes: 5)),
        preventOverwrite: false,
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/private/$path?token=$token'),
      );

      expect(response.statusCode, 403);
    });

    test('a request containing ".." serves no file without a token', () async {
      for (final url in [
        'http://localhost:8082/storage/file/public/../private/$path',
        'http://localhost:8082/storage/file/public/%2e%2e/private/$path',
      ]) {
        final response = await route.handleCall(
          sessionBuilder.build(),
          get(url),
        );

        expect(response.statusCode, isNot(200), reason: url);
      }
    });

    test('the storage rejects paths with "..", ".", and empty segments', () {
      for (final bad in ['../passwords.yaml', 'files/../../x', './a', 'a//b']) {
        expect(
          () => private.fileFor(bad),
          throwsA(isA<CloudStorageException>()),
          reason: bad,
        );
      }
    });

    test('a public file downloads without a token', () async {
      final publicFile = public.fileFor(path);
      await publicFile.parent.create(recursive: true);
      await publicFile.writeAsBytes(bytes);

      final response = await route.handleCall(
        sessionBuilder.build(),
        get('http://localhost:8082/storage/file/public/$path'),
      );

      expect(response.statusCode, 200);
      expect(await bodyOf(response), bytes);
    });

    test('sensitive files do not download without a token even if left on the public disk', () async {
      for (final legacy in [
        'certificates/old.p12',
        'device-uploads/old.png',
      ]) {
        final file = public.fileFor(legacy);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes);

        final response = await route.handleCall(
          sessionBuilder.build(),
          get('http://localhost:8082/storage/file/public/$legacy'),
        );

        expect(response.statusCode, 404, reason: legacy);
      }
    });

    test('a missing file returns 404', () async {
      final token = signature.signDownload(
        storageId: 'private',
        path: 'files/missing.pdf',
        expiration: DateTime.now().add(const Duration(minutes: 5)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        get(
          'http://localhost:8082/storage/file/private/files/missing.pdf'
          '?token=$token',
        ),
      );

      expect(response.statusCode, 404);
    });
  });
}
