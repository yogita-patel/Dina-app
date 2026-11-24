// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatalogModelAdapter extends TypeAdapter<CatalogModel> {
  @override
  final int typeId = 26;

  @override
  CatalogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatalogModel(
      categoryData: fields[1] as CategoryData?,
      moduleData: fields[2] as ModuleData?,
      productTotal: fields[4] as dynamic,
      byDefultSelected: fields[3] as String?,
      filterGroups: (fields[6] as List?)?.cast<FilterGroup>(),
      sorts: (fields[5] as List?)?.cast<Sort>(),
      title: fields[7] as String?,
    )
      ..eTag = fields[100] as String?
      ..fault = fields[201] as int?
      ..message = fields[202] as String?
      ..error = fields[203] as int?
      ..redirect = fields[204] as String?
      ..newsletter = fields[205] as dynamic
      ..cartTotal = fields[206] as dynamic;
  }

  @override
  void write(BinaryWriter writer, CatalogModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.categoryData)
      ..writeByte(2)
      ..write(obj.moduleData)
      ..writeByte(3)
      ..write(obj.byDefultSelected)
      ..writeByte(4)
      ..write(obj.productTotal)
      ..writeByte(5)
      ..write(obj.sorts)
      ..writeByte(6)
      ..write(obj.filterGroups)
      ..writeByte(201)
      ..write(obj.fault)
      ..writeByte(202)
      ..write(obj.message)
      ..writeByte(203)
      ..write(obj.error)
      ..writeByte(204)
      ..write(obj.redirect)
      ..writeByte(205)
      ..write(obj.newsletter)
      ..writeByte(206)
      ..write(obj.cartTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogModel _$CatalogModelFromJson(Map<String, dynamic> json) => CatalogModel(
      categoryData: json['categoryData'] == null
          ? null
          : CategoryData.fromJson(json['categoryData'] as Map<String, dynamic>),
      moduleData: json['moduleData'] == null
          ? null
          : ModuleData.fromJson(json['moduleData'] as Map<String, dynamic>),
      productTotal: json['product_total'],
      byDefultSelected: json['byDefult_selected'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      filterGroups: (json['filter_groups'] as List<dynamic>?)
          ?.map((e) => FilterGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
    )
      ..fault = (json['fault'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..error = (json['error'] as num?)?.toInt()
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..eTag = json['etag'] as String?;

Map<String, dynamic> _$CatalogModelToJson(CatalogModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'etag': instance.eTag,
      'title': instance.title,
      'categoryData': instance.categoryData,
      'moduleData': instance.moduleData,
      'byDefult_selected': instance.byDefultSelected,
      'products': instance.products,
      'product_total': instance.productTotal,
      'sorts': instance.sorts,
      'filter_groups': instance.filterGroups,
    };
