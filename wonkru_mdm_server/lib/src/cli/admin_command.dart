import 'dart:io';

import '../generated/serverpod.dart';
import '../server/auth_initialization.dart';
import '../service/admin_recovery_service.dart';

const _usage = '''
Wonkru MDM admin CLI

Usage:
  server admin list
  server admin passwd --email <email> [options]

Options for passwd:
  --email <email>       Panel account to update.
  --create              Create the auth user, admin profile and scope when
                        the email is unknown.
  --grant-admin         Add or activate the admin profile of an existing
                        auth user.
  --clear-totp          Remove two-factor authentication for the account.
  --keep-sessions       Do not revoke the account's active sessions.
  --password-stdin      Read the new password from stdin (first line).
  --name <name>         Display name used with --create.
  --yes                 Skip the confirmation prompt for --create,
                        --grant-admin and --clear-totp.
  -h, --help            Show this help.

The password is never accepted as a command line argument, so it does not end
up in the shell history. Without --password-stdin it is prompted twice with
echo disabled; that requires a terminal (do not pass -T to docker compose exec).
For scripts, pipe the password with --password-stdin and add -T to docker
compose exec.

Examples:
  docker compose exec server ./bin/server admin list
  docker compose exec server ./bin/server admin passwd --email a@example.com
  docker compose exec server ./bin/server admin passwd --email a@example.com --clear-totp
''';

/// Runs the `admin` subcommand of the server binary.
///
/// The CLI starts a maintenance-mode Serverpod pod: it connects to the
/// database but never opens the API or web ports, so it is safe to run while
/// the real server is up.
Future<void> runAdminCli(List<String> args) async {
  try {
    final code = await _dispatch(args);
    await stdout.flush();
    await stderr.flush();
    exit(code);
  } on _CliError catch (error) {
    stderr.writeln('error: ${error.message}');
    stderr.writeln('Run "server admin --help" for usage.');
    await stdout.flush();
    await stderr.flush();
    exit(2);
  } on AdminRecoveryException catch (error) {
    stderr.writeln('error: ${error.message}');
    await stdout.flush();
    await stderr.flush();
    exit(1);
  }
}

Future<int> _dispatch(List<String> args) async {
  if (args.isEmpty || args.first == '--help' || args.first == '-h') {
    stdout.write(_usage);
    return 0;
  }

  final command = args.first;
  if (command == 'help') {
    stdout.write(_usage);
    return 0;
  }

  return switch (command) {
    'list' => _runList(args.sublist(1)),
    'passwd' || 'password' => _runPasswd(args.sublist(1)),
    _ => throw _CliError('Unknown admin command: $command'),
  };
}

Future<int> _runList(List<String> args) async {
  if (args.isNotEmpty) {
    throw _CliError('"admin list" does not take arguments.');
  }

  final pod = await _startPod();
  try {
    final session = await pod.createSession(enableLogging: false);
    try {
      final admins = await AdminRecoveryService.listAdmins(session);
      if (admins.isEmpty) {
        stdout.writeln('No panel admins found.');
        return 0;
      }

      stdout.writeln(
        '${_pad('EMAIL', 34)}${_pad('STATUS', 10)}'
        '${_pad('PASSWORD', 10)}${_pad('2FA', 6)}LAST LOGIN',
      );
      for (final admin in admins) {
        stdout.writeln(
          '${_pad(admin.email ?? '-', 34)}'
          '${_pad(admin.blocked ? 'blocked' : admin.status.name, 10)}'
          '${_pad(admin.hasPassword ? 'yes' : 'no', 10)}'
          '${_pad(admin.totpEnabled ? 'on' : 'off', 6)}'
          '${admin.lastLoginAt?.toUtc().toIso8601String() ?? '-'}',
        );
      }
      return 0;
    } finally {
      await session.close();
    }
  } finally {
    await pod.shutdown(exitProcess: false);
  }
}

Future<int> _runPasswd(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    stdout.write(_usage);
    return 0;
  }

  final options = _PasswdOptions.parse(args);

  final changesPrivileges =
      options.createUser || options.grantAdmin || options.clearTotp;
  if (changesPrivileges && !options.yes) {
    final confirmed = _confirm(
      'This will ${options.describePrivilegeChanges()} '
      'for ${options.email}. Continue?',
    );
    if (!confirmed) {
      stdout.writeln('Cancelled.');
      return 1;
    }
  }

  final password = await _readPassword(options.passwordStdin);
  if (password.length < AdminRecoveryService.minimumPasswordLength) {
    throw _CliError(
      'Password must be at least '
      '${AdminRecoveryService.minimumPasswordLength} characters.',
    );
  }

  final pod = await _startPod();
  try {
    final session = await pod.createSession(enableLogging: false);
    try {
      final result = await AdminRecoveryService.resetPassword(
        session,
        email: options.email,
        password: password,
        createUser: options.createUser,
        grantAdmin: options.grantAdmin,
        clearTotp: options.clearTotp,
        revokeSessions: !options.keepSessions,
        name: options.name,
      );

      stdout.writeln(
        'Password updated for ${result.email} '
        '(admin profile ${result.adminProfileId}).',
      );
      if (result.userCreated) stdout.writeln('Auth user created.');
      if (result.profileCreated) stdout.writeln('Admin profile created.');
      if (result.profileActivated) stdout.writeln('Admin profile activated.');
      if (result.totpCleared) {
        stdout.writeln('Two-factor authentication cleared.');
      }
      stdout.writeln(
        result.sessionsRevoked
            ? 'Active sessions revoked.'
            : 'Active sessions kept.',
      );
      return 0;
    } finally {
      await session.close();
    }
  } finally {
    await pod.shutdown(exitProcess: false);
  }
}

/// Starts a database-only pod. Maintenance mode skips the API and web servers;
/// future calls are disabled so recovery does not trigger scheduled work.
///
/// The run mode must be resolved here: the container sets `runmode` for the
/// entrypoint to pass as `--mode`, but `docker compose exec` bypasses the
/// entrypoint arguments. Without this, the CLI would load the development
/// config (and its embedded database) on a production installation.
Future<Serverpod> _startPod() async {
  final runMode =
      Platform.environment['SERVERPOD_RUN_MODE'] ??
      Platform.environment['runmode'] ??
      'development';

  final pod = Serverpod(
    ['--mode=$runMode', '--role=maintenance'],
    serverDirectory: Directory.current,
    configOverride: (config) =>
        config.copyWith(futureCallExecutionEnabled: false),
  );
  initializeAuthServices(pod);
  await pod.start(runInGuardedZone: false);
  return pod;
}

Future<String> _readPassword(bool fromStdin) async {
  if (fromStdin) {
    final line = stdin.readLineSync();
    if (line == null || line.isEmpty) {
      throw _CliError('No password was received on stdin.');
    }
    return line;
  }

  if (!stdin.hasTerminal) {
    throw _CliError(
      'No terminal available to prompt for the password. '
      'Use --password-stdin.',
    );
  }

  final first = _promptHidden('New password: ');
  if (first.isEmpty) {
    throw _CliError('The password cannot be empty.');
  }
  final second = _promptHidden('Repeat password: ');
  if (first != second) {
    throw _CliError('The passwords do not match.');
  }
  return first;
}

String _promptHidden(String label) {
  stdout.write(label);
  final previousEchoMode = stdin.echoMode;
  stdin.echoMode = false;
  try {
    final line = stdin.readLineSync() ?? '';
    stdout.writeln();
    return line;
  } finally {
    stdin.echoMode = previousEchoMode;
  }
}

bool _confirm(String question) {
  if (!stdin.hasTerminal) {
    throw _CliError(
      'Confirmation requires a terminal. Re-run with --yes in scripts.',
    );
  }
  stdout.write('$question [y/N]: ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();
  return answer == 'y' || answer == 'yes';
}

String _pad(String value, int width) =>
    value.length >= width ? value : value.padRight(width);

class _PasswdOptions {
  _PasswdOptions({
    required this.email,
    required this.name,
    required this.createUser,
    required this.grantAdmin,
    required this.clearTotp,
    required this.keepSessions,
    required this.passwordStdin,
    required this.yes,
  });

  final String email;
  final String? name;
  final bool createUser;
  final bool grantAdmin;
  final bool clearTotp;
  final bool keepSessions;
  final bool passwordStdin;
  final bool yes;

  static _PasswdOptions parse(List<String> args) {
    String? email;
    String? name;
    var createUser = false;
    var grantAdmin = false;
    var clearTotp = false;
    var keepSessions = false;
    var passwordStdin = false;
    var yes = false;

    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      final separator = arg.indexOf('=');
      final key = separator == -1 ? arg : arg.substring(0, separator);
      final inlineValue = separator == -1 ? null : arg.substring(separator + 1);

      String valueOf() {
        if (inlineValue != null) return inlineValue;
        if (i + 1 >= args.length) {
          throw _CliError('$key needs a value.');
        }
        return args[++i];
      }

      switch (key) {
        case '--email' || '-e':
          email = valueOf();
        case '--name':
          name = valueOf();
        case '--create':
          createUser = true;
        case '--grant-admin':
          grantAdmin = true;
        case '--clear-totp':
          clearTotp = true;
        case '--keep-sessions':
          keepSessions = true;
        case '--password-stdin':
          passwordStdin = true;
        case '--yes' || '-y':
          yes = true;
        default:
          throw _CliError('Unknown option: $arg');
      }
    }

    if (email == null || email.trim().isEmpty) {
      throw _CliError('--email is required.');
    }

    return _PasswdOptions(
      email: email.trim(),
      name: name,
      createUser: createUser,
      grantAdmin: grantAdmin,
      clearTotp: clearTotp,
      keepSessions: keepSessions,
      passwordStdin: passwordStdin,
      yes: yes,
    );
  }

  String describePrivilegeChanges() {
    final changes = [
      if (createUser) 'create a new admin user',
      if (grantAdmin) 'create or activate the admin profile',
      if (clearTotp) 'clear two-factor authentication',
    ];
    return changes.join(', ');
  }
}

class _CliError implements Exception {
  _CliError(this.message);

  final String message;
}
