import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Extensions/context.dart';
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Init/dependency_injection.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/config_manager.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_text.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_register.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';
import 'package:wonkrumdm/Data/Repositories/device_repository.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/UI/input_controller.dart';
import 'package:wonkrumdm/Views/Home/home_page.dart';
import 'package:wonkrumdm/Views/Install/Widgets/server_choice_screen.dart';
import 'package:wonkrumdm/Views/Install/Widgets/server_config_form_screen.dart';
import 'package:wonkrumdm/Views/PermissionsSetup/permission_setup.dart';
import 'package:wonkrumdm/Views/Widgets/full_screen_message.dart';
import 'package:wonkrumdm/main.dart';

const _tag = 'InstallPage';

class InstallPage extends StatefulWidget {
  const InstallPage({super.key});

  @override
  State<InstallPage> createState() => _InstallPageState();
}

class _InstallPageState extends State<InstallPage> {
  final _st = BasicStorage.instance;
  final _status = ActionStatus.idle.obs;
  final _statusMessage = "...".obs;
  String action = '';

  bool _showCustomServerForm = false;

  final _keyStore = EnrollmentKeyStore.instance;

  late final _enrollmentKeyController = TextEditingController(
    text: _keyStore.key ?? buildEnrollmentKey,
  );

  bool _keyRejected = false;

  bool get _needsEnrollmentKey =>
      _keyStore.isRejected ||
      (_keyStore.key == null && buildEnrollmentKey.isEmpty);

  void _saveEnteredKey([String? value]) {
    final entered = (value ?? _enrollmentKeyController.text).trim();
    if (entered.isNotEmpty) _keyStore.save(entered);
  }

  Future<void> _registerInBackground() async {
    _saveEnteredKey();
    _status.value = ActionStatus.loading;

    WLog.i(_tag, 'Starting device registration...');
    final provisionedCode = BasicStorage.instance.getString(
      Sk.device_code.name,
    );
    final (code, uuid, errorMessage) = await DeviceRegister().register(
      deviceCode: provisionedCode,
    );

    if (code == null || uuid == null) {
      WLog.w(_tag, 'Registration failed: ${errorMessage ?? "unknown"}');
      _keyRejected = _keyStore.isRejected;
      _status.value = ActionStatus.error;
      _statusMessage.value = errorMessage ?? L.register_failed;
      return;
    }

    WLog.i(_tag, 'Device registered, proceeding to permission and config flow');
    final permCompleted = BasicStorage.instance.getInt(
      Sk.permissionsCompletedAt.name,
    );

    if (permCompleted == null) {
      WLog.i(_tag, 'Permissions not complete, redirecting to permission page');
      action = "permissions";
      _status.value = ActionStatus.action;
      _statusMessage.value = L.permissions_not_complete_redirecting;
      return;
    }

    _statusMessage.value = L.device_registered_preparing;

    try {
      await AppBootstrap.firstInit();
      // The install flow calls fullSync() before servicesInit(); on an already
      // registered device (early return above) the client would not be set up
      // here and the first RPC would fail with a StateError.
      ServerpodGateway.instance.init();
      await AppBootstrap.permissionsInit();
      _statusMessage.value = L.permission_ops_done_syncing;
      await DeviceRepository().fullSync();
      _statusMessage.value = L.sync_done_applying_policies;
      await DeviceController.to.applyLatestConfig(forceUpdate: true);
      _statusMessage.value = L.policies_downloaded_applying;

      if (DeviceController.to.config.value.name == null) {
        WLog.w(_tag, 'Config received but device name is missing');
        _status.value = ActionStatus.error;
        _statusMessage.value = L.device_registered_config_failed_restart;
        return;
      }

      await ConfigManager().applyConfiguration(
        DeviceController.to.config.value,
      );

      _st.setInt(Sk.installTime.name, DateTime.now().millisecondsSinceEpoch);

      await AppBootstrap.servicesInit();

      action = "homePage";
      _statusMessage.value = L.all_operations_done_redirecting;
      _status.value = ActionStatus.action;
      WLog.i(_tag, 'Setup complete, redirecting to home page');
    } catch (e, st) {
      WLog.e(_tag, 'Setup error', error: e, stackTrace: st);
      _status.value = ActionStatus.error;
      _statusMessage.value =
          L.device_registered_other_failed_restart +
          '\n${L.errorWithMessage(e.toString())}';
    }
  }

  @override
  void initState() {
    super.initState();
    DependencyInjection.getOrCreate(() => InputController());
  }

  @override
  void dispose() {
    _enrollmentKeyController.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    if (_keyRejected) {
      setState(() => _showCustomServerForm = false);
      _status.value = ActionStatus.idle;
      return;
    }
    await _registerInBackground();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (_status.value == ActionStatus.idle) {
            if (_showCustomServerForm) {
              return ServerConfigFormScreen(
                onCancel: () => setState(() => _showCustomServerForm = false),
                initialEnrollmentKey: _enrollmentKeyController.text,
                onStartSetup: (serverUrl, enrollmentKey) async {
                  if (serverUrl.isEmpty) return;
                  BasicStorage.instance.setString(
                    Sk.server_url.name,
                    serverUrl,
                  );
                  _enrollmentKeyController.text = enrollmentKey;
                  await _registerInBackground();
                },
              );
            }
            return ServerChoiceScreen(
              onUseDefault: _registerInBackground,
              onEnterManual: () => setState(() => _showCustomServerForm = true),
              requireBootstrapCaServerInfo: true,
              enrollmentKeyController: _needsEnrollmentKey
                  ? _enrollmentKeyController
                  : null,
            );
          }
          if (_status.value == ActionStatus.loading) {
            return FullScreenMessage(
              title: L.please_wait,
              message: _statusMessage.value,
            );
          }
          if (_status.value == ActionStatus.action) {
            return FullScreenMessage(
              key: UniqueKey(),
              message: _statusMessage.value,
              type: MessageType.warning,
              onReady: () {
                if (action == 'permissions') {
                  context.toRemove(const PermissionsSetupPage());
                  return;
                }
                if (action == 'homePage') {
                  context.toRemove(const HomePage());
                  return;
                }
              },
            );
          }
          if (_status.value == ActionStatus.error) {
            return FullScreenMessage(
              title: L.an_error_occurred,
              message: _statusMessage.value,
              type: MessageType.error,
              buttonText: L.try_again,
              onTap: _retry,
              extras: [
                InkWell(
                  onTap: () {
                    context.toRemove(const ControlPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Text(
                      L.restart_install,
                      style: WonkruText.body(
                        14,
                        color: Colors.white70,
                        weight: FontWeight.w500,
                      ).copyWith(height: 1.2),
                    ),
                  ),
                ),
              ],
            );
          }
          if (_status.value == ActionStatus.success) {
            return FullScreenMessage(
              message: _statusMessage.value,
              onReady: () => context.toRemove(const HomePage()),
            );
          }
          return FullScreenMessage(
            message: _statusMessage.value,
            type: MessageType.success,
            onReady: () {},
          );
        }),
      ),
    );
  }
}
