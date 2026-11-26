import 'package:serverpod/serverpod.dart';

import '../../config/mail_config.dart';
import '../../service/setting_service.dart';
import 'smtp_health_settings.dart';

/// Validates SMTP configuration consistency.
///
/// SMTP is optional: disabled always passes. When enabled only the
/// configuration (host/port/from) is validated; no network connection is
/// attempted on purpose, so a transient SMTP outage cannot drop readiness for a
/// non-required dependency.
///
/// `check()` receives no session; production reads settings through
/// [sessionFactory], tests inject [settingsReader] directly.
class SmtpHealthIndicator extends HealthIndicator<String> {
  SmtpHealthIndicator({
    this.sessionFactory,
    this.settingsReader,
  });

  final Future<Session> Function()? sessionFactory;

  final Future<SmtpHealthSettings?> Function()? settingsReader;

  @override
  String get name => 'smtp:configuration';

  @override
  String get componentType => HealthComponentType.component.name;

  @override
  Duration get timeout => const Duration(seconds: 3);

  @override
  Future<HealthCheckResult> check() async {
    final SmtpHealthSettings? settings;
    try {
      settings = await (settingsReader ?? _readSettingsOverDb)();
    } catch (error) {
      // SMTP is optional: if settings cannot be read, treat it as disabled
      // rather than failing readiness like a required dependency. The database
      // itself is covered by its own indicator.
      return pass(
        observedValue: 'unknown',
        output: 'SMTP settings unavailable; treated as disabled: $error',
      );
    }

    if (settings == null || !settings.enabled) {
      return pass(observedValue: 'disabled', output: 'SMTP is disabled.');
    }

    final problems = validate(settings);
    if (problems.isEmpty) {
      return pass(
        observedValue: 'configured',
        output: 'SMTP configuration is valid.',
      );
    }

    return fail(observedValue: 'invalid', output: problems.join(' '));
  }

  static List<String> validate(SmtpHealthSettings settings) {
    final problems = <String>[];
    if (settings.host.trim().isEmpty) {
      problems.add('smtp_host is empty.');
    }
    if (settings.port < 1 || settings.port > 65535) {
      problems.add('smtp_port (${settings.port}) is out of range.');
    }
    if (settings.fromAddress.trim().isEmpty) {
      problems.add('smtp_from_address is empty.');
    }
    return problems;
  }

  /// Queries only the four needed settings: `AdminSettingsService.read` runs ~40
  /// queries, and the health endpoint is polled often. Defaults match
  /// `AdminSettingsService.read` (see `mail_config.dart`).
  Future<SmtpHealthSettings?> _readSettingsOverDb() async {
    final factory = sessionFactory;
    if (factory == null) {
      throw StateError('No session factory configured for health checks.');
    }

    final session = await factory();
    try {
      final enabled = await SettingService.getBool(
        session,
        'smtp_enabled',
        fallback: false,
      );
      final host =
          await SettingService.raw(session, 'smtp_host') ?? MailConfig.host;
      // `getInt` is typed `int?`; with `fallback` given the value is never null.
      final port = (await SettingService.getInt(
        session,
        'smtp_port',
        fallback: MailConfig.port,
      ))!;
      final fromAddress =
          await SettingService.raw(session, 'smtp_from_address') ??
          MailConfig.fromAddress;

      return SmtpHealthSettings(
        enabled: enabled,
        host: host,
        port: port,
        fromAddress: fromAddress,
      );
    } finally {
      await session.close();
    }
  }
}
