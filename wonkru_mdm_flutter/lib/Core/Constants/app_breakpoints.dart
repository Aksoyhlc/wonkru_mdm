class AppBreakpoints {
  const AppBreakpoints._();

  /// Below this the sidebar stops being persistent and collapses to a drawer.
  static const double compact = 1024;

  /// Below this the top-bar search field is hidden; search moves to the Devices page.
  static const double narrow = 640;

  static const double searchWidth = 240;
}
