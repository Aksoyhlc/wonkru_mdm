import 'package:serverpod/serverpod.dart';

import 'future_calls_health_indicator.dart';
import 'smtp_health_indicator.dart';
import 'storage_health_indicator.dart';

/// Collects the indicators in one place so the registration list is testable
/// without starting a server. The built-in database (and Redis) indicators are
/// added by Serverpod automatically, so they are not repeated here.
HealthConfig buildHealthConfig({
  required Future<Session> Function() sessionFactory,
  bool Function()? initialSetupComplete,
}) {
  return HealthConfig(
    additionalStartupIndicators: [
      if (initialSetupComplete != null)
        _InitialSetupHealthIndicator(initialSetupComplete),
    ],
    additionalReadinessIndicators: [
      StorageHealthIndicator(),
      FutureCallsHealthIndicator(sessionFactory: sessionFactory),
      SmtpHealthIndicator(sessionFactory: sessionFactory),
    ],
  );
}

class _InitialSetupHealthIndicator extends HealthIndicator<String> {
  _InitialSetupHealthIndicator(this.isComplete);

  final bool Function() isComplete;

  @override
  String get name => 'initial-setup';

  @override
  Future<HealthCheckResult> check() async {
    if (isComplete()) return pass();
    return fail(output: 'Initial setup is still running.');
  }
}
