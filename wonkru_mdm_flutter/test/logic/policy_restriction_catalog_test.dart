import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/input_controller.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_restriction_catalog.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_settings_codec.dart';

RestrictionCatalogEntry _entry(String name, String key, String? group) =>
    RestrictionCatalogEntry(
      name: name,
      key: key,
      apiLevel: 18,
      group: group,
    );

/// Sample in catalog (alphabetic `name`) order; `no_config_cell_broadcasts`
/// must be shown last in the `network` group.
final _catalog = <RestrictionCatalogEntry>[
  _entry(
    'ALLOW_PARENT_PROFILE_APP_LINKING',
    'allow_parent_profile_app_linking',
    'applications',
  ),
  _entry('DISALLOW_AMBIENT_DISPLAY', 'no_ambient_display', 'device'),
  _entry('DISALLOW_BLUETOOTH', 'no_bluetooth', 'device'),
  _entry('DISALLOW_CAMERA', 'no_camera', 'security'),
  _entry(
    'DISALLOW_CHANGE_NEAR_FIELD_COMMUNICATION_RADIO',
    'no_change_near_field_communication_radio',
    'network',
  ),
  _entry(
    'DISALLOW_CONFIG_CELL_BROADCASTS',
    'no_config_cell_broadcasts',
    'network',
  ),
  _entry('DISALLOW_MODIFY_ACCOUNTS', 'no_modify_accounts', 'user_and_account'),
  _entry('DISALLOW_ASSIST_CONTENT', 'no_assist_content', 'privacy_and_sharing'),
  _entry('DISALLOW_FUN', 'no_fun', 'system_and_ui'),
];

void main() {
  group('restrictionKeysInPanelOrder', () {
    test('lists groups in legacy order', () {
      final groups = restrictionGroupsInPanelOrder(
        _catalog,
      ).map((group) => group.label.tr).toList();

      expect(groups, [
        L.common.security,
        L.policies.restrictionGroupNetwork,
        L.policies.restrictionGroupApplications,
        L.common.device,
        L.policies.restrictionGroupUserAndAccount,
        L.policies.restrictionGroupPrivacyAndSharing,
        L.policies.restrictionGroupSystemAndUi,
      ]);
    });

    test('preserves catalog order within a group', () {
      final device = restrictionGroupsInPanelOrder(_catalog)
          .firstWhere(
            (group) => group.label.tr == L.common.device,
          )
          .entries
          .map((entry) => entry.key)
          .toList();

      expect(device, ['no_ambient_display', 'no_bluetooth']);
    });

    test('no_config_cell_broadcasts stays last in the network group', () {
      final network = restrictionKeysInPanelOrder(_catalog)
          .where(
            (key) =>
                key == 'no_config_cell_broadcasts' ||
                key == 'no_change_near_field_communication_radio',
          )
          .toList();

      expect(network, [
        'no_change_near_field_communication_radio',
        'no_config_cell_broadcasts',
      ]);
    });

    test('canonical key list follows the panel order', () {
      expect(restrictionKeysInPanelOrder(_catalog), [
        'no_camera',
        'no_change_near_field_communication_radio',
        'no_config_cell_broadcasts',
        'allow_parent_profile_app_linking',
        'no_ambient_display',
        'no_bluetooth',
        'no_modify_accounts',
        'no_assist_content',
        'no_fun',
      ]);
    });

    test('unknown group is appended to the end of the order', () {
      final keys = restrictionKeysInPanelOrder([
        ..._catalog,
        _entry('DISALLOW_UNKNOWN', 'no_unknown', 'other_group'),
      ]);

      expect(keys.last, 'no_unknown');
    });
  });

  group('restrictionKeysForSave', () {
    test('uses catalog keys from the cache when state is empty', () {
      expect(
        restrictionKeysForSave(const [], _catalog),
        restrictionKeysInPanelOrder(_catalog),
      );
    });

    test('preserves state when it is filled', () {
      expect(restrictionKeysForSave(const ['x'], _catalog), const ['x']);
    });

    test('saving with keys resolved from cache writes the edit', () {
      final keys = restrictionKeysForSave(const [], _catalog);
      final json = flatToRestrictionSettings(
        <String, String>{'restriction_settings.no_camera': '1'},
        keys,
      );

      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final restrictions = decoded['restrictions'] as List<dynamic>;
      expect(restrictions.length, keys.length);

      final camera =
          restrictions.firstWhere(
                (item) =>
                    (item as Map<String, dynamic>)['restriction'] ==
                    'no_camera',
              )
              as Map<String, dynamic>;
      expect(camera['value'], 1);
    });
  });

  group('resolveRestrictionKeys', () {
    test(
      'empty state, full cache → resolves from cache (no network)',
      () async {
        final keys = await resolveRestrictionKeys(
          const [],
          cached: () => _catalog,
          load: () async => throw StateError('should not have been called'),
        );

        expect(keys, restrictionKeysInPanelOrder(_catalog));
      },
    );

    test(
      'empty state and cache, successful load → resolves from network',
      () async {
        final keys = await resolveRestrictionKeys(
          const [],
          cached: () => const [],
          load: () async => _catalog,
        );

        expect(keys, restrictionKeysInPanelOrder(_catalog));
      },
    );

    test(
      'all empty/failed → returns empty (restrictions untouched)',
      () async {
        final keys = await resolveRestrictionKeys(
          const [],
          cached: () => const [],
          load: () async => throw StateError('no network'),
        );

        expect(keys, isEmpty);
      },
    );

    test(
      'a saved restriction stays enabled even if the initial load fails',
      () async {
        final keys = await resolveRestrictionKeys(
          const [],
          cached: () => _catalog,
          load: () async => const [],
        );
        final flat = restrictionSettingsToFlat(
          '{"restrictions":[{"restriction":"no_camera","value":1}]}',
          keys,
        );

        final input = InputController();
        const inputKey = 'policy.restriction_settings.no_camera';
        input.getController(
          inputKey,
          defaultValue: flat['restriction_settings.no_camera'],
        );
        expect(input.getValue(inputKey), '1');

        final json = flatToRestrictionSettings(flat, keys);
        final decoded = jsonDecode(json) as Map<String, dynamic>;
        final camera =
            (decoded['restrictions'] as List<dynamic>).firstWhere(
                  (item) =>
                      (item as Map<String, dynamic>)['restriction'] ==
                      'no_camera',
                )
                as Map<String, dynamic>;
        expect(camera['value'], 1);
      },
    );
  });

  group('panel order with RestrictionCatalog.all (38 entries)', () {
    test('the real catalog preserves the panel order exactly', () {
      final lookup = _readModuleCatalog();
      if (!lookup.exists) {
        markTestSkipped(
          'wonkru_core_server package not found (standalone panel copy); '
          'the 38-entry order parity test was skipped.',
        );
        return;
      }

      final entries = lookup.entries;
      expect(
        entries,
        isNotNull,
        reason:
            'Module catalog source was found but could not be parsed: ${lookup.path}',
      );
      expect(entries!.length, _panelOrderGolden.length);

      expect(
        restrictionKeysInPanelOrder(entries),
        _panelOrderGolden,
        reason:
            'Panel order changed. The `RestrictionCatalog.all` order or the '
            '`no_config_cell_broadcasts` tail in the `network` group '
            '(_groupTail) may have changed.',
      );
    });

    test('no_config_cell_broadcasts really is last in the network group', () {
      final lookup = _readModuleCatalog();
      if (!lookup.exists || lookup.entries == null) {
        markTestSkipped('Module catalog source missing; tail check skipped.');
        return;
      }

      final network =
          restrictionGroupsInPanelOrder(
                lookup.entries!,
              )
              .firstWhere(
                (group) => group.label.tr == L.policies.restrictionGroupNetwork,
              )
              .entries;

      expect(network.last.key, 'no_config_cell_broadcasts');
      expect(network.length, 8);
    });
  });
}

const _panelOrderGolden = <String>[
  'no_camera',
  'disallow_camera_toggle',
  'disallow_microphone_toggle',
  'ensure_verify_apps',
  'no_change_near_field_communication_radio',
  'no_near_field_communication_radio',
  'no_network_reset',
  'no_outgoing_beam',
  'no_sim_globally',
  'no_thread_network',
  'no_ultra_wideband_radio',
  'no_config_cell_broadcasts',
  'allow_parent_profile_app_linking',
  'no_control_apps',
  'no_create_windows',
  'no_run_in_background',
  'no_system_error_dialogs',
  'no_ambient_display',
  'no_bluetooth',
  'no_bluetooth_sharing',
  'no_config_bluetooth',
  'no_config_screen_timeout',
  'no_physical_media',
  'no_printing',
  'disallow_unmute_device',
  'restrictions_pending',
  'no_add_private_profile',
  'no_config_credentials',
  'no_modify_accounts',
  'no_remove_user',
  'no_set_user_icon',
  'no_assist_content',
  'no_content_capture',
  'no_content_suggestions',
  'no_cross_profile_copy_paste',
  'no_sharing_into_profile',
  'no_fun',
  'no_outgoing_calls',
];

typedef _ModuleCatalogLookup = ({
  bool exists,
  String? path,
  List<RestrictionCatalogEntry>? entries,
});

_ModuleCatalogLookup _readModuleCatalog() {
  const candidates = <String>[
    '../wonkru_core_server/lib/src/catalog/restriction_catalog.dart',
    'wonkru_core_server/lib/src/catalog/restriction_catalog.dart',
  ];

  String? existingPath;
  for (final path in candidates) {
    final file = File(path);
    if (!file.existsSync()) continue;

    existingPath = path;
    final entries = _parseModuleCatalog(file.readAsStringSync());
    if (entries != null) {
      return (exists: true, path: path, entries: entries);
    }
  }
  return (exists: existingPath != null, path: existingPath, entries: null);
}

List<RestrictionCatalogEntry>? _parseModuleCatalog(String source) {
  final entries = <RestrictionCatalogEntry>[];
  final pattern = RegExp(
    r'RestrictionCatalogEntry\((.*?)\n\s*\),',
    dotAll: true,
  );

  for (final match in pattern.allMatches(source)) {
    final body = match.group(1)!;
    final name = RegExp(r"name:\s*'([^']+)'").firstMatch(body)?.group(1);
    final key = RegExp(r"key:\s*'([^']+)'").firstMatch(body)?.group(1);
    final apiLevel = RegExp(r'apiLevel:\s*(\d+)').firstMatch(body)?.group(1);
    final group = RegExp(r"group:\s*'([^']+)'").firstMatch(body)?.group(1);

    if (name == null || key == null || apiLevel == null) return null;
    entries.add(
      RestrictionCatalogEntry(
        name: name,
        key: key,
        apiLevel: int.parse(apiLevel),
        group: group,
      ),
    );
  }

  return entries.isEmpty ? null : entries;
}
