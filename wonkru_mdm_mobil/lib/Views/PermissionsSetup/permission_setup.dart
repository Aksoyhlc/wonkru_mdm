import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Extensions/context.dart';
import 'package:wonkrumdm/Core/Init/permission_initializer.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/keyguard_manager.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Views/BtManagement/bt_management_page.dart';
import 'package:wonkrumdm/Views/Widgets/full_screen_message.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';
import 'package:wonkrumdm/main.dart';

import '../../Core/Init/app_bootstrap.dart';

class PermissionsSetupPage extends StatefulWidget {
  const PermissionsSetupPage({super.key});

  @override
  State<PermissionsSetupPage> createState() => _PermissionsSetupPageState();
}

class _PermissionsSetupPageState extends State<PermissionsSetupPage> with WidgetsBindingObserver {
  Future<bool>? _deviceOwnerFuture;
  Future<CriticalPermissionsStatus>? _statusFuture;
  bool _isFinishing = false;
  String? _finishError;
  bool _openedSettingsForPermission = false;

  int? _autoPermissionIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
    AppBootstrap.permissionsInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _openedSettingsForPermission) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (!mounted) return;
        final status = await PermissionInitializer.instance.checkCriticalManualPermissions();
        if (!mounted) return;
        setState(() {
          _openedSettingsForPermission = false;
          _statusFuture = Future.value(status);
        });
        final idx = _autoPermissionIndex;
        if (idx != null && idx < _permissionItems.length && _permissionItems[idx].getGranted(status)) {
          final nextIdx = _nextNotGrantedIndex(status, idx);
          if (nextIdx == null) {
            setState(() => _autoPermissionIndex = null);
            return;
          }
          setState(() {
            _autoPermissionIndex = nextIdx;
            _openedSettingsForPermission = true;
          });
          _permissionItems[nextIdx].request();
        }
      });
    }
  }

  void _refreshStatus() {
    setState(() {
      _deviceOwnerFuture = KeyguardManager().isDeviceOwner;
      _statusFuture = PermissionInitializer.instance.checkCriticalManualPermissions();
    });
  }

  int? _firstNotGrantedIndex(CriticalPermissionsStatus status) {
    for (var i = 0; i < _permissionItems.length; i++) {
      if (!_permissionItems[i].getGranted(status)) return i;
    }
    return null;
  }

  int? _nextNotGrantedIndex(CriticalPermissionsStatus status, int afterIndex) {
    for (var i = afterIndex + 1; i < _permissionItems.length; i++) {
      if (!_permissionItems[i].getGranted(status)) return i;
    }
    return null;
  }

  void _startAutoPermission(CriticalPermissionsStatus status) {
    final i = _firstNotGrantedIndex(status);
    if (i == null) return;
    setState(() {
      _autoPermissionIndex = i;
      _openedSettingsForPermission = true;
    });
    _permissionItems[i].request();
  }

  Future<void> _onFinishSetup() async {
    if (_isFinishing) return;
    setState(() {
      _isFinishing = true;
      _finishError = null;
    });

    try {
      BasicStorage.instance.setInt(Sk.permissionsCompletedAt.name, DateTime.now().millisecondsSinceEpoch);

      context.toRemove(const ControlPage());
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFinishing = false;
          _finishError = L.setupFinishError(e.toString());
        });
        bottomMessage(_finishError!, type: MessageType.error);
      }
    }
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WonkruColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: WonkruColors.accentDim, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 24, color: WonkruColors.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: WonkruText.body(18, color: Colors.white, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  static final List<
    ({String key, String label, bool Function(CriticalPermissionsStatus s) getGranted, Future<void> Function() request})
  >
  _permissionItems = [
    (
      key: 'WRITE_SETTINGS',
      label: L.permission_write_settings,
      getGranted: (s) => s.hasWriteSettings,
      request: () async {
        await DisplayManager().requestWriteSettingsPermission();
      },
    ),
    (
      key: 'NOTIFICATION_POLICY',
      label: L.permission_notification_policy,
      getGranted: (s) => s.hasNotificationPolicy,
      request: () async {
        await AudioManager().requestNotificationPolicyAccess();
      },
    ),
    (
      key: 'MANAGE_STORAGE',
      label: L.permission_manage_storage,
      getGranted: (s) => s.hasManageStorage,
      request: () async {
        await requestStoragePermission();
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isFinishing) {
      return FullScreenMessage(title: L.setup_finishing, message: L.setup_finishing_message, isLoading: true);
    }

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
            L.permission_setup_title,
            style: WonkruText.body(18, color: Colors.white, weight: FontWeight.w600),
          ),
          actions: [
            if (BasicStorage.instance.getInt(Sk.installTime.name) != null)
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => context.to(const BtManagementPage()),
                tooltip: L.device_management_tooltip,
              ),
            IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _refreshStatus, tooltip: L.refresh_tooltip),
          ],
        ),
        body: FutureBuilder<bool>(
          future: _deviceOwnerFuture,
          builder: (context, doSnapshot) {
            if (doSnapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: WonkruColors.accent),
                    const SizedBox(height: 16),
                    Text(L.device_owner_checking, style: WonkruText.body(14, color: Colors.white60)),
                  ],
                ),
              );
            }

            final isDeviceOwner = doSnapshot.data ?? false;
            if (!isDeviceOwner) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildSectionCard(
                  icon: Icons.admin_panel_settings_rounded,
                  title: L.device_owner_required_title,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L.device_owner_required_message,
                        style: WonkruText.body(14, color: Colors.white60).copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _refreshStatus,
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: Text(L.refresh),
                          style: FilledButton.styleFrom(
                            backgroundColor: WonkruColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return FutureBuilder<CriticalPermissionsStatus>(
              future: _statusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: WonkruColors.accent),
                        const SizedBox(height: 16),
                        Text(L.permissions_checking, style: WonkruText.body(14, color: Colors.white60)),
                      ],
                    ),
                  );
                }

                final status = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 400),
                        child: _buildSectionCard(
                          icon: Icons.security_rounded,
                          title: L.manual_permissions,
                          child: Column(
                            children: [
                              Text(
                                L.manual_permissions_hint,
                                style: WonkruText.body(13, color: Colors.white60).copyWith(height: 1.4),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _firstNotGrantedIndex(status) == null
                                      ? null
                                      : () => _startAutoPermission(status),
                                  icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                                  label: Text(L.auto_permission),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: WonkruColors.accent,
                                    side: BorderSide(color: WonkruColors.accent),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._permissionItems.map((item) {
                                final granted = item.getGranted(status);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () async {
                                      _openedSettingsForPermission = true;
                                      await item.request();
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: granted ? WonkruColors.greenDim : Colors.white10,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            granted ? Icons.check_circle_rounded : Icons.pending_rounded,
                                            size: 22,
                                            color: granted ? WonkruColors.green : Colors.white60,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.label,
                                                  style: WonkruText.body(
                                                    14,
                                                    color: Colors.white,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  granted ? L.completed : L.missing_tap_go_settings,
                                                  style: WonkruText.body(
                                                    12,
                                                    color: granted ? WonkruColors.green : Colors.white60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!granted)
                                            Icon(Icons.open_in_new_rounded, size: 18, color: WonkruColors.accent),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      if (_finishError != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(_finishError!, style: WonkruText.body(13, color: WonkruColors.red)),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FadeInDown(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 80),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isFinishing ? null : _onFinishSetup,
                            style: FilledButton.styleFrom(
                              backgroundColor: WonkruColors.accent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(L.finish_setup),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
        ),
      ],
    );
  }
}