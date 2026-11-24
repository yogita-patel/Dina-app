


import 'package:oc_demo/models/base_model.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../network_manager/api_client.dart';

abstract class NewsLetterScreenRepository {
  Future<BaseModel?> getNewsLetter();
  Future<BaseModel?> setNewsLetter(String newsLetter);
}

class NewsLetterScreenRepositoryImp implements NewsLetterScreenRepository {
  @override
  Future<BaseModel?> getNewsLetter() async{
   var model = await ApiClient().getNewsLetter(await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<BaseModel?> setNewsLetter(String newsLetter) async{
   var model = await ApiClient().subscribeNewsletter(await AppSharedPref.getWkToken(),newsLetter);
    return model;
  }

}


