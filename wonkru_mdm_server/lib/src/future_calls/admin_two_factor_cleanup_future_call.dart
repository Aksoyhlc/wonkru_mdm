import 'package:serverpod/serverpod.dart';

import '../service/admin_two_factor_service.dart';

class AdminTwoFactorCleanupFutureCall extends FutureCall {
  /// The verification window is 12 hours, so running a few times a day is
  /// enough; 6 hours keeps freshly expired rows from lingering.
  static const interval = Duration(hours: 6);

  /// Never throws; errors are logged and the scheduled chain continues.
  Future<void> purgeExpiredVerifications(Session session) async {
    try {
      final deleted = await AdminTwoFactorService.purgeExpiredVerifications(
        session,
      );
      session.log(
        'AdminTwoFactorCleanup: expired verifications purged',
        metadata: {'deleted': deleted},
      );
    } catch (error, stackTrace) {
      session.log(
        'AdminTwoFactorCleanup: purge failed',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
