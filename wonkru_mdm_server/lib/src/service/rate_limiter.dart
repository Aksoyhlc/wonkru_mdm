import 'dart:async';
import '../enums/rate_limit_scope.dart';

import 'package:meta/meta.dart';

import '../generated/protocol.dart';
import 'rate_limit_policy.dart';

export 'rate_limit_policy.dart';

/// Process-local fixed-window limiter. Counters are not shared across servers
/// and reset on restart; expired buckets are evicted periodically and when the
/// map exceeds [maxBuckets].
class InMemoryRateLimiter {
  InMemoryRateLimiter({Map<RateLimitScope, RateLimitPolicy>? policies})
    : policies = {...defaultPolicies, ...?policies};

  /// Lets tests exercise the "unconfigured scope allows" behavior.
  @visibleForTesting
  InMemoryRateLimiter.withoutDefaults(
    Map<RateLimitScope, RateLimitPolicy> policies,
  ) : policies = Map.unmodifiable(policies);

  /// Limits are generous so real device traffic is not throttled: `sync` and
  /// `log` run periodically, `register` once per device, and the public download
  /// route also carries panel previews.
  static const Map<RateLimitScope, RateLimitPolicy> defaultPolicies = {
    RateLimitScope.deviceRegister: RateLimitPolicy(
      maxRequests: 120,
      window: Duration(minutes: 10),
    ),
    RateLimitScope.deviceConnect: RateLimitPolicy(
      maxRequests: 60,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.deviceSync: RateLimitPolicy(
      maxRequests: 60,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.deviceReport: RateLimitPolicy(
      maxRequests: 120,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.deviceLog: RateLimitPolicy(
      maxRequests: 120,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.deviceUploadFile: RateLimitPolicy(
      maxRequests: 60,
      window: Duration(minutes: 5),
    ),
    RateLimitScope.devicePasswordCheck: RateLimitPolicy(
      maxRequests: 10,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.devicePasswordCheckPolicy: RateLimitPolicy(
      maxRequests: 30,
      window: Duration(minutes: 5),
    ),
    RateLimitScope.authBootstrap: RateLimitPolicy(
      maxRequests: 20,
      window: Duration(minutes: 10),
    ),
    RateLimitScope.authLogin: RateLimitPolicy(
      maxRequests: 20,
      window: Duration(minutes: 10),
    ),
    RateLimitScope.webUpload: RateLimitPolicy(
      maxRequests: 120,
      window: Duration(minutes: 5),
    ),
    RateLimitScope.webDownload: RateLimitPolicy(
      maxRequests: 600,
      window: Duration(minutes: 1),
    ),
    RateLimitScope.webLocalCa: RateLimitPolicy(
      maxRequests: 300,
      window: Duration(minutes: 10),
    ),
  };

  static InMemoryRateLimiter instance = InMemoryRateLimiter();

  static const cleanupInterval = Duration(minutes: 1);

  static const maxBuckets = 50000;

  /// Bounded eviction: a full scan of 50 000 buckets would cost O(n) per
  /// request and multiply CPU under a flood; batching keeps it constant.
  static const evictionBatch = 256;

  final Map<RateLimitScope, RateLimitPolicy> policies;

  final Map<String, _Bucket> _buckets = {};
  Timer? _cleanupTimer;

  @visibleForTesting
  DateTime Function() clock = _utcNow;

  static DateTime _utcNow() => DateTime.now().toUtc();

  void start() {
    _cleanupTimer ??= Timer.periodic(cleanupInterval, (_) => evictExpired());
  }

  void stop() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  RateLimitDecision check(RateLimitScope scope, String key) {
    final policy = policies[scope];
    if (policy == null) {
      return const RateLimitDecision.allow();
    }

    final now = clock();
    // Include the scope so one IP cannot consume another surface's budget.
    final bucketKey = '${scope.name}\u0000$key';
    final bucket = _buckets[bucketKey];

    if (bucket == null || !now.isBefore(bucket.windowEnd)) {
      // Remove then re-insert: LinkedHashMap keeps the original order on update,
      // which would make bucket eviction miss the stale keys.
      _buckets.remove(bucketKey);
      _buckets[bucketKey] = _Bucket(
        windowEnd: now.add(policy.window),
        count: 1,
      );
      _evictIfNeeded(now);
      return const RateLimitDecision.allow();
    }

    bucket.count++;
    if (bucket.count > policy.maxRequests) {
      final remaining = bucket.windowEnd.difference(now);
      return RateLimitDecision.deny(
        remaining.isNegative ? Duration.zero : remaining,
      );
    }

    return const RateLimitDecision.allow();
  }

  bool allow(RateLimitScope scope, String key) => check(scope, key).isAllowed;

  /// Throws [RateLimitExceededException]. Web routes call [check] directly so
  /// they can return HTTP 429.
  void enforce(RateLimitScope scope, {required String key}) {
    final decision = check(scope, key);
    if (decision.isAllowed) {
      return;
    }

    final seconds = decision.retryAfterSeconds;
    throw RateLimitExceededException(
      message:
          'Too many requests. Please try again in $seconds seconds.',
      retryAfterSeconds: seconds,
    );
  }

  /// For periodic cleanup and tests; not called on the hot path.
  void evictExpired() {
    final now = clock();
    _buckets.removeWhere((_, bucket) => !now.isBefore(bucket.windowEnd));
  }

  @visibleForTesting
  int get bucketCount => _buckets.length;

  /// Scans at most [evictionBatch] entries per call, dropping expired ones
  /// first and then the oldest; every insert drops at least one bucket, so the
  /// count converges below [maxBuckets] within a few requests.
  void _evictIfNeeded(DateTime now) {
    if (_buckets.length <= maxBuckets) {
      return;
    }

    var scanned = 0;
    final expired = <String>[];
    for (final entry in _buckets.entries) {
      if (scanned >= evictionBatch) {
        break;
      }
      scanned++;
      if (!now.isBefore(entry.value.windowEnd)) {
        expired.add(entry.key);
      }
    }
    for (final key in expired) {
      _buckets.remove(key);
    }

    var budget = evictionBatch;
    while (_buckets.length > maxBuckets && budget > 0) {
      if (_buckets.isEmpty) {
        break;
      }
      _buckets.remove(_buckets.keys.first);
      budget--;
    }
  }
}

class _Bucket {
  _Bucket({required this.windowEnd, required this.count});

  final DateTime windowEnd;

  int count;
}
