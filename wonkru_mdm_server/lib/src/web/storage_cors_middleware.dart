import 'package:serverpod/serverpod.dart';

/// Adds CORS support to the storage routes on the web server.
///
/// Panel and web server live on different origins, so uploads trigger a browser
/// preflight (`OPTIONS`). This middleware answers an allowed-origin `OPTIONS`
/// with 204 and CORS headers without running the route, and adds
/// `Access-Control-Allow-Origin` plus `Vary: Origin` to other responses.
///
/// When `allowedOrigins` is empty, no headers are added at all: missing
/// configuration must not silently open browser access.
class StorageCorsMiddleware extends MiddlewareObject {
  const StorageCorsMiddleware({required this.allowedOrigins});

  final List<String> allowedOrigins;

  static const allowedMethods = 'GET, POST, OPTIONS';
  static const allowedHeaders =
      'content-type, accept, authorization, x-requested-with';
  static const maxAgeSeconds = '86400';

  @override
  Handler call(Handler next) {
    return (Request request) async {
      final origin = allowedOriginFor(request.headers['origin']?.first);

      if (origin != null && request.method == Method.options) {
        return Response.noContent(headers: preflightHeaders(origin));
      }

      final result = await next(request);
      if (origin != null && result is Response) {
        return result.copyWith(
          headers: result.headers.transform((headers) {
            headers['access-control-allow-origin'] = [origin];
            headers['vary'] = ['Origin'];
          }),
        );
      }
      return result;
    };
  }

  String? allowedOriginFor(String? origin) {
    if (origin == null || origin.isEmpty) return null;
    return allowedOrigins.contains(origin) ? origin : null;
  }

  static Headers preflightHeaders(String origin) => Headers.build((headers) {
    headers['access-control-allow-origin'] = [origin];
    headers['access-control-allow-methods'] = [allowedMethods];
    headers['access-control-allow-headers'] = [allowedHeaders];
    headers['access-control-max-age'] = [maxAgeSeconds];
    headers['vary'] = ['Origin'];
  });
}

void registerStorageCors(
  void Function(Middleware middleware, String path) add,
  List<String>? allowedOrigins,
) {
  add(
    StorageCorsMiddleware(allowedOrigins: allowedOrigins ?? const []).call,
    storageCorsPath,
  );
}

const storageCorsPath = '/storage';
