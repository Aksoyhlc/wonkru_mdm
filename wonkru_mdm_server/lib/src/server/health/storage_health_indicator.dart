import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../config/storage_config.dart';

/// Verifies local file storage is writable.
///
/// The server writes APK, certificate and device uploads to disk
/// (`LocalFileCloudStorage`); a read-only disk makes uploads fail silently, so
/// this catches it at readiness. The roots (`storage/private`, `storage/public`)
/// are created on first upload, so creating them when missing (idempotent) does
/// not produce a false failure. A small probe file is then written and deleted
/// per root.
class StorageHealthIndicator extends HealthIndicator<double> {
  StorageHealthIndicator({this.roots});

  final Iterable<Directory>? roots;

  List<Directory> get _resolvedRoots =>
      roots?.toList() ?? [StorageConfig.privateRoot, StorageConfig.publicRoot];

  @override
  String get name => 'storage:local';

  @override
  String get componentType => HealthComponentType.datastore.name;

  @override
  String get observedUnit => 'ms';

  @override
  Duration get timeout => const Duration(seconds: 2);

  @override
  Future<HealthCheckResult> check() async {
    final stopwatch = Stopwatch()..start();
    try {
      for (final root in _resolvedRoots) {
        await _verifyWritable(root);
      }
      stopwatch.stop();
      return pass(observedValue: stopwatch.elapsedMilliseconds.toDouble());
    } catch (error) {
      stopwatch.stop();
      return fail(output: 'Local storage is not writable: $error');
    }
  }

  Future<void> _verifyWritable(Directory root) async {
    await root.create(recursive: true);

    final probe = File('${root.path}/.health_probe');
    try {
      await probe.writeAsString('ok', flush: true);
    } finally {
      // The probe file is always cleaned up; a delete failure does not spoil the
      // check.
      try {
        if (await probe.exists()) {
          await probe.delete();
        }
      } catch (_) {
        // Ignored: the real error (if any) was already thrown above.
      }
    }
  }
}
