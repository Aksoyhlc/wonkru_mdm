import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppSection {
  const AppSection({
    required this.labelKey,
    required this.icon,
    required this.path,
  });

  final String labelKey;

  final IconData icon;

  /// Sidebar order and the route tree both derive from this list.
  final String path;

  String get label => labelKey.tr;
}

/// Order of the menu sections; indexes match the route-tree branch order.
const appSections = <AppSection>[
  AppSection(
    labelKey: 'common.nav_dashboard',
    icon: LucideIcons.layoutDashboard,
    path: '/dashboard',
  ),
  AppSection(
    labelKey: 'common.nav_devices',
    icon: LucideIcons.smartphone,
    path: '/devices',
  ),
  AppSection(
    labelKey: 'common.nav_policies',
    icon: LucideIcons.shieldCheck,
    path: '/policies',
  ),
  AppSection(
    labelKey: 'common.nav_applications',
    icon: LucideIcons.package,
    path: '/applications',
  ),
  AppSection(
    labelKey: 'common.nav_certificates',
    icon: LucideIcons.fileBadge,
    path: '/certificates',
  ),
  AppSection(
    labelKey: 'common.nav_files',
    icon: LucideIcons.files,
    path: '/files',
  ),
  AppSection(
    labelKey: 'common.nav_file_groups',
    icon: LucideIcons.folderTree,
    path: '/file-groups',
  ),
  AppSection(
    labelKey: 'common.nav_device_groups',
    icon: LucideIcons.folders,
    path: '/device-groups',
  ),
  AppSection(
    labelKey: 'common.nav_device_logs',
    icon: LucideIcons.scrollText,
    path: '/device-logs',
  ),
  AppSection(
    labelKey: 'common.nav_device_syncs',
    icon: LucideIcons.refreshCw,
    path: '/device-syncs',
  ),
  AppSection(
    labelKey: 'common.nav_notifications',
    icon: LucideIcons.bell,
    path: '/notifications',
  ),
  AppSection(
    labelKey: 'common.nav_admin_notifications',
    icon: LucideIcons.bellRing,
    path: '/admin-notifications',
  ),
  AppSection(
    labelKey: 'common.nav_provisioning_profiles',
    icon: LucideIcons.fileCog,
    path: '/provisioning-profiles',
  ),
  AppSection(
    labelKey: 'common.nav_settings',
    icon: LucideIcons.settings,
    path: '/settings',
  ),
  AppSection(
    labelKey: 'common.nav_users',
    icon: LucideIcons.users,
    path: '/users',
  ),
  AppSection(
    labelKey: 'common.nav_activity',
    icon: LucideIcons.history,
    path: '/activity',
  ),
];

int sectionIndexForLocation(String location) {
  for (var i = 0; i < appSections.length; i++) {
    final path = appSections[i].path;
    if (location == path || location.startsWith('$path/')) return i;
  }
  return 0;
}
