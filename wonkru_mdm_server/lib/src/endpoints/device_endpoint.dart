import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../enums/rate_limit_scope.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart' hide LogLevel;

import '../generated/protocol.dart';
import '../service/device_application_sync_service.dart';
import '../service/device_auth_service.dart';
import '../service/device_command_service.dart';
import '../service/device_connection_registry.dart';
import '../service/device_request_limits.dart';
import '../service/device_security_alert_draft.dart';
import '../service/device_security_alert_service.dart';
import '../service/device_service.dart';
import '../service/device_state_cache_service.dart';
import '../service/device_sync_sanitizer.dart';
import '../service/device_upload_service.dart';
import '../service/enrollment_key_service.dart';
import '../service/policy_payload_service.dart';
import '../service/client_ip_resolver.dart';
import '../service/rate_limiter.dart';
import '../util/device_time.dart';
import '../util/json_utils.dart';
import '../util/password_hasher.dart';

class DeviceEndpoint extends Endpoint {
  static const _minMillisTimestamp = 100000000000;

  /// Requires the global enrollment key ([EnrollmentKeyService]); a missing or
  /// wrong key throws [DeviceEnrollmentRejectedException]. Oversized fields
  /// throw [DeviceRequestInvalidException]. The plaintext token is returned
  /// only here; the database keeps its SHA-256.
  Future<DeviceRegisterResponse> register(
    Session session,
    DeviceRegisterRequest request,
  ) async {
    // No device identity exists yet at registration; key the limit by client IP.
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceRegister,
      key: ClientIpResolver.ipKey(session),
    );
    DeviceRequestLimits.checkRegister(request);
    await EnrollmentKeyService.require(session, request.enrollmentKey);

    final code = await DeviceService.resolveDeviceCode(
      session,
      request.deviceCode,
    );
    final uuid = await DeviceService.generateUniqueUuid(session);
    final token = await DeviceService.generateUniqueAuthToken(session);
    final now = DateTime.now().toUtc();

    final device = Device(
      code: code,
      uuid: uuid,
      authToken: DeviceAuthService.hashToken(token),
      manufacturer: request.manufacturer,
      model: request.model,
      brand: request.brand,
      serialNo: request.serialNo,
      androidVersion: request.version?.release,
      sdkVersion: request.version?.sdkInt,
      firstSeenAt: now,
      lastSeenAt: now,
      collectedAt: now,
    );

    await DeviceService.applySavingDefaults(session, device);

    await Device.db.insertRow(session, device);

    return DeviceRegisterResponse(code: code, uuid: uuid, token: token);
  }

  /// The agent authenticates with the [token] returned by [register] and keeps
  /// the stream open. While it is open the device is tracked in
  /// [DeviceConnectionRegistry] so commands can be pushed over the websocket.
  /// Inbound `heartbeat`/`ack` messages refresh [Device.lastSeenAt].
  Stream<DeviceStreamMessage> connect(
    Session session,
    String token,
    Stream<DeviceStreamMessage> inbound,
  ) async* {
    final device = await DeviceAuthService.requireDevice(session, token);
    final uuid = device.uuid;
    if (uuid == null || uuid.isEmpty) {
      throw DeviceUnauthenticatedException(message: 'Device has no uuid.');
    }

    // Keyed per device after token verification: devices behind the same NAT do
    // not consume each other's quota.
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceConnect,
      key: ClientIpResolver.deviceKey(session, uuid),
    );

    final registry = DeviceConnectionRegistry.instance;
    final controller = StreamController<DeviceStreamMessage>();

    final subscription = inbound.listen(
      (message) {
        unawaited(_handleInbound(session, device, controller, message));
      },
      onError: (Object error, StackTrace stackTrace) {
        session.log(
          'Device $uuid stream error: $error',
          level: LogLevel.warning,
        );
      },
      onDone: () {
        if (!controller.isClosed) {
          unawaited(controller.close());
        }
      },
      cancelOnError: false,
    );

    // Only mark presence `offline` if this connection removed its own
    // registration; when a newer connection replaced it, the old session must
    // not touch presence (see [DeviceConnectionRegistry.register]).
    var releasedOwnRegistration = false;
    void release() {
      if (registry.unregister(uuid, controller)) {
        releasedOwnRegistration = true;
      }
    }

    registry.register(uuid, controller);
    session.addWillCloseListener((_) => release());

    try {
      await _markPresence(session, device, online: true);

      // A newer connection may have taken over the registration meanwhile; then
      // the controller is closed and the stream ends at once.
      if (!controller.isClosed) {
        controller.add(
          DeviceStreamMessage(type: 'welcome', sentAt: DateTime.now().toUtc()),
        );
      }

      // Commands queued while the device was offline are pushed before the
      // stream starts yielding; unacked `sent` commands (possibly sent to a dead
      // socket) are re-sent with the same `commandId`.
      await DeviceCommandService.flushPending(
        session,
        device,
        redeliverSent: true,
      );

      yield* controller.stream;
    } finally {
      await subscription.cancel();
      release();
      if (!controller.isClosed) {
        unawaited(controller.close());
      }
      if (releasedOwnRegistration && !registry.isOnline(uuid)) {
        try {
          await _markPresence(session, device, online: false);
        } catch (_) {
          // The stream session may already be closing; presence is best
          // effort.
        }
      }
    }
  }

  /// Verifies the requesting device by token and ensures it matches `deviceUuid`.
  ///
  /// An invalid token throws [DeviceUnauthenticatedException] (the device
  /// re-enrols). A valid token with a different `deviceUuid` throws
  /// [DeviceIdentityMismatchException] carrying the uuid/code the token belongs
  /// to; the agent adopts that identity and retries without re-enrolling
  /// (otherwise a ghost device appears in the panel). Returning the identity is
  /// not a leak: only the holder of the device's valid token can obtain it.
  Future<Device> _requireAuthorizedDevice(
    Session session,
    String? token,
    String deviceUuid,
  ) async {
    final device = await DeviceAuthService.requireDevice(session, token);
    final uuid = device.uuid;
    if (uuid == null || uuid.isEmpty) {
      throw DeviceUnauthenticatedException(
        message: 'Device has no uuid.',
      );
    }
    if (uuid != deviceUuid) {
      throw DeviceIdentityMismatchException(
        message: 'Device token belongs to a different device uuid.',
        deviceUuid: uuid,
        deviceCode: device.code,
      );
    }
    return device;
  }

  Future<DeviceConfigResponse> config(
    Session session,
    DeviceConfigRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );

    final policyId = device.policyId;
    final policy = policyId == null
        ? null
        : await Policy.db.findById(session, policyId);

    return DeviceConfigResponse(
      deviceCode: device.code,
      policy: policy == null
          ? null
          : await PolicyPayloadService.buildJson(session, policy),
    );
  }

  Future<DeviceSyncResponse> sync(
    Session session,
    DeviceSyncRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceSync,
      key: ClientIpResolver.deviceKey(session, device.uuid),
    );

    DeviceRequestLimits.requireMaxLength(
      request.payload,
      DeviceRequestLimits.syncPayloadChars,
      'payload',
    );
    final data = _decodePayload(request.payload);
    final collectedAt = _parseCollectedAt(data);

    // Security-alert detection runs inside the sync transaction, before the
    // cache is updated; dispatch happens after the transaction closes so a
    // notification/mail failure cannot roll the sync back.
    DeviceSecurityAlertDraft? securityAlert;

    final response = await session.db.transaction((transaction) async {
      final deviceId = device.id!;
      final deviceInfo = asMap(data['device']);
      final mdmAppInfo = asMap(data['mdmApp']);
      final networkInfo = asMap(data['network']);
      final storageInfo = asMap(data['storage']);
      final batteryInfo = asMap(data['battery']);
      final versionInfo = asMap(deviceInfo['version']);
      final securityInfo = asMap(asMap(data['systemSettings'])['security']);
      // Identity secrets (token, enrollment key, command log…) are never written
      // to disk; newer agents omit them, this guards against older ones.
      final bsInfo = DeviceSyncSanitizer.strip(asMap(data['bs']));
      final stInfo = DeviceSyncSanitizer.strip(asMap(data['st']));

      final deviceSync = await DeviceSync.db.insertRow(
        session,
        DeviceSync(
          deviceId: deviceId,
          collectedAt: collectedAt,
          syncType: _syncType(data, request.syncType),
          deviceInfo: _encode(data['device']),
          mdmAppInfo: _encode(data['mdmApp']),
          appsInfo: _encode(data['apps']),
          audioInfo: _encode(data['audio']),
          batteryInfo: _encode(data['battery']),
          certificatesInfo: _encode(data['certificates']),
          displayInfo: _encode(data['display']),
          networkInfo: _encode(data['network']),
          notificationInfo: _encode(data['notification']),
          restrictionsInfo: _encode(data['restrictions']),
          securityInfo: _encode(data['security']),
          storageInfo: _encode(data['storage']),
          systemInfo: _encode(data['systemSettings']),
          otherInfo: _encode(data['otherSettings']),
          bsInfo: data['bs'] == null ? null : _encode(bsInfo),
          stInfo: data['st'] == null ? null : _encode(stInfo),
        ),
        transaction: transaction,
      );

      // Detected by comparing against the previous state before the state cache
      // is updated (read-only; dispatch happens outside the transaction).
      securityAlert = await DeviceSecurityAlertService.detect(
        session,
        deviceSync,
        transaction: transaction,
      );

      await DeviceStateCacheService.updateFromSync(
        session,
        deviceSync,
        transaction: transaction,
      );

      await DeviceApplicationSyncService.upsert(
        session,
        transaction: transaction,
        deviceId: deviceId,
        apps: asList(asMap(data['apps'])['userApps']),
      );

      session.log('Synced device ${device.code}');

      final syncColumns = _applySyncFields(
        Device.t,
        device,
        data: data,
        collectedAt: collectedAt,
        deviceInfo: deviceInfo,
        versionInfo: versionInfo,
        mdmAppInfo: mdmAppInfo,
        batteryInfo: batteryInfo,
        networkInfo: networkInfo,
        securityInfo: securityInfo,
        storageInfo: storageInfo,
        bsInfo: bsInfo,
        stInfo: stInfo,
      );
      await Device.db.updateRow(
        session,
        device,
        columns: (_) => syncColumns,
        transaction: transaction,
      );

      return DeviceSyncResponse(deviceCode: device.code);
    });

    // Dispatch after the transaction closes so a notification/mail failure does
    // not roll the sync back.
    await DeviceSecurityAlertService.dispatch(session, securityAlert);

    return response;
  }

  Future<bool> report(Session session, DeviceReportRequest request) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceReport,
      key: ClientIpResolver.deviceKey(session, device.uuid),
    );

    final now = DateTime.now().toUtc();

    await DeviceReport.db.insertRow(
      session,
      DeviceReport(
        deviceId: device.id!,
        type: request.type,
        payload: request.payload,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return true;
  }

  Future<int> log(Session session, DeviceLogRequest request) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceLog,
      key: ClientIpResolver.deviceKey(session, device.uuid),
    );
    if (request.entries.isEmpty) {
      return 0;
    }

    final rows = request.entries
        .map(
          (entry) => DeviceLog(
            deviceId: device.id!,
            entryUuid: entry.id,
            // Each record carries its own session in a batch; older agents send
            // it only at the request level.
            sessionId: entry.sessionId ?? request.sessionId,
            loggedAt: _parseDeviceTimestamp(entry.timestamp),
            level: entry.level.index,
            tag: entry.tag,
            message: entry.message,
            stacktrace: entry.stacktrace,
          ),
        )
        .toList();

    await DeviceLog.db.insert(session, rows);
    return rows.length;
  }

  /// Policy assignment is the server's job: the panel assigns `Device.policyId`
  /// when it sends the `policy_change` command. This RPC writes nothing: it
  /// returns `true` only when the requested policy is already the device's, so a
  /// device cannot move itself to another policy.
  Future<bool> policyChange(
    Session session,
    DevicePolicyChangeRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );

    final assigned = device.policyId;
    if (assigned == null || assigned != request.policyId) {
      session.log(
        'Device ${device.code} policyChange(${request.policyId}) rejected; '
        'assigned policy: ${assigned ?? 'none'}.',
        level: LogLevel.warning,
      );
      return false;
    }

    return true;
  }

  Future<bool> passwordCheck(
    Session session,
    DevicePasswordCheckRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );
    // Admin-password attempts are a brute-force surface: limit per device.
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.devicePasswordCheck,
      key: ClientIpResolver.deviceKey(session, device.uuid),
    );
    DeviceRequestLimits.requireMaxLength(
      request.password,
      DeviceRequestLimits.password,
      'password',
    );

    final policyId = device.policyId;
    if (policyId == null) {
      return false;
    }

    // Many devices on the same policy must not pool their per-device quota to
    // guess one password: also limit per policy.
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.devicePasswordCheckPolicy,
      key: 'policy:$policyId',
    );

    final policy = await Policy.db.findById(session, policyId);
    final hash = policy?.adminPassword;
    if (hash == null || hash.isEmpty) {
      return false;
    }

    return _verify(
      session: session,
      password: request.password,
      hash: hash,
      policyId: policyId,
    );
  }

  /// Runs [PasswordHasher.verify] safely.
  ///
  /// `verify` throws `StateError` when no pepper is configured; the device must
  /// see "wrong password" (`false`) rather than a server error. Other
  /// verification errors are treated the same way.
  Future<bool> _verify({
    required Session session,
    required String password,
    required String hash,
    required int policyId,
  }) async {
    try {
      return await PasswordHasher.verify(password: password, hash: hash);
    } catch (error, stackTrace) {
      session.log(
        'Policy $policyId admin password could not be verified.',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> notificationAck(
    Session session,
    DeviceNotificationAckRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );

    final notification = await DeviceNotification.db.findFirstRow(
      session,
      where: (t) => t.uuid.equals(request.notificationUuid),
    );
    if (notification == null) {
      return false;
    }

    final delivery = await DeviceNotificationDevice.db.findFirstRow(
      session,
      where: (t) =>
          t.deviceNotificationId.equals(notification.id!) &
          t.deviceId.equals(device.id!),
    );
    if (delivery == null) {
      return false;
    }

    delivery
      ..status = NotificationDeliveryStatus.received
      ..receivedAt = DateTime.now().toUtc();

    await DeviceNotificationDevice.db.updateRow(session, delivery);
    return true;
  }

  Future<DeviceFileUploadResponse> uploadFile(
    Session session,
    DeviceFileUploadRequest request,
  ) async {
    final device = await _requireAuthorizedDevice(
      session,
      request.token,
      request.deviceUuid,
    );
    InMemoryRateLimiter.instance.enforce(
      RateLimitScope.deviceUploadFile,
      key: ClientIpResolver.deviceKey(session, device.uuid),
    );

    return DeviceUploadService.store(session, request, deviceId: device.id);
  }

  /// Writes the fields present in the sync payload onto [device] and returns the
  /// columns to persist.
  ///
  /// A dynamic (partial) sync carries only some sections; a field missing from
  /// the payload does not clear the current value. Columns the sync does not own
  /// (policyId, name, userId…) are never written, so a concurrent panel change
  /// is not reverted.
  List<Column> _applySyncFields(
    DeviceTable t,
    Device device, {
    required Map<String, dynamic> data,
    required DateTime collectedAt,
    required Map<String, dynamic> deviceInfo,
    required Map<String, dynamic> versionInfo,
    required Map<String, dynamic> mdmAppInfo,
    required Map<String, dynamic> batteryInfo,
    required Map<String, dynamic> networkInfo,
    required Map<String, dynamic> securityInfo,
    required Map<String, dynamic> storageInfo,
    required Map<String, dynamic> bsInfo,
    required Map<String, dynamic> stInfo,
  }) {
    final columns = <Column>[t.collectedAt, t.lastSeenAt, t.firstSeenAt];
    device
      ..collectedAt = collectedAt
      ..lastSeenAt = collectedAt
      ..firstSeenAt = device.firstSeenAt ?? collectedAt;

    void put(
      Map<String, dynamic> source,
      String key,
      Column column,
      void Function(dynamic value) apply,
    ) {
      if (source.containsKey(key)) {
        apply(source[key]);
        columns.add(column);
      }
    }

    put(data, 'policy_version', t.policyVersion, (v) {
      device.policyVersion = asInt(v);
    });
    put(deviceInfo, 'manufacturer', t.manufacturer, (v) {
      device.manufacturer = asString(v);
    });
    put(deviceInfo, 'model', t.model, (v) => device.model = asString(v));
    put(deviceInfo, 'brand', t.brand, (v) => device.brand = asString(v));
    put(deviceInfo, 'id', t.serialNo, (v) => device.serialNo = asString(v));
    put(versionInfo, 'release', t.androidVersion, (v) {
      device.androidVersion = asString(v);
    });
    put(versionInfo, 'sdkInt', t.sdkVersion, (v) {
      device.sdkVersion = asInt(v);
    });
    put(mdmAppInfo, 'version', t.agentVersionName, (v) {
      device.agentVersionName = asString(v);
    });
    put(mdmAppInfo, 'buildNumber', t.agentVersionCode, (v) {
      device.agentVersionCode = asInt(v);
    });
    put(batteryInfo, 'level', t.batteryLevel, (v) {
      device.batteryLevel = asInt(v);
    });
    put(asMap(networkInfo['ipInfo']), 'ipv4', t.ipAddress, (v) {
      device.ipAddress = asString(v);
    });
    put(storageInfo, 'totalStorageBytes', t.totalStorageBytes, (v) {
      device.totalStorageBytes = asInt(v);
    });
    put(storageInfo, 'freeStorageBytes', t.freeStorageBytes, (v) {
      device.freeStorageBytes = asInt(v);
    });

    // Non-nullable bool columns: written only when a real value arrived.
    final isRooted = asBoolOrNull(securityInfo['isRooted']);
    if (isRooted != null) {
      device.isRooted = isRooted;
      columns.add(t.isRooted);
    }
    // Newer agents write the new key; fall back to `kiosk_enabled` for older ones.
    final isLauncherMode =
        asBoolOrNull(bsInfo['launcher_mode_enabled']) ??
        asBoolOrNull(bsInfo['kiosk_enabled']);
    if (isLauncherMode != null) {
      device.isLauncherMode = isLauncherMode;
      columns.add(t.isLauncherMode);
    }

    put(stInfo, 'lastPolicyUpdate', t.lastPolicyUpdate, (v) {
      final millis = asInt(v);
      device.lastPolicyUpdate = millis != null && millis > _minMillisTimestamp
          ? DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true)
          : null;
    });

    return columns;
  }

  /// Applies an inbound stream message: refreshes the heartbeat, records an
  /// `ack` result, and updates presence for `heartbeat`/`ack`.
  ///
  /// Only `lastSeenAt` is written (the [device] copy read when the connection
  /// opened is stale; writing the whole row would revert the panel's
  /// policy/name/user changes). The update is conditional on the device id and
  /// the token hash read on the connection, so a deleted device or a rotated
  /// token matches no row and the stream is closed. The call is `unawaited`,
  /// hence the catch here.
  ///
  /// The `heartbeat` payload (battery, policy version) is deliberately not
  /// written; sync is the source of those fields.
  Future<void> _handleInbound(
    Session session,
    Device device,
    DeviceStreamController controller,
    DeviceStreamMessage message,
  ) async {
    final deviceId = device.id!;
    try {
      final touched = await Device.db.updateWhere(
        session,
        where: (t) =>
            t.id.equals(deviceId) & t.authToken.equals(device.authToken),
        columnValues: (t) => [t.lastSeenAt(DateTime.now().toUtc())],
      );
      if (touched.isEmpty) {
        session.log(
          'Device $deviceId no longer exists or its token changed; '
          'closing stream.',
          level: LogLevel.warning,
        );
        if (!controller.isClosed) {
          unawaited(controller.close());
        }
        return;
      }

      switch (message.type) {
        case 'heartbeat':
          await _markPresence(session, device, online: true);
        case 'ack':
          await _markPresence(session, device, online: true);

          final commandId = message.commandId;
          if (commandId != null && commandId.isNotEmpty) {
            await DeviceCommandService.acknowledge(
              session,
              commandId,
              deviceId: deviceId,
              response: message.payload,
              error: _isErrorAck(message.payload),
            );
          }
        default:
          break;
      }
    } catch (error, stackTrace) {
      try {
        session.log(
          'Device $deviceId could not process inbound "${message.type}".',
          level: LogLevel.error,
          exception: error,
          stackTrace: stackTrace,
        );
      } catch (_) {
        // The log can fail if the session is closing; losing the message is
        // acceptable.
      }
    }
  }

  /// The agent sends `{"success": false}` (or `{"error": true}`) for failures;
  /// any other payload counts as a success.
  bool _isErrorAck(String? payload) {
    if (payload == null || payload.isEmpty) {
      return false;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        return decoded['error'] == true || decoded['success'] == false;
      }
    } on FormatException {
      return false;
    }

    return false;
  }

  /// Only updates an existing [DeviceStateCache] row: the row is created by a
  /// device sync, which also owns the required `deviceSyncId`.
  Future<void> _markPresence(
    Session session,
    Device device, {
    required bool online,
  }) async {
    final deviceId = device.id;
    if (deviceId == null) {
      return;
    }

    // Presence columns only: a concurrent sync's cache values are not
    // overwritten by a stale copy.
    await DeviceStateCache.db.updateWhere(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      columnValues: (t) => [
        t.isOnline(online),
        t.updatedAt(DateTime.now().toUtc()),
      ],
    );
  }

  String? _syncType(Map<String, dynamic> data, String? fallback) {
    final raw = asString(data['sync_type']) ?? fallback;
    return raw == 'full' || raw == 'dynamic' ? raw : null;
  }

  DateTime _parseCollectedAt(Map<String, dynamic> data) {
    final candidates = <dynamic>[
      asMap(asMap(data['otherSettings'])['dateTime'])['currentDateTime'],
      asMap(data['dateTime'])['currentDateTime'],
      data['collectedAt'],
    ];

    // Timestamps without an offset (older agents) have an ambiguous zone, so
    // they are skipped; if none parses, the server's receive time is used
    // (see [parseDeviceTimestamp]).
    for (final candidate in candidates) {
      final parsed = parseDeviceTimestamp(asString(candidate));
      if (parsed != null) {
        return parsed;
      }
    }

    return DateTime.now().toUtc();
  }

  DateTime _parseDeviceTimestamp(String raw) =>
      parseDeviceTimestamp(raw) ?? DateTime.now().toUtc();

  Map<String, dynamic> _decodePayload(String payload) {
    if (payload.isEmpty) {
      return const {};
    }
    final decoded = jsonDecode(payload);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : const {};
  }

  String? _encode(dynamic value) => value == null ? null : jsonEncode(value);
}
