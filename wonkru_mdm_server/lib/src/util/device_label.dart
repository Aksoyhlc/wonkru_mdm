import '../generated/protocol.dart';

/// The device name, or its code, or `#id` — for alert texts and short labels.
///
/// Three services used to carry an identical private copy; one function keeps
/// the fallback order from drifting.
String deviceShortLabel(Device device) {
  final name = device.name;
  if (name != null && name.isNotEmpty) {
    return name;
  }
  if (device.code.isNotEmpty) {
    return device.code;
  }
  return '#${device.id}';
}

/// `Name (CODE)`, or just the code/id when there is no name.
String deviceDetailedLabel(Device device) {
  final code = device.code.isEmpty ? '#${device.id}' : device.code;
  final name = device.name;
  return name == null || name.isEmpty ? code : '$name ($code)';
}
