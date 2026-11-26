import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/policy_enums.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_settings_codec.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_settings_tabs/policy_settings_tabs.dart';

void main() {
  final fields = policyFieldsByPath(policySettingsTabs);

  Map<String, dynamic> column(String? raw) => raw == null
      ? <String, dynamic>{}
      : jsonDecode(raw) as Map<String, dynamic>;

  group('conversion by field type', () {
    test('a text field that looks numeric stays text', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'display_settings.lock_screen_message': '1234',
        'other_settings.time_zone': '0300',
      }, fields: fields);

      expect(column(result.displaySettings)['lock_screen_message'], '1234');
      expect(column(result.otherSettings)['time_zone'], '0300');
    });

    test('color field stays text (000000 does not become zero)', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'launcher.design.background.color': '000000',
        'launcher.design.item_display.label_color': '112233',
      }, fields: fields);

      final design = column(result.launcher)['design'] as Map;
      expect((design['background'] as Map)['color'], '000000');
      expect((design['item_display'] as Map)['label_color'], '112233');
    });

    test(
      'number field becomes a number, decimals preserved; toggle becomes bool',
      () {
        final result = applySettings(Policy(name: 'p'), <String, dynamic>{
          'launcher.design.item_display.border_radius': '12.5',
          'launcher.design.columns': '4',
          'launcher.mode': 'true',
        }, fields: fields);

        final launcher = column(result.launcher);
        final design = launcher['design'] as Map;
        expect((design['item_display'] as Map)['border_radius'], 12.5);
        expect(design['columns'], 4);
        expect(launcher['mode'], isTrue);
      },
    );

    test('selection follows the types of the option keys', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'other_settings.time_12_24': '24',
        'launcher.design.item_display.icon_size': 'large',
        'display_settings.locked_orientation': '-1',
      }, fields: fields);

      expect(column(result.otherSettings)['time_12_24'], 24);
      final item =
          (column(result.launcher)['design'] as Map)['item_display'] as Map;
      expect(item['icon_size'], 'large');
      expect(column(result.displaySettings)['locked_orientation'], -1);
    });

    test('label list expands into a JSON array', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'security_settings.allowed_accessibility_apps': '["com.a"]',
      }, fields: fields);

      expect(
        column(result.securitySettings)['allowed_accessibility_apps'],
        ['com.a'],
      );
    });
  });

  group('tri-state fields', () {
    test('auto_time is written as integer 0/1/2, empty is not written', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'other_settings.auto_time': '2',
        'other_settings.auto_time_zone': '',
        'display_settings.screen_capture_policy': '0',
      }, fields: fields);

      final other = column(result.otherSettings);
      expect(other['auto_time'], 2);
      expect(other.containsKey('auto_time_zone'), isFalse);
      expect(column(result.displaySettings)['screen_capture_policy'], 0);
    });

    test('legacy bool auto_time record is written back as 1/0', () {
      final policy = Policy(
        name: 'p',
        otherSettings: '{"auto_time":true,"auto_time_zone":false}',
      );
      final flat = flattenSettings(policy);
      expect(normalizeTriStateInt(flat['other_settings.auto_time']!), '1');
      expect(normalizeTriStateInt(flat['other_settings.auto_time_zone']!), '0');

      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'other_settings.auto_time': flat['other_settings.auto_time'],
        'other_settings.auto_time_zone': flat['other_settings.auto_time_zone'],
      }, fields: fields);
      final other = column(result.otherSettings);
      expect(other['auto_time'], 1);
      expect(other['auto_time_zone'], 0);
    });

    test('tri-state bool: true/false is written, default is not written', () {
      final result = applySettings(Policy(name: 'p'), <String, dynamic>{
        'security_settings.keyguard.disable_fingerprint': 'true',
        'security_settings.keyguard.disable_iris': 'false',
        'security_settings.keyguard.disable_face_unlock': '',
        'display_settings.brightness_config_restriction': '',
      }, fields: fields);

      final keyguard = column(result.securitySettings)['keyguard'] as Map;
      expect(keyguard['disable_fingerprint'], isTrue);
      expect(keyguard['disable_iris'], isFalse);
      expect(keyguard.containsKey('disable_face_unlock'), isFalse);
      expect(result.displaySettings, isNull);
    });

    test(
      'tri-state full round trip: record → form → record stays equivalent',
      () {
        final original = Policy(
          name: 'p',
          otherSettings: '{"auto_time":2,"auto_time_zone":1}',
          securitySettings: '{"keyguard":{"disable_iris":false}}',
        );
        final result = applySettings(
          Policy(name: 'p'),
          flattenSettings(original),
          fields: fields,
        );
        expect(column(result.otherSettings), {
          'auto_time': 2,
          'auto_time_zone': 1,
        });
        expect(column(result.securitySettings), {
          'keyguard': {'disable_iris': false},
        });
      },
    );

    test('normalize helpers reduce unknown values to the default', () {
      expect(normalizeTriStateInt(''), '2');
      expect(normalizeTriStateInt('x'), '2');
      expect(normalizeTriStateBool('2'), '');
      expect(normalizeTriStateBool('1'), 'true');
    });
  });

  group('range validation', () {
    test('min brightness greater than max returns a violation', () {
      expect(
        policyRangeViolations(<String, dynamic>{
          'display_settings.min_brightness': '80',
          'display_settings.max_brightness': '20',
        }, fields.values),
        ['display_settings.min_brightness'],
      );
    });

    test('equal, empty or valid range is not a violation', () {
      expect(
        policyRangeViolations(<String, dynamic>{
          'display_settings.min_brightness': '20',
          'display_settings.max_brightness': '20',
        }, fields.values),
        isEmpty,
      );
      expect(
        policyRangeViolations(<String, dynamic>{
          'display_settings.min_brightness': '80',
          'display_settings.max_brightness': '',
        }, fields.values),
        isEmpty,
      );
    });

    test('min_brightness field is bounded by max_brightness', () {
      final spec = fields['display_settings.min_brightness']!;
      expect(spec.type, PolicyFieldType.slider);
      expect(spec.notAbovePath, 'display_settings.max_brightness');
    });
  });
}
