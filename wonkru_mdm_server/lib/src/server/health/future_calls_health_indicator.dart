import 'package:serverpod/protocol.dart' as serverpod_protocol;
import 'package:serverpod/serverpod.dart';

/// Checks whether scheduled future calls are falling behind.
///
/// `HealthIndicator.check()` receives no session, so `server.dart` injects a
/// [sessionFactory] based on `pod.createSession`; tests can pass [overdueProbe]
/// directly and run without a database.
///
/// It counts periodic calls registered by `server.dart` ([knownIdentifiers])
/// that are more than `grace` late. While the scanner runs the recurring row's
/// time is always in the future; if it stalls (e.g.
/// `futureCallExecutionEnabled: false`) rows stay in the past. A single overdue
/// row can be a false alarm, so [overdueThreshold] only fails past a count.
class FutureCallsHealthIndicator extends HealthIndicator<int> {
  /// At least one of [sessionFactory] and [overdueProbe] must be given;
  /// [overdueProbe] is for tests, production uses [sessionFactory].
  FutureCallsHealthIndicator({
    this.sessionFactory,
    this.overdueProbe,
    this.grace = const Duration(minutes: 30),
    this.overdueThreshold = 2,
  });

  final Future<Session> Function()? sessionFactory;

  final Future<int> Function()? overdueProbe;

  /// The scan interval defaults to 5 s; 30 min sits far above the slowest
  /// scan/run and the leftover rows after a restart, so a single late row does
  /// not raise a false alarm.
  final Duration grace;

  /// This many overdue rows are tolerated; above it the check fails.
  ///
  /// A running call's old row looks past-dated until `finally` deletes it, and
  /// with the default `concurrencyLimit` of 1 at most one row can look overdue
  /// that way. If the scanner truly stalls, all three known periodic calls stay
  /// overdue. A threshold of 2 separates the cases: one row `pass`, three
  /// `fail`.
  final int overdueThreshold;

  /// Identifiers of the calls `server.dart` registers as periodic.
  static const knownIdentifiers = <String>{
    'device-command-timeouts',
    'device-offline-alerts',
    'admin-totp-cleanup',
  };

  @override
  String get name => 'future_calls:overdue';

  @override
  String get componentType => HealthComponentType.system.name;

  @override
  String get observedUnit => 'calls';

  @override
  Duration get timeout => const Duration(seconds: 3);

  @override
  Future<HealthCheckResult> check() async {
    try {
      final overdue = await (overdueProbe ?? _countOverdueOverDb)();
      if (overdue <= overdueThreshold) {
        return pass(observedValue: overdue);
      }
      return fail(
        observedValue: overdue,
        output:
            '$overdue scheduled future call(s) are overdue by more than '
            '${grace.inMinutes} minute(s) (threshold: $overdueThreshold); '
            'the future call scanner may be stalled.',
      );
    } catch (error) {
      return fail(
        output: 'Future call subsystem could not be inspected: $error',
      );
    }
  }

  Future<int> _countOverdueOverDb() async {
    final factory = sessionFactory;
    if (factory == null) {
      throw StateError('No session factory configured for health checks.');
    }

    final session = await factory();
    try {
      final threshold = DateTime.now().toUtc().subtract(grace);
      return await serverpod_protocol.FutureCallEntry.db.count(
        session,
        where: (t) =>
            t.identifier.inSet(knownIdentifiers) & (t.time < threshold),
      );
    } finally {
      await session.close();
    }
  }
}
