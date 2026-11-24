import 'package:json_annotation/json_annotation.dart';

part 'about_us_model.g.dart';

@JsonSerializable()
class AboutUsModel {
  int? error;
  List<PageModel>? pages;

  AboutUsModel({
    this.error,
    this.pages,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) =>
      _$AboutUsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutUsModelToJson(this);

}

@JsonSerializable()
class PageModel {
  String? group_id;
  String? main_group;
  String? image;
  String? category_id;
  String? information_id;
  String? sort_order;
  String? name;

  PageModel({
    this.group_id,
    this.main_group,
    this.image,
    this.category_id,
    this.information_id,
    this.sort_order,
    this.name,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);

}