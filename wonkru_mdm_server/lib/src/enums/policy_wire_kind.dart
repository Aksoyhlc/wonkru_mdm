/// The wire type a policy setting field takes on the way to a device.
enum PolicyWireKind {
  integer,

  number,

  boolean,

  /// Three-state integer: `0` inactive, `1` active, `2` default. Bool records
  /// become `1`/`0`; an unresolvable value drops from the key (a missing key
  /// means "don't touch" to the device).
  triStateInt,

  /// Three-state bool: `true`/`false` or absent (default, don't touch). `2` /
  /// `"2"` is also treated as default and dropped.
  triStateBool,

  text,

  color,

  stringList,
}
