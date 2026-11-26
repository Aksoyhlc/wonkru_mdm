extension NumExtension on num {
  String get readableBytes {
    final bytes = toDouble();
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes;
    var unit = 0;
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }
    final digits = unit >= 3 ? 1 : 0;
    return '${value.toStringAsFixed(digits)} ${units[unit]}';
  }
}
