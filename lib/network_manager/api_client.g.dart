// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ApiClient implements ApiClient {
  _ApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    //baseUrl ??= 'https://www.dinainternational.co.uk/';
    baseUrl ??= 'https://www.dinainternational.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HomePageData> getHomePage(
    String lang,
    String currency,
    int deviceWidth,
    String wsKey,
    String header,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'mfactor': lang,
      'count': currency,
      'width': deviceWidth,
      'wk_token': wsKey,
      'etag': header,
    };
    final _options = _setStreamType<HomePageData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/homepage',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late HomePageData _value;
    try {
      _value = HomePageData.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ApiLoginResponseModel> apiLogin(
    String apiKey,
    String apiPassword,
    String customerId,
    String language,
    String currency,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'apiKey': apiKey,
      'apiPassword': apiPassword,
      'customer_id': customerId,
      'language': language,
      'currency': currency,
    };
    final _options = _setStreamType<ApiLoginResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/apiLogin',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ApiLoginResponseModel _value;
    try {
      _value = ApiLoginResponseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SubCategoryModel> getSubCategoryData(
    String width,
    String wkToken,
    String categoryId,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wkToken,
      'category_id': categoryId,
      'etag': eTag,
    };
    final _options = _setStreamType<SubCategoryModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getSubCategory',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SubCategoryModel _value;
    try {
      _value = SubCategoryModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> getCatalogProducts(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/productCategory',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> getCustomCollection(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'id': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/customCollection',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ProductDetailScreenModel> getProductDetail(
    String width,
    String productId,
    String profilePage,
    String wkToken,
    String count,
    String header,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'product_id': productId,
      'profile_page': profilePage,
      'wk_token': wkToken,
      'count': count,
      'etag': header,
    };
    final _options = _setStreamType<ProductDetailScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/getProduct',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProductDetailScreenModel _value;
    try {
      _value = ProductDetailScreenModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> writeReview(
    String name,
    String text,
    String rating,
    String productId,
    dynamic stringwkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'name': name,
      'text': text,
      'rating': rating,
      'product_id': productId,
      'wk_token': stringwkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/writeProductReview',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewData> getProductReviewList(
    String wkToken,
    String productId,
    String page,
    String limit,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'product_id': productId,
      'page': page,
      'limit': limit,
    };
    final _options = _setStreamType<ReviewData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/getReviews',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewData _value;
    try {
      _value = ReviewData.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> addToCart(
    String productId,
    String quantity,
    String option,
    String width,
    String wkToken,
    String UnitofSalenew,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'quantity': quantity,
      'option': option,
      'width': width,
      'wk_token': wkToken,
      'UnitofSalenew': UnitofSalenew,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/addToCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> moveToCart(
    String productId,
    String quantity,
    String width,
    String wkToken,
    String UnitofSalenew,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'quantity': quantity,
      'width': width,
      'wk_token': wkToken,
      'UnitofSalenew': UnitofSalenew,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/MoveToCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddProductToWishListModel> addProductToWishlist(
    String productId,
    String wkToken,
    String quantity,
    String UnitofSalenew,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'wk_token': wkToken,
      'quantity': quantity,
      'UnitofSalenew': UnitofSalenew,
    };
    final _options = _setStreamType<AddProductToWishListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/addToWishlist',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AddProductToWishListModel _value;
    try {
      _value = AddProductToWishListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<RegisterAccountModel> registerAccount(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<RegisterAccountModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/registerAccount',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RegisterAccountModel _value;
    try {
      _value = RegisterAccountModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<RegisterAccountModel> checkEmail(
    String wkToken,
    String email,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'email': email,
    };
    final _options = _setStreamType<RegisterAccountModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/checkEmail',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RegisterAccountModel _value;
    try {
      _value = RegisterAccountModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<LoginModel> addCustomer(
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
    String zoneId,
    String countryId,
    String customFieldJson,
    String sector,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'customer_group_id': customerGroupId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'password': password,
      'newsletter': isSubscribe,
      'agree': agree,
      'tobecomepartner': tobecomepartner,
      'shoppartner': shoppartner,
      'android_device_id': androidDeviceId,
      'company': company,
      'address_1': address_1,
      'address_2': address_2,
      'postcode': postcode,
      'city': city,
      'zone_id': zoneId,
      'country_id': countryId,
      'custom_field': customFieldJson,
      'sector': sector,
    };
    final _options = _setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addCustomer',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LoginModel _value;
    try {
      _value = LoginModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<LoginModel> loginCustomer(
    String wkToken,
    String username,
    String password,
    String? androidDeviceId,
    String? iosDeviceId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'username': username,
      'password': password,
      'android_device_id': androidDeviceId,
      'ios_device_id': iosDeviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/customerLogin',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LoginModel _value;
    try {
      _value = LoginModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> forgotPassword(
    String wkToken,
    String email,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'email': email,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/forgotPassword',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> logoutUser(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/customerLogout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> deleteUser(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/deleteaccount',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<AccountInfoModel> userDetail(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<AccountInfoModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/myAccount',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AccountInfoModel _value;
    try {
      _value = AccountInfoModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> editCustomer(
    String wkToken,
    String firstName,
    String lastname,
    String email,
    String telephone,
    String fax,
    String customFieldJson,
    String sector,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'firstname': firstName,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'fax': fax,
      'custom_field': customFieldJson,
      'sector': sector,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/editCustomer',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> editPassword(
    String wkToken,
    String oldPassword,
    String newPassword,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/editPassword',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CartModel> viewCart(
    String width,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CartModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/viewCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CartModel _value;
    try {
      _value = CartModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> removeFromCart(
    String key,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'key': key,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/removeFromCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> emptyCart(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/clearCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> updateCart(
    String quantity,
    String unitOfSale,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'quantity': quantity,
      'UnitofSalenew': unitOfSale,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/updateCart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> applyCoupon(
    String coupon,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'coupon': coupon,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/applyCoupon',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> applayVoucher(
    String voucher,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'voucher': voucher,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/applyVoucher',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> applyRewards(
    String coupon,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'reward': coupon,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/cart/applyPoints',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CountryDataModel> getCountryData(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<CountryDataModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '?route=api/wkrestapi/cart/getCountry',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CountryDataModel _value;
    try {
      _value = CountryDataModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CartShippingModel> getShipping(
    String wkToken,
    String zoneId,
    String countryId,
    String postcode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'zone_id': zoneId,
      'country_id': countryId,
      'postcode': postcode,
    };
    final _options = _setStreamType<CartShippingModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '?route=api/wkrestapi/cart/getShipping',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CartShippingModel _value;
    try {
      _value = CartShippingModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> applyShipping(
    String wkToken,
    String shippingMethod,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'shipping_method': shippingMethod,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '?route=api/wkrestapi/cart/applyShipping',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutPaymentAddressModel> getCheckoutPaymentAddress(
    String wkToken,
    String function,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'function': function,
    };
    final _options = _setStreamType<CheckoutPaymentAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutPaymentAddressModel _value;
    try {
      _value = CheckoutPaymentAddressModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutShippingAddressModel> getCheckoutShippingAddress(
    String function,
    String addressId,
    String paymentAddress,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': addressId,
      'payment_address': paymentAddress,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutShippingAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutShippingAddressModel _value;
    try {
      _value = CheckoutShippingAddressModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutShippingMethodModel> getCheckoutShippingMethods(
    String function,
    String addressId,
    String shippingAddress,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': addressId,
      'shipping_address': shippingAddress,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutShippingMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutShippingMethodModel _value;
    try {
      _value = CheckoutShippingMethodModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutPaymentMethodModel>
      getPaymentMethodsWhileShippingIsNotRequired(
    String function,
    String addressId,
    String paymentAddress,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': addressId,
      'payment_address': paymentAddress,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutPaymentMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutPaymentMethodModel _value;
    try {
      _value = CheckoutPaymentMethodModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutPaymentMethodModel> getCheckoutPaymentMethod(
    String function,
    String shippingMethod,
    String comment,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'shipping_method': shippingMethod,
      'comment': comment,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutPaymentMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutPaymentMethodModel _value;
    try {
      _value = CheckoutPaymentMethodModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutReviewOrderModel> reviewOrder(
    String width,
    String function,
    String paymentMethod,
    String agree,
    String comment,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'function': function,
      'payment_method': paymentMethod,
      'agree': agree,
      'comment': comment,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutReviewOrderModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutReviewOrderModel _value;
    try {
      _value = CheckoutReviewOrderModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutConfirmOrderModel> confirmOrder(
    String wkToken,
    String state,
    // String comment,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'state': state,
      //'comment': comment,
    };
    final _options = _setStreamType<CheckoutConfirmOrderModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/confirmOrder',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutConfirmOrderModel _value;
    try {
      _value = CheckoutConfirmOrderModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutGuestModel> guestCheckout(
    String state,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': state,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutGuestModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutGuestModel _value;
    try {
      _value = CheckoutGuestModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> guestOrdersAndReturnsData(
    String wkToken,
    String orderId,
    String orderProductId,
    String firstName,
    String lastName,
    String email,
    String telephone,
    String dateOrdered,
    String product,
    String model,
    String quantity,
    String returnReasonId,
    String opened,
    String comment,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'order_id': orderId,
      'product_id': orderProductId,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'telephone': telephone,
      'date_ordered': dateOrdered,
      'product': product,
      'model': model,
      'quantity': quantity,
      'return_reason_id': returnReasonId,
      'opened': opened,
      'comment': comment,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/returnGuestOrder',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<GuestOrderReturn> getGuestOrders(
    String wkToken,
    String orderId,
    String lastName,
    String email,
    String zip,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'order_id': orderId,
      'lastName': lastName,
      'email': email,
      'zip': zip,
    };
    final _options = _setStreamType<GuestOrderReturn>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/getGuestOrder',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GuestOrderReturn _value;
    try {
      _value = GuestOrderReturn.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewsListModel> getReviewsList(
    String wkToken,
    int pageNo,
    int limit,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'page': pageNo,
      'limit': limit,
    };
    final _options = _setStreamType<ReviewsListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getProductReviews',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewsListModel _value;
    try {
      _value = ReviewsListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutShippingAddressModel> guestShippingAddress(
    String state,
    String function,
    String email,
    String telephone,
    String fax,
    String firstname,
    String lastname,
    String company,
    String address_1,
    String address_2,
    String city,
    String postcode,
    String countryId,
    String zoneId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'shipping_address': state,
      'function': function,
      'email': email,
      'telephone': telephone,
      'fax': fax,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'postcode': postcode,
      'country_id': countryId,
      'zone_id': zoneId,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutShippingAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutShippingAddressModel _value;
    try {
      _value = CheckoutShippingAddressModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckoutShippingMethodModel> guestShippingMethod(
    String state,
    String function,
    String email,
    String telephone,
    String fax,
    String firstname,
    String lastname,
    String company,
    String address_1,
    String address_2,
    String city,
    String postcode,
    String countryId,
    String zoneId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'shipping_address': state,
      'function': function,
      'email': email,
      'telephone': telephone,
      'fax': fax,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'postcode': postcode,
      'country_id': countryId,
      'zone_id': zoneId,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<CheckoutShippingMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/checkout/checkout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckoutShippingMethodModel _value;
    try {
      _value = CheckoutShippingMethodModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<OrderDetailModel> getOrderDetails(
    String wkToken,
    String orderId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'order_id': orderId,
    };
    final _options = _setStreamType<OrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getOrderInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OrderDetailModel _value;
    try {
      _value = OrderDetailModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReturnOrderListModel> getReturnOrderList(
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'etag': eTag,
    };
    final _options = _setStreamType<ReturnOrderListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getReturns',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReturnOrderListModel _value;
    try {
      _value = ReturnOrderListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CmsDetailModel> getCmsPageDetail(
    String wkToken,
    String informationId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'information_id': informationId,
    };
    final _options = _setStreamType<CmsDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getInformationPage',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CmsDetailModel _value;
    try {
      _value = CmsDetailModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> updateCurrency(
    String wkToken,
    String code,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'code': code,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/currency',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> updateLanguage(
    String wkToken,
    String code,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'code': code,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/language',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<TransactionModel> getTransactionDetails(
    String wkToken,
    String page,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'page': page,
    };
    final _options = _setStreamType<TransactionModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getTransactionInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TransactionModel _value;
    try {
      _value = TransactionModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<RewardModel> getRewardPointsDetails(
    String wkToken,
    String page,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'page': page,
    };
    final _options = _setStreamType<RewardModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getRewardInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RewardModel _value;
    try {
      _value = RewardModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<DownloadProductModel> getDownloadableProducts(
    String wkToken,
    String limit,
    String page,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'limit': limit,
      'page': page,
    };
    final _options = _setStreamType<DownloadProductModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getDownloadInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DownloadProductModel _value;
    try {
      _value = DownloadProductModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetWishlist> getWishlist(
    String width,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wkToken,
      'etag': eTag,
    };
    final _options = _setStreamType<GetWishlist>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getWishlist',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetWishlist _value;
    try {
      _value = GetWishlist.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> removeFromWishlist(
    String productId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/removeFromWishlist',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<OrderListModel> getAllOrderList(
    String wkToken,
    String page,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'page': page,
      'etag': eTag,
    };
    final _options = _setStreamType<OrderListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getOrders',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OrderListModel _value;
    try {
      _value = OrderListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<PreviousOrderResponse> getPreviouslyOrderedProductsRepository(
    String wkToken,
    String page,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'page': page,
      'etag': eTag,
    };
    final _options = _setStreamType<PreviousOrderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getPreviousOrder',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PreviousOrderResponse _value;
    try {
      _value = PreviousOrderResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> subscribeNewsletter(
    String wkToken,
    String newsletter,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'newsletter': newsletter,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/setNewsletter',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> getNewsLetter(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getNewsletter',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetAddress> getAddressList(
    String token,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'etag': eTag,
    };
    final _options = _setStreamType<GetAddress>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getAddresses',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetAddress _value;
    try {
      _value = GetAddress.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> deleteAddress(
    String addressId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'address_id': addressId,
      'wk_token': token,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/deleteAddress',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<EditAddressBook> addAddressBook(
    String? addressId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'address_id': addressId,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<EditAddressBook>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getAddress',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late EditAddressBook _value;
    try {
      _value = EditAddressBook.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<OrderDetailModel> dashboarOrderInfo(
    String? orderId,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'order_id': orderId,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<OrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getOrderInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OrderDetailModel _value;
    try {
      _value = OrderDetailModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> reOrderProduct(
    String token,
    String? orderId,
    String orderProductId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': orderId,
      'order_product_id': orderProductId,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/reorder',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReturnOrderRequest> addReturnData(
    String token,
    String? orderId,
    String orderProductId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': orderId,
      'product_id': orderProductId,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<ReturnOrderRequest>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addReturnData',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReturnOrderRequest _value;
    try {
      _value = ReturnOrderRequest.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> addReturn(
    String token,
    String? orderId,
    String orderProductId,
    String? firstname,
    String? lastname,
    String? email,
    String? telephone,
    String? dateOrdered,
    String? product,
    String? model,
    String? quantity,
    String? returnReasonId,
    String? opened,
    String? comment,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': orderId,
      'product_id': orderProductId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'date_ordered': dateOrdered,
      'product': product,
      'model': model,
      'quantity': quantity,
      'return_reason_id': returnReasonId,
      'opened': opened,
      'comment': comment,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addReturn',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<LocationModel> getDboyLocation(
    String token,
    String? id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'id': id,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<LocationModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/deliveryboy/getTrackData',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late LocationModel _value;
    try {
      _value = LocationModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> loginWithQr(
    String? key,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'key': key,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=account/qrcode/mobiletoweb',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> addAddress(
    String customerId,
    String? addressId,
    String firstname,
    String lastname,
    String company,
    String address1,
    String address22,
    String city,
    String zoneId,
    String postcode,
    String countryId,
    String defaultValue,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'customer_id': customerId,
      'address_id': addressId,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address1,
      'address_2': address22,
      'city': city,
      'zone_id': zoneId,
      'postcode': postcode,
      'country_id': countryId,
      'default': defaultValue,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addAddress',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<GooglePlaceModel> getGooglePlace(String endPoint) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GooglePlaceModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'place/textsearch/json?query=${endPoint}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GooglePlaceModel _value;
    try {
      _value = GooglePlaceModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<NotificationScreenModel> getNotifications(
    String width,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wkToken,
      'etag': eTag,
    };
    final _options = _setStreamType<NotificationScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/viewNotifications',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late NotificationScreenModel _value;
    try {
      _value = NotificationScreenModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SearchModel> searchSuggestions(
    String? search,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'search': search,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<SearchModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/searchSuggest',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchModel _value;
    try {
      _value = SearchModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SearchModel> quickSearchSuggestions(
    String? search,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'search': search,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<SearchModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/quickSearch',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchModel _value;
    try {
      _value = SearchModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> popularProducts(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getPopularProducts',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> bestProducts(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getBestProducts',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> featured(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/featured',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> latestProduct(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/latestProduct',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ManufactureModel> manufactureInfo(
    String page,
    String limit,
    String width,
    String manufacturerId,
    String sort,
    String order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'manufacturer_id': manufacturerId,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<ManufactureModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/manufacturerInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ManufactureModel _value;
    try {
      _value = ManufactureModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> registerCustomerDeviceToken(
    String wkToken,
    String? androidDeviceId,
    String? iosDeviceId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'android_device_id': androidDeviceId,
      'ios_device_id': iosDeviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/registerDeviceToken',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReturnOrderDetailModel> getReturnDetails(
    String wkToken,
    String? returnId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'return_id': returnId,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<ReturnOrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getReturnInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReturnOrderDetailModel _value;
    try {
      _value = ReturnOrderDetailModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> toBecomeSeller(
    String wkToken,
    String shoppartner,
    String description,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'shoppartner': shoppartner,
      'description': description,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/becomeSeller',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<WalkThroughModel> getWalkThrough(
    String height,
    String width,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'height': height,
      'width': width,
    };
    final _options = _setStreamType<WalkThroughModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getWalkThrough',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late WalkThroughModel _value;
    try {
      _value = WalkThroughModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CatalogModel> getCarouselProducts(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'carousel_id': path,
      'sort': sort,
      'order': order,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getCarousels',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CatalogModel _value;
    try {
      _value = CatalogModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CarouselModel> getCarouselManufacture(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'carousel_id': path,
      'sort': sort,
      'order': order,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<CarouselModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getCarousels',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CarouselModel _value;
    try {
      _value = CarouselModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<CompareProduct> getCompareProducts(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<CompareProduct>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/productCompare',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CompareProduct _value;
    try {
      _value = CompareProduct.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> addCompareProduct(
    String? productId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/addToComparelist',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> removeCompareProduct(
    String? productId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'remove': productId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/removeProductCompare',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SplashScreenModel> getSplashScreen(
    String height,
    String width,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'height': height,
      'width': width,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<SplashScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getSplashScreen',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SplashScreenModel _value;
    try {
      _value = SplashScreenModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<AccountItemsListModel> getAccountItemsList(
    String customerId,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'customer_id': customerId,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<AccountItemsListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/getUserNavigationList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AccountItemsListModel _value;
    try {
      _value = AccountItemsListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> sendWishlistCollection(
    String email,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/shareWishlist',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SaveImageModel> uploadProfileImage(
    String customerId,
    String wkToken,
    File image,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'customer_id',
      customerId,
    ));
    _data.fields.add(MapEntry(
      'wk_token',
      wkToken,
    ));
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    ));
    final _options = _setStreamType<SaveImageModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addUserProfile',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SaveImageModel _value;
    try {
      _value = SaveImageModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SaveImageModel> uploadBannerImage(
    String customerId,
    String wkToken,
    File banner,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'customer_id',
      customerId,
    ));
    _data.fields.add(MapEntry(
      'wk_token',
      wkToken,
    ));
    _data.files.add(MapEntry(
      'banner',
      MultipartFile.fromFileSync(
        banner.path,
        filename: banner.path.split(Platform.pathSeparator).last,
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    ));
    final _options = _setStreamType<SaveImageModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/addUserProfile',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SaveImageModel _value;
    try {
      _value = SaveImageModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<AboutUsModel> getAboutData(String wkToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _options = _setStreamType<AboutUsModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/common/getAboutUsPages',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AboutUsModel _value;
    try {
      _value = AboutUsModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> contactUsForm(
    String wkToken,
    String name,
    String email,
    String enquiry,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'name': name,
      'email': email,
      'enquiry': enquiry,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/contectUs',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel> reactivateAccount(
    String wkToken,
    String name,
    String email,
    String subject,
    String message,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
    final _options = _setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/customer/reactivateSubmit',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel _value;
    try {
      _value = BaseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<ProductSearchModel> productSearch(
    String? page,
    String? limit,
    String? width,
    String? tag,
    String? sort,
    String? order,
    String? filter,
    String? wkToken,
    String? eTag,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'tag': tag,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<ProductSearchModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/productSearch',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProductSearchModel _value;
    try {
      _value = ProductSearchModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<SearchModel> barcodeSearch(
    String search,
    String wkToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'search': search,
      'wk_token': wkToken,
    };
    final _options = _setStreamType<SearchModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'index.php?route=api/wkrestapi/catalog/barcodeSearch',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchModel _value;
    try {
      _value = SearchModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
