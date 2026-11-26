import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/policy_payload_normalizer.dart';

void main() {
  Map<String, dynamic> normalize(String column, Map<String, dynamic> value) =>
      PolicyPayloadNormalizer.normalizeColumn(column, value)
          as Map<String, dynamic>;

  group('tri-state', () {
    test('legacy bool auto_time/auto_time_zone becomes 1/0', () {
      final other = normalize('other_settings', {
        'auto_time': true,
        'auto_time_zone': false,
      });
      expect(other['auto_time'], 1);
      expect(other['auto_time_zone'], 0);
    });

    test('default (2) is preserved, unresolvable value is dropped from the key', () {
      final other = normalize('other_settings', {
        'auto_time': 2,
        'auto_time_zone': 'unknown',
      });
      expect(other['auto_time'], 2);
      expect(other.containsKey('auto_time_zone'), isFalse);
    });

    test('numeric text is converted to a tri-state integer', () {
      final display = normalize('display_settings', {
        'screen_capture_policy': '1',
        'auto_brightness_policy': '2',
      });
      expect(display['screen_capture_policy'], 1);
      expect(display['auto_brightness_policy'], 2);
    });

    test('tri-state bool: 2 and null count as default and are dropped', () {
      final security = normalize('security_settings', {
        'keyguard': {
          'disable_fingerprint': 'true',
          'disable_iris': 0,
          'disable_face_unlock': 2,
          'disable_smart_lock': null,
        },
      });
      final keyguard = security['keyguard'] as Map;
      expect(keyguard['disable_fingerprint'], isTrue);
      expect(keyguard['disable_iris'], isFalse);
      expect(keyguard.containsKey('disable_face_unlock'), isFalse);
      expect(keyguard.containsKey('disable_smart_lock'), isFalse);
    });

    test('restriction value: missing/malformed -> 2, bool -> 1/0', () {
      expect(PolicyPayloadNormalizer.restrictionValue(null), 2);
      expect(PolicyPayloadNormalizer.restrictionValue('x'), 2);
      expect(PolicyPayloadNormalizer.restrictionValue(7), 2);
      expect(PolicyPayloadNormalizer.restrictionValue(true), 1);
      expect(PolicyPayloadNormalizer.restrictionValue(false), 0);
      expect(PolicyPayloadNormalizer.restrictionValue('0'), 0);
      expect(PolicyPayloadNormalizer.restrictionValue(2), 2);
    });
  });

  group('text and number fields', () {
    test('lock message stays text even when stored as a number', () {
      final display = normalize('display_settings', {
        'lock_screen_message': 1234,
      });
      expect(display['lock_screen_message'], '1234');
    });

    test('a color turned into a number is padded to 6 digits; a text color is preserved', () {
      final launcher = normalize('launcher', {
        'design': {
          'background': {'color': 0},
          'item_display': {'label_color': '#FF0000', 'background_color': 1122},
        },
      });
      final design = launcher['design'] as Map;
      expect((design['background'] as Map)['color'], '000000');
      final item = design['item_display'] as Map;
      expect(item['label_color'], '#FF0000');
      expect(item['background_color'], '001122');
    });

    test('decimal border_radius is rounded; numeric text becomes int', () {
      final launcher = normalize('launcher', {
        'design': {
          'columns': '4',
          'item_display': {'border_radius': 12.5, 'label_font_size': '14.5'},
        },
      });
      final design = launcher['design'] as Map;
      expect(design['columns'], 4);
      final item = design['item_display'] as Map;
      expect(item['border_radius'], 13);
      expect(item['label_font_size'], 14.5);
    });

    test('bool fields are parsed from text', () {
      final launcher = normalize('launcher', {
        'mode': 'true',
        'header_widgets': {'left': 1, 'center': 'false'},
      });
      expect(launcher['mode'], isTrue);
      final header = launcher['header_widgets'] as Map;
      expect(header['left'], isTrue);
      expect(header['center'], isFalse);
    });

    test('unknown key passes through as-is (not converted to a number)', () {
      final other = normalize('other_settings', {'custom': '0012'});
      expect(other['custom'], '0012');
    });

    test('allowed_accessibility_apps JSON text is expanded into a list', () {
      final security = normalize('security_settings', {
        'allowed_accessibility_apps': '["com.a","com.b"]',
      });
      expect(security['allowed_accessibility_apps'], ['com.a', 'com.b']);
    });

    test('a non-object column is returned as-is', () {
      expect(PolicyPayloadNormalizer.normalizeColumn('launcher', null), isNull);
      expect(PolicyPayloadNormalizer.normalizeColumn('launcher', [1]), [1]);
    });
  });
}
