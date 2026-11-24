import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/models/catalog/sort.dart';

import '../../../hive/hive_constant.dart';
import '../product/product.dart';


part 'product_search_model.g.dart';
@JsonSerializable()
@HiveType(typeId: HiveConstant.FourtyFour)
class ProductSearchModel {
  @HiveField( HiveConstant.Two)
  @JsonKey(name: "byDefult_selected")
  String? byDefultSelected;
  @HiveField( HiveConstant.Three)
  @JsonKey(name:"heading_title")
  String? headingTitle;
  @JsonKey(name:"text_empty")
  @HiveField(4)
  String? textEmpty;
  @JsonKey(name:"text_quantity")
  @HiveField(5)
  String? textQuantity;
  @JsonKey(name:"text_manufacturer")
  @HiveField(6)
  String? textManufacturer;
  @JsonKey(name:"text_model")
  @HiveField(7)
  String? textModel;
  @JsonKey(name:"text_price")
  @HiveField(8)
  String? textPrice;
  @JsonKey(name:"text_tax")
  @HiveField(9)
  String? textTax;
  @JsonKey(name:"text_points")
  @HiveField(10)
  String? textPoints;

  @JsonKey(name:"text_compare")
  @HiveField(11)
  String? textCompare;
  @JsonKey(name:"text_sort")
  @HiveField(12)
  String? textSort;
  @JsonKey(name:"text_limit")
  @HiveField(13)
  String? textLimit;
  @JsonKey(name:"button_cart")
  @HiveField(14)
  String? buttonCart;
  @JsonKey(name:"button_wishlist")
  @HiveField(27)
  String? buttonWishlist;
  @JsonKey(name:"button_compare")
  @HiveField(15)
  String? buttonCompare;
  @JsonKey(name:"button_continue")
  @HiveField(16)
  String? buttonContinue;
  @JsonKey(name:"button_list")
  @HiveField(17)
  String? buttonList;
  @JsonKey(name:"button_grid")
  @HiveField(18)
  String? buttonGrid;
  @JsonKey(name:"products")
  @HiveField(19)
  List<Product>? products;
  @JsonKey(name:"sorts")
  @HiveField(20)
  List<Sort>? sorts;
  @JsonKey(name:"product_total")
  @HiveField(21)
  dynamic productTotal;
  @JsonKey(name: "filter_groups")
  List<FilterGroup>? filterGroups;


  ProductSearchModel(
      {this.headingTitle,
        this.textEmpty,
        this.textQuantity,
        this.textManufacturer,
        this.textModel,
        this.textPrice,
        this.textTax,
        this.textPoints,
        this.textCompare,
        this.textSort,
        this.textLimit,
        this.buttonCart,
        this.buttonWishlist,
        this.buttonCompare,
        this.buttonContinue,
        this.buttonList,
        this.buttonGrid,
        this.products,
        this.sorts,
        this.productTotal,
        this.byDefultSelected});

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSearchModelToJson(this);

}