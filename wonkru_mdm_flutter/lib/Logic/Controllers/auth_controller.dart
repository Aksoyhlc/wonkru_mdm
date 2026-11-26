import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Constants/Enums/alert_enums.dart';
import '../../Core/Constants/Enums/auth_enums.dart';
import '../../Core/Errors/server_error_message.dart';
import '../../Core/L10n/L.dart';
import '../../Core/Logging/wlog.dart';
import '../../Core/Time/app_time.dart';
import '../../Data/Client/serverpod_client.dart' show serverpodSessionRestored;
import '../../Data/Repositories/auth_repository.dart';
import '../../Data/Repositories/settings_repository.dart';
import '../../Views/Widgets/Alert/app_toast.dart';

const _tag = 'AuthController';

class AuthController extends GetxController {
  final status = AuthStatus.loading.obs;

  /// Whether the system has no admin profile at all; the "set up first admin"
  /// option depends on this.
  final needsBootstrap = false.obs;

  final errorMessage = RxnString();

  final twoFactorError = RxnString();

  Future<void> init() async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;

    // Must await the stored session before checking, otherwise a page refresh
    // would drop the login.
    await awaitSessionRestored();

    if (!isSignedIn) {
      // With no session, still learn whether first-time setup is needed so an
      // empty database can show the bootstrap form.
      try {
        final info = await fetchSession();
        needsBootstrap.value = info.needsBootstrap;
      } catch (_) {
        needsBootstrap.value = false;
      }
      status.value = AuthStatus.signedOut;
      return;
    }

    try {
      final info = await fetchSession();
      needsBootstrap.value = info.needsBootstrap;

      final resolved = statusFor(info);
      if (resolved == AuthStatus.noAccess &&
          info.status == AdminAccountStatus.active) {
        // An active account whose session token lacks the `admin` scope gets
        // 403 from the admin endpoints. Treating it as ready would loop
        // (403 -> init -> ready -> 403); the scope is baked into the JWT at
        // sign-in, so the admin must sign in again.
        AppToast.show(
          L.common.sessionNoAdminScope,
          tone: UiAlertTone.warning,
        );
      }
      status.value = resolved;
      if (resolved == AuthStatus.ready) {
        // The timezone is stored on the server and cannot be read before the
        // session is ready, but the panel renders all times in it.
        unawaited(_loadPanelTimezone());
      }
    } catch (e) {
      needsBootstrap.value = false;
      errorMessage.value = serverErrorMessage(e);
      status.value = AuthStatus.failed;
      AppToast.show(errorMessage.value!, tone: UiAlertTone.danger);
    }
  }

  /// Does not block the login flow: on failure the panel shows UTC and a
  /// warning banner appears ([AppTime.isConfigured] false).
  Future<void> _loadPanelTimezone() async {
    try {
      AppTime.instance.set(await SettingsRepository.timezone());
    } catch (e, stackTrace) {
      WLog.e(
        _tag,
        'panel timezone could not be loaded',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// A scope-less **active** account must map to `noAccess`; treating it as
  /// ready makes admin calls 403 in a loop.
  @visibleForTesting
  static AuthStatus statusFor(AdminSessionInfo info) {
    if (info.twoFactorRequired) return AuthStatus.awaitingTwoFactor;
    if (info.status != AdminAccountStatus.active) return AuthStatus.noAccess;
    return info.hasAdminScope ? AuthStatus.ready : AuthStatus.noAccess;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await requestSignIn(email, password);
      await init();
      return true;
    } catch (_) {
      AppToast.show(
        L.common.signInFailed,
        tone: UiAlertTone.danger,
      );
      return false;
    }
  }

  /// Only runs when no admin exists; the panel returns to the login screen
  /// afterwards, with no session opened.
  Future<bool> bootstrap(String email, String password) async {
    try {
      await requestBootstrap(email, password);
    } catch (_) {
      return false;
    }

    needsBootstrap.value = false;
    status.value = AuthStatus.signedOut;

    AppToast.show(L.common.firstAdminCreated, tone: UiAlertTone.info);
    return true;
  }

  @visibleForTesting
  Future<void> requestBootstrap(String email, String password) async {
    await AuthRepository.bootstrap(email: email, password: password);
  }

  @visibleForTesting
  Future<AdminSessionInfo> fetchSession() => AuthRepository.me();

  @visibleForTesting
  Future<void> awaitSessionRestored() => serverpodSessionRestored;

  @visibleForTesting
  bool get isSignedIn => AuthRepository.isSignedIn;

  @visibleForTesting
  Future<void> requestSignIn(String email, String password) =>
      AuthRepository.signIn(email, password);

  /// A recovery code is also accepted; on failure [twoFactorError] carries the
  /// message, which is the server's verbatim text for cases like lockout.
  Future<bool> verifyTotp(String code) async {
    twoFactorError.value = null;
    try {
      final ok = await AuthRepository.verifyTotp(code);
      if (ok) {
        await init();
        return true;
      }
      twoFactorError.value = L.common.codeInvalid;
      return false;
    } catch (e) {
      twoFactorError.value = serverErrorMessage(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await AuthRepository.signOut();
    status.value = AuthStatus.signedOut;
  }
}
