class FileInfo {
  final String path;

  final String name;

  final String extension;

  final int size;

  final DateTime? modified;

  final DateTime? accessed;

  final DateTime? created;

  final bool isDirectory;

  final bool exists;

  FileInfo({
    required this.path,
    required this.name,
    required this.extension,
    required this.size,
    this.modified,
    this.accessed,
    this.created,
    required this.isDirectory,
    required this.exists,
  });

  String get readableSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    return '${(size / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }

  Map<String, dynamic> toJson() => {
    'path': path,
    'name': name,
    'extension': extension,
    'size': size,
    'modified': modified?.toUtc().toIso8601String(),
    'accessed': accessed?.toUtc().toIso8601String(),
    'created': created?.toUtc().toIso8601String(),
    'is_directory': isDirectory,
    'exists': exists,
  };
}
