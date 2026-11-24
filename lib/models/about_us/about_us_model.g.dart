// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutUsModel _$AboutUsModelFromJson(Map<String, dynamic> json) => AboutUsModel(
      error: (json['error'] as num?)?.toInt(),
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => PageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AboutUsModelToJson(AboutUsModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'pages': instance.pages,
    };

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel(
      group_id: json['group_id'] as String?,
      main_group: json['main_group'] as String?,
      image: json['image'] as String?,
      category_id: json['category_id'] as String?,
      information_id: json['information_id'] as String?,
      sort_order: json['sort_order'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'group_id': instance.group_id,
      'main_group': instance.main_group,
      'image': instance.image,
      'category_id': instance.category_id,
      'information_id': instance.information_id,
      'sort_order': instance.sort_order,
      'name': instance.name,
    };
