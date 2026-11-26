import 'dart:io';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import '../config/storage_config.dart';
import '../generated/serverpod.dart';
import '../storage/local_file_cloud_storage.dart';
import '../storage/storage_signature.dart';

/// The local disks and the signature resolver shared by the storage routes.
class StorageSetup {
  const StorageSetup({required this.localStorages, required this.signature});

  final Map<String, LocalFileCloudStorage> localStorages;
  final StorageSignature signature;
}

/// Wires the private/public cloud storages.
///
/// Files go to disk: keeping 100 MB APKs in Postgres as `bytea` bloated the
/// database and slowed reads and writes. Serverpod Cloud's provider is used when
/// deployed, otherwise local disk. The signing key is derived from the
/// `storageSigningKey` secret (passwords.yaml or
/// `SERVERPOD_PASSWORD_storageSigningKey`) so the signed links in policies
/// survive a restart and stay valid across instances; it falls back to the JWT
/// key when unset (warns in production).
Future<StorageSetup> configureStorage(Serverpod pod) async {
  final signature = StorageSignature.resolve(
    signingKey: pod.getPassword('storageSigningKey'),
    fallbackSecret: pod.getPassword('jwtHmacSha512PrivateKey'),
    runMode: pod.runMode,
    warn: stderr.writeln,
  );

  final webServerConfig = pod.config.webServer;
  final storageBaseUrl = Uri(
    scheme: webServerConfig?.publicScheme ?? 'http',
    host: webServerConfig?.publicHost ?? 'localhost',
    port: webServerConfig?.publicPort ?? 8082,
  );

  final localStorages = {
    for (final storageId in StorageConfig.disks)
      storageId: LocalFileCloudStorage(
        storageId,
        publicBaseUrl: storageBaseUrl,
        signature: signature,
      ),
  };

  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => localStorages['private']!,
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => localStorages['public']!,
    ),
  );

  return StorageSetup(localStorages: localStorages, signature: signature);
}
