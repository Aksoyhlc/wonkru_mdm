import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../enums/storage_area.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';
import 'setting_service.dart';

class DeviceUploadService {
  const DeviceUploadService._();

  static const maxSizeSettingKey = 'device_upload_max_size_kb';

  static const defaultMaxSizeKb = 50 * 1024;

  /// Uploads (screenshots, logs, documents) can carry personal data: they are
  /// written to a private disk and served only through the signed, time-limited
  /// links from `AdminFileEndpoint.downloadUrl`. No `publicUrl` is stored.
  static const storageArea = StorageArea.deviceUploads;

  static String get storageId => storageArea.defaultDisk;

  static const storagePrefix = 'device-uploads';

  static const allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bpm',
    'mp3',
    'mp4',
    'pdf',
    'txt',
    'log',
    'csv',
    'zip',
    'json',
    'xml',
    'vcard',
    'vcf',
    'avi',
    'avif',
    'mov',
    'webm',
    'ogg',
    'wav',
    'aac',
    'm4a',
    'flac',
    'wma',
  };

  static const _nameLength = 40;

  static const _nameAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  static final _random = Random.secure();

  static Future<DeviceFileUploadResponse> store(
    Session session,
    DeviceFileUploadRequest request, {
    int? deviceId,
  }) async {
    final bytes = _bytes(request.byteData);

    final maxSizeKb =
        await SettingService.getInt(
          session,
          maxSizeSettingKey,
          fallback: defaultMaxSizeKb,
        ) ??
        defaultMaxSizeKb;
    if (bytes.lengthInBytes > maxSizeKb * 1024) {
      // Typed error so the agent can tell a size rejection from a transient
      // network failure and stop retrying the same file.
      throw DeviceRequestInvalidException(
        message: 'File is too large.',
        field: 'byteData',
      );
    }

    final extension = resolveExtension(request);
    if (!allowedExtensions.contains(extension)) {
      throw DeviceRequestInvalidException(
        message: 'Unsupported file type.',
        field: 'fileExtension',
      );
    }

    final path = storageArea.pathFor('${_randomName()}.$extension');

    await session.storage.storeFile(
      storageId: storageId,
      path: path,
      byteData: request.byteData,
    );

    final now = DateTime.now().toUtc();
    final file = await FileAsset.db.insertRow(
      session,
      FileAsset(
        name: request.fileName,
        fileExtension: extension,
        filePath: path,
        mimeType: request.mimeType,
        sizeBytes: bytes.lengthInBytes,
        fileHashSha256: sha256.convert(bytes).toString(),
        disk: StorageDisk.values.byName(storageId),
        deviceId: deviceId,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await PolicyVersionService.bumpForFile(session, file.id!);

    return DeviceFileUploadResponse(
      id: file.id!,
      name: file.name,
      filePath: file.filePath,
      sizeBytes: file.sizeBytes,
      // Private disk: the device gets no permanent public URL.
      publicUrl: null,
    );
  }

  static String resolveExtension(DeviceFileUploadRequest request) {
    final provided = request.fileExtension?.trim() ?? '';
    final raw = provided.isNotEmpty
        ? provided
        : request.fileName.contains('.')
        ? request.fileName.split('.').last
        : '';

    return raw.replaceFirst(RegExp(r'^\.'), '').toLowerCase();
  }

  static Uint8List _bytes(ByteData data) =>
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  static String _randomName() {
    final buffer = StringBuffer();
    for (var i = 0; i < _nameLength; i++) {
      buffer.write(_nameAlphabet[_random.nextInt(_nameAlphabet.length)]);
    }
    return buffer.toString();
  }
}
