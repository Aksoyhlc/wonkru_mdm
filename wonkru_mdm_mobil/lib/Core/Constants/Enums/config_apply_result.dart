enum ConfigApplyResult {
  applied,

  partial,

  /// Fetched but not active yet (passive, or outside its time window); stored,
  /// not applied.
  inactive,

  throttled,

  busy,

  fetchFailed,

  noPolicy,

  /// The policy could not be decoded; nothing stored, the last valid config is
  /// preserved.
  invalidPolicy,

  failed;

  /// `inactive` counts as success: the policy was fetched and stored, and
  /// applies once its window opens.
  bool get isSuccess =>
      this == applied || this == inactive || this == throttled;
}
