import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/storage/local_file_cloud_storage.dart';
import 'package:wonkru_mdm_server/src/storage/storage_signature.dart';
import 'package:wonkru_mdm_server/src/web/routes/storage_upload_route.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given StorageUploadRoute', (sessionBuilder, endpoints) {
    late Directory root;
    late StorageSignature signature;
    late LocalFileCloudStorage storage;
    late StorageUploadRoute route;

    setUp(() {
      root = Directory.systemTemp.createTempSync('wonkru-upload-');
      signature = StorageSignature.generate();
      storage = LocalFileCloudStorage(
        'private',
        publicBaseUrl: Uri.parse('http://localhost:8082'),
        signature: signature,
        root: root,
      );
      route = StorageUploadRoute(
        storages: {'private': storage},
        signature: signature,
      );
    });

    tearDown(() => root.deleteSync(recursive: true));

    Request uploadRequest({
      String? token,
      required List<int> bytes,
      String path = 'files/panel.txt',
      int maxSize = 1 << 20,
      int? contentLength,
      String storageId = 'private',
      DateTime? expiration,
      bool preventOverwrite = false,
    }) {
      final signed =
          token ??
          signature.signUpload(
            storageId: storageId,
            path: path,
            maxSize: maxSize,
            contentLength: contentLength ?? bytes.length,
            expiration:
                expiration ?? DateTime.now().add(const Duration(minutes: 5)),
            preventOverwrite: preventOverwrite,
          );

      return RequestInternal.create(
        Method.post,
        Uri.parse('http://localhost:8082/storage/upload?token=$signed'),
        Object(),
        headers: Headers.build(
          (headers) => headers['content-type'] = ['application/octet-stream'],
        ),
        body: Body.fromData(Uint8List.fromList(bytes)),
      );
    }

    File storedFile([String path = 'files/panel.txt']) =>
        File('${root.path}/private/$path');

    test('with a valid token the bytes are written to disk', () async {
      final bytes = utf8.encode('panel upload');

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: bytes),
      );

      expect(response.statusCode, 200);
      expect(storedFile().existsSync(), isTrue);
      expect(storedFile().readAsBytesSync(), bytes);
      expect(File('${storedFile().path}.part').existsSync(), isFalse);
    });

    test('without a token it returns 403 and no file is written', () async {
      final response = await route.handleCall(
        sessionBuilder.build(),
        RequestInternal.create(
          Method.post,
          Uri.parse('http://localhost:8082/storage/upload'),
          Object(),
          body: Body.fromData(Uint8List.fromList(utf8.encode('x'))),
        ),
      );

      expect(response.statusCode, 403);
      expect(storedFile().existsSync(), isFalse);
    });

    test('if the expected size does not match it returns 400 and no file remains', () async {
      final bytes = utf8.encode('short body');

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: bytes, contentLength: bytes.length + 5),
      );

      expect(response.statusCode, 400);
      expect(storedFile().existsSync(), isFalse);
    });

    test('if the size limit is exceeded it returns 413 and no file remains', () async {
      final bytes = utf8.encode('oversized body');

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: bytes, maxSize: 4),
      );

      expect(response.statusCode, 413);
      expect(storedFile().existsSync(), isFalse);
    });

    test('a token signed for a different action is rejected', () async {
      final downloadToken = signature.signDownload(
        storageId: 'private',
        path: 'files/panel.txt',
        expiration: DateTime.now().add(const Duration(minutes: 5)),
      );

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(token: downloadToken, bytes: utf8.encode('x')),
      );

      expect(response.statusCode, 403);
      expect(storedFile().existsSync(), isFalse);
    });

    test('an expired token is rejected', () async {
      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(
          bytes: utf8.encode('x'),
          expiration: DateTime.now().subtract(const Duration(seconds: 1)),
        ),
      );

      expect(response.statusCode, 403);
      expect(storedFile().existsSync(), isFalse);
    });

    test('a token signed for an unknown storage is rejected', () async {
      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: utf8.encode('x'), storageId: 'other'),
      );

      expect(response.statusCode, 403);
    });

    test(
      'a body exactly at the limit is accepted, one byte over is rejected',
      () async {
        final exact = List<int>.filled(8, 1);

        final accepted = await route.handleCall(
          sessionBuilder.build(),
          uploadRequest(bytes: exact, maxSize: 8),
        );
        final rejected = await route.handleCall(
          sessionBuilder.build(),
          uploadRequest(
            bytes: [...exact, 1],
            maxSize: 8,
            path: 'files/extra.bin',
          ),
        );

        expect(accepted.statusCode, 200);
        expect(rejected.statusCode, 413);
        expect(storedFile('files/extra.bin').existsSync(), isFalse);
      },
    );

    test('with preventOverwrite the existing file is protected with 409', () async {
      storedFile().parent.createSync(recursive: true);
      storedFile().writeAsStringSync('old');

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: utf8.encode('new'), preventOverwrite: true),
      );

      expect(response.statusCode, 409);
      expect(storedFile().readAsStringSync(), 'old');
    });

    test('without preventOverwrite the existing file is overwritten', () async {
      storedFile().parent.createSync(recursive: true);
      storedFile().writeAsStringSync('old');

      final response = await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: utf8.encode('new')),
      );

      expect(response.statusCode, 200);
      expect(storedFile().readAsStringSync(), 'new');
    });

    test('metadata carries the real size, sha256, and content type', () async {
      final bytes = utf8.encode('checksum');

      await route.handleCall(
        sessionBuilder.build(),
        uploadRequest(bytes: bytes),
      );

      final metadata = await storage.readMetadata('files/panel.txt');
      expect(metadata['size'], bytes.length);
      expect(metadata['sha256'], sha256.convert(bytes).toString());
      expect(metadata['contentType'], 'application/octet-stream');
    });
  });
}
