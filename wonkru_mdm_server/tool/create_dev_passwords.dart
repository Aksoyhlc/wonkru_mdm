import 'dart:convert';
import 'dart:io';
import 'dart:math';

Future<void> main() async {
  final file = File.fromUri(
    Platform.script.resolve('../config/passwords.yaml'),
  );
  if (await file.exists()) {
    stderr.writeln(
      'passwords.yaml already exists; existing secrets were kept.',
    );
    exitCode = 1;
    return;
  }

  final random = Random.secure();
  const keys = [
    'database',
    'serviceSecret',
    'emailSecretHashPepper',
    'jwtHmacSha512PrivateKey',
    'jwtRefreshTokenHashPepper',
    'passwordHashPepper',
    'storageSigningKey',
  ];
  final yaml = StringBuffer('development:\n');
  for (final key in keys) {
    final secret = base64Encode(List.generate(48, (_) => random.nextInt(256)));
    yaml.writeln("  $key: '$secret'");
  }
  await file.parent.create(recursive: true);
  await file.writeAsString(yaml.toString(), flush: true);
  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['600', file.path]);
    if (result.exitCode != 0) {
      stderr.writeln('Could not restrict passwords.yaml permissions.');
      exitCode = 1;
      return;
    }
  }
  stdout.writeln('Created development secrets in ${file.path}.');
}
