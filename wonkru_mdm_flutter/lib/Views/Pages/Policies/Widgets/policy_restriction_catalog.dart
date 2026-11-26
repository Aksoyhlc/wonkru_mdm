import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

/// Restriction group display order. The catalog only states each entry's group,
/// never an order, so the panel fixes it here.
const restrictionGroupOrder = <String>[
  'security',
  'network',
  'applications',
  'device',
  'user_and_account',
  'privacy_and_sharing',
  'system_and_ui',
];

const restrictionGroupLabels = <String, String>{
  'security': 'common.security',
  'network': 'policies.restriction_group.network',
  'applications': 'policies.restriction_group.applications',
  'device': 'common.device',
  'user_and_account': 'policies.restriction_group.user_and_account',
  'privacy_and_sharing': 'policies.restriction_group.privacy_and_sharing',
  'system_and_ui': 'policies.restriction_group.system_and_ui',
};

/// The one place the panel deviates from catalog order: the catalog sorts
/// alphabetically by `name`, but `no_config_cell_broadcasts` is shown last in
/// the `network` group. This order defines the `restriction_settings` payload
/// order, so it must be preserved.
const _groupTail = <String, List<String>>{
  'network': ['no_config_cell_broadcasts'],
};

List<RestrictionCatalogEntry> restrictionsInPanelOrder(
  List<RestrictionCatalogEntry> entries,
) {
  final byGroup = <String, List<RestrictionCatalogEntry>>{};
  for (final entry in entries) {
    byGroup
        .putIfAbsent(entry.group ?? '', () => <RestrictionCatalogEntry>[])
        .add(entry);
  }

  final ordered = <String>[
    for (final group in restrictionGroupOrder)
      if (byGroup.containsKey(group)) group,
    for (final group in byGroup.keys)
      if (!restrictionGroupOrder.contains(group)) group,
  ];

  final result = <RestrictionCatalogEntry>[];
  for (final group in ordered) {
    final items = List<RestrictionCatalogEntry>.of(byGroup[group]!);
    final tail = _groupTail[group];
    if (tail != null) {
      final moved = <RestrictionCatalogEntry>[];
      for (final key in tail) {
        final index = items.indexWhere((entry) => entry.key == key);
        if (index >= 0) moved.add(items.removeAt(index));
      }
      items.addAll(moved);
    }
    result.addAll(items);
  }

  return result;
}

List<String> restrictionKeysInPanelOrder(
  List<RestrictionCatalogEntry> entries,
) => [for (final entry in restrictionsInPanelOrder(entries)) entry.key];

/// Falls back to [cachedEntries] when [stateKeys] is empty so that a failed
/// initial catalog request cannot silently drop the user's restriction edits.
List<String> restrictionKeysForSave(
  List<String> stateKeys,
  List<RestrictionCatalogEntry> cachedEntries,
) => stateKeys.isNotEmpty
    ? stateKeys
    : restrictionKeysInPanelOrder(cachedEntries);

Future<List<String>> resolveRestrictionKeys(
  List<String> stateKeys, {
  required List<RestrictionCatalogEntry> Function() cached,
  required Future<List<RestrictionCatalogEntry>> Function() load,
}) async {
  var keys = restrictionKeysForSave(stateKeys, cached());
  if (keys.isEmpty) {
    try {
      keys = restrictionKeysForSave(stateKeys, await load());
    } catch (_) {
      // Catalog unreachable: return empty; the caller then leaves restrictions
      // untouched.
    }
  }
  return keys;
}

class RestrictionGroupView {
  const RestrictionGroupView({required this.label, required this.entries});

  final String label;
  final List<RestrictionCatalogEntry> entries;
}

List<RestrictionGroupView> restrictionGroupsInPanelOrder(
  List<RestrictionCatalogEntry> entries,
) {
  final groups = <RestrictionGroupView>[];
  String? currentGroup;
  var current = <RestrictionCatalogEntry>[];

  void flush() {
    final group = currentGroup;
    if (group == null) return;
    groups.add(
      RestrictionGroupView(
        label: restrictionGroupLabels[group] ?? group,
        entries: List<RestrictionCatalogEntry>.unmodifiable(current),
      ),
    );
  }

  for (final entry in restrictionsInPanelOrder(entries)) {
    final group = entry.group ?? '';
    if (group != currentGroup) {
      flush();
      currentGroup = group;
      current = <RestrictionCatalogEntry>[];
    }
    current.add(entry);
  }
  flush();

  return groups;
}
