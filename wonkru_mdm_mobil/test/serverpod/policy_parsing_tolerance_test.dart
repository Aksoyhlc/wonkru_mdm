import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Constants/Enums/screen_orientation.dart';
import 'package:wonkrumdm/Core/Managers/keyguard_manager.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_rpc_mapper.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';
import 'package:wonkrumdm/Data/Models/Features/index.dart';
import 'package:wonkrumdm/Data/Repositories/device_repository.dart';

void main() {
  group('JsonParse', () {
    test('integer: int, double (rounded), numeric text', () {
      expect(JsonParse.toInt(3), 3);
      expect(JsonParse.toInt(12.5), 13);
      expect(JsonParse.toInt('7'), 7);
      expect(JsonParse.toInt('7.4'), 7);
      expect(JsonParse.toInt(true), isNull);
      expect(JsonParse.toInt('seven'), isNull);
    });

    test('bool: bool, 1/0, text', () {
      expect(JsonParse.toBool(true), isTrue);
      expect(JsonParse.toBool(1), isTrue);
      expect(JsonParse.toBool('0'), isFalse);
      expect(JsonParse.toBool('TRUE'), isTrue);
      expect(JsonParse.toBool(2), isNull);
      expect(JsonParse.toBool('yes'), isNull);
    });

    test('OnOff: bool/int/text, unknown null', () {
      expect(JsonParse.toOnOff(true), OnOff.on);
      expect(JsonParse.toOnOff(false), OnOff.off);
      expect(JsonParse.toOnOff(2), OnOff.def);
      expect(JsonParse.toOnOff('1'), OnOff.on);
      expect(JsonParse.toOnOff(9), isNull);
      expect(JsonParse.toOnOff(1.5), isNull);
      expect(JsonParse.toOnOffOrDef('x'), OnOff.def);
    });

    test('tri-state bool: 2 and unknown default (null)', () {
      expect(JsonParse.toTriStateBool(true), isTrue);
      expect(JsonParse.toTriStateBool(0), isFalse);
      expect(JsonParse.toTriStateBool(2), isNull);
      expect(JsonParse.toTriStateBool('2'), isNull);
      expect(JsonParse.toTriStateBool(null), isNull);
    });

    test('nested: a broken child object only drops itself', () {
      final parsed = JsonParse.nested<int>({'a': 1}, (_) => throw StateError('boom'), field: 'test');
      expect(parsed, isNull);
      expect(JsonParse.nested('not a map', (m) => 1, field: 'test'), isNull);
    });
  });

  group('crash cases', () {
    test('does not crash when auto_time is a bool, becomes on/off', () {
      final config = OtherSettingsConfig.fromJson({'auto_time': true, 'auto_time_zone': false});
      expect(config.autoTime, OnOff.on);
      expect(config.autoTimeZone, OnOff.off);
    });

    test('auto_time 2/missing/unknown defaults (leave alone)', () {
      expect(OtherSettingsConfig.fromJson({'auto_time': 2}).autoTime, OnOff.def);
      expect(OtherSettingsConfig.fromJson({}).autoTime, isNull);
      expect(OtherSettingsConfig.fromJson({'auto_time': 'x'}).autoTime, isNull);
    });

    test('a numeric "1234" lock message is read as text', () {
      final display = DisplayConfig.fromJson({'lock_screen_message': 1234});
      expect(display.lockScreenMessage, '1234');
    });

    test('a numeric "000000" color is padded to 6 digits', () {
      final background = LauncherBackground.fromJson({'color': 0});
      expect(background.color, '000000');
      final item = LauncherItemDisplay.fromJson({'label_color': 1122, 'background_color': '#FFFFFF'});
      expect(item.labelColor, '001122');
      expect(item.backgroundColor, '#FFFFFF');
    });

    test('12.5 border_radius is rounded and the font size is parsed from text', () {
      final item = LauncherItemDisplay.fromJson({
        'border_radius': 12.5,
        'label_font_size': '14',
        'show_label': 'false',
      });
      expect(item.borderRadius, 13);
      expect(item.labelFontSize, 14.0);
      expect(item.showLabel, isFalse);
    });

    test('brightness min > max does not throw; the range is ignored', () {
      final display = DisplayConfig.fromJson({'min_brightness': 80, 'max_brightness': 20, 'brightness_level': 50});
      expect(display.minBrightness, isNull);
      expect(display.maxBrightness, isNull);
      expect(display.brightnessLevel, 50);
    });

    test('unknown enum values fall back to the default', () {
      final display = DisplayConfig.fromJson({
        'screen_capture_policy': 9,
        'auto_brightness_policy': 'unknown',
        'rotation_policy': 'x',
        'locked_orientation': 42,
      });
      expect(display.screenCapturePolicy, OnOff.def);
      expect(display.autoBrightnessPolicy, OnOff.def);
      expect(display.rotationPolicy, RotationPolicy.systemDefault);
      expect(display.lockedOrientation, ScreenOrientation.auto);

      final design = LauncherDesign.fromJson({
        'layout_type': 'hexagon',
        'item_display': {'icon_size': 'huge'},
      });
      expect(design.layoutType, isNull);
      expect(design.itemDisplay?.iconSize, isNull);

      expect(RestrictModel.fromJson({'key': 'no_camera', 'value': 'x'}).value, OnOff.def);
    });
  });

  group('DeviceConfig.fromJson', () {
    test('the policy is still built despite all the crash fields', () {
      final config = DeviceConfig.fromJson({
        'id': '7',
        'name': 'P',
        'version': 3,
        'is_active': 1,
        'other_settings': {'auto_time': true, 'time_12_24': '24'},
        'display_settings': {'lock_screen_message': 1234, 'min_brightness': 90, 'max_brightness': 10},
        'launcher': {
          'mode': 'true',
          'design': {
            'columns': '4',
            'background': {'type': 'color', 'color': 0},
            'item_display': {'border_radius': 12.5},
          },
          'header_widgets': 'broken',
        },
        'audio_settings': 'not a map',
        'restriction_settings': {
          'restrictions': [
            {'key': 'no_camera', 'value': 1},
            'broken entry',
            {'key': 'no_sms', 'value': true},
          ],
        },
        'applications': {
          'management_apps': [
            {
              'sort': '1',
              'run_on_boot': 2,
              'application': {'package_name': 'a'},
            },
            42,
          ],
        },
        'files': [
          {
            'id': 1,
            'name': 'Hand note',
            'file': {'name': 'handout', 'size_bytes': '3'},
          },
        ],
        'active_time_ranges': {'08:00': '18:00', '20:00': null},
      });

      expect(config.id, 7);
      expect(config.isActive, isTrue);
      expect(config.otherSettings?.autoTime, OnOff.on);
      expect(config.otherSettings?.time1224, 24);
      expect(config.displaySettings?.lockScreenMessage, '1234');
      expect(config.displaySettings?.minBrightness, isNull);
      expect(config.launcherConfig?.isActive, isTrue);
      expect(config.launcherConfig?.design?.columns, 4);
      expect(config.launcherConfig?.design?.background?.color, '000000');
      expect(config.launcherConfig?.design?.itemDisplay?.borderRadius, 13);
      expect(config.launcherConfig?.headerWidgets, isNull);
      expect(config.audioSettings, isNull);
      expect(config.restrictionSettings?.restrictions?.map((r) => r.value).toList(), [OnOff.on, OnOff.on]);
      expect(config.applications, hasLength(1));
      expect(config.applications!.single.sort, 1);
      expect(config.applications!.single.runOnBoot, OnOff.def);
      expect(config.fileSettings?.policies.single.name, 'Hand note');
      expect(config.fileSettings?.policies.single.file?.sizeBytes, 3);
      expect(config.activeTimeRanges, {'08:00': '18:00'});
    });

    test('a missing header widget key counts as visible; false hides it', () {
      final header = HeaderWidgetsConfig.fromJson({'left': false});
      expect(header.left, isFalse);
      expect(header.center, isTrue);
      expect(header.right, isTrue);
    });

    test('falls back to the file’s own name when the policy name is missing', () {
      final policy = FilePolicy.fromJson({
        'file': {'name': 'handout'},
      });
      expect(policy.name, 'handout');
    });
  });

  group('parse-then-persist', () {
    test('a parsed policy is persisted', () async {
      Map<String, dynamic>? saved;
      final (config, error) = await DeviceRepository.acceptRemoteConfig({
        'id': 5,
        'name': 'P',
      }, persist: (raw) async => saved = raw);
      expect(error, isNull);
      expect(config?.id, 5);
      expect(saved?['id'], 5);
    });

    test('an unparseable policy is not persisted; the last valid config is kept', () async {
      var persisted = false;
      final (config, error) = await DeviceRepository.acceptRemoteConfig(
        {'id': 5},
        persist: (_) async => persisted = true,
        parse: (_) => null,
      );
      expect(config, isNull);
      expect(error, ConfigApplyResult.invalidPolicy);
      expect(persisted, isFalse);
    });
  });

  group('tri-state application', () {
    test('lock flag: true restricts, false frees, null leaves alone', () {
      expect(OnOff.fromRestrictionBool(true), OnOff.on);
      expect(OnOff.fromRestrictionBool(false), OnOff.off);
      expect(OnOff.fromRestrictionBool(null), OnOff.def);
    });

    test('display lock flags are read as tri-state', () {
      final display = DisplayConfig.fromJson({
        'screen_timeout_config_restriction': 2,
        'brightness_config_restriction': 'true',
      });
      expect(display.screenTimeoutConfigRestriction, isNull);
      expect(display.brightnessConfigRestriction, isTrue);
    });

    test('keyguard: default fields preserve the on-device bit', () {
      final config = KeyguardConfig.fromJson({
        'disable_fingerprint': true,
        'disable_lock_screen_camera': false,
        'disable_iris': 2,
      });
      final merged = KeyguardManager.mergeKeyguardFlags(config, {
        'secure_camera': true,
        'iris': true,
        'trust_agents': true,
      });
      expect(merged['fingerprint'], isTrue);
      expect(merged['secure_camera'], isFalse);
      expect(merged['iris'], isTrue);
      expect(merged['trust_agents'], isTrue);
      expect(merged['face'], isFalse);
    });

    test('keyguard is not applied at all when fully default', () {
      expect(KeyguardConfig.fromJson({}).isAllDefault, isTrue);
      expect(KeyguardConfig.fromJson({'disable_iris': 2}).isAllDefault, isTrue);
      expect(KeyguardConfig.fromJson({'disable_iris': false}).isAllDefault, isFalse);
    });
  });

  group('identity mismatch', () {
    test('a mismatch is not counted as a token rejection and the identity is adopted', () {
      final error = DeviceIdentityMismatchException(
        message: 'mismatch',
        deviceUuid: 'real-uuid',
        deviceCode: 'ABC123',
      );
      expect(EnrollmentRecovery.isUnauthenticated(error), isFalse);
      final identity = EnrollmentRecovery.identityToAdopt(error);
      expect(identity?.uuid, 'real-uuid');
      expect(identity?.code, 'ABC123');
    });

    test('a mismatch without a uuid, or any other error, is not adopted', () {
      expect(EnrollmentRecovery.identityToAdopt(DeviceIdentityMismatchException(message: 'm')), isNull);
      expect(EnrollmentRecovery.identityToAdopt(DeviceUnauthenticatedException(message: 'x')), isNull);
    });
  });

  test('log mapping carries each record’s own sessionId', () {
    final entries = DeviceRpcMapper.logEntries([
      LogEntry(id: '1', timestamp: 't', level: 2, tag: 'a', message: 'm', sessionId: 's1'),
      LogEntry(id: '2', timestamp: 't', level: 2, tag: 'a', message: 'm', sessionId: 's2'),
    ]);
    expect(entries.map((e) => e.sessionId), ['s1', 's2']);
  });
}
