enum LogLevel {
  verbose(0, 'VERBOSE'),
  debug(1, 'DEBUG'),
  info(2, 'INFO'),
  warning(3, 'WARNING'),
  error(4, 'ERROR'),
  fatal(5, 'FATAL');

  const LogLevel(this.value, this.label);

  final int value;

  final String label;

  static LogLevel fromValue(int value) =>
      LogLevel.values.firstWhere((l) => l.value == value, orElse: () => info);

  static LogLevel fromLabel(String label) => LogLevel.values.firstWhere(
        (l) => l.label.toLowerCase() == label.toLowerCase(),
        orElse: () => info,
      );
}