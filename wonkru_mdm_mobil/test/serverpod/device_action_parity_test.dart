import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/device_action.dart';
import 'package:wonkrumdm/Core/Extensions/enum.dart';

/// The test parses the module's `device_action.spy.yaml` at runtime, so adding
/// an action server-side without updating the mobile enum fails the test
/// instead of silently passing against a hand-copied list.
///
/// A file that exists but does not parse fails the test; only a genuinely
/// absent file (mobile-only copy) falls back to [_fallbackServerActions].
void main() {
  test('the mobile enum knows all of the server action values', () {
    final lookup = _readServerActions();
    final serverActions = _serverActionsOrFallback(lookup);
    expect(serverActions, isNotEmpty);

    for (final value in serverActions) {
      expect(
        DeviceAction.values.tryFromValue(value),
        isNotNull,
        reason: 'Mobile enum does not know the value $value',
      );
    }
  });

  test('the fallback list is consistent with the server source', () {
    final lookup = _readServerActions();
    if (!lookup.exists) {
      markTestSkipped(
        'wonkru_core_server package not found (mobile-only copy); parity was '
        'verified against the fallback list. In a full monorepo copy the '
        'source file is read.',
      );
      return;
    }

    expect(
      _serverActionsOrFallback(lookup),
      _fallbackServerActions,
      reason:
          'The fallback list diverged from the server enum. If '
          'wonkru_core_server/lib/src/models/enums/device_action.spy.yaml '
          'changed, update this list.',
    );
  });
}

/// [exists] is false when no candidate file was found; [values] is null when a
/// file exists but its `values:` block could not be parsed.
typedef _ServerEnumLookup = ({bool exists, String? path, List<String>? values});

/// Reads the module enum `.spy.yaml` from the neighbouring package, relative to
/// the working directory.
_ServerEnumLookup _readServerActions() {
  const candidates = <String>[
    '../wonkru_core_server/lib/src/models/enums/device_action.spy.yaml',
    'wonkru_core_server/lib/src/models/enums/device_action.spy.yaml',
  ];

  String? existingPath;
  for (final path in candidates) {
    final file = File(path);
    if (!file.existsSync()) continue;

    existingPath = path;
    final values = _parseDeviceActions(file.readAsStringSync());
    if (values != null) {
      return (exists: true, path: path, values: values);
    }
  }
  return (exists: existingPath != null, path: existingPath, values: null);
}

List<String>? _parseDeviceActions(String source) {
  if (!RegExp(r'^enum:\s*DeviceAction\s*$', multiLine: true).hasMatch(source)) {
    return null;
  }
  if (!RegExp(r'^serialized:\s*byName\s*$', multiLine: true).hasMatch(source)) {
    return null;
  }

  final valuesMatch = RegExp(
    r'^values:\s*\n((?:\s*-\s*\S+\s*\n?)+)',
    multiLine: true,
  ).firstMatch(source);
  if (valuesMatch == null) return null;

  final values = RegExp(
    r'-\s*(\S+)',
  ).allMatches(valuesMatch.group(1)!).map((m) => m.group(1)!).toList();
  return values.isEmpty ? null : values;
}

/// Falls back only when the file is absent; a present-but-unparseable file
/// fails the test, since silently falling back would reintroduce the drift this
/// guards against.
List<String> _serverActionsOrFallback(_ServerEnumLookup lookup) {
  if (lookup.exists) {
    final values = lookup.values;
    if (values == null) {
      fail(
        'Module action source was found but the `DeviceAction` enum '
        'could not be parsed: ${lookup.path}\n'
        'Expected: `enum: DeviceAction`, `serialized: byName` and a `values:` '
        'list (e.g. `- send_notification`). If the file was moved/renamed, '
        'update the candidate path in the test.',
      );
    }
    return values;
  }

  // ignore: avoid_print
  print(
    'WARNING: wonkru_core_server package not found (mobile-only copy); '
    'parity is verified against the fallback list.',
  );
  return _fallbackServerActions;
}

/// Used only when the module enum file is absent. Keep in sync with
/// `wonkru_core_server/lib/src/models/enums/device_action.spy.yaml` and the
/// mobile `DeviceAction` enum.
const _fallbackServerActions = <String>[
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
];
