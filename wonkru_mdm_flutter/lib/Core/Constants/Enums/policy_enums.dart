enum PolicyFieldType {
  text,
  number,
  textarea,
  toggle,
  select,
  timeZone,
  color,
  slider,
  tags,
  keyValue,

  /// Active time ranges as start/end clock pairs. The value is a JSON object
  /// `{"HH:mm":"HH:mm"}` keyed by start time.
  timeRanges,

  fileUpload,

  /// `path` must be `restriction_settings.<key>`.
  restrictionShortcut,

  /// Three-state int: `1` active, `0` inactive, `2` default (untouched on
  /// device); an empty value counts as default and is not persisted.
  triState,

  /// Three-state bool: `true` / `false` or empty (default, untouched); for
  /// fields the device reads as `bool?`.
  triStateBool,
}
