import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_upload_service.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Given DeviceEndpoint.uploadFile', (sessionBuilder, endpoints) {
    const content = 'hello world';

    late String deviceUuid;
    late String deviceToken;

    Future<void> enrollDevice() async {
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'test'),
      );
      deviceUuid = registered.uuid;
      deviceToken = registered.token;
    }

    DeviceFileUploadRequest uploadRequest({
      String? uuid,
      String? token,
      String fileName = 'notes.txt',
      String? fileExtension = 'txt',
      String body = content,
    }) {
      return DeviceFileUploadRequest(
        deviceUuid: uuid ?? deviceUuid,
        token: token ?? deviceToken,
        fileName: fileName,
        fileExtension: fileExtension,
        mimeType: 'text/plain',
        byteData: ByteData.sublistView(Uint8List.fromList(utf8.encode(body))),
      );
    }

    test('when the device token is unknown then the upload is '
        'rejected.', () async {
      await expectLater(
        endpoints.device.uploadFile(
          sessionBuilder,
          uploadRequest(uuid: 'device-uuid-upload', token: 'unknown-token'),
        ),
        throwsA(isA<DeviceUnauthenticatedException>()),
      );

      final session = sessionBuilder.build();
      expect(await FileAsset.db.find(session), isEmpty);
    });

    test('when the extension is not whitelisted then the upload is '
        'rejected.', () async {
      await enrollDevice();

      await expectLater(
        endpoints.device.uploadFile(
          sessionBuilder,
          uploadRequest(fileName: 'payload.exe', fileExtension: 'exe'),
        ),
        throwsA(
          isA<DeviceRequestInvalidException>().having(
            (e) => e.field,
            'field',
            'fileExtension',
          ),
        ),
      );

      final session = sessionBuilder.build();
      expect(await FileAsset.db.find(session), isEmpty);
    });

    test('when the file exceeds the configured limit then the upload is '
        'rejected.', () async {
      await enrollDevice();

      final session = sessionBuilder.build();
      await SettingService.save(
        session,
        DeviceUploadService.maxSizeSettingKey,
        '0',
      );

      await expectLater(
        endpoints.device.uploadFile(sessionBuilder, uploadRequest()),
        throwsA(
          isA<DeviceRequestInvalidException>().having(
            (e) => e.field,
            'field',
            'byteData',
          ),
        ),
      );

      expect(await FileAsset.db.find(session), isEmpty);
    });

    test('when the upload is valid then the bytes and the row are '
        'stored.', () async {
      await enrollDevice();

      final response = await endpoints.device.uploadFile(
        sessionBuilder,
        uploadRequest(),
      );

      expect(response.id, greaterThan(0));
      expect(response.name, 'notes.txt');
      expect(response.sizeBytes, utf8.encode(content).length);
      expect(
        response.filePath,
        startsWith('${DeviceUploadService.storagePrefix}/'),
      );
      expect(response.filePath, endsWith('.txt'));

      final session = sessionBuilder.build();

      final asset = await FileAsset.db.findById(session, response.id);
      expect(asset, isNotNull);
      expect(asset!.fileExtension, 'txt');
      expect(asset.disk, StorageDisk.private);
      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(deviceUuid),
      );
      expect(asset.deviceId, device!.id);
      expect(asset.mimeType, 'text/plain');
      expect(asset.sizeBytes, utf8.encode(content).length);
      expect(
        asset.fileHashSha256,
        sha256.convert(utf8.encode(content)).toString(),
      );
      expect(asset.createdAt, isNotNull);
      expect(asset.publicUrl, isNull);

      final stored = await session.storage.retrieveFile(
        storageId: DeviceUploadService.storageId,
        path: response.filePath,
      );
      expect(
        utf8.decode(
          stored.buffer.asUint8List(stored.offsetInBytes, stored.lengthInBytes),
        ),
        content,
      );
    });

    test('when the upload is valid then the response carries no public '
        'link.', () async {
      await enrollDevice();

      final response = await endpoints.device.uploadFile(
        sessionBuilder,
        uploadRequest(),
      );

      // Private disk: no permanent public URL; the panel asks for a signed
      // link instead.
      expect(response.publicUrl, isNull);
    });

    test('when the extension is only present in the name then it is '
        'used.', () async {
      await enrollDevice();

      final response = await endpoints.device.uploadFile(
        sessionBuilder,
        uploadRequest(fileName: 'archive.ZIP', fileExtension: null),
      );

      expect(response.filePath, endsWith('.zip'));
    });
  });
}
