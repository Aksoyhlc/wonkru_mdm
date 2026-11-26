import 'package:serverpod/serverpod.dart';
import '../enums/rate_limit_scope.dart';

import '../service/client_ip_resolver.dart';
import '../service/rate_limiter.dart';

/// Endpoints throw `RateLimitExceededException`, but HTTP routes return 429 with
/// `Retry-After`: a route's client (browser, download stream) cannot decode
/// Serverpod's typed error. Returns `null` when the limit is not exceeded.
Response? rateLimitResponse(Request request, RateLimitScope scope) {
  final decision = InMemoryRateLimiter.instance.check(
    scope,
    ClientIpResolver.ipKeyFor(request),
  );
  if (decision.isAllowed) {
    return null;
  }

  return Response(
    429,
    headers: Headers.build(
      (headers) =>
          headers['retry-after'] = [decision.retryAfterSeconds.toString()],
    ),
  );
}
