import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/app_date_time.dart';
import 'device_log_service.dart';
import 'device_pdf_labels.dart';

/// Builds a downloadable PDF report for a single device: identity, last sync
/// state, installed applications and recent logs in one document. The report is
/// produced entirely server-side with the pure-Dart `pdf` package; only the
/// finished bytes reach the browser.
///
/// Labels come from the [DevicePdfLabels] catalog, the panel passing its active
/// locale through [DevicePdfLabels.forLocale]. The `pdf` package's default Type1
/// fonts (Helvetica) lack ş, ğ, ı, İ; Quicksand, which has the Turkish glyphs,
/// is embedded from `assets/fonts/`.
class DevicePdfReportService {
  const DevicePdfReportService._();

  static const appName = 'Wonkru MDM';

  static const maxApplications = 250;

  static const maxRecentLogs = 25;

  static const maxLogMessageChars = 160;

  /// A null or unknown [locale] selects the Turkish labels. Throws when the
  /// device does not exist.
  static Future<Uint8List> build(
    Session session,
    int deviceId, {
    String? locale,
  }) async {
    final labels = DevicePdfLabels.forLocale(locale);

    final device = await Device.db.findById(session, deviceId);
    if (device == null) {
      throw Exception('Device $deviceId does not exist.');
    }

    final state = await DeviceStateCache.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(deviceId),
    );

    final applications = await DeviceApplication.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      orderBy: (t) => t.appName,
    );

    final logs = await DeviceLog.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      orderByList: (t) => [t.loggedAt.desc(), t.id.desc()],
      limit: maxRecentLogs,
    );

    final regular = pw.Font.ttf(await _loadFont('Quicksand-Regular.ttf'));
    final bold = pw.Font.ttf(await _loadFont('Quicksand-Bold.ttf'));

    final document = pw.Document(
      title: '${labels['reportTitle']} - ${device.code}',
      author: appName,
      creator: appName,
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 26, 28, 26),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        header: (context) => _header(context, device, labels),
        footer: (context) => _footer(context, labels),
        // Sections are returned as a flat list: `MultiPage` can only split
        // top-level widgets (e.g. a long `Table`) across pages; a table wrapped
        // in a `Column` that outgrows the page makes `PdfTooBigPageException`
        // fail the whole report.
        build: (context) => [
          ..._identitySection(device, labels),
          ..._stateSection(device, state, labels),
          ..._applicationsSection(applications, labels),
          ..._logsSection(logs, labels),
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _header(
    pw.Context context,
    Device device,
    DevicePdfLabels labels,
  ) {
    if (context.pageNumber > 1) {
      return pw.SizedBox();
    }

    final title = device.name?.trim().isNotEmpty == true
        ? device.name!.trim()
        : device.code;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.8),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  appName,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey900,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${labels['reportTitle']} · $title (${device.code})',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            '${labels['produced']}: ${_formatDateTime(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer(pw.Context context, DevicePdfLabels labels) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        DevicePdfLabels.fill(labels['pageOf'], {
          'page': '${context.pageNumber}',
          'total': '${context.pagesCount}',
        }),
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      ),
    );
  }

  static List<pw.Widget> _identitySection(
    Device device,
    DevicePdfLabels labels,
  ) {
    return _section(labels['deviceIdentity'], [
      _kvTable([
        (labels['code'], device.code),
        (labels['name'], _orDash(device.name)),
        ('UUID', _orDash(device.uuid)),
        (labels['serialNo'], _orDash(device.serialNo)),
        (labels['manufacturer'], _orDash(device.manufacturer)),
        (labels['brand'], _orDash(device.brand)),
        (labels['model'], _orDash(device.model)),
        (labels['androidVersion'], _orDash(device.androidVersion)),
        ('SDK', _orDash(device.sdkVersion?.toString())),
        (
          labels['agentVersion'],
          _join([
            device.agentVersionName,
            device.agentVersionCode == null
                ? null
                : '(${device.agentVersionCode})',
          ]),
        ),
        (labels['firstSeen'], _formatDateTime(device.firstSeenAt)),
        (labels['lastSeen'], _formatDateTime(device.lastSeenAt)),
      ]),
    ]);
  }

  static List<pw.Widget> _stateSection(
    Device device,
    DeviceStateCache? state,
    DevicePdfLabels labels,
  ) {
    if (state == null) {
      return _section(labels['lastStatus'], [
        pw.Text(
          labels['noSyncData'],
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ]);
    }

    final totalStorage = state.totalStorageBytes ?? device.totalStorageBytes;
    final freeStorage = state.freeStorageBytes ?? device.freeStorageBytes;
    final usedStorage =
        state.usedStorageBytes ??
        (totalStorage != null && freeStorage != null
            ? totalStorage - freeStorage
            : null);
    final usagePct =
        state.storageUsagePct ??
        (totalStorage != null && totalStorage > 0 && usedStorage != null
            ? usedStorage / totalStorage * 100
            : null);

    return _section(labels['lastStatusSummary'], [
      _kvTable([
        (labels['lastSync'], _formatDateTime(state.collectedAt)),
        (labels['online'], _yesNo(state.isOnline, labels)),
        (labels['battery'], _battery(state, device)),
        (labels['networkSsid'], _orDash(state.currentSsid)),
        (labels['ipAddress'], _orDash(state.ipv4 ?? device.ipAddress)),
        (
          labels['storage'],
          '${_formatBytes(usedStorage)} / ${_formatBytes(totalStorage)}'
              '${usagePct == null ? '' : ' (%${usagePct.round()})'}',
        ),
        (
          labels['appCount'],
          _appCounts(state, labels),
        ),
        (labels['agentKiosk'], _agentState(state, device)),
      ]),
      pw.SizedBox(height: 8),
      _subTitle(labels['security']),
      _kvTable([
        ('Root', _yesNo(state.isRooted ?? device.isRooted, labels)),
        ('ADB', _yesNo(state.adbEnabled, labels)),
        (
          labels['developerOptions'],
          _yesNo(state.developerOptionsEnabled, labels),
        ),
        (
          labels['unknownSources'],
          _yesNo(state.unknownSourcesAllowed, labels),
        ),
        (labels['encryption'], _orDash(state.encryptionStatus)),
        (labels['secureLock'], _yesNo(state.hasSecureLock, labels)),
        ('Device Owner', _yesNo(state.isDeviceOwner, labels)),
        (
          labels['passwordSufficient'],
          _yesNo(state.passwordIsSufficient, labels),
        ),
        ('Play Protect', _yesNo(state.playProtectStatus, labels)),
      ]),
    ]);
  }

  static List<pw.Widget> _applicationsSection(
    List<DeviceApplication> applications,
    DevicePdfLabels labels,
  ) {
    final systemCount = applications.where((app) => app.isSystemApp).length;
    final userCount = applications.length - systemCount;
    final listed = applications.take(maxApplications).toList();
    final trimmed = applications.length > listed.length;

    final children = <pw.Widget>[
      pw.Text(
        DevicePdfLabels.fill(labels['appCountSummary'], {
          'total': '${applications.length}',
          'user': '$userCount',
          'system': '$systemCount',
        }),
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 6),
    ];

    if (listed.isEmpty) {
      children.add(
        pw.Text(
          labels['noApps'],
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      );
    } else {
      children.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(3.4),
            2: pw.FlexColumnWidth(1.4),
            3: pw.FlexColumnWidth(1.2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _headerCell(labels['app']),
                _headerCell(labels['package']),
                _headerCell(labels['version']),
                _headerCell(labels['type']),
              ],
            ),
            for (final app in listed)
              pw.TableRow(
                children: [
                  _bodyCell(_orDash(app.appName)),
                  _bodyCell(_orDash(app.packageName)),
                  _bodyCell(_orDash(app.versionName)),
                  _bodyCell(
                    app.isSystemApp ? labels['system'] : labels['user'],
                  ),
                ],
              ),
          ],
        ),
      );
    }

    if (trimmed) {
      children
        ..add(pw.SizedBox(height: 4))
        ..add(
          pw.Text(
            DevicePdfLabels.fill(labels['capNote'], {
              'count': '$maxApplications',
            }),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        );
    }

    return _section(labels['installedApps'], children);
  }

  static List<pw.Widget> _logsSection(
    List<DeviceLog> logs,
    DevicePdfLabels labels,
  ) {
    final counts = <int, int>{};
    for (final log in logs) {
      counts.update(log.level, (value) => value + 1, ifAbsent: () => 1);
    }

    final distribution = [
      for (var level = 0; level < DeviceLogService.levelLabels.length; level++)
        if (counts.containsKey(level))
          '${DeviceLogService.levelLabels[level]}: ${counts[level]}',
    ].join(' · ');

    final children = <pw.Widget>[
      pw.Text(
        logs.isEmpty
            ? labels['noLogs']
            : '${DevicePdfLabels.fill(labels['recentLogs'], {
                'count': '${logs.length}',
              })}${distribution.isEmpty ? '' : ' · $distribution'}',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
      ),
    ];

    if (logs.isNotEmpty) {
      children
        ..add(pw.SizedBox(height: 6))
        ..add(
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2.2),
              1: pw.FlexColumnWidth(1.2),
              2: pw.FlexColumnWidth(1.6),
              3: pw.FlexColumnWidth(5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _headerCell(labels['time']),
                  _headerCell(labels['level']),
                  _headerCell(labels['tag']),
                  _headerCell(labels['message']),
                ],
              ),
              for (final log in logs)
                pw.TableRow(
                  children: [
                    _bodyCell(_formatDateTime(log.loggedAt)),
                    _bodyCell(_levelLabel(log.level)),
                    _bodyCell(_orDash(log.tag)),
                    _bodyCell(_truncate(log.message, maxLogMessageChars)),
                  ],
                ),
            ],
          ),
        );
    }

    return _section(labels['logSummary'], children);
  }

  static List<pw.Widget> _section(String title, List<pw.Widget> children) {
    return [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey900,
        ),
      ),
      pw.SizedBox(height: 5),
      ...children,
      pw.SizedBox(height: 16),
    ];
  }

  static pw.Widget _subTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  static pw.Widget _kvTable(List<(String, String)> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.4),
        1: pw.FlexColumnWidth(3),
      },
      children: [
        for (final (label, value) in rows)
          pw.TableRow(
            children: [
              _labelCell(label),
              _bodyCell(value),
            ],
          ),
      ],
    );
  }

  static pw.Widget _labelCell(String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      color: PdfColors.grey100,
      child: pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  static pw.Widget _headerCell(String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  static pw.Widget _bodyCell(String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(
        value,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
      ),
    );
  }

  static String _battery(DeviceStateCache state, Device device) {
    final level = state.batteryLevel ?? device.batteryLevel;
    if (level == null) {
      return '-';
    }

    final status = state.batteryState;
    return status == null ? '%$level' : '%$level · $status';
  }

  static String _appCounts(DeviceStateCache state, DevicePdfLabels labels) {
    final total = state.totalInstalledApps;
    if (total == null) {
      return '-';
    }

    String count(String key, Object? value) =>
        DevicePdfLabels.fill(labels[key], {'count': '$value'});

    return [
      count('countTotal', total),
      if (state.userAppsCount != null) count('countUser', state.userAppsCount),
      if (state.systemAppsCount != null)
        count('countSystem', state.systemAppsCount),
      if (state.managedAppsCount != null)
        count('countManaged', state.managedAppsCount),
    ].join(' · ');
  }

  static String _agentState(DeviceStateCache state, Device device) {
    final flags = [
      if (state.launcherModeEnabled ?? device.isLauncherMode) 'Launcher',
      if (state.watchdogServiceEnabled == true) 'Watchdog',
    ];
    return flags.isEmpty ? '-' : flags.join(' · ');
  }

  static String _levelLabel(int level) {
    if (level < 0 || level >= DeviceLogService.levelLabels.length) {
      return '#$level';
    }

    return DeviceLogService.levelLabels[level];
  }

  static String _orDash(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? '-' : trimmed;
  }

  static String _join(List<String?> parts) {
    final kept = [
      for (final part in parts)
        if (part != null && part.trim().isNotEmpty) part.trim(),
    ];
    return kept.isEmpty ? '-' : kept.join(' ');
  }

  static String _truncate(String value, int max) {
    final trimmed = value.trim();
    if (trimmed.length <= max) {
      return trimmed;
    }

    return '${trimmed.substring(0, max)}…';
  }

  static String _formatDateTime(DateTime? moment) =>
      moment == null ? '-' : formatDateTime(moment);

  static String _formatBytes(int? bytes) {
    if (bytes == null || bytes <= 0) {
      return '-';
    }

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }

    final rounded = value >= 100 || unit == 0
        ? value.round().toString()
        : value.toStringAsFixed(1);

    return '$rounded ${units[unit]}';
  }

  static String _yesNo(bool? value, DevicePdfLabels labels) {
    if (value == null) {
      return '-';
    }

    return value ? labels['yes'] : labels['no'];
  }

  /// Loads the report font from `assets/fonts/`.
  ///
  /// Tries the package's real location first (tests may run from the workspace
  /// root, where `Directory.current` is unreliable), then falls back to working
  /// directory candidates.
  static Future<ByteData> _loadFont(String fileName) async {
    final candidates = <String>[];

    try {
      final resolved = await Isolate.resolvePackageUri(
        Uri.parse(
          'package:wonkru_mdm_server/src/service/device_pdf_report_service.dart',
        ),
      );
      if (resolved != null && resolved.isScheme('file')) {
        // .../lib/src/service/<file> -> package root.
        final packageRoot = p.dirname(
          p.dirname(p.dirname(p.dirname(resolved.toFilePath()))),
        );
        candidates.add(p.join(packageRoot, 'assets', 'fonts', fileName));
      }
    } on Object {
      // No package resolution; fall back to the working-directory candidates.
    }

    candidates
      ..add(p.join('assets', 'fonts', fileName))
      ..add(p.join('wonkru_mdm_server', 'assets', 'fonts', fileName))
      ..add(p.join('..', 'assets', 'fonts', fileName));

    for (final candidate in candidates) {
      final file = File(candidate);
      if (file.existsSync()) {
        return ByteData.sublistView(await file.readAsBytes());
      }
    }

    throw StateError(
      'PDF font asset "$fileName" not found. Looked in: '
      '${candidates.join(', ')}.',
    );
  }
}
