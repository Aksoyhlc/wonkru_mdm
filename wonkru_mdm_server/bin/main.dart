import 'package:wonkru_mdm_server/server.dart';
import 'package:wonkru_mdm_server/src/cli/admin_command.dart';

/// This is the starting point for your Serverpod server. Typically, there is
/// no need to modify this file.
///
/// The same binary also exposes the operator CLI used for password recovery:
///
/// ```bash
/// docker compose exec server ./bin/server admin passwd --email you@example.com
/// ```
Future<void> main(List<String> args) async {
  if (args.isNotEmpty && args.first == 'admin') {
    await runAdminCli(args.sublist(1));
    return;
  }

  run(args);
}
