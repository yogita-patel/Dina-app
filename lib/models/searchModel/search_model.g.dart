// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
      searchData: (json['search_data'] as List<dynamic>?)
          ?.map((e) => SearchData.fromJson(e as Map<String, dynamic>))
          .toList(),
      byDefultSelected: json['byDefult_selected'] as String?,
    )
      ..fault = (json['fault'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..error = (json['error'] as num?)?.toInt()
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'search_data': instance.searchData,
      'byDefult_selected': instance.byDefultSelected,
    };

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
      thumb: json['thumb'] as String?,
      productCode: json['product_code'] as String?,
      status: json['status'] as String?,
      minipack: json['minipack'] as String?,
      carton: json['carton'] as String?,
      inner: json['inner'] as String?,
      quantity: json['quantity'] as String?,
      newPrice: json['new_price'] as String?,
      discountsNew: json['discounts_new'],
      statusId: json['status_id'],
    );

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'thumb': instance.thumb,
      'product_code': instance.productCode,
      'status': instance.status,
      'minipack': instance.minipack,
      'carton': instance.carton,
      'inner': instance.inner,
      'quantity': instance.quantity,
      'new_price': instance.newPrice,
      'discounts_new': instance.discountsNew,
      'status_id': instance.statusId,
    };
