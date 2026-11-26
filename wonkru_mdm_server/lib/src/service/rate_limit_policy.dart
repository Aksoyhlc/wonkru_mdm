/// Fixed window: at most [maxRequests] requests per [window], one counter per key.
class RateLimitPolicy {
  const RateLimitPolicy({required this.maxRequests, required this.window});

  final int maxRequests;

  final Duration window;
}

/// The result of one [RateLimitPolicy] check.
class RateLimitDecision {
  const RateLimitDecision.allow()
    : isAllowed = true,
      retryAfter = Duration.zero;

  const RateLimitDecision.deny(this.retryAfter) : isAllowed = false;

  final bool isAllowed;

  final Duration retryAfter;

  /// Seconds to wait before retrying, rounded up; 0 when allowed, at least 1
  /// when denied.
  int get retryAfterSeconds {
    if (isAllowed) {
      return 0;
    }
    final seconds = (retryAfter.inMilliseconds / 1000).ceil();
    return seconds < 1 ? 1 : seconds;
  }
}
