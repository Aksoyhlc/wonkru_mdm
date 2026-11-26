library;

/// Trims surrounding whitespace; a non-empty path starting with `/` is absolute.
/// Relative names (e.g. `2wed`) resolve to the process root and writes fail with
/// `Read-only file system`.
bool isAbsoluteDevicePath(String path) {
  final trimmed = path.trim();
  return trimmed.isNotEmpty && trimmed.startsWith('/');
}
