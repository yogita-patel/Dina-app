import 'dart:io';

import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/loginModel/login_model.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';

import '../../../network_manager/api_client.dart';

abstract class SigninSignupScreenRepository {
  Future<RegisterAccountModel>? getRegisterPageData(String wkToken);

  Future<LoginModel>? addCustomer(
    String wkToken,
    String customerGroupId,
    String firstname,
    String lastname,
    String email,
    String telephone,
    String password,
    String isSubscribe,
    String agree,
    String tobecomepartner,
    String shoppartner,
    String androidDeviceId,
    String company,
    String address_1,
    String address_2,
    String postcode,
    String city,
    String? zoneId,
    String? countryId,
      String? customFieldJson, String? sector
  );

  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken);

  Future<BaseModel>? forgotPassword(String wkToken, String email);
  Future<BaseModel>? checkEmail(String wkToken, String email);


}

class SigninSignupScreenRepositoryImp implements SigninSignupScreenRepository {
  @override
  Future<RegisterAccountModel>? getRegisterPageData(String wkToken) async {
    RegisterAccountModel model = await ApiClient().registerAccount(wkToken);
    return model;
  }

  @override
  Future<LoginModel>? addCustomer(
      String wkToken,
      String customerGroupId,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String password,
      String isSubscribe,
      String agree,
      String tobecomepartner,
      String shoppartner,
      String androidDeviceId,
      String company,
      String address_1,
      String address_2,
      String postcode,
      String city,
      String? zoneId,
      String? countryId,
      String? customFieldJson,
      String? sector,
      ) async {
    LoginModel model = await ApiClient().addCustomer(
        wkToken,
        customerGroupId,
        firstname,
        lastname,
        email,
        telephone,
        password,
        isSubscribe,
        agree,
        tobecomepartner,
        shoppartner,
        androidDeviceId,
       company,
       address_1,
       address_2,
       postcode,
       city,
       zoneId??"",
      countryId??"",
      customFieldJson??"",
        sector ?? ""
    );
    return model;
  }

  @override
  Future<LoginModel>? loginCustomer(
      String wkToken, String name, String password, String fcmToken) async {
    print('asddsaas---$fcmToken');
    LoginModel model =
        await ApiClient().loginCustomer(wkToken, name, password,  Platform.isAndroid? fcmToken: null,  Platform.isIOS ? fcmToken : null);
    return model;
  }

  @override
  Future<BaseModel>? forgotPassword(String wkToken, String email) async {
    BaseModel model = await ApiClient().forgotPassword(wkToken, email);
    return model;
  }

  @override
  Future<BaseModel>? checkEmail(String wkToken, String email) async {
    BaseModel model = await ApiClient().checkEmail(wkToken, email);
    return model;
  }


}
