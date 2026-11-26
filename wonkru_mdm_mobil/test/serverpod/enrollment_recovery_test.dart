import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';

void main() {
  test('returns true for DeviceUnauthenticatedException', () {
    final error = DeviceUnauthenticatedException(message: 'Token rejected');

    expect(EnrollmentRecovery.isUnauthenticated(error), isTrue);
  });

  test('returns false for other errors', () {
    expect(EnrollmentRecovery.isUnauthenticated(Exception('boom')), isFalse);
    expect(EnrollmentRecovery.isUnauthenticated(StateError('missing')), isFalse);
    expect(EnrollmentRecovery.isUnauthenticated('plain text'), isFalse);
    expect(EnrollmentRecovery.isUnauthenticated(Object()), isFalse);
  });

  test('an error that is not a token rejection does not trigger recovery', () async {
    // This path returns before any network or service call, so it needs no
    // plugin. The outcome must be distinguishable as "not applicable".
    final outcome = await EnrollmentRecovery.handle(Exception('boom'));

    expect(outcome, RecoveryOutcome.notApplicable);
    expect(EnrollmentRecovery.isRunning, isFalse);
  });

  test('recovery appears not to run when idle', () {
    expect(EnrollmentRecovery.isRunning, isFalse);
  });
}
