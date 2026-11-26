import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/ProvisioningProfiles/Widgets/provisioning_config.dart';

void main() {
  group('tryParse', () {
    test('maps top-level and bundle keys to fields', () {
      final raw = jsonEncode({
        ProvisioningConfig.componentNameKey: 'pkg/receiver',
        ProvisioningConfig.apkUrlKey: 'https://cdn/agent.apk',
        ProvisioningConfig.signatureChecksumKey: 'abc123',
        ProvisioningConfig.timeZoneKey: 'Europe/Berlin',
        ProvisioningConfig.localeKey: 'de_DE',
        ProvisioningConfig.organizationKey: 'ACME',
        ProvisioningConfig.adminExtrasBundleKey: {
          ProvisioningConfig.serverUrlKey: 'https://mdm.example',
          ProvisioningConfig.policyIdKey: 7,
          ProvisioningConfig.groupIdKey: 3,
          ProvisioningConfig.deviceCodeKey: 'DEV-42',
        },
      });

      final config = ProvisioningConfig.tryParse(raw)!;

      expect(config.componentName, 'pkg/receiver');
      expect(config.apkUrl, 'https://cdn/agent.apk');
      expect(config.signatureChecksum, 'abc123');
      expect(config.timeZone, 'Europe/Berlin');
      expect(config.locale, 'de_DE');
      expect(config.organization, 'ACME');
      expect(config.serverUrl, 'https://mdm.example');
      expect(config.policyId, 7);
      expect(config.groupId, 3);
      expect(config.deviceCode, 'DEV-42');
    });

    test('missing timeZone/locale/organization falls back to defaults', () {
      final config = ProvisioningConfig.tryParse('{"other":"x"}')!;

      expect(config.timeZone, 'Europe/Istanbul');
      expect(config.locale, 'tr_TR');
      expect(config.organization, 'Wonkru MDM');
    });

    test('empty and invalid JSON return null', () {
      expect(ProvisioningConfig.tryParse(''), isNull);
      expect(ProvisioningConfig.tryParse('   '), isNull);
      expect(ProvisioningConfig.tryParse('invalid'), isNull);
      expect(ProvisioningConfig.tryParse('[1,2]'), isNull);
    });

    test('numeric text policy/group is accepted', () {
      final raw = jsonEncode({
        ProvisioningConfig.adminExtrasBundleKey: {
          ProvisioningConfig.policyIdKey: '12',
          ProvisioningConfig.groupIdKey: '4',
        },
      });

      final config = ProvisioningConfig.tryParse(raw)!;

      expect(config.policyId, 12);
      expect(config.groupId, 4);
    });
  });

  group('toMap / toJson', () {
    test('only known fields are written to the produced JSON', () {
      const original = ProvisioningConfig(
        componentName: 'pkg/receiver',
        serverUrl: 'https://mdm.example',
        policyId: 7,
      );

      final decoded = (jsonDecode(original.toJson()) as Map)
          .cast<String, dynamic>();
      final bundle = (decoded[ProvisioningConfig.adminExtrasBundleKey] as Map)
          .cast<String, dynamic>();

      expect(decoded.keys.toSet(), {
        ProvisioningConfig.componentNameKey,
        ProvisioningConfig.signatureChecksumKey,
        ProvisioningConfig.apkUrlKey,
        ProvisioningConfig.timeZoneKey,
        ProvisioningConfig.localeKey,
        ProvisioningConfig.organizationKey,
        ProvisioningConfig.adminExtrasBundleKey,
      });
      expect(bundle.keys.toSet(), {
        ProvisioningConfig.serverUrlKey,
        ProvisioningConfig.policyIdKey,
        ProvisioningConfig.groupIdKey,
        ProvisioningConfig.deviceCodeKey,
      });
      expect(bundle[ProvisioningConfig.serverUrlKey], 'https://mdm.example');
      expect(bundle[ProvisioningConfig.policyIdKey], 7);
    });

    test('values are preserved across a fields → JSON → fields round trip', () {
      const original = ProvisioningConfig(
        componentName: 'pkg/receiver',
        apkUrl: 'https://cdn/agent.apk',
        signatureChecksum: 'hash',
        timeZone: 'Europe/Berlin',
        locale: 'de_DE',
        organization: 'ACME',
        serverUrl: 'https://mdm.example',
        deviceCode: 'DEV-1',
        policyId: 5,
        groupId: 2,
      );

      final parsed = ProvisioningConfig.tryParse(original.toJson())!;

      expect(parsed.componentName, original.componentName);
      expect(parsed.apkUrl, original.apkUrl);
      expect(parsed.signatureChecksum, original.signatureChecksum);
      expect(parsed.timeZone, original.timeZone);
      expect(parsed.locale, original.locale);
      expect(parsed.organization, original.organization);
      expect(parsed.serverUrl, original.serverUrl);
      expect(parsed.deviceCode, original.deviceCode);
      expect(parsed.policyId, original.policyId);
      expect(parsed.groupId, original.groupId);
    });

    test('defaults assign the receiver and emit no extra keys', () {
      final bundle =
          (ProvisioningConfig.defaults
                      .toMap()[ProvisioningConfig.adminExtrasBundleKey]
                  as Map)
              .cast<String, dynamic>();

      expect(
        ProvisioningConfig.defaults.componentName,
        ProvisioningConfig.defaultComponentName,
      );
      expect(bundle.keys.toSet(), {
        ProvisioningConfig.serverUrlKey,
        ProvisioningConfig.policyIdKey,
        ProvisioningConfig.groupIdKey,
        ProvisioningConfig.deviceCodeKey,
      });
    });
  });

  group('canonicalPayload', () {
    test('returns compacted JSON with key order preserved', () {
      final raw = '{\n  "a": 1,\n  "b": {"c": 2}\n}';
      final payload = ProvisioningConfig.canonicalPayload(raw)!;

      expect(payload, '{"a":1,"b":{"c":2}}');
      expect(payload.contains('\n'), isFalse);
    });

    test('preserves the keys present in the raw JSON', () {
      final raw = jsonEncode({
        ProvisioningConfig.componentNameKey: 'pkg/receiver',
        ProvisioningConfig.adminExtrasBundleKey: {
          ProvisioningConfig.serverUrlKey: 'https://mdm.example',
          ProvisioningConfig.policyIdKey: 7,
        },
      });

      final decoded =
          (jsonDecode(ProvisioningConfig.canonicalPayload(raw)!) as Map)
              .cast<String, dynamic>();
      final bundle = (decoded[ProvisioningConfig.adminExtrasBundleKey] as Map)
          .cast<String, dynamic>();

      expect(decoded[ProvisioningConfig.componentNameKey], 'pkg/receiver');
      expect(bundle[ProvisioningConfig.serverUrlKey], 'https://mdm.example');
      expect(bundle[ProvisioningConfig.policyIdKey], 7);
    });

    test('empty object, empty text and invalid JSON return null', () {
      expect(ProvisioningConfig.canonicalPayload('{}'), isNull);
      expect(ProvisioningConfig.canonicalPayload(''), isNull);
      expect(ProvisioningConfig.canonicalPayload('nope'), isNull);
    });
  });

  group('validate', () {
    test('rejects empty, non-object and invalid JSON', () {
      expect(ProvisioningConfig.validate(''), L.provisioning.configEmpty);
      expect(
        ProvisioningConfig.validate('[1]'),
        L.provisioning.configNotObject,
      );
      expect(
        ProvisioningConfig.validate('{bad'),
        startsWith(L.provisioning.invalidJson.split('@message').first),
      );
    });

    test('returns null for a valid object', () {
      expect(ProvisioningConfig.validate('{"a":1}'), isNull);
      expect(ProvisioningConfig.validate('{}'), isNull);
    });
  });
}
