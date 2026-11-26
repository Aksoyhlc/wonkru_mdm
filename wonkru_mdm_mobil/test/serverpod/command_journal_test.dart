import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_journal.dart';

void main() {
  CommandJournal journalOn(
    List<Map<String, dynamic>> store, {
    int maxEntries = 200,
    int maxAckLength = 4096,
  }) {
    return CommandJournal(
      load: () => [for (final e in store) Map.of(e)],
      save: (entries) => store
        ..clear()
        ..addAll(entries),
      maxEntries: maxEntries,
      maxAckLength: maxAckLength,
    );
  }

  test('a started and completed command is known in a new instance too', () {
    final store = <Map<String, dynamic>>[];
    final journal = journalOn(store);

    journal.markStarted('c1');
    expect(journal.contains('c1'), isTrue);
    expect(journal.ackFor('c1'), isNull);

    journal.complete('c1', '{"success":true}');

    final reloaded = journalOn(store);
    expect(reloaded.contains('c1'), isTrue);
    expect(reloaded.ackFor('c1'), '{"success":true}');
    expect(reloaded.contains('c2'), isFalse);
  });

  test('the oldest record is dropped when the limit is exceeded', () {
    final store = <Map<String, dynamic>>[];
    final journal = journalOn(store, maxEntries: 3);

    for (final id in ['c1', 'c2', 'c3', 'c4']) {
      journal.markStarted(id);
    }

    expect(journal.contains('c1'), isFalse);
    expect(journal.contains('c4'), isTrue);
    expect(store.map((e) => e['id']), ['c2', 'c3', 'c4']);
  });

  test('the pending ack mark is persistent and preserves order', () {
    final store = <Map<String, dynamic>>[];
    final journal = journalOn(store);
    journal
      ..complete('c1', '{"n":1}')
      ..complete('c2', '{"n":2}')
      ..complete('c3', '{"n":3}')
      ..setPending('c1', true)
      ..setPending('c3', true);

    final reloaded = journalOn(store);
    expect(reloaded.pendingAcks(), [('c1', '{"n":1}'), ('c3', '{"n":3}')]);

    reloaded.setPending('c1', false);
    expect(journalOn(store).pendingAcks(), [('c3', '{"n":3}')]);
  });

  test('a large ack body is truncated to the envelope fields', () {
    final store = <Map<String, dynamic>>[];
    final journal = journalOn(store, maxAckLength: 64);
    final big = jsonEncode({
      'success': true,
      'status': 'success',
      'message': 'ok',
      'apps': List.generate(50, (i) => 'com.example.app$i'),
    });

    journal.complete('c1', big);

    final stored = jsonDecode(journal.ackFor('c1')!) as Map;
    expect(stored['success'], isTrue);
    expect(stored['message'], 'ok');
    expect(stored['truncated'], isTrue);
    expect(stored.containsKey('apps'), isFalse);
  });

  test('a corrupt store starts with an empty journal', () {
    final journal = CommandJournal(
      load: () => throw StateError('corrupt'),
      save: (_) {},
    );
    expect(journal.contains('c1'), isFalse);
  });
}
