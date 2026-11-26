import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../../enums/rate_limit_scope.dart';

import '../rate_limit_guard.dart';

/// Serves the local CA certificate (PEM) at `GET /downloads/local-ca` for the
/// bootstrap flow. The path comes from `caPath`, or `LOCAL_CA_PATH` at setup,
/// defaulting to `certs/local-ca.crt`. A missing file returns 404, but a dev
/// fallback middleware (unbuilt `web/app`) can replace that 404 with the build
/// page HTML (200), so the agent verifies the body is really PEM.
class LocalCaRoute extends Route {
  LocalCaRoute({String? caPath})
    : caPath =
          caPath ??
          Platform.environment['LOCAL_CA_PATH'] ??
          'certs/local-ca.crt',
      super(methods: const {Method.get});

  final String caPath;

  @override
  Future<Response> handleCall(Session session, Request request) async {
    // Every new device downloads here during bootstrap; limit per IP.
    final limited = rateLimitResponse(request, RateLimitScope.webLocalCa);
    if (limited != null) return limited;

    final file = File(caPath);
    if (!file.existsSync()) return Response.notFound();

    return Response.ok(
      body: Body.fromDataStream(
        file.openRead().map((chunk) => chunk as Uint8List),
        mimeType: MimeType.parse('application/x-pem-file'),
        contentLength: await file.length(),
      ),
    );
  }
}
