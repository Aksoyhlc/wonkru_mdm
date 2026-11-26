import 'package:serverpod/serverpod.dart';
import 'package:wonkru_mdm_server/src/enums/rate_limit_scope.dart';
import 'package:wonkru_mdm_server/src/enums/client_ip_source.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/client_ip_resolver.dart';
import 'package:wonkru_mdm_server/src/service/rate_limiter.dart';

void main() {
  group('InMemoryRateLimiter', () {
    late DateTime now;
    late InMemoryRateLimiter limiter;

    setUp(() {
      now = DateTime.utc(2026, 1, 1);
      limiter = InMemoryRateLimiter(
        policies: {
          RateLimitScope.deviceSync: const RateLimitPolicy(
            maxRequests: 3,
            window: Duration(minutes: 1),
          ),
        },
      );
      limiter.clock = () => now;
    });

    tearDown(() => limiter.stop());

    test('allows up to the limit of requests within the window.', () {
      for (var i = 0; i < 3; i++) {
        expect(limiter.check(RateLimitScope.deviceSync, 'a').isAllowed, isTrue);
      }
    });

    test('rejects once the limit is exceeded and returns the remaining window.', () {
      for (var i = 0; i < 3; i++) {
        limiter.check(RateLimitScope.deviceSync, 'a');
      }

      final decision = limiter.check(RateLimitScope.deviceSync, 'a');

      expect(decision.isAllowed, isFalse);
      expect(decision.retryAfter, const Duration(minutes: 1));
      expect(decision.retryAfterSeconds, 60);
    });

    test('rejected requests do not extend the window.', () {
      for (var i = 0; i < 10; i++) {
        limiter.check(RateLimitScope.deviceSync, 'a');
      }

      now = now.add(const Duration(seconds: 30));
      final decision = limiter.check(RateLimitScope.deviceSync, 'a');
      // Fixed window: the remaining time is measured from the first request.
      expect(decision.retryAfter, const Duration(seconds: 30));
    });

    test('allow returns the same decision as check.', () {
      expect(limiter.allow(RateLimitScope.deviceSync, 'a'), isTrue);
      limiter.check(RateLimitScope.deviceSync, 'a');
      limiter.check(RateLimitScope.deviceSync, 'a');
      expect(limiter.allow(RateLimitScope.deviceSync, 'a'), isFalse);
    });

    test('counter resets once the window fills up.', () {
      for (var i = 0; i < 4; i++) {
        limiter.check(RateLimitScope.deviceSync, 'a');
      }
      expect(limiter.check(RateLimitScope.deviceSync, 'a').isAllowed, isFalse);

      now = now.add(const Duration(minutes: 1));

      expect(limiter.check(RateLimitScope.deviceSync, 'a').isAllowed, isTrue);
    });

    test('different keys do not affect each other.', () {
      for (var i = 0; i < 4; i++) {
        limiter.check(RateLimitScope.deviceSync, 'a');
      }

      expect(limiter.check(RateLimitScope.deviceSync, 'a').isAllowed, isFalse);
      expect(limiter.check(RateLimitScope.deviceSync, 'b').isAllowed, isTrue);
    });

    test('the same key is not shared across different scopes.', () {
      final scoped = InMemoryRateLimiter(
        policies: {
          RateLimitScope.deviceSync: const RateLimitPolicy(
            maxRequests: 1,
            window: Duration(minutes: 1),
          ),
          RateLimitScope.deviceConnect: const RateLimitPolicy(
            maxRequests: 1,
            window: Duration(minutes: 1),
          ),
        },
      );
      scoped.clock = () => now;
      addTearDown(scoped.stop);

      expect(scoped.check(RateLimitScope.deviceSync, 'ip:x').isAllowed, isTrue);
      expect(
        scoped.check(RateLimitScope.deviceConnect, 'ip:x').isAllowed,
        isTrue,
      );
      expect(
        scoped.check(RateLimitScope.deviceSync, 'ip:x').isAllowed,
        isFalse,
      );
    });

    test('evictExpired clears expired buckets.', () {
      limiter.check(RateLimitScope.deviceSync, 'a');
      limiter.check(RateLimitScope.deviceSync, 'b');
      expect(limiter.bucketCount, 2);

      now = now.add(const Duration(minutes: 2));
      limiter.evictExpired();

      expect(limiter.bucketCount, 0);
    });

    test('enforce throws a typed exception when the limit is exceeded.', () {
      for (var i = 0; i < 3; i++) {
        limiter.enforce(RateLimitScope.deviceSync, key: 'a');
      }

      expect(
        () => limiter.enforce(RateLimitScope.deviceSync, key: 'a'),
        throwsA(
          isA<RateLimitExceededException>().having(
            (e) => e.retryAfterSeconds,
            'retryAfterSeconds',
            greaterThanOrEqualTo(1),
          ),
        ),
      );
    });

    test('a scope without a policy always allows.', () {
      final bare = InMemoryRateLimiter.withoutDefaults(const {});
      bare.clock = () => now;
      addTearDown(bare.stop);

      for (var i = 0; i < 100; i++) {
        expect(bare.check(RateLimitScope.authBootstrap, 'a').isAllowed, isTrue);
      }
    });

    test('retryAfterSeconds returns 0 on an allowed decision.', () {
      expect(const RateLimitDecision.allow().retryAfterSeconds, 0);
    });

    test(
      'retryAfterSeconds rounds up and returns at least 1 when denied.',
      () {
        expect(
          const RateLimitDecision.deny(
            Duration(milliseconds: 400),
          ).retryAfterSeconds,
          1,
        );
        expect(
          const RateLimitDecision.deny(
            Duration(milliseconds: 1500),
          ).retryAfterSeconds,
          2,
        );
        expect(
          const RateLimitDecision.deny(Duration.zero).retryAfterSeconds,
          1,
        );
      },
    );

    test('bucket count does not exceed the maxBuckets limit and eviction does not throw.', () {
      final capped = InMemoryRateLimiter.withoutDefaults({
        RateLimitScope.deviceSync: const RateLimitPolicy(
          maxRequests: 1000000,
          window: Duration(hours: 1),
        ),
      });
      capped.clock = () => now;
      addTearDown(capped.stop);

      for (var i = 0; i < InMemoryRateLimiter.maxBuckets + 500; i++) {
        capped.check(RateLimitScope.deviceSync, 'key-$i');
      }

      expect(
        capped.bucketCount,
        lessThanOrEqualTo(InMemoryRateLimiter.maxBuckets),
      );
    });

    test('exception JSON round-trip preserves fields.', () {
      final exception = RateLimitExceededException(
        message: 'too many',
        retryAfterSeconds: 5,
      );

      final decoded = RateLimitExceededException.fromJson(exception.toJson());

      expect(decoded.message, 'too many');
      expect(decoded.retryAfterSeconds, 5);
    });
  });

  group('ClientIpResolver modes', () {
    late List<String> warnings;

    Request buildRequest({
      String? cfConnectingIp,
      String? xForwardedFor,
      String? forwarded,
    }) {
      return RequestInternal.create(
        Method.get,
        Uri.parse('http://localhost/hot'),
        Object(),
        headers: Headers.build((headers) {
          if (cfConnectingIp != null) {
            headers['cf-connecting-ip'] = [cfConnectingIp];
          }
          if (xForwardedFor != null) {
            headers['x-forwarded-for'] = [xForwardedFor];
          }
          if (forwarded != null) {
            headers['forwarded'] = [forwarded];
          }
        }),
      );
    }

    setUp(() {
      warnings = [];
      ClientIpResolver.warningSink = warnings.add;
      ClientIpResolver.resetWarnings();
      ClientIpResolver.source = ClientIpSource.socket;
    });

    tearDown(() {
      ClientIpResolver.warningSink = null;
      ClientIpResolver.resetWarnings();
      ClientIpResolver.source = ClientIpSource.socket;
    });

    test('cloudflare mode selects the CF-Connecting-IP header.', () {
      ClientIpResolver.source = ClientIpSource.cloudflare;
      final request = buildRequest(
        cfConnectingIp: '203.0.113.7',
        xForwardedFor: '198.51.100.1',
      );

      expect(ClientIpResolver.resolve(request), '203.0.113.7');
    });

    test('cloudflare mode falls back to the first X-Forwarded-For hop when CF is absent.', () {
      ClientIpResolver.source = ClientIpSource.cloudflare;
      final request = buildRequest(xForwardedFor: '198.51.100.1, 10.0.0.1');

      expect(ClientIpResolver.resolve(request), '198.51.100.1');
    });

    test('proxy mode selects the first X-Forwarded-For hop.', () {
      ClientIpResolver.source = ClientIpSource.proxy;
      final request = buildRequest(
        cfConnectingIp: '203.0.113.7',
        xForwardedFor: '198.51.100.1, 10.0.0.1',
      );

      // Proxy mode uses XFF, not the CF header.
      expect(ClientIpResolver.resolve(request), '198.51.100.1');
    });

    test('socket mode ignores headers.', () {
      ClientIpResolver.source = ClientIpSource.socket;
      final request = buildRequest(
        cfConnectingIp: '203.0.113.7',
        xForwardedFor: '198.51.100.1',
      );

      final raw = ClientIpResolver.resolve(request);

      expect(raw, isNot('203.0.113.7'));
      expect(raw, isNot('198.51.100.1'));
      expect(raw, isNotEmpty);
      expect(warnings, hasLength(1));
    });

    test('socket mode writes the proxy warning once, not per request.', () {
      final request = buildRequest(xForwardedFor: '198.51.100.1');

      ClientIpResolver.resolve(request);
      ClientIpResolver.resolve(request);
      ClientIpResolver.resolve(buildRequest(forwarded: 'for=198.51.100.1'));

      expect(warnings, hasLength(1));
    });

    test('socket mode without headers writes no warning.', () {
      ClientIpResolver.resolve(buildRequest());

      expect(warnings, isEmpty);
    });

    test('empty/malformed header value falls back to the socket address instead of 500.', () {
      ClientIpResolver.source = ClientIpSource.cloudflare;
      final request = buildRequest(cfConnectingIp: '   ');

      final raw = ClientIpResolver.resolve(request);

      expect(raw, isNotEmpty);
      expect(raw, isNot('   '));
    });

    test('unknown CLIENT_IP_SOURCE falls back to socket and warns once.', () {
      expect(
        ClientIpResolver.parseSource('bogus'),
        ClientIpSource.socket,
      );
      expect(warnings, hasLength(1));

      ClientIpResolver.parseSource('bogus-again');
      expect(warnings, hasLength(1));
    });

    test('undefined/empty CLIENT_IP_SOURCE falls back to socket without warning.', () {
      expect(
        ClientIpResolver.parseSource(null),
        ClientIpSource.socket,
      );
      expect(
        ClientIpResolver.parseSource('  '),
        ClientIpSource.socket,
      );
      expect(warnings, isEmpty);
    });
  });
}
