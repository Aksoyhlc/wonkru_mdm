enum AppDialogSize {
  /// Single-field and confirmation dialogs.
  sm(420),

  /// Standard forms.
  md(560),

  /// Multi-column forms, previews and JSON viewers.
  lg(760);

  const AppDialogSize(this.width);

  final double width;
}
