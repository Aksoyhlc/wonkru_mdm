/// Each scope has its own key space and policy, so one IP's requests on one
/// surface do not consume another's budget.
enum RateLimitScope {
  deviceRegister,

  deviceConnect,

  deviceSync,

  deviceReport,

  deviceLog,

  deviceUploadFile,

  devicePasswordCheck,

  /// Per-device limits are not enough: N devices bound to one policy collect N
  /// times the attempts. Key is `policy:<id>`.
  devicePasswordCheckPolicy,

  authBootstrap,

  authLogin,

  webUpload,

  webDownload,

  webLocalCa,
}
