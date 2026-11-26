import 'dart:async';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_register.dart';

const _tag = 'EnrollmentRecovery';

/// Distinguishes "another recovery is in progress" from "recovery failed": the
/// stream must fall back to normal reconnection only for the latter.
enum RecoveryOutcome {
  recovered,

  alreadyRunning,

  failed,

  notApplicable,

  /// The enrollment key was rejected: retrying with the same key is pointless,
  /// so the caller must not set up a reconnect loop until a new key is entered.
  enrollmentRejected,
}

/// Clears local identity, re-registers and restarts the stream when the server
/// rejects the device token, so a DB reset or token revocation self-heals.
///
/// Note: `register` opens a new device row on every call, so a revoked device
/// that self-heals leaves its old row behind as a ghost for the operator to clean up.
class EnrollmentRecovery {
  EnrollmentRecovery._();

  static bool _running = false;

  /// Upper bound for the recovery body: if `register()` or `restart()` hangs,
  /// the timeout fires so `_running` does not stay `true` forever.
  static const _recoveryTimeout = Duration(seconds: 60);

  static bool get isRunning => _running;

  /// Identity mismatch ([DeviceIdentityMismatchException]) is deliberately
  /// excluded: the token is valid and re-registering would create a ghost device.
  static bool isUnauthenticated(Object error) =>
      error is DeviceUnauthenticatedException;

  static ({String uuid, String? code})? identityToAdopt(Object error) {
    if (error is! DeviceIdentityMismatchException) return null;
    final uuid = error.deviceUuid?.trim();
    if (uuid == null || uuid.isEmpty) return null;
    final code = error.deviceCode?.trim();
    return (uuid: uuid, code: code == null || code.isEmpty ? null : code);
  }

  /// No re-registration happens; the token is kept. Adopting returns `true` and
  /// the caller may retry the request with the new uuid.
  static bool adoptIdentity(Object error) {
    final identity = identityToAdopt(error);
    if (identity == null) return false;
    WLog.w(
      _tag,
      'Local uuid differs from server; adopting server identity '
      '(no re-registration)',
    );
    DeviceIdentityHelper.saveUuid(identity.uuid);
    final code = identity.code;
    if (code != null) DeviceIdentityHelper.saveCode(code);
    return true;
  }

  static void onRpcError(Object error) {
    if (adoptIdentity(error)) return;
    if (isUnauthenticated(error)) unawaited(handle(error));
  }

  static Future<RecoveryOutcome> handle(Object error) async {
    if (!isUnauthenticated(error)) return RecoveryOutcome.notApplicable;
    return _recover();
  }

  /// Covers the token-less case: [handle] only runs after a token rejection, so
  /// a register failure right after `clearEnrollment` would otherwise leave the
  /// device unregistered forever. [DeviceStreamManager] calls this on its
  /// token-less branch.
  static Future<RecoveryOutcome> recoverMissingEnrollment() =>
      _recover(requireMissingToken: true);

  static Future<RecoveryOutcome> _recover({
    bool requireMissingToken = false,
  }) async {
    if (_running) return RecoveryOutcome.alreadyRunning;
    _running = true;
    try {
      if (requireMissingToken && !_hasMissingToken()) {
        return RecoveryOutcome.notApplicable;
      }
      return await _recoverBody().timeout(
        _recoveryTimeout,
        onTimeout: () {
          WLog.e(_tag, 'Recovery timed out');
          return RecoveryOutcome.failed;
        },
      );
    } catch (e, st) {
      WLog.e(_tag, 'Recovery failed', error: e, stackTrace: st);
      return RecoveryOutcome.failed;
    } finally {
      _running = false;
    }
  }

  static bool _hasMissingToken() {
    final token = DeviceIdentityHelper.getToken();
    return token == null || token.isEmpty;
  }

  static Future<RecoveryOutcome> _recoverBody() async {
    // The server already rejected this key: stop before hitting the network.
    // Identity is kept; registration resumes once a new key is entered in setup.
    if (EnrollmentKeyStore.instance.isRejected) {
      WLog.w(
        _tag,
        'Enrollment key rejected; automatic re-registration is not performed '
        'until a new key is entered',
      );
      return RecoveryOutcome.enrollmentRejected;
    }

    WLog.w(_tag, 'Device not registered/rejected; re-registering');

    // Do not clear identity while offline: losing the token without being able
    // to re-register would leave the device unregistered, and keeping the
    // invalid identity lets the next attempt retry once connectivity returns.
    if (!await NetworkManager.instance.isOnline()) {
      WLog.w(_tag, 'Offline; recovery postponed (identity kept)');
      return RecoveryOutcome.failed;
    }

    await DeviceIdentityHelper.clearEnrollment();
    final (code, uuid, err) = await DeviceRegister().register();
    if (EnrollmentKeyStore.instance.isRejected) {
      return RecoveryOutcome.enrollmentRejected;
    }
    if (code == null || uuid == null) {
      WLog.e(_tag, 'Re-registration failed: ${err ?? "unknown"}');
      return RecoveryOutcome.failed;
    }
    await DeviceStreamManager.to.restart();
    return RecoveryOutcome.recovered;
  }
}
