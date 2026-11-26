import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/web/storage_cors_middleware.dart';

/// Browsers send a preflight `OPTIONS` before a cross-origin binary POST, so
/// the storage routes must answer it instead of rejecting it.
void main() {
  const panelOrigin = 'http://localhost:8099';
  final middleware = StorageCorsMiddleware(allowedOrigins: const [panelOrigin]);

  Request request(Method method, {String? origin}) => RequestInternal.create(
    method,
    Uri.parse('http://localhost:8082/storage/upload'),
    Object(),
    headers: Headers.build((headers) {
      if (origin != null) headers['origin'] = [origin];
    }),
  );

  Future<Result> next(Request _) async => Response.ok();

  test(
    'an allowed origin preflight is answered with 204 + CORS headers',
    () async {
      final result = await middleware.call(next)(
        request(Method.options, origin: panelOrigin),
      );

      expect(result, isA<Response>());
      final response = result as Response;
      expect(response.statusCode, 204);
      expect(response.headers['access-control-allow-origin'], [panelOrigin]);
      expect(
        response.headers['access-control-allow-methods'],
        [StorageCorsMiddleware.allowedMethods],
      );
      expect(
        response.headers['access-control-allow-headers']!.single,
        contains('content-type'),
      );
    },
  );

  test('Access-Control-Allow-Origin is added to a real request response', () async {
    final result = await middleware.call(next)(
      request(Method.post, origin: panelOrigin),
    );

    final response = result as Response;
    expect(response.statusCode, 200);
    expect(response.headers['access-control-allow-origin'], [panelOrigin]);
  });

  test('no CORS header is added for a disallowed origin', () async {
    final result = await middleware.call(next)(
      request(Method.options, origin: 'http://evil.example'),
    );

    final response = result as Response;
    expect(response.statusCode, 200);
    expect(response.headers['access-control-allow-origin'], isNull);
  });

  test('behavior is unchanged when there is no origin', () async {
    final result = await middleware.call(next)(request(Method.post));

    final response = result as Response;
    expect(response.statusCode, 200);
    expect(response.headers['access-control-allow-origin'], isNull);
  });

  test('no CORS header is added when the allow list is empty', () async {
    // Without configuration browser access must not silently open up.
    final empty = StorageCorsMiddleware(allowedOrigins: const []);

    final preflight = await empty.call(next)(
      request(Method.options, origin: panelOrigin),
    );
    final normal = await empty.call(next)(
      request(Method.post, origin: panelOrigin),
    );

    expect(
      (preflight as Response).headers['access-control-allow-origin'],
      isNull,
    );
    expect((normal as Response).headers['access-control-allow-origin'], isNull);
  });

  group('wiring', () {
    test('middleware is registered on the /storage path', () {
      Middleware? registered;
      String? path;

      registerStorageCors((middleware, registeredPath) {
        registered = middleware;
        path = registeredPath;
      }, const [panelOrigin]);

      expect(registered, isNotNull);
      expect(path, '/storage');
    });

    test('the registered middleware answers the panel preflight', () async {
      Middleware? registered;
      registerStorageCors(
        (middleware, _) => registered = middleware,
        const [panelOrigin],
      );

      final result = await registered!(next)(
        request(Method.options, origin: panelOrigin),
      );

      expect((result as Response).statusCode, 204);
      expect(result.headers['access-control-allow-origin'], [panelOrigin]);
    });

    test(
      'registration still happens when allowedOrigins is null, but no header is added',
      () async {
        Middleware? registered;
        registerStorageCors((middleware, _) => registered = middleware, null);

        final result = await registered!(next)(
          request(Method.options, origin: panelOrigin),
        );

        expect(registered, isNotNull);
        expect(
          (result as Response).headers['access-control-allow-origin'],
          isNull,
        );
      },
    );
  });
}
