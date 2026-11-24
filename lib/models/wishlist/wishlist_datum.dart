import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

import '../../hive/hive_constant.dart';

part 'wishlist_datum.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.ThirtyFour)
class WishlistDatum extends BaseModel {
  @JsonKey(name:"product_id")
  @HiveField( HiveConstant.One)
  String? productId;
  @JsonKey(name:"is_ar")
  @HiveField( HiveConstant.Two)
  bool? isAr;
  @JsonKey(name:"thumb")
  @HiveField( HiveConstant.Three)
  String? thumb;
  @JsonKey(name:"dominant_color")
  @HiveField( HiveConstant.Four)
  String? dominantColor;

  @JsonKey(name:"name")
  @HiveField( HiveConstant.Five)
  String? name;

  @JsonKey(name:"model")
  @HiveField( HiveConstant.Six)
  String? model;
  @JsonKey(name:"stock")
  @HiveField( HiveConstant.Seven)
  String? stock;
  @JsonKey(name:"price")
  @HiveField( HiveConstant.Eight)
  String? price;
  @JsonKey(name:"quantity")
  @HiveField( HiveConstant.TwentyThree)
  String? quantity;
  @JsonKey(name:"formatted_special")
  @HiveField( HiveConstant.Nine)
  String? formattedSpecial;
  @JsonKey(name:"hasOption")
  @HiveField( HiveConstant.Ten)
  bool? hasOption;
  @JsonKey(name: "discounts")
  @HiveType(typeId: HiveConstant.TwentyTwo)
  List<Discounts>? discounts;
  dynamic UnitofSalenew;

  @JsonKey(name:"expected")
  @HiveField( HiveConstant.TwentySix)
  String? expected;
  WishlistDatum({
    this.productId,this.isAr, this.thumb, this.dominantColor,this.name,
    this.model, this.stock, this.price, this.formattedSpecial, this.hasOption,this.discounts,this.quantity, this.UnitofSalenew,
    this.expected
  });

  factory WishlistDatum.fromJson(Map<String, dynamic> json) =>
      _$WishlistDatumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WishlistDatumToJson(this);
}
@JsonSerializable()
class Discounts {
  @JsonKey(name: "quantity")
  @HiveField( HiveConstant.Two)
  String? quantity;

  @JsonKey(name: "price")
  @HiveField( HiveConstant.Three)
  String? price;

  Discounts({
    this.quantity,
    this.price,
  });

  factory Discounts.fromJson(Map<String, dynamic> json) => _$DiscountsFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountsToJson(this);
}
