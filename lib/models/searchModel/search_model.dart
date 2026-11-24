import 'package:oc_demo/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel extends BaseModel {
  @JsonKey(name: "search_data")
  List<SearchData>? searchData;

  // Newly added: capture which unit is selected by default (e.g., "carton", "inner", "minipack")
  @JsonKey(name: "byDefult_selected")
  String? byDefultSelected;

  SearchModel({this.searchData, this.byDefultSelected});

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}

@JsonSerializable()
class SearchData {
  @JsonKey(name: "product_id")
  String? productId;
  String? name;
  String? thumb;
  @JsonKey(name: "product_code")
  String? productCode;

  // Additional fields returned by barcode API
  String? status;
  String? minipack;
  String? carton;
  String? inner;
  String? quantity;
  @JsonKey(name: "new_price")
  String? newPrice;
  @JsonKey(name: "discounts_new")
  dynamic discountsNew;
  @JsonKey(name: "status_id")
  dynamic statusId;

  SearchData({
    this.productId,
    this.name,
    this.thumb,
    this.productCode,
    this.status,
    this.minipack,
    this.carton,
    this.inner,
    this.quantity,
    this.newPrice,
    this.discountsNew,
    this.statusId,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);
}
