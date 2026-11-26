/// One validated pagination window shared by the admin list endpoints.
///
/// The client sends unvalidated `page`/`perPage`; this clamps them once so every
/// endpoint does not repeat the same three lines. `maxPerPage` stays the single
/// source for the per-endpoint constant the integration tests read.
class PageParams {
  const PageParams._({required this.page, required this.perPage});

  /// Upper bound for a single list page.
  static const maxPerPage = 200;

  /// Upper bound for a CSV export query.
  static const maxExportRows = 50000;

  /// Clamps a client-supplied `page`/`perPage` pair to valid bounds.
  factory PageParams.from(int page, int perPage) => PageParams._(
    page: page < 1 ? 1 : page,
    perPage: perPage.clamp(1, maxPerPage),
  );

  final int page;
  final int perPage;

  int get offset => (page - 1) * perPage;

  /// Clamps a standalone limit (e.g. a "recent rows" cap) to [maxPerPage].
  static int clampSize(int value) => value.clamp(1, maxPerPage);
}
