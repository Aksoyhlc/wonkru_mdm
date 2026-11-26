class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const error = '/error';
  static const noAccess = '/no-access';
  static const profile = '/profile';

  static const dashboard = '/dashboard';
  static const devices = '/devices';
  static const policies = '/policies';
  static const applications = '/applications';
  static const certificates = '/certificates';
  static const files = '/files';
  static const fileGroups = '/file-groups';
  static const deviceGroups = '/device-groups';
  static const deviceLogs = '/device-logs';
  static const deviceSyncs = '/device-syncs';
  static const notifications = '/notifications';
  static const adminNotifications = '/admin-notifications';
  static const provisioningProfiles = '/provisioning-profiles';
  static const settings = '/settings';
  static const users = '/users';
  static const activity = '/activity';

  static const newSegment = 'new';

  static String device(int id) => '$devices/$id';

  static String deviceApps(int id) => '${device(id)}?tab=$deviceAppsTab';

  static const deviceAppsTab = 'apps';

  static String policy(int id) => '$policies/$id';

  static String get policyNew => '$policies/$newSegment';

  static String applicationVersions(int applicationId) => '$applications/$applicationId/versions';

  static String deviceSync(int id) => '$deviceSyncs/$id';

  static String provisioningProfile(int id) => '$provisioningProfiles/$id';

  static String get provisioningProfileNew => '$provisioningProfiles/$newSegment';
}
