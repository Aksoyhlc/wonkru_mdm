library;

/// Whether [path] is an absolute Android file path.
///
/// Leading/trailing whitespace is trimmed; a non-empty path starting with `/`
/// counts as absolute. A relative name (e.g. `2wed`) resolves to the process
/// root on the device and the download fails with `Read-only file system`, so
/// the panel accepts absolute paths only.
bool isAbsoluteDevicePath(String path) {
  final trimmed = path.trim();
  return trimmed.isNotEmpty && trimmed.startsWith('/');
}
