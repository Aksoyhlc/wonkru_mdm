class PolicyPivotOption {
  const PolicyPivotOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.isSystemApp,
    this.hasVersions,
  });

  final int id;
  final String label;
  final String? subtitle;

  final bool? isSystemApp;

  final bool? hasVersions;
}
