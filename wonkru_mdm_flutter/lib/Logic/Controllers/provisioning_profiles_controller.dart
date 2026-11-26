import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/provisioning_profile_repository.dart';
import 'Base/paged_table_controller.dart';

class ProvisioningProfilesController extends PagedTableController<ProvisioningProfile> {
  ProvisioningProfilesController() : super(pageSize: 25);

  @override
  Future<PagedResult<ProvisioningProfile>> fetch(ListQuery query) async {
    final page = await ProvisioningProfileRepository.list(
      query.toAdminListRequest(),
    );

    return PagedResult(items: page.items, total: page.total);
  }

  Future<void> deleteProfile(int profileId) => reloadAfter(() => ProvisioningProfileRepository.delete([profileId]));

  Future<ProvisioningProfile> getProfile(int profileId) => ProvisioningProfileRepository.get(profileId);

  Future<String> defaultConfig() => ProvisioningProfileRepository.defaultConfig();

  Future<ProvisioningProfile> saveProfile(ProvisioningProfile profile) => profile.id == null
      ? ProvisioningProfileRepository.create(profile)
      : ProvisioningProfileRepository.update(profile);
}
