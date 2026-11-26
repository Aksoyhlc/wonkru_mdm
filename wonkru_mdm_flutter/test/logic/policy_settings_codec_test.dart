import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_settings_codec.dart';

void expectJsonEquals(String? actual, String? expected) {
  if (expected == null) {
    expect(actual, isNull);
    return;
  }
  expect(actual, isNotNull);
  expect(jsonDecode(actual!), equals(jsonDecode(expected)));
}

void main() {
  group('flattenSettings', () {
    test('flattens nested objects into dotted paths', () {
      final policy = Policy(
        name: 'p',
        securitySettings:
            '{"password_policy":{"min_length":6,"require_alpha":true}}',
      );

      final flat = flattenSettings(policy);

      expect(
        flat['security_settings.password_policy.min_length'],
        '6',
      );
      expect(
        flat['security_settings.password_policy.require_alpha'],
        'true',
      );
      expect(
        jsonDecode(flat['security_settings']!),
        equals({
          'password_policy': {'min_length': 6, 'require_alpha': true},
        }),
      );
    });

    test('number, bool and string values are formatted correctly', () {
      final policy = Policy(
        name: 'p',
        syncSettings:
            '{"max_interval_minutes":60,"enabled":true,"cron":"0 * * * *"}',
      );

      final flat = flattenSettings(policy);

      expect(flat['sync_settings.max_interval_minutes'], '60');
      expect(flat['sync_settings.enabled'], 'true');
      expect(flat['sync_settings.cron'], '0 * * * *');
    });

    test('arrays are stored as JSON strings', () {
      final policy = Policy(
        name: 'p',
        activeTimeRanges: '{"monday":["09:00","17:00"]}',
      );

      final flat = flattenSettings(policy);

      expect(flat['active_time_ranges.monday'], '["09:00","17:00"]');
    });

    test('empty and invalid columns are skipped', () {
      final policy = Policy(
        name: 'p',
        batterySettings: '',
        storageSettings: 'invalid json',
      );

      final flat = flattenSettings(policy);

      expect(flat, isEmpty);
    });

    test('multiple columns are flattened independently', () {
      final policy = Policy(
        name: 'p',
        batterySettings: '{"low_battery_threshold":20}',
        storageSettings: '{"warning_threshold":80}',
        otherSettings: '{"time_12_24":24}',
      );

      final flat = flattenSettings(policy);

      expect(flat['battery_settings.low_battery_threshold'], '20');
      expect(flat['storage_settings.warning_threshold'], '80');
      expect(flat['other_settings.time_12_24'], '24');
    });
  });

  group('applySettings', () {
    test('builds dotted paths into a nested object', () {
      final result = applySettings(
        Policy(name: 'p'),
        <String, dynamic>{
          'security_settings.password_policy.min_length': '6',
          'security_settings.password_policy.require_alpha': 'true',
        },
      );

      expectJsonEquals(
        result.securitySettings,
        '{"password_policy":{"min_length":6,"require_alpha":true}}',
      );
    });

    test('number and bool strings are converted to JSON types', () {
      final result = applySettings(
        Policy(name: 'p'),
        <String, dynamic>{
          'sync_settings.max_interval_minutes': '60',
          'sync_settings.enabled': 'false',
          'sync_settings.cron': '0 * * * *',
        },
      );

      expectJsonEquals(
        result.syncSettings,
        '{"max_interval_minutes":60,"enabled":false,"cron":"0 * * * *"}',
      );
    });

    test('an all-empty group column becomes null', () {
      final base = Policy(
        name: 'p',
        batterySettings: '{"low_battery_threshold":20}',
      );

      final result = applySettings(base, <String, dynamic>{
        'battery_settings.low_battery_threshold': '',
        'battery_settings.critical_battery_threshold': '',
      });

      expect(result.batterySettings, isNull);
    });

    test('untouched columns are preserved', () {
      final base = Policy(
        name: 'p',
        otherSettings: '{"time_12_24":12}',
        storageSettings: '{"warning_threshold":80}',
      );

      final result = applySettings(base, <String, dynamic>{
        'battery_settings.low_battery_threshold': '15',
      });

      expectJsonEquals(result.otherSettings, '{"time_12_24":12}');
      expectJsonEquals(result.storageSettings, '{"warning_threshold":80}');
      expectJsonEquals(
        result.batterySettings,
        '{"low_battery_threshold":15}',
      );
    });

    test('multiple columns are updated independently', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'battery_settings.low_battery_threshold': '20',
        'storage_settings.warning_threshold': '80',
        'other_settings.auto_time': 'true',
      });

      expectJsonEquals(
        result.batterySettings,
        '{"low_battery_threshold":20}',
      );
      expectJsonEquals(
        result.storageSettings,
        '{"warning_threshold":80}',
      );
      expectJsonEquals(result.otherSettings, '{"auto_time":true}');
    });

    test('empty map leaves the policy unchanged', () {
      final base = Policy(
        name: 'p',
        audioSettings: '{"fixed_volume":50}',
      );

      final result = applySettings(base, <String, dynamic>{});

      expect(identical(result, base), isTrue);
    });

    test('unknown prefix is ignored', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'wallpaper.foo': 'bar',
      });

      expect(result.batterySettings, isNull);
      expect(result.otherSettings, isNull);
    });
  });

  group('round trip (flatten → apply)', () {
    test('JSON values stay equivalent', () {
      final original = Policy(
        name: 'p',
        batterySettings:
            '{"low_battery_threshold":20,"critical_battery_threshold":10}',
        syncSettings: '{"max_interval_minutes":60,"enabled":true}',
        securitySettings:
            '{"password_policy":{"min_length":6,"require_alpha":true}}',
        otherSettings: '{"time_12_24":24,"time_zone":"Europe/Istanbul"}',
        activeTimeRanges: '{"monday":"09:00-17:00"}',
      );

      final flat = flattenSettings(original);
      final result = applySettings(Policy(name: 'p'), flat);

      expectJsonEquals(result.batterySettings, original.batterySettings);
      expectJsonEquals(result.syncSettings, original.syncSettings);
      expectJsonEquals(result.securitySettings, original.securitySettings);
      expectJsonEquals(result.otherSettings, original.otherSettings);
      expectJsonEquals(result.activeTimeRanges, original.activeTimeRanges);
    });
  });

  group('new nested paths (Display / Security / Launcher)', () {
    test('flatten spreads subfields into dotted paths', () {
      final policy = Policy(
        name: 'p',
        displaySettings: '{"brightness_level":50,"rotation_policy":1}',
        launcher:
            '{"design":{"columns":4,"background":{"type":"color","color":"#FFFFFF"}}}',
        securitySettings:
            '{"password_policy":{"min_length":6},"keyguard":{"disable_fingerprint":true}}',
      );

      final flat = flattenSettings(policy);

      expect(flat['display_settings.brightness_level'], '50');
      expect(flat['display_settings.rotation_policy'], '1');
      expect(flat['launcher.design.columns'], '4');
      expect(flat['launcher.design.background.type'], 'color');
      expect(flat['launcher.design.background.color'], '#FFFFFF');
      expect(
        flat['security_settings.password_policy.min_length'],
        '6',
      );
      expect(
        flat['security_settings.keyguard.disable_fingerprint'],
        'true',
      );
    });

    test('stays equivalent across a flatten → apply round trip', () {
      final original = Policy(
        name: 'p',
        displaySettings:
            '{"brightness_level":50,"min_brightness":10,"max_brightness":90}',
        launcher:
            '{"mode":true,"design":{"columns":4,"item_display":{"show_label":true}}}',
        securitySettings:
            '{"keyguard":{"disable_iris":true},"allowed_accessibility_apps":["com.a"]}',
      );

      final flat = flattenSettings(original);
      final result = applySettings(Policy(name: 'p'), flat);

      expectJsonEquals(result.displaySettings, original.displaySettings);
      expectJsonEquals(result.launcher, original.launcher);
      expectJsonEquals(result.securitySettings, original.securitySettings);
    });

    test('tags field is flattened as a JSON array string and resolved to a list', () {
      final policy = Policy(
        name: 'p',
        securitySettings: '{"allowed_accessibility_apps":["com.a","com.b"]}',
      );

      final flat = flattenSettings(policy);

      expect(
        flat['security_settings.allowed_accessibility_apps'],
        '["com.a","com.b"]',
      );

      final result = applySettings(Policy(name: 'p'), flat);

      expectJsonEquals(
        result.securitySettings,
        '{"allowed_accessibility_apps":["com.a","com.b"]}',
      );
    });
  });

  group('restriction_settings', () {
    const keys = <String>['no_camera', 'no_bluetooth'];

    test('restrictionSettingsToFlat expands the list into 0/1 keys', () {
      final flat = restrictionSettingsToFlat(
        '{"restrictions":[{"restriction":"no_camera","value":1},'
        '{"restriction":"no_bluetooth","value":0}]}',
        keys,
      );

      expect(flat['restriction_settings.no_camera'], '1');
      expect(flat['restriction_settings.no_bluetooth'], '0');
    });

    test('missing key and empty/invalid JSON fall back to default (2)', () {
      final missing = restrictionSettingsToFlat(
        '{"restrictions":[{"restriction":"no_camera","value":1}]}',
        keys,
      );
      expect(missing['restriction_settings.no_bluetooth'], '2');

      expect(
        restrictionSettingsToFlat(null, keys)['restriction_settings.no_camera'],
        '2',
      );
      expect(
        restrictionSettingsToFlat(
          'invalid json',
          keys,
        )['restriction_settings.no_camera'],
        '2',
      );
    });

    test('stored 2, bool and unknown values reduce to three states', () {
      final flat = restrictionSettingsToFlat(
        '{"restrictions":[{"restriction":"no_camera","value":2},'
        '{"restriction":"no_bluetooth","value":true}]}',
        keys,
      );
      expect(flat['restriction_settings.no_camera'], '2');
      expect(flat['restriction_settings.no_bluetooth'], '1');

      final odd = restrictionSettingsToFlat(
        '{"restrictions":[{"restriction":"no_camera","value":7},'
        '{"restriction":"no_bluetooth","value":false}]}',
        keys,
      );
      expect(odd['restriction_settings.no_camera'], '2');
      expect(odd['restriction_settings.no_bluetooth'], '0');
    });

    test('empty/default selection is saved as 2, allow stays 0', () {
      final json = flatToRestrictionSettings(<String, String>{
        'restriction_settings.no_camera': '',
        'restriction_settings.no_bluetooth': '0',
      }, keys);

      expect(
        jsonDecode(json),
        equals({
          'restrictions': [
            {'restriction': 'no_camera', 'value': 2},
            {'restriction': 'no_bluetooth', 'value': 0},
          ],
        }),
      );
    });

    test('tri-state full round trip: 0/1/2 are preserved as-is', () {
      const original =
          '{"restrictions":[{"restriction":"no_camera","value":2},'
          '{"restriction":"no_bluetooth","value":0}]}';
      final rebuilt = flatToRestrictionSettings(
        restrictionSettingsToFlat(original, keys),
        keys,
      );
      expectJsonEquals(rebuilt, original);
    });

    test('legacy flat map format is also read', () {
      final flat = restrictionSettingsToFlat(
        '{"no_camera":1,"no_bluetooth":1}',
        keys,
      );

      expect(flat['restriction_settings.no_camera'], '1');
      expect(flat['restriction_settings.no_bluetooth'], '1');
    });

    test('flatToRestrictionSettings produces the list in canonical order', () {
      final json = flatToRestrictionSettings(<String, String>{
        'restriction_settings.no_camera': '1',
        'restriction_settings.no_bluetooth': '0',
      }, keys);

      expect(
        jsonDecode(json),
        equals({
          'restrictions': [
            {'restriction': 'no_camera', 'value': 1},
            {'restriction': 'no_bluetooth', 'value': 0},
          ],
        }),
      );
    });

    test('applySettings builds the restriction root object', () {
      final json = flatToRestrictionSettings(<String, String>{
        'restriction_settings.no_camera': '1',
        'restriction_settings.no_bluetooth': '0',
      }, keys);

      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'restriction_settings': json,
      });

      expectJsonEquals(result.restrictionSettings, json);
    });

    test('full round trip: record → flat keys → record stays equivalent', () {
      final original = Policy(
        name: 'p',
        restrictionSettings:
            '{"restrictions":[{"restriction":"no_camera","value":1},'
            '{"restriction":"no_bluetooth","value":0}]}',
      );

      final perKey = restrictionSettingsToFlat(
        original.restrictionSettings,
        keys,
      );
      final rebuilt = flatToRestrictionSettings(perKey, keys);
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'restriction_settings': rebuilt,
      });

      expectJsonEquals(
        result.restrictionSettings,
        original.restrictionSettings,
      );
    });
  });
}
