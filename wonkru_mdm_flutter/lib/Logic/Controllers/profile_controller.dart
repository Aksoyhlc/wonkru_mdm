import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/L10n/L.dart';
import '../../Data/Repositories/auth_repository.dart';
import '../../Data/Repositories/user_repository.dart';

class ProfileController extends GetxController {
  final savingPassword = false.obs;
  final savingEmail = false.obs;

  final totpEnabled = false.obs;

  final totpBusy = false.obs;

  Future<void> loadTwoFactor() async {
    try {
      totpEnabled.value = (await AuthRepository.me()).totpEnabled;
    } catch (_) {
      // The card must render even if the state read fails; operations will
      // surface their own errors.
    }
  }

  Future<AdminTotpSetup> startTotpSetup() => AuthRepository.startTotpSetup();

  Future<List<String>> confirmTotpSetup(String code) async {
    final codes = await AuthRepository.confirmTotpSetup(code);
    totpEnabled.value = true;
    return codes;
  }

  Future<void> disableTotp(String code) async {
    totpBusy.value = true;
    try {
      await AuthRepository.disableTotp(code);
      totpEnabled.value = false;
    } finally {
      totpBusy.value = false;
    }
  }

  /// The `serverpod_auth` session carries only `authUserId`, not the address,
  /// so the email is read back from the user row. Returns null when unavailable.
  Future<String?> currentEmail() async {
    final authUserId = AuthRepository.currentAuthUserId;
    if (authUserId == null) return null;

    try {
      final row = await UserRepository.get(authUserId);
      final email = row.email?.trim();
      return email == null || email.isEmpty ? null : email;
    } catch (_) {
      return null;
    }
  }

  /// Throws [AdminTotpException] when the code is missing, cancelled, or wrong.
  static Future<void> ensureTwoFactorVerified({
    required AdminSessionInfo info,
    required Future<String?> Function()? requestCode,
    required Future<bool> Function(String code) verify,
  }) async {
    if (!info.twoFactorRequired) return;

    final code = await requestCode?.call();
    if (code == null || code.trim().isEmpty) {
      throw AdminTotpException(
        message: L.common.twoFactorCodeRequired,
      );
    }

    final ok = await verify(code.trim());
    if (!ok) {
      throw AdminTotpException(message: L.common.codeInvalidShort);
    }
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    Future<String?> Function()? requestTotpCode,
  }) async {
    savingPassword.value = true;
    try {
      await AuthRepository.verifyPassword(email, currentPassword);
      await ensureTwoFactorVerified(
        info: await AuthRepository.me(),
        requestCode: requestTotpCode,
        verify: AuthRepository.verifyTotp,
      );
      await AuthRepository.changePassword(email, newPassword);
    } finally {
      savingPassword.value = false;
    }
  }

  Future<void> changeEmail({
    required String currentEmail,
    required String currentPassword,
    required String newEmail,
    Future<String?> Function()? requestTotpCode,
  }) async {
    savingEmail.value = true;
    try {
      await AuthRepository.verifyPassword(currentEmail, currentPassword);
      await ensureTwoFactorVerified(
        info: await AuthRepository.me(),
        requestCode: requestTotpCode,
        verify: AuthRepository.verifyTotp,
      );
      await AuthRepository.changeEmail(currentEmail, newEmail);
    } finally {
      savingEmail.value = false;
    }
  }
}
