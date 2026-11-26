import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Data/Client/unauthorized_gate.dart';

/// Concurrent 403s that run the refresh handler more than once put the panel
/// into a `403 -> init -> ready -> 403` loop; this gate prevents re-entry.
void main() {
  group('isUnauthorized', () {
    test('401 and 403 count as session rejection', () {
      expect(
        UnauthorizedGate.isUnauthorized(ServerpodClientUnauthorized()),
        isTrue,
      );
      expect(
        UnauthorizedGate.isUnauthorized(ServerpodClientForbidden()),
        isTrue,
      );
    });

    test('business-rule and network errors are not rejections', () {
      expect(
        UnauthorizedGate.isUnauthorized(
          const ServerpodClientNetworkException('x'),
        ),
        isFalse,
      );
      expect(
        UnauthorizedGate.isUnauthorized(ServerpodClientNotFound()),
        isFalse,
      );
      expect(UnauthorizedGate.isUnauthorized(Exception('boom')), isFalse);
    });
  });

  test('the handler runs only once for concurrent 403s', () async {
    final gate = UnauthorizedGate();
    var calls = 0;
    final completer = Completer<void>();

    Future<void> handler() async {
      calls++;
      await completer.future;
    }

    final first = gate.handle(ServerpodClientForbidden(), handler);
    final second = gate.handle(ServerpodClientForbidden(), handler);

    expect(calls, 1, reason: 'the second call must be swallowed');

    completer.complete();
    await Future.wait([first, second]);
    expect(calls, 1);
  });

  test('a new 403 runs the handler again after it finishes', () async {
    final gate = UnauthorizedGate();
    var calls = 0;

    await gate.handle(ServerpodClientForbidden(), () async => calls++);
    await gate.handle(ServerpodClientForbidden(), () async => calls++);

    expect(calls, 2);
    expect(gate.isBusy, isFalse);
  });

  test('the handler does not run on a non-rejection error', () async {
    final gate = UnauthorizedGate();
    var calls = 0;

    await gate.handle(Exception('boom'), () async => calls++);

    expect(calls, 0);
  });

  test('it passes silently when no handler is attached', () async {
    final gate = UnauthorizedGate();

    await gate.handle(ServerpodClientForbidden(), null);

    expect(gate.isBusy, isFalse);
  });

  test('the gate reopens even if the handler throws', () async {
    final gate = UnauthorizedGate();

    await expectLater(
      gate.handle(ServerpodClientForbidden(), () async => throw Exception('x')),
      throwsA(isA<Exception>()),
    );

    expect(gate.isBusy, isFalse);
  });
}
