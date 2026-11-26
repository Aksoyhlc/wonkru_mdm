import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/L10n/Language.dart';
import 'package:wonkrumdm/Core/Native/Bridges/restriction_bridge.dart';
import 'package:wonkrumdm/Core/Services/device_data_collector.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Core/Utils/network_address_helper.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_admin_password_tab.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_connection_tab.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_device_info_tab.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_diagnostics_tab.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_logs_tab.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_restrictions_tab.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';

import 'Widgets/bt_general_tab.dart';

class BtManagementPage extends StatefulWidget {
  const BtManagementPage({super.key});

  @override
  State<BtManagementPage> createState() => _BtManagementPageState();
}

class _BtManagementPageState extends State<BtManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>> _deviceInfoFuture;
  final _restrictionBridge = RestrictionBridge();
  final _st = StorageHelper();
  final _logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _deviceInfoFuture = _loadDeviceInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceMap = await DeviceDataCollector.getDeviceInfo();
    final version = deviceMap['version'];
    final versionMap = version is Map ? version as Map<String, dynamic> : null;

    final local = await NetworkAddressHelper.getLocalLanIPv4();
    final pub = await NetworkAddressHelper.getPublicIPv4();
    return {
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'installerStore': packageInfo.installerStore,
      'manufacturer': deviceMap['manufacturer'],
      'model': deviceMap['model'],
      'brand': deviceMap['brand'],
      'device': deviceMap['device'],
      'androidRelease': versionMap?['release']?.toString(),
      'sdkInt': versionMap?['sdkInt'],
      'securityPatch': versionMap?['securityPatch']?.toString(),
      'ipLocal': local ?? (await NetworkInfo().getWifiIP()) ?? '—',
      'ipPublic': pub ?? '—',
      'deviceName': DeviceIdentityHelper.getCode(),
      'deviceUuid': DeviceIdentityHelper.getUuid(),
      'lastSync': DateTime.fromMillisecondsSinceEpoch(_st.getInt(Sk.lastSync.name) ?? 0).toString(),
      'lastPolicyUpdate': DateTime.fromMillisecondsSinceEpoch(_st.getInt(Sk.lastPolicyUpdate.name) ?? 0).toString(),
      'lastPolicyVersion': _st.getInt(Sk.lastPolicyVersion.name),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: WonkruBackdrop()),
        SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: Text(
            L.device_management,
            style: WonkruText.body(18, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.2),
          ),
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language_rounded, size: 24),
              tooltip: L.language,
              onSelected: (locale) {
                BasicStorage.instance.setString(Sk.locale.name, AppTranslations.storageKeyFor(locale));
                Get.updateLocale(locale);
                setState(() {});
              },
              itemBuilder: (context) {
                final code = Get.locale?.languageCode ?? 'en';
                return [
                  PopupMenuItem(
                    value: AppTranslations.tr,
                    child: Row(
                      children: [
                        if (code == 'tr') const Icon(Icons.check_rounded, size: 20, color: WonkruColors.accent),
                        if (code == 'tr') const SizedBox(width: 8),
                        Text(L.language_turkish),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: AppTranslations.en,
                    child: Row(
                      children: [
                        if (code == 'en') const Icon(Icons.check_rounded, size: 20, color: WonkruColors.accent),
                        if (code == 'en') const SizedBox(width: 8),
                        Text(L.language_english),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                indicatorColor: WonkruColors.accent,
                indicatorWeight: 2,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: WonkruText.body(13, color: Colors.white, weight: FontWeight.w600),
                unselectedLabelStyle: WonkruText.body(13, color: Colors.white60),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(icon: Icon(Icons.lock_outline_rounded, size: 20), text: L.tab_launcher_mode_policy),
                  Tab(icon: Icon(Icons.block_rounded, size: 20), text: L.tab_restrictions),
                  Tab(icon: Icon(Icons.info_outline_rounded, size: 20), text: L.tab_info),
                  Tab(icon: Icon(Icons.wifi_tethering_rounded, size: 20), text: L.tab_connection),
                  Tab(icon: Icon(Icons.health_and_safety_outlined, size: 20), text: L.tab_diagnostics),
                  Tab(icon: Icon(Icons.terminal_rounded, size: 20), text: L.tab_logs),
                  Tab(icon: Icon(Icons.password_rounded, size: 20), text: L.tab_admin_password),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BtGeneralTab(onRefresh: () => setState(() {})),
            BtRestrictionsTab(bridge: _restrictionBridge),
            BtDeviceInfoTab(deviceInfoFuture: _deviceInfoFuture, onRefresh: () => setState(() {})),
            BtConnectionTab(logScrollController: _logScrollController),
            const BtDiagnosticsTab(),
            const BtLogsTab(),
            const BtAdminPasswordTab(),
          ],
        ),
      ),
        ),
      ],
    );
  }
}