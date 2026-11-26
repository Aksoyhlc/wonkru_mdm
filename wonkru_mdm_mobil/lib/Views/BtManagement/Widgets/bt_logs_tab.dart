import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';
import 'package:wonkrumdm/Core/Extensions/datetime.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Data/Models/Core/wlog_config.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_logs_list_dialog.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_section_card.dart';

class BtLogsTab extends StatefulWidget {
  const BtLogsTab({super.key});

  @override
  State<BtLogsTab> createState() => _BtLogsTabState();
}

class _BtLogsTabState extends State<BtLogsTab> with SingleTickerProviderStateMixin {
  late TabController _subTabController;
  late final TextEditingController _maxEntries;
  late final TextEditingController _flushThreshold;
  late final TextEditingController _idleFlush;
  late final TextEditingController _retentionDays;
  late final TextEditingController _endpoint;
  late final TextEditingController _authToken;
  late final TextEditingController _maxRetries;
  late final TextEditingController _tagFilter;
  late final TextEditingController _msgFilter;

  LogLevel _consoleLevel = LogLevel.info;
  LogLevel _dbLevel = LogLevel.info;
  LogLevel _remoteLevel = LogLevel.warning;
  LogLevel _listMinLevel = LogLevel.verbose;
  bool _remoteEnabled = false;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  static InputDecoration _denseField(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: WonkruText.body(14, color: Colors.white60),
      contentPadding: const EdgeInsets.only(bottom: 12),
    );
  }

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this);
    final base = WLogConfig.loadLocal() ?? WLog.config;
    _consoleLevel = base.consoleMinLevel;
    _dbLevel = base.dbMinLevel;
    _remoteLevel = base.remoteMinLevel;
    _remoteEnabled = base.remoteEnabled;
    _maxEntries = TextEditingController(text: '${base.maxLocalEntries}');
    _flushThreshold = TextEditingController(text: '${base.flushThreshold}');
    _idleFlush = TextEditingController(text: '${base.idleFlushSeconds}');
    _retentionDays = TextEditingController(text: '${base.retentionDays}');
    _endpoint = TextEditingController(text: base.remoteEndpoint);
    _authToken = TextEditingController(text: base.remoteAuthToken);
    _maxRetries = TextEditingController(text: '${base.remoteMaxRetries}');
    _tagFilter = TextEditingController();
    _msgFilter = TextEditingController();
  }

  @override
  void dispose() {
    _maxEntries.dispose();
    _flushThreshold.dispose();
    _idleFlush.dispose();
    _retentionDays.dispose();
    _endpoint.dispose();
    _authToken.dispose();
    _maxRetries.dispose();
    _tagFilter.dispose();
    _msgFilter.dispose();
    _subTabController.dispose();
    super.dispose();
  }

  WLogConfig _configFromFields() {
    return WLogConfig(
      consoleMinLevel: _consoleLevel,
      dbMinLevel: _dbLevel,
      remoteMinLevel: _remoteLevel,
      maxLocalEntries: int.tryParse(_maxEntries.text.trim()) ?? 1000,
      flushThreshold: int.tryParse(_flushThreshold.text.trim()) ?? 50,
      idleFlushSeconds: int.tryParse(_idleFlush.text.trim()) ?? 60,
      retentionDays: int.tryParse(_retentionDays.text.trim()) ?? 7,
      remoteEnabled: _remoteEnabled,
      remoteEndpoint: _endpoint.text.trim(),
      remoteAuthToken: _authToken.text.trim(),
      remoteMaxRetries: int.tryParse(_maxRetries.text.trim()) ?? 3,
    );
  }

  void _applyLogConfig() {
    final cfg = _configFromFields();
    WLogConfig.saveLocal(cfg);
    WLog.updateConfig(cfg);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L.bt_logs_config_applied)));
  }

  Widget _levelDropdownRow(String label, LogLevel value, void Function(LogLevel?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: WonkruText.body(11, color: Colors.white60)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<LogLevel>(
              isExpanded: true,
              value: value,
              dropdownColor: WonkruColors.surface,
              style: WonkruText.body(12, color: Colors.white),
              underline: Container(height: 1, color: Colors.white12),
              items: LogLevel.values
                  .map(
                    (l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.label, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _intField(String label, TextEditingController c, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboardType ?? TextInputType.number,
        style: WonkruText.mono(14, color: Colors.white),
        decoration: _denseField(label),
      ),
    );
  }

  Widget _buildLogSettingsBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _levelDropdownRow(L.bt_logs_console_level, _consoleLevel, (v) {
          if (v != null) setState(() => _consoleLevel = v);
        }),
        _levelDropdownRow(L.bt_logs_db_level, _dbLevel, (v) {
          if (v != null) setState(() => _dbLevel = v);
        }),
        _levelDropdownRow(L.bt_logs_remote_level, _remoteLevel, (v) {
          if (v != null) setState(() => _remoteLevel = v);
        }),
        _intField(L.bt_logs_max_entries, _maxEntries),
        _intField(L.bt_logs_flush_threshold, _flushThreshold),
        _intField(L.bt_logs_idle_seconds, _idleFlush),
        _intField(L.bt_logs_retention_days, _retentionDays),
        SwitchListTile(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          contentPadding: EdgeInsets.zero,
          title: Text(L.bt_logs_remote_enabled, style: WonkruText.body(14, color: Colors.white)),
          value: _remoteEnabled,
          activeThumbColor: WonkruColors.accent,
          onChanged: (v) => setState(() => _remoteEnabled = v),
        ),
        TextField(
          controller: _endpoint,
          style: WonkruText.mono(14, color: Colors.white),
          decoration: _denseField(L.bt_logs_endpoint),
        ),
        12.hh,
        TextField(
          controller: _authToken,
          obscureText: true,
          style: WonkruText.mono(14, color: Colors.white),
          decoration: _denseField(L.bt_logs_auth_token),
        ),
        12.hh,
        _intField(L.bt_logs_max_retries, _maxRetries),
        8.hh,
        CustomButton(label: L.bt_logs_apply_config, variant: ButtonVariant.primary, onTap: _applyLogConfig),
      ],
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final current = isStart ? _rangeStart : _rangeEnd;
    final initial = current ?? now;
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 1)),
      initialDate: DateTime(initial.year, initial.month, initial.day),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (t == null || !mounted) return;
    final picked = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    setState(() {
      if (isStart) {
        _rangeStart = picked;
        if (_rangeEnd != null && _rangeStart!.isAfter(_rangeEnd!)) {
          _rangeEnd = _rangeStart;
        }
      } else {
        _rangeEnd = picked;
        if (_rangeStart != null && _rangeEnd!.isBefore(_rangeStart!)) {
          _rangeStart = _rangeEnd;
        }
      }
    });
  }

  Widget _dateTimeRangeRow({
    required String label,
    required DateTime? value,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 76,
            child: Text(label, style: WonkruText.body(11, color: Colors.white60)),
          ),
          Expanded(
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
                child: Text(
                  value != null ? value.formatDateTime('dd.MM.yyyy HH:mm') : L.bt_logs_range_not_set,
                  style: WonkruText.mono(12, color: value != null ? Colors.white : Colors.white60),
                ),
              ),
            ),
          ),
          if (value != null)
            IconButton(
              icon: const Icon(Icons.clear_rounded, size: 18),
              color: Colors.white60,
              onPressed: onClear,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

  void _openLogListDialog() {
    BtLogsListDialog.show(
      minLevel: _listMinLevel,
      tagFilter: _tagFilter.text,
      msgFilter: _msgFilter.text,
      rangeStart: _rangeStart,
      rangeEnd: _rangeEnd,
    );
  }

  Future<void> _confirmDeleteAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WonkruColors.surface,
        title: Text(L.bt_logs_clear_all, style: WonkruText.body(16, color: Colors.white)),
        content: Text(L.bt_logs_confirm_clear_all, style: WonkruText.body(13, color: Colors.white60)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(L.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: WonkruColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(L.bt_logs_clear_all),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await WLog.deleteAllLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _subTabController,
            indicatorColor: WonkruColors.accent,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: WonkruText.body(13, color: Colors.white, weight: FontWeight.w600),
            unselectedLabelStyle: WonkruText.body(13, color: Colors.white60),
            tabs: [
              Tab(text: L.bt_logs_tab_settings),
              Tab(text: L.bt_logs_tab_filters),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _subTabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  child: BtSectionCard(
                    compact: true,
                    icon: Icons.tune_rounded,
                    title: L.bt_logs_settings_section,
                    child: _buildLogSettingsBody(),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  child: BtSectionCard(
                    compact: true,
                    icon: Icons.filter_list_rounded,
                    title: L.bt_logs_list_section,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _levelDropdownRow(L.bt_logs_min_level_filter, _listMinLevel, (v) {
                          if (v != null) setState(() => _listMinLevel = v);
                        }),
                        _dateTimeRangeRow(
                          label: L.bt_logs_range_start,
                          value: _rangeStart,
                          onPick: () => _pickDateTime(isStart: true),
                          onClear: () => setState(() => _rangeStart = null),
                        ),
                        _dateTimeRangeRow(
                          label: L.bt_logs_range_end,
                          value: _rangeEnd,
                          onPick: () => _pickDateTime(isStart: false),
                          onClear: () => setState(() => _rangeEnd = null),
                        ),
                        TextField(
                          controller: _tagFilter,
                          style: WonkruText.mono(12, color: Colors.white),
                          decoration: _denseField(L.bt_logs_tag_filter_hint),
                        ),
                        4.hh,
                        TextField(
                          controller: _msgFilter,
                          style: WonkruText.mono(12, color: Colors.white),
                          decoration: _denseField(L.bt_logs_message_filter_hint),
                        ),
                        8.hh,
                        CustomButton(
                          label: L.bt_logs_open_list_dialog,
                          variant: ButtonVariant.primary,
                          icon: Icons.open_in_full_rounded,
                          onTap: _openLogListDialog,
                        ),
                        8.hh,
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            CustomButton(
                              label: L.bt_logs_purge_synced,
                              variant: ButtonVariant.secondary,
                              onTap: () async {
                                await WLog.clear();
                              },
                            ),
                            CustomButton(
                              label: L.bt_logs_flush,
                              variant: ButtonVariant.secondary,
                              onTap: () async {
                                await WLog.flush(force: true);
                              },
                            ),
                            CustomButton(
                              label: L.bt_logs_clear_all,
                              variant: ButtonVariant.danger,
                              onTap: () {
                                _confirmDeleteAll();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}