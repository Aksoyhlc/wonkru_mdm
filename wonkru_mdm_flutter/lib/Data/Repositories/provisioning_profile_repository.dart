import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class ProvisioningProfileRepository {
  const ProvisioningProfileRepository._();

  static Future<ProvisioningProfilePage> list(AdminListRequest request) =>
      serverpodClient.adminProvisioningProfile.list(request);

  static Future<ProvisioningProfile> get(int profileId) =>
      serverpodClient.adminProvisioningProfile.get(profileId);

  static Future<String> defaultConfig() =>
      serverpodClient.adminProvisioningProfile.defaultConfig();

  static Future<ProvisioningProfile> create(ProvisioningProfile profile) =>
      serverpodClient.adminProvisioningProfile.create(profile);

  static Future<ProvisioningProfile> update(ProvisioningProfile profile) =>
      serverpodClient.adminProvisioningProfile.update(profile);

  static Future<int> delete(List<int> profileIds) =>
      serverpodClient.adminProvisioningProfile.delete(profileIds);
}
