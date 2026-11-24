import 'dart:io';

import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../models/accountInfoModel/account_info_model.dart';
import '../../../models/loginModel/login_model.dart';

abstract class AccountInfoRepository {
  Future<AccountInfoModel> getAccountAccountInfo(String wkToken);
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken);
  Future<BaseModel> editCustomer(
      String wkToken,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String fax,
      bool changePassword,
      String? password,
      String? customFieldJson,
      String? sector);
  Future<BaseModel>? deleteAccount();
}

class AccountInfoRepositoryImp implements AccountInfoRepository {
  @override
  Future<AccountInfoModel> getAccountAccountInfo(String wkToken) async {
    var model = await ApiClient().userDetail(wkToken);
    return model;
  }

  @override
  Future<BaseModel> editCustomer(
      String wkToken,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String fax,
      bool changePassword,
      String? password,
      String? customFieldJson,
      String? sector) async {
    var model = await ApiClient()
        .editCustomer(wkToken, firstname, lastname, email, telephone, fax, customFieldJson ?? "", sector ?? "");
    return model;
  }

  Future<BaseModel> editPassword(
      String? oldPassword,
      String? newPassword,
      ) async {
    BaseModel? baseModel;
    baseModel = await ApiClient().editPassword(await AppSharedPref.getWkToken(), oldPassword ?? "", newPassword ?? "");
    return baseModel;
  }

  @override
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken) async {
    LoginModel model =
    await ApiClient().loginCustomer(wkToken, name, password,  Platform.isAndroid? fcmToken: null,  Platform.isIOS ? fcmToken : null);
    // Platform.isAndroid ? value! : null,
    //         Platform.isIOS ? value! : null,
    return model;
  }
  @override
  Future<BaseModel>? deleteAccount() async {
    BaseModel model =
    await ApiClient().deleteUser(await AppSharedPref.getWkToken());
    return model;
  }
}
