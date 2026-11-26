import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';
import 'package:wonkrumdm/Core/Extensions/datetime.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';

class BtLogsListDialog extends StatefulWidget {
  const BtLogsListDialog({
    super.key,
    required this.minLevel,
    required this.tagFilter,
    required this.msgFilter,
    this.rangeStart,
    this.rangeEnd,
  });

  final LogLevel minLevel;
  final String tagFilter;
  final String msgFilter;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  static void show({
    required LogLevel minLevel,
    required String tagFilter,
    required String msgFilter,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) {
    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: WonkruColors.bg,
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: BtLogsListDialog(
            minLevel: minLevel,
            tagFilter: tagFilter,
            msgFilter: msgFilter,
            rangeStart: rangeStart,
            rangeEnd: rangeEnd,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  State<BtLogsListDialog> createState() => _BtLogsListDialogState();
}

class _BtLogsListDialogState extends State<BtLogsListDialog> {
  List<LogEntry> _rawEntries = [];
  bool _loading = true;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await WLog.getRecent(minLevel: LogLevel.verbose, limit: 800);
    if (!mounted) return;
    setState(() {
      _rawEntries = list;
      _loading = false;
    });
  }

  bool _inDateTimeRange(LogEntry e) {
    if (widget.rangeStart == null && widget.rangeEnd == null) return true;
    final parsed = DateTime.tryParse(e.timestamp);
    if (parsed == null) return true;
    final local = parsed.toLocal();
    if (widget.rangeStart != null && local.isBefore(widget.rangeStart!)) return false;
    if (widget.rangeEnd != null && local.isAfter(widget.rangeEnd!)) return false;
    return true;
  }

  List<LogEntry> get _baseFiltered {
    final tagQ = widget.tagFilter.trim().toLowerCase();
    final msgQ = widget.msgFilter.trim().toLowerCase();
    final minV = widget.minLevel.value;
    return _rawEntries.where((e) {
      if (e.level < minV) return false;
      if (!_inDateTimeRange(e)) return false;
      if (tagQ.isNotEmpty && !e.tag.toLowerCase().contains(tagQ)) return false;
      if (msgQ.isNotEmpty && !e.message.toLowerCase().contains(msgQ)) return false;
      return true;
    }).toList();
  }

  String _searchHaystack(LogEntry e) {
    final lvl = LogLevel.fromValue(e.level);
    final parts = <String>[e.tag, lvl.label, e.message, _formatLogTime(e)];
    final st = e.stacktrace;
    if (st != null && st.isNotEmpty) parts.add(st);
    return parts.join(' ');
  }

  List<LogEntry> get _displayEntries {
    final base = _baseFiltered;
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((e) => _searchHaystack(e).toLowerCase().contains(q)).toList();
  }

  Color _levelColor(int level) {
    final l = LogLevel.fromValue(level);
    return switch (l) {
      LogLevel.verbose || LogLevel.debug => WonkruColors.grayLight,
      LogLevel.info => WonkruColors.green,
      LogLevel.warning => WonkruColors.orange,
      LogLevel.error || LogLevel.fatal => WonkruColors.red,
    };
  }

  String _formatLogTime(LogEntry e) {
    final parsed = DateTime.tryParse(e.timestamp);
    if (parsed == null) return e.timestamp.isEmpty ? '—' : e.timestamp;
    return parsed.toLocal().formatDateTime('dd.MM.yyyy HH:mm:ss');
  }

  Widget _logItem(LogEntry e) {
    final lvl = LogLevel.fromValue(e.level);
    final lc = _levelColor(e.level);
    final st = e.stacktrace;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '[${lvl.label}] ${e.tag}',
                  style: WonkruText.mono(11, color: lc).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatLogTime(e),
                style: WonkruText.mono(10, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            e.message,
            style: WonkruText.mono(11, color: Colors.white),
          ),
          if (st != null && st.isNotEmpty) ...[
            const SizedBox(height: 6),
            SelectableText(
              st,
              style: WonkruText.mono(10, color: Colors.white60),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WonkruColors.bg,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 46,
        backgroundColor: WonkruColors.bg,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          visualDensity: VisualDensity.compact,
          tooltip: L.close,
          onPressed: () => Get.back<void>(),
        ),
        title: Text(
          L.bt_connection_logs_title,
          style: WonkruText.body(15, color: Colors.white, weight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            visualDensity: VisualDensity.compact,
            tooltip: L.bt_logs_refresh,
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchController,
              style: WonkruText.mono(13, color: Colors.white),
              decoration: InputDecoration(
                hintText: L.bt_logs_search_hint,
                hintStyle: WonkruText.body(13, color: Colors.white60),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.white60),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20, color: Colors.white60),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: WonkruColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: WonkruColors.accent),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: Text(L.bt_loading, style: WonkruText.body(13, color: Colors.white60)))
                : _displayEntries.isEmpty
                    ? Center(
                        child: Text(
                          _emptyListMessage(),
                          textAlign: TextAlign.center,
                          style: WonkruText.body(13, color: Colors.white60),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        itemCount: _displayEntries.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white12),
                        itemBuilder: (context, i) => _logItem(_displayEntries[i]),
                      ),
          ),
        ],
      ),
    );
  }

  String _emptyListMessage() {
    if (_baseFiltered.isNotEmpty && _searchController.text.trim().isNotEmpty) {
      return L.bt_logs_no_search_results;
    }
    return L.bt_logs_empty;
  }
}