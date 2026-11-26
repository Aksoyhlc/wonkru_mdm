import 'package:test/test.dart';
import 'package:wonkru_core_server/src/catalog/restriction_catalog.dart';

/// Verifies the restriction catalog is the single source and matches the
/// restriction contract. The golden list pins all 38 entries by
/// `(name, key, apiLevel, group)`, so a silent change to any entry breaks the test.
///
/// The catalog carries no user text (labels are resolved in the panel via
/// `policies.restriction.<key>`), so `label` is not pinned here.
void main() {
  group('Given the module restriction catalog', () {
    test('when read then it carries the 38 keys in enum order', () {
      expect(RestrictionCatalog.all, hasLength(38));
      expect(
        RestrictionCatalog.all.map((entry) => entry.key).toList(),
        <String>[
          'allow_parent_profile_app_linking',
          'no_add_private_profile',
          'no_ambient_display',
          'no_control_apps',
          'no_assist_content',
          'no_bluetooth',
          'no_bluetooth_sharing',
          'no_camera',
          'disallow_camera_toggle',
          'no_change_near_field_communication_radio',
          'no_config_bluetooth',
          'no_config_cell_broadcasts',
          'no_config_credentials',
          'no_config_screen_timeout',
          'no_content_capture',
          'no_content_suggestions',
          'no_create_windows',
          'no_cross_profile_copy_paste',
          'no_fun',
          'disallow_microphone_toggle',
          'no_modify_accounts',
          'no_physical_media',
          'no_near_field_communication_radio',
          'no_network_reset',
          'no_outgoing_beam',
          'no_outgoing_calls',
          'no_printing',
          'no_remove_user',
          'no_run_in_background',
          'no_set_user_icon',
          'no_sharing_into_profile',
          'no_sim_globally',
          'no_system_error_dialogs',
          'no_thread_network',
          'no_ultra_wideband_radio',
          'disallow_unmute_device',
          'ensure_verify_apps',
          'restrictions_pending',
        ],
      );
    });

    test('when read then every entry pins the exact contract', () {
      expect(
        RestrictionCatalog.all
            .map(
              (entry) => (entry.name, entry.key, entry.apiLevel, entry.group),
            )
            .toList(),
        goldenTuples,
      );
    });

    test('when looked up by key then every entry is addressable', () {
      expect(RestrictionCatalog.byKey, hasLength(38));
      for (final entry in RestrictionCatalog.all) {
        expect(RestrictionCatalog.byKey[entry.key], same(entry));
      }
      expect(RestrictionCatalog.byKey['not_a_restriction'], isNull);
    });

    test('when checked then keys and names are unique and populated', () {
      expect(
        RestrictionCatalog.all.map((entry) => entry.key).toSet(),
        hasLength(38),
      );
      expect(
        RestrictionCatalog.all.map((entry) => entry.name).toSet(),
        hasLength(38),
      );
      for (final entry in RestrictionCatalog.all) {
        expect(entry.name, isNotEmpty);
        expect(entry.key, isNotEmpty);
        expect(entry.apiLevel, greaterThanOrEqualTo(18));
      }
    });

    test('when checked then every entry carries a group', () {
      const groups = <String>{
        'security',
        'network',
        'applications',
        'device',
        'user_and_account',
        'privacy_and_sharing',
        'system_and_ui',
      };

      for (final entry in RestrictionCatalog.all) {
        expect(groups, contains(entry.group));
      }
    });

    test('when mutated then the single source stays immutable', () {
      expect(
        () => RestrictionCatalog.all.add(RestrictionCatalog.all.first),
        throwsUnsupportedError,
      );
      expect(
        () => RestrictionCatalog.byKey['x'] = RestrictionCatalog.all.first,
        throwsUnsupportedError,
      );
    });

    test('when a known key is read then the pinned values are kept', () {
      final camera = RestrictionCatalog.byKey['no_camera']!;
      expect(camera.name, 'DISALLOW_CAMERA');
      expect(camera.apiLevel, 18);
      expect(camera.group, 'security');

      final pending = RestrictionCatalog.byKey['restrictions_pending']!;
      expect(pending.name, 'KEY_RESTRICTIONS_PENDING');
      expect(pending.apiLevel, 22);
      expect(pending.group, 'device');
    });
  });
}

/// All 38 entries, in enum order: `(name, key, apiLevel, group)`.
const List<(String, String, int, String?)>
goldenTuples = <(String, String, int, String?)>[
  (
    'ALLOW_PARENT_PROFILE_APP_LINKING',
    'allow_parent_profile_app_linking',
    23,
    'applications',
  ),
  (
    'DISALLOW_ADD_PRIVATE_PROFILE',
    'no_add_private_profile',
    35,
    'user_and_account',
  ),
  ('DISALLOW_AMBIENT_DISPLAY', 'no_ambient_display', 28, 'device'),
  ('DISALLOW_APPS_CONTROL', 'no_control_apps', 21, 'applications'),
  ('DISALLOW_ASSIST_CONTENT', 'no_assist_content', 35, 'privacy_and_sharing'),
  ('DISALLOW_BLUETOOTH', 'no_bluetooth', 26, 'device'),
  ('DISALLOW_BLUETOOTH_SHARING', 'no_bluetooth_sharing', 26, 'device'),
  ('DISALLOW_CAMERA', 'no_camera', 18, 'security'),
  ('DISALLOW_CAMERA_TOGGLE', 'disallow_camera_toggle', 31, 'security'),
  (
    'DISALLOW_CHANGE_NEAR_FIELD_COMMUNICATION_RADIO',
    'no_change_near_field_communication_radio',
    36,
    'network',
  ),
  ('DISALLOW_CONFIG_BLUETOOTH', 'no_config_bluetooth', 18, 'device'),
  (
    'DISALLOW_CONFIG_CELL_BROADCASTS',
    'no_config_cell_broadcasts',
    21,
    'network',
  ),
  (
    'DISALLOW_CONFIG_CREDENTIALS',
    'no_config_credentials',
    18,
    'user_and_account',
  ),
  ('DISALLOW_CONFIG_SCREEN_TIMEOUT', 'no_config_screen_timeout', 28, 'device'),
  ('DISALLOW_CONTENT_CAPTURE', 'no_content_capture', 29, 'privacy_and_sharing'),
  (
    'DISALLOW_CONTENT_SUGGESTIONS',
    'no_content_suggestions',
    29,
    'privacy_and_sharing',
  ),
  ('DISALLOW_CREATE_WINDOWS', 'no_create_windows', 21, 'applications'),
  (
    'DISALLOW_CROSS_PROFILE_COPY_PASTE',
    'no_cross_profile_copy_paste',
    21,
    'privacy_and_sharing',
  ),
  ('DISALLOW_FUN', 'no_fun', 23, 'system_and_ui'),
  ('DISALLOW_MICROPHONE_TOGGLE', 'disallow_microphone_toggle', 31, 'security'),
  ('DISALLOW_MODIFY_ACCOUNTS', 'no_modify_accounts', 18, 'user_and_account'),
  ('DISALLOW_MOUNT_PHYSICAL_MEDIA', 'no_physical_media', 21, 'device'),
  (
    'DISALLOW_NEAR_FIELD_COMMUNICATION_RADIO',
    'no_near_field_communication_radio',
    35,
    'network',
  ),
  ('DISALLOW_NETWORK_RESET', 'no_network_reset', 23, 'network'),
  ('DISALLOW_OUTGOING_BEAM', 'no_outgoing_beam', 22, 'network'),
  ('DISALLOW_OUTGOING_CALLS', 'no_outgoing_calls', 21, 'system_and_ui'),
  ('DISALLOW_PRINTING', 'no_printing', 28, 'device'),
  ('DISALLOW_REMOVE_USER', 'no_remove_user', 18, 'user_and_account'),
  ('DISALLOW_RUN_IN_BACKGROUND', 'no_run_in_background', 18, 'applications'),
  ('DISALLOW_SET_USER_ICON', 'no_set_user_icon', 24, 'user_and_account'),
  (
    'DISALLOW_SHARE_INTO_MANAGED_PROFILE',
    'no_sharing_into_profile',
    28,
    'privacy_and_sharing',
  ),
  ('DISALLOW_SIM_GLOBALLY', 'no_sim_globally', 35, 'network'),
  (
    'DISALLOW_SYSTEM_ERROR_DIALOGS',
    'no_system_error_dialogs',
    28,
    'applications',
  ),
  ('DISALLOW_THREAD_NETWORK', 'no_thread_network', 36, 'network'),
  ('DISALLOW_ULTRA_WIDEBAND_RADIO', 'no_ultra_wideband_radio', 34, 'network'),
  ('DISALLOW_UNMUTE_DEVICE', 'disallow_unmute_device', 28, 'device'),
  ('ENSURE_VERIFY_APPS', 'ensure_verify_apps', 21, 'security'),
  ('KEY_RESTRICTIONS_PENDING', 'restrictions_pending', 22, 'device'),
];
