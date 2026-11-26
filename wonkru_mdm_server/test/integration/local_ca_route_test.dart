import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/web/routes/local_ca_route.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  // There is no sibling web-route test, so withServerpod is used only to get a
  // real Session; the route never touches the database.
  withServerpod('Given LocalCaRoute', (sessionBuilder, endpoints) {
    Request buildRequest() {
      return RequestInternal.create(
        Method.get,
        Uri.parse('http://localhost:8082/downloads/local-ca'),
        Object(),
      );
    }

    test('when the CA file exists then it is served with 200 and its '
        'bytes.', () async {
      final dir = await Directory.systemTemp.createTemp('local-ca-route');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/local-ca.crt');
      final bytes = Uint8List.fromList(List<int>.generate(64, (i) => i));
      await file.writeAsBytes(bytes);

      final session = sessionBuilder.build();
      addTearDown(session.close);

      final response = await LocalCaRoute(
        caPath: file.path,
      ).handleCall(session, buildRequest());

      expect(response.statusCode, 200);
      final served = await response.read().expand((chunk) => chunk).toList();
      expect(served, bytes);
    });

    test('when the CA file is missing then it returns 404.', () async {
      final dir = await Directory.systemTemp.createTemp('local-ca-route');
      addTearDown(() => dir.delete(recursive: true));
      final missing = '${dir.path}/missing.crt';

      final session = sessionBuilder.build();
      addTearDown(session.close);

      final response = await LocalCaRoute(
        caPath: missing,
      ).handleCall(session, buildRequest());

      expect(response.statusCode, 404);
    });
  });
}
