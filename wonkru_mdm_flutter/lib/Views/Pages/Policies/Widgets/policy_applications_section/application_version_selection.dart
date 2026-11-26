import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

/// Picks the version the application attachment should target: the active
/// default when present, otherwise the active version with the highest
/// versionCode, falling back to the whole list when nothing is active.
ApplicationVersion? selectDefaultApplicationVersion(
  List<ApplicationVersion> versions,
) {
  if (versions.isEmpty) return null;

  final active = [
    for (final version in versions)
      if (version.isActive) version,
  ];
  final pool = active.isEmpty ? versions : active;

  for (final version in pool) {
    if (version.isDefault) return version;
  }

  var best = pool.first;
  for (final version in pool) {
    if (version.versionCode > best.versionCode) best = version;
  }
  return best;
}
