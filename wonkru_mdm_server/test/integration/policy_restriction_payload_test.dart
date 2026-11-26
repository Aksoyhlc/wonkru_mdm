import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/policy_payload_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a policy payload with restriction settings', (
    sessionBuilder,
    endpoints,
  ) {
    Future<Map<String, dynamic>> payloadFor(String? restrictionSettings) async {
      final session = sessionBuilder.build();
      final policy = await Policy.db.insertRow(
        session,
        Policy(
          name: 'Restriction policy',
          restrictionSettings: restrictionSettings,
        ),
      );

      return PolicyPayloadService.buildMap(session, policy);
    }

    test('when a known restriction is stored then the legacy '
        '{name,key,api_level,value} shape is kept.', () async {
      final payload = await payloadFor(
        '{"restrictions":[{"restriction":"no_camera","value":1}]}',
      );

      final restrictions =
          (payload['restriction_settings'] as Map)['restrictions'] as List;
      expect(restrictions, hasLength(1));

      final entry = restrictions.single as Map;
      expect(entry.keys.toList(), <String>[
        'name',
        'key',
        'api_level',
        'value',
      ]);
      expect(entry['name'], 'DISALLOW_CAMERA');
      expect(entry['key'], 'no_camera');
      expect(entry['api_level'], 18);
      expect(entry['value'], 1);
      expect(entry.containsKey('label'), isFalse);
    });

    test(
      'when an unknown restriction is stored then only value survives.',
      () async {
        final payload = await payloadFor(
          '{"restrictions":[{"restriction":"not_a_restriction","value":0}]}',
        );

        final entry =
            ((payload['restriction_settings'] as Map)['restrictions'] as List)
                    .single
                as Map;
        expect(entry['name'], isNull);
        expect(entry['key'], isNull);
        expect(entry['api_level'], isNull);
        expect(entry['value'], 0);
        expect(entry.containsKey('label'), isFalse);
      },
    );

    test(
      'when the column is empty then restrictions is an empty list.',
      () async {
        final payload = await payloadFor(null);

        expect(
          (payload['restriction_settings'] as Map)['restrictions'],
          isEmpty,
        );
      },
    );
  });
}
