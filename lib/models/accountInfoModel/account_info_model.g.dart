// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoModel _$AccountInfoModelFromJson(Map<String, dynamic> json) =>
    AccountInfoModel(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      fax: json['fax'] as String?,
      status: (json['status'] as num?)?.toInt(),
      customField: (json['customField'] as List<dynamic>?)
          ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
          .toList(),
      sector: json['sector'] == null
          ? null
          : Sector.fromJson(json['sector'] as Map<String, dynamic>),
    )
      ..fault = (json['fault'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..error = (json['error'] as num?)?.toInt()
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$AccountInfoModelToJson(AccountInfoModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'telephone': instance.telephone,
      'fax': instance.fax,
      'status': instance.status,
      'customField': instance.customField,
      'sector': instance.sector,
    };

Sector _$SectorFromJson(Map<String, dynamic> json) => Sector(
      fieldname: json['fieldname'] as String?,
      type: json['type'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SectorOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedSector: (json['selected_sector'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SectorToJson(Sector instance) => <String, dynamic>{
      'fieldname': instance.fieldname,
      'type': instance.type,
      'options': instance.options,
      'selected_sector': instance.selectedSector,
    };

SectorOption _$SectorOptionFromJson(Map<String, dynamic> json) => SectorOption(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SectorOptionToJson(SectorOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
