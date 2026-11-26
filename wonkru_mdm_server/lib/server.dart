import 'src/server/server_bootstrap.dart';

void run(List<String> args) async {
  await ServerBootstrap(args).run();
}
