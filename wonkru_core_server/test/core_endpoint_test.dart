import 'dart:io';
import 'dart:isolate';

import 'package:test/test.dart';
import 'package:wonkru_core_server/src/catalog/device_action_metadata.dart';
import 'package:wonkru_core_server/src/catalog/restriction_catalog.dart';
import 'package:wonkru_core_server/src/endpoints/core_endpoint.dart';
import 'package:wonkru_core_server/src/generated/protocol.dart';

/// Verifies `CoreEndpoint.catalogs` carries the panel's single source: the
/// restriction catalog (38), the device action metadata (20), and the ordered
/// wire values of the shared enums.
///
/// The module has no tables and no migrations, so `withServerpod` cannot start
/// the embedded database; hence the endpoint is checked through the
/// session-independent [CoreEndpoint.buildCatalog], which `catalogs` delegates to.
void main() {
  group('Given the core endpoint catalog', () {
    test('when built then it mirrors the 38-entry restriction catalog', () {
      final catalog = CoreEndpoint.buildCatalog();

      expect(catalog.restrictions, hasLength(38));
      expect(
        catalog.restrictions.map((entry) => entry.key).toList(),
        RestrictionCatalog.all.map((entry) => entry.key).toList(),
      );
    });

    test('when built then it mirrors the 20-entry device action metadata', () {
      final catalog = CoreEndpoint.buildCatalog();

      expect(catalog.deviceActions, hasLength(20));
      expect(
        catalog.deviceActions.map((info) => info.action).toList(),
        DeviceActionMetadata.all.map((info) => info.action).toList(),
      );
    });

    test(
      'when built then it carries every shared enum in wire order',
      () async {
        final catalog = CoreEndpoint.buildCatalog();
        final models = await _readEnumModels();

        expect(catalog.enumValues, isNotEmpty);
        expect(catalog.enumValues.keys.toSet(), models.keys.toSet());
        // The expected wire values are written by hand: deriving them from the
        // enum would test the enum against itself and verify nothing.
        expect(catalog.enumValues['DeviceAction'], const [
          'send_notification',
          'enable_power_save',
          'reduce_brightness',
          'disable_wifi',
          'disable_bluetooth',
          'lock_device',
          'clear_cache',
          'disable_camera',
          'clear_app_data',
          'launch_app',
          'launch_intent',
          'uninstall_app',
          'open_app_settings',
          'update_policy',
          'policy_change',
          'get_installed_apps',
          'get_logs',
          'device_data',
          'get_current_location',
          'reboot',
        ]);
        expect(
          catalog.enumValues['CertificateFormat'],
          const ['PEM', 'DER', 'PKCS12', 'PKCS7'],
        );
        for (final values in catalog.enumValues.values) {
          expect(values, isNotEmpty);
        }
      },
    );

    test('when built then the payload survives a JSON round trip', () {
      final catalog = CoreEndpoint.buildCatalog();

      final restored = ProtocolCatalog.fromJson(catalog.toJson());

      expect(restored.restrictions, hasLength(38));
      expect(restored.deviceActions, hasLength(20));
      expect(restored.enumValues, catalog.enumValues);
    });

    test('when the endpoint is inspected then it does not require login', () {
      expect(CoreEndpoint().requireLogin, isFalse);
    });
  });

  group('Given the module enum models on disk', () {
    test(
      'when compared then enumValues covers exactly the shared enums',
      () async {
        final models = await _readEnumModels();
        final catalogNames = CoreEndpoint.buildCatalog().enumValues.keys
            .toSet();
        final modelNames = models.keys.toSet();

        expect(
          modelNames,
          isNotEmpty,
          reason: 'No enum model files found; path resolution is broken.',
        );

        final missing = modelNames.difference(catalogNames).toList()..sort();
        final extra = catalogNames.difference(modelNames).toList()..sort();

        expect(
          missing,
          isEmpty,
          reason: 'enumValues is missing these shared enums: $missing',
        );
        expect(
          extra,
          isEmpty,
          reason: 'enumValues is emitting enums with no model file: $extra',
        );
        expect(catalogNames, modelNames);
      },
    );

    test('when compared then every shared enum is serialized byName', () async {
      final models = await _readEnumModels();

      for (final entry in models.entries) {
        expect(
          entry.value,
          'byName',
          reason:
              '${entry.key} must declare `serialized: byName`; otherwise its '
              'wire values are unstable.',
        );
      }
    });
  });
}

/// Enum name → `serialized` value from the module's `lib/src/models/enums/`.
///
/// The model files are the single source; reading them from disk catches drift
/// between the hand-maintained `_enumValues` and the models.
Future<Map<String, String>> _readEnumModels() async {
  final directory = await _enumModelsDirectory();
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.spy.yaml'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final models = <String, String>{};
  for (final file in files) {
    String? name;
    String? serialized;
    for (final line in file.readAsLinesSync()) {
      name ??= _enumNamePattern.firstMatch(line)?.group(1);
      serialized ??= _serializedPattern.firstMatch(line)?.group(1);
    }
    if (name == null) {
      throw StateError('No `enum:` line found in ${file.path}.');
    }
    models[name] = serialized ?? '';
  }

  return models;
}

/// Finds `lib/src/models/enums/` independently of the working directory.
Future<Directory> _enumModelsDirectory() async {
  final candidates = <Directory>[];

  final resolved = await Isolate.resolvePackageUri(
    Uri.parse('package:wonkru_core_server/wonkru_core_server.dart'),
  );
  if (resolved != null) {
    final packageRoot = File(resolved.toFilePath()).parent.parent;
    candidates.add(Directory('${packageRoot.path}/lib/src/models/enums'));
  }

  var directory = Directory.current;
  for (var depth = 0; depth < 8; depth++) {
    candidates
      ..add(Directory('${directory.path}/lib/src/models/enums'))
      ..add(
        Directory('${directory.path}/wonkru_core_server/lib/src/models/enums'),
      );
    final parent = directory.parent;
    if (parent.path == directory.path) break;
    directory = parent;
  }

  for (final candidate in candidates) {
    if (candidate.existsSync()) return candidate;
  }

  throw StateError(
    'lib/src/models/enums not found. Tried: '
    '${candidates.map((c) => c.path).toList()}',
  );
}

final RegExp _enumNamePattern = RegExp(r'^enum:\s*(\S+)\s*$');
final RegExp _serializedPattern = RegExp(r'^serialized:\s*(\S+)\s*$');
