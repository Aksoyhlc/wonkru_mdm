import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Services/sync_scheduler_service.dart';

/// The first sync carries the pre-apply state, so a status sync must follow the
/// apply for the panel to observe the applied settings.
void main() {
  test('after a successful sync, apply runs, then a second sync', () async {
    final calls = <String>[];

    await runFullSyncAndApplySequence(
      sync: () async {
        calls.add('sync');
        return true;
      },
      apply: () async => calls.add('apply'),
    );

    expect(calls, ['sync', 'apply', 'sync']);
  });

  test('when the first sync fails, apply and the second sync do not run', () async {
    final calls = <String>[];

    await runFullSyncAndApplySequence(
      sync: () async {
        calls.add('sync');
        return false;
      },
      apply: () async => calls.add('apply'),
    );

    expect(calls, ['sync']);
  });
}
