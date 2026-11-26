import 'dart:async';

import 'package:wonkru_core_server/wonkru_core_server.dart';

typedef DeviceStreamController = StreamController<DeviceStreamMessage>;

/// In-memory registry of the currently open device command streams, keyed by
/// device uuid.
///
/// A single Serverpod instance serves all devices, and the registry lives on
/// one isolate guarded by the single-threaded event loop, so the plain map is
/// safe without locks.
class DeviceConnectionRegistry {
  DeviceConnectionRegistry._();

  static final DeviceConnectionRegistry instance = DeviceConnectionRegistry._();

  final Map<String, DeviceStreamController> _connections = {};

  /// Registers (or replaces) the open stream of [uuid].
  ///
  /// Closing the previous controller on reconnect ends the old `connect`
  /// session, so it no longer writes presence `offline` (see [isCurrent]).
  void register(String uuid, DeviceStreamController controller) {
    final previous = _connections[uuid];
    _connections[uuid] = controller;
    if (previous != null &&
        !identical(previous, controller) &&
        !previous.isClosed) {
      unawaited(previous.close());
    }
  }

  /// When [controller] is given, the registration is only removed if it is
  /// still the current one, so a reconnecting device is not unregistered by its
  /// old stream. Returns `true` when the registration was actually removed.
  bool unregister(String uuid, [DeviceStreamController? controller]) {
    if (!_connections.containsKey(uuid)) {
      return false;
    }
    if (controller == null || identical(_connections[uuid], controller)) {
      _connections.remove(uuid);
      return true;
    }
    return false;
  }

  bool isCurrent(String uuid, DeviceStreamController controller) =>
      identical(_connections[uuid], controller);

  bool disconnect(String uuid) {
    final controller = _connections.remove(uuid);
    if (controller == null) {
      return false;
    }
    if (!controller.isClosed) {
      unawaited(controller.close());
    }
    return true;
  }

  bool isOnline(String uuid) => _connections.containsKey(uuid);

  bool send(String uuid, DeviceStreamMessage message) {
    final controller = _connections[uuid];
    if (controller == null || controller.isClosed) {
      return false;
    }
    try {
      controller.add(message);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<String> get onlineUuids => _connections.keys.toList(growable: false);

  /// Only meant for tests and full shutdowns.
  void clear() => _connections.clear();
}
