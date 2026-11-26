import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../config/app_config.dart';
import '../enums/system_alert_enums.dart';
import '../generated/protocol.dart';
import 'admin_settings_service.dart';
import 'smtp_mail_service.dart';

/// Test seam: matches [AdminSettingsService.read].
typedef SystemAlertSettingsReader =
    Future<SettingsFormState> Function(
      Session session, {
      Transaction? transaction,
    });

/// Test seam: matches [SmtpMailService.send].
typedef SystemAlertMailSender =
    Future<void> Function(
      SettingsFormState state, {
      required String to,
      required String subject,
      required String body,
    });

/// Routes system alerts to panel admins using the type -> channel map in the
/// `system_alert_routing` setting: one [AdminNotification] row per target, plus
/// email via [SmtpMailService] when the channel includes `mail`. The `sms`
/// channel is out of scope and is logged and skipped.
class SystemAlertDispatcher {
  const SystemAlertDispatcher._();

  /// Returns the number of targets actually reached (a row written or a mail
  /// sent). `0` when no channel is configured, no recipient is found, or only
  /// the `sms` channel is routed, so callers do not log a false "dispatched".
  ///
  /// [readSettings] and [mailSender] are only replaced in tests.
  static Future<int> dispatch(
    Session session, {
    required SystemAlertType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    List<UuidValue>? userIds,
    SystemAlertSettingsReader readSettings = AdminSettingsService.read,
    SystemAlertMailSender mailSender = SmtpMailService.send,
    Transaction? transaction,
  }) async {
    final SettingsFormState state;
    try {
      state = await readSettings(session, transaction: transaction);
    } catch (error, stackTrace) {
      session.log(
        'SystemAlertDispatcher: settings could not be read, dispatch skipped',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
        metadata: {'alertType': type.name},
      );
      return 0;
    }

    final channels = channelsFor(state, type);
    if (channels.isEmpty) {
      session.log(
        'SystemAlertDispatcher: no channel defined for alert type, '
        'dispatch skipped',
        level: LogLevel.warning,
        metadata: {'alertType': type.name},
      );
      return 0;
    }

    final recipients = await _resolveRecipients(
      session,
      userIds,
      transaction: transaction,
    );
    if (recipients.isEmpty) {
      session.log(
        'SystemAlertDispatcher: no panel user to notify',
        level: LogLevel.warning,
        metadata: {'alertType': type.name},
      );
      return 0;
    }

    final database = channels.contains(SystemAlertChannel.database.value);
    final mail = channels.contains(SystemAlertChannel.mail.value);
    final sms = channels.contains(SystemAlertChannel.sms.value);

    if (database) {
      await _writeRows(
        session,
        recipients,
        type: type,
        title: title,
        message: message,
        data: data,
        transaction: transaction,
      );
    }

    if (mail) {
      await _sendMail(
        session,
        state,
        recipients,
        type: type,
        title: title,
        message: message,
        data: data,
        mailSender: mailSender,
        transaction: transaction,
      );
    }

    if (sms) {
      session.log(
        'SystemAlertDispatcher: SMS channel is not implemented, '
        'notification was not delivered over SMS',
        level: LogLevel.warning,
        metadata: {'alertType': type.name},
      );
    }

    if (!database && !mail) {
      return 0;
    }

    return recipients.length;
  }

  /// Empty when the type has no routing entry; only faked settings produce that.
  static List<String> channelsFor(
    SettingsFormState state,
    SystemAlertType type,
  ) {
    for (final entry in state.systemAlertTypeChannels) {
      if (entry.type == type) {
        return entry.channels;
      }
    }
    return const [];
  }

  /// Explicit [userIds] (even an empty list) win, deduplicated in order.
  /// Otherwise the session's admin is targeted, or all active panel admins
  /// ordered by id when there is no session, as in scheduled calls.
  static Future<List<UuidValue>> _resolveRecipients(
    Session session,
    List<UuidValue>? userIds, {
    Transaction? transaction,
  }) async {
    if (userIds != null) {
      final seen = <UuidValue>{};
      return [
        for (final userId in userIds)
          if (seen.add(userId)) userId,
      ];
    }

    final authenticated = session.authenticated;
    if (authenticated != null) {
      try {
        return [UuidValue.fromString(authenticated.userIdentifier)];
      } on FormatException {
        // Not a UUID; fall through to the panel admins below.
      }
    }

    final admins = await AdminProfile.db.find(
      session,
      where: (t) => t.status.equals(AdminAccountStatus.active),
      orderBy: (t) => t.id,
      transaction: transaction,
    );

    return [for (final admin in admins) admin.userId];
  }

  static Future<void> _writeRows(
    Session session,
    List<UuidValue> recipients, {
    required SystemAlertType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    Transaction? transaction,
  }) async {
    final now = DateTime.now().toUtc();
    final encoded = _encodeData(data);

    for (final userId in recipients) {
      await AdminNotification.db.insertRow(
        session,
        AdminNotification(
          userId: userId,
          type: type.name,
          title: title,
          message: message,
          data: encoded,
          createdAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  /// Users without an email are skipped and SMTP that is not configured is
  /// logged instead of sent. One send failure does not block the rest.
  static Future<void> _sendMail(
    Session session,
    SettingsFormState state,
    List<UuidValue> recipients, {
    required SystemAlertType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    required SystemAlertMailSender mailSender,
    Transaction? transaction,
  }) async {
    if (!state.smtpEnabled || state.smtpHost.trim().isEmpty) {
      session.log(
        'SystemAlertDispatcher: SMTP is not configured, mail not sent',
        level: LogLevel.warning,
        metadata: {'alertType': type.name},
      );
      return;
    }

    final profiles = await UserProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(recipients.toSet()),
      transaction: transaction,
    );

    final emailByUser = <UuidValue, String>{
      for (final profile in profiles)
        if (profile.email != null && profile.email!.trim().isNotEmpty)
          profile.authUserId: profile.email!.trim(),
    };

    if (emailByUser.isEmpty) {
      session.log(
        'SystemAlertDispatcher: no recipient has an email, mail not sent',
        level: LogLevel.warning,
        metadata: {'alertType': type.name},
      );
      return;
    }

    final subject = _mailSubject(state, title);
    final body = _mailBody(message, data);

    for (final userId in recipients) {
      final to = emailByUser[userId];
      if (to == null) {
        continue;
      }

      try {
        await mailSender(state, to: to, subject: subject, body: body);
      } catch (error, stackTrace) {
        session.log(
          'SystemAlertDispatcher: alert mail could not be sent ($to)',
          level: LogLevel.error,
          exception: error,
          stackTrace: stackTrace,
          metadata: {'alertType': type.name},
        );
      }
    }
  }

  static String? _encodeData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return null;
    }

    return jsonEncode(data);
  }

  static String _mailSubject(SettingsFormState state, String title) {
    final brand = state.panelBrandName.trim();
    return '[${brand.isEmpty ? AppConfig.name : brand}] $title';
  }

  static String _mailBody(String message, Map<String, dynamic>? data) {
    final url = data?['url'];
    if (url is String && url.trim().isNotEmpty) {
      return '$message\n\n${url.trim()}\n';
    }

    return '$message\n';
  }
}
