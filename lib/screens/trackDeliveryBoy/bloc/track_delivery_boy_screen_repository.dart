import 'package:oc_demo/models/locationModel/location_model.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../network_manager/api_client.dart';

abstract class TrackDeliveryBoyRepository {
  Future<LocationModel?> getTrackDeliveryBoyData(String id);
}

class TrackDeliveryBoyRepositoryImp implements TrackDeliveryBoyRepository {
  @override
  Future<LocationModel?> getTrackDeliveryBoyData(String id) async {
    return await ApiClient().getDboyLocation(
      await AppSharedPref.getWkToken(),
      id,
    );
  }
}
