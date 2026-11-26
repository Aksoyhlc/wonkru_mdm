import 'dart:io';

import '../generated/serverpod.dart';
import '../service/admin_scope_service.dart';
import '../service/client_ip_resolver.dart';
import '../service/initial_setup_service.dart';
import '../service/rate_limiter.dart';
import '../service/timezone_service.dart';
import '../util/password_hasher.dart';
import '../util/totp_secret_cipher.dart';
import 'auth_initialization.dart';
import 'health/health_config_builder.dart';
import 'recurring_future_calls.dart';
import 'web_routes.dart';

/// Builds and starts the server: one ordered composition root for auth, rate
/// limiting, web routes, storage and the recurring future calls.
class ServerBootstrap {
  ServerBootstrap(this.args);

  final List<String> args;

  Future<void> run() async {
    TimezoneService.ensureInitialized();

    late final Serverpod pod;
    var initialSetupComplete = false;
    pod = Serverpod(
      args,
      healthConfig: buildHealthConfig(
        sessionFactory: () => pod.createSession(enableLogging: false),
        initialSetupComplete: () => initialSetupComplete,
      ),
    );

    _warnIfPepperUnconfigured();
    initializeAuthServices(pod);
    _configureRateLimiting();

    await registerWebRoutes(pod);
    await pod.start();

    final session = await pod.createSession(enableLogging: false);
    try {
      await InitialSetupService.initialize(session);
      initialSetupComplete = true;
    } finally {
      await session.close();
    }
    await _syncAdminScopes(pod);
    await RecurringFutureCalls.scheduleAll(pod);
  }

  void _warnIfPepperUnconfigured() {
    if (PasswordHasher.isConfigured || TotpSecretCipher.isConfigured) {
      return;
    }

    stderr.writeln(
      'WARNING: PASSWORD_HASH_PEPPER is not set and config/passwords.yaml has '
      'no `passwordHashPepper`. Policy admin password and 2FA features return '
      '500. Provide the environment variable or the config value, a random '
      'string of at least 32 characters.',
    );
  }

  void _configureRateLimiting() {
    ClientIpResolver.source = ClientIpResolver.parseSource(
      Platform.environment['CLIENT_IP_SOURCE'],
    );
    InMemoryRateLimiter.instance.start();
  }

  Future<void> _syncAdminScopes(Serverpod pod) async {
    try {
      final session = await pod.createSession();
      try {
        await AdminScopeService.syncAllProfiles(session);
      } finally {
        await session.close();
      }
    } catch (error, stackTrace) {
      stderr.writeln('AdminScopeService: could not sync admin scopes: $error');
      stderr.writeln(stackTrace);
    }
  }
}
