import 'dart:collection';
import 'dart:convert';

import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

const _tag = 'CommandJournal';

typedef CommandJournalLoader = List<Map<String, dynamic>> Function();

typedef CommandJournalSaver = void Function(List<Map<String, dynamic>> entries);

/// Persistent, bounded journal of recently processed commands.
///
/// The server delivers at least once: the same `commandId` can arrive again on
/// reconnect. The journal drops already-seen ids, replays the stored ack body
/// for a completed command, and keeps acks that could not be sent while the
/// stream was down marked `pending` so they go out on the next connection.
///
/// Entries run oldest to newest, the oldest is evicted past [maxEntries]. Acks
/// can carry data (location, installed apps), so the default store is the
/// encrypted [StorageHelper]; a body longer than [maxAckLength] keeps only the
/// envelope fields (`success`/`status`/`message`).
class CommandJournal {
  CommandJournal({
    CommandJournalLoader? load,
    CommandJournalSaver? save,
    this.maxEntries = 200,
    this.maxAckLength = 4096,
  }) : _load = load ?? _defaultLoad,
       _save = save ?? _defaultSave;

  final CommandJournalLoader _load;
  final CommandJournalSaver _save;
  final int maxEntries;
  final int maxAckLength;

  final LinkedHashMap<String, Map<String, dynamic>> _entries = LinkedHashMap();
  bool _loaded = false;

  static List<Map<String, dynamic>> _defaultLoad() =>
      StorageHelper.instance.getJsonList(Sk.commandJournal.name) ?? const [];

  static void _defaultSave(List<Map<String, dynamic>> entries) =>
      StorageHelper.instance.setJsonList(Sk.commandJournal.name, entries);

  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    try {
      for (final raw in _load()) {
        final id = raw['id']?.toString();
        if (id == null || id.isEmpty) continue;
        _entries[id] = {
          if (raw['ack'] is String) 'ack': raw['ack'],
          if (raw['pending'] == true) 'pending': true,
        };
      }
      _trim();
    } catch (e, st) {
      WLog.w(
        _tag,
        'Command journal could not be read; starting empty',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _persist() {
    try {
      _save([
        for (final e in _entries.entries) {'id': e.key, ...e.value},
      ]);
    } catch (e, st) {
      WLog.w(_tag, 'Command journal could not be written', error: e, stackTrace: st);
    }
  }

  void _trim() {
    while (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }
  }

  bool contains(String commandId) {
    _ensureLoaded();
    return _entries.containsKey(commandId);
  }

  /// Stored ack body for a completed command; `null` if it was interrupted.
  String? ackFor(String commandId) {
    _ensureLoaded();
    return _entries[commandId]?['ack'] as String?;
  }

  /// Records that processing started; if the process dies mid-way, redelivery
  /// does not re-run it, which prevents a crash loop.
  void markStarted(String commandId) {
    _ensureLoaded();
    _entries.remove(commandId);
    _entries[commandId] = {};
    _trim();
    _persist();
  }

  void complete(String commandId, String ackPayload) {
    _ensureLoaded();
    final entry = _entries.putIfAbsent(commandId, () => {});
    entry['ack'] = _shrink(ackPayload);
    _trim();
    _persist();
  }

  void setPending(String commandId, bool pending) {
    _ensureLoaded();
    final entry = _entries[commandId];
    if (entry == null) return;
    final wasPending = entry['pending'] == true;
    if (wasPending == pending) return;
    if (pending) {
      entry['pending'] = true;
    } else {
      entry.remove('pending');
    }
    _persist();
  }

  /// Pending acks, oldest first: `(commandId, ackPayload)`.
  List<(String, String)> pendingAcks() {
    _ensureLoaded();
    return [
      for (final e in _entries.entries)
        if (e.value['pending'] == true && e.value['ack'] is String)
          (e.key, e.value['ack'] as String),
    ];
  }

  String _shrink(String ackPayload) {
    if (ackPayload.length <= maxAckLength) return ackPayload;
    try {
      final decoded = jsonDecode(ackPayload);
      if (decoded is Map) {
        return jsonEncode(<String, dynamic>{
          'success': decoded['success'],
          'status': decoded['status'],
          'message': decoded['message'],
          'truncated': true,
        });
      }
    } catch (_) {
    }
    return jsonEncode(<String, dynamic>{
      'success': true,
      'status': 'success',
      'truncated': true,
    });
  }
}
