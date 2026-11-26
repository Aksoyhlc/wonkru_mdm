import 'package:get/get.dart';

import '../../Logic/Controllers/admin_activity_controller.dart';
import '../../Logic/Controllers/admin_notifications_controller.dart';
import '../../Logic/Controllers/applications_controller.dart';
import '../../Logic/Controllers/auth_controller.dart';
import '../../Logic/Controllers/certificates_controller.dart';
import '../../Logic/Controllers/dashboard_controller.dart';
import '../../Logic/Controllers/device_count_controller.dart';
import '../../Logic/Controllers/device_groups_controller.dart';
import '../../Logic/Controllers/device_logs_controller.dart';
import '../../Logic/Controllers/device_syncs_controller.dart';
import '../../Logic/Controllers/devices_controller.dart';
import '../../Logic/Controllers/file_groups_controller.dart';
import '../../Logic/Controllers/file_upload_controller.dart';
import '../../Logic/Controllers/files_controller.dart';
import '../../Logic/Controllers/locale_controller.dart';
import '../../Logic/Controllers/notifications_controller.dart';
import '../../Logic/Controllers/policies_controller.dart';
import '../../Logic/Controllers/profile_controller.dart';
import '../../Logic/Controllers/provisioning_profiles_controller.dart';
import '../../Logic/Controllers/settings_controller.dart';
import '../../Logic/Controllers/theme_controller.dart';
import '../../Logic/Controllers/users_controller.dart';
import '../../Logic/UI/app_toast_controller.dart';
import '../../Logic/UI/input_controller.dart';

class DependencyInjection {
  static Future<void> initCore() async {
    registerPermanent<AuthController>(() => AuthController());
    registerPermanent<ThemeController>(() => ThemeController());
    await Get.find<ThemeController>().loadPreferences();
    registerPermanent<LocaleController>(() => LocaleController());
    await Get.find<LocaleController>().loadPreferences();
    registerPermanent<InputController>(() => InputController());
    registerPermanent<AppToastController>(() => AppToastController());

    // The badge stays visible in the shell, so the list and badge share one instance.
    registerPermanent<AdminNotificationsController>(() => AdminNotificationsController());

    registerLazy<DashboardController>(() => DashboardController(), fenix: true);
    registerLazy<DevicesController>(() => DevicesController(), fenix: true);
    registerLazy<DeviceCountController>(() => DeviceCountController(), fenix: true);
    registerLazy<DeviceGroupsController>(() => DeviceGroupsController(), fenix: true);
    registerLazy<DeviceLogsController>(() => DeviceLogsController(), fenix: true);
    registerLazy<DeviceSyncsController>(() => DeviceSyncsController(), fenix: true);
    registerLazy<NotificationsController>(() => NotificationsController(), fenix: true);
    registerLazy<PoliciesController>(() => PoliciesController(), fenix: true);
    registerLazy<ApplicationsController>(() => ApplicationsController(), fenix: true);
    registerLazy<CertificatesController>(() => CertificatesController(), fenix: true);
    registerLazy<FilesController>(() => FilesController(), fenix: true);
    registerLazy<FileGroupsController>(() => FileGroupsController(), fenix: true);
    registerLazy<ProvisioningProfilesController>(() => ProvisioningProfilesController(), fenix: true);
    registerLazy<SettingsController>(() => SettingsController(), fenix: true);
    registerLazy<UsersController>(() => UsersController(), fenix: true);
    registerLazy<AdminActivityController>(() => AdminActivityController(), fenix: true);
    registerLazy<ProfileController>(() => ProfileController(), fenix: true);
    registerLazy<FileUploadController>(() => FileUploadController(), fenix: true);
  }

  static void registerLazy<T>(T Function() builder, {bool fenix = true}) {
    if (!Get.isRegistered<T>()) Get.lazyPut<T>(builder, fenix: fenix);
  }

  static void registerPermanent<T>(T Function() builder) {
    if (!Get.isRegistered<T>()) Get.put<T>(builder(), permanent: true);
  }
}
