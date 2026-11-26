import 'package:flutter/material.dart';

import 'package:wonkrumdm/Core/Constants/Enums/restriction.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Native/Bridges/restriction_bridge.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_restriction_tile.dart';

class BtRestrictionsTab extends StatefulWidget {
  const BtRestrictionsTab({super.key, required this.bridge});

  final RestrictionBridge bridge;

  @override
  State<BtRestrictionsTab> createState() => _BtRestrictionsTabState();
}

class _BtRestrictionsTabState extends State<BtRestrictionsTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _bulkLoading = false;
  int _refreshKey = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Restriction> get _filteredRestrictions {
    if (_searchQuery.trim().isEmpty) return Restriction.values;
    final q = _searchQuery.trim().toLowerCase();
    return Restriction.values.where((r) {
      final label = r.value
          .replaceAll('_', ' ')
          .replaceFirst('no ', '')
          .replaceFirst('disallow ', '')
          .toLowerCase();
      return label.contains(q) || r.value.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L.restrictions_temporary_hint,
                style: WonkruText.body(13, color: Colors.white60),
              ),
              10.hh,
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _bulkLoading
                        ? null
                        : () async {
                            setState(() => _bulkLoading = true);
                            try {
                              final map = {
                                for (final r in Restriction.values) r.value: false,
                              };
                              await widget.bridge.setBulk(map);
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _bulkLoading = false;
                                  _refreshKey++;
                                });
                              }
                            }
                          },
                    icon: Icon(
                      Icons.lock_open_rounded,
                      size: 18,
                      color: _bulkLoading ? Colors.white60 : WonkruColors.green,
                    ),
                    label: Text(L.bt_restrictions_open_all),
                    style: TextButton.styleFrom(foregroundColor: WonkruColors.green),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _bulkLoading
                        ? null
                        : () async {
                            setState(() => _bulkLoading = true);
                            try {
                              final map = {
                                for (final r in Restriction.values) r.value: true,
                              };
                              await widget.bridge.setBulk(map);
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _bulkLoading = false;
                                  _refreshKey++;
                                });
                              }
                            }
                          },
                    icon: Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: _bulkLoading ? Colors.white60 : WonkruColors.accent,
                    ),
                    label: Text(L.bt_restrictions_close_all),
                    style: TextButton.styleFrom(foregroundColor: WonkruColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: L.bt_restrictions_search_hint,
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  filled: true,
                  fillColor: WonkruColors.bg2.withValues(alpha: 0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filteredRestrictions.length,
            itemBuilder: (context, index) {
              final r = _filteredRestrictions[index];
              return BtRestrictionTile(
                key: ValueKey('${r.value}_$_refreshKey'),
                restriction: r,
                bridge: widget.bridge,
                onChanged: () => setState(() {}),
              );
            },
          ),
        ),
      ],
    );
  }
}