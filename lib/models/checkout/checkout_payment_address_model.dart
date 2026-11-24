
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';


part 'checkout_payment_address_model.g.dart';

@JsonSerializable()
class CheckoutPaymentAddressModel {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "shipping_required")
  bool? shippingRequired;
  CheckoutAddressModel? paymentAddress;
  @JsonKey(name: "items")
  List<Items>? items;
  String? account;
  String? logged;
  dynamic cartCount;
  @JsonKey(name: "currency_code")
  String? currencyCode;
  @JsonKey(name: "cart_total")
  List<CartTotal>? cartTotal;

  CheckoutPaymentAddressModel(
      {this.headingTitle,
        this.shippingRequired,
        this.paymentAddress,
        this.account,
        this.logged,
        this.cartCount,
        this.currencyCode});


  factory CheckoutPaymentAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPaymentAddressModelFromJson(json);

}


@JsonSerializable()
class LoginData {
  @JsonKey(name: "customer_id")
  String? customerId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;

  LoginData(
      {this.customerId, this.firstname, this.lastname, this.email, this.phone});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

}

@JsonSerializable()
class Items {
  @JsonKey(name: "cart_id")
  String? cartId;

  @JsonKey(name: "product_id")
  String? productId;

  String? name;
  String? model;
  String? shipping;
  String? image;
  List<Option>? option;
  List<dynamic>? download;
  String? quantity;
  String? minimum;
  String? subtract;
  bool? stock;
  dynamic price;
  dynamic total;
  dynamic reward;
  dynamic points;

  @JsonKey(name: "tax_class_id")
  String? taxClassId;

  dynamic weight;

  @JsonKey(name: "weight_class_id")
  String? weightClassId;

  String? length;
  String? width;
  String? height;

  @JsonKey(name: "length_class_id")
  String? lengthClassId;

  dynamic recurring;

  @JsonKey(name: "unit_of_sale")
  dynamic unitOfSale;
  @JsonKey(name: "discounts")
  List<Discounts>? discounts;

  @JsonKey(name: "mini_pack")
  String? miniPack;
  @JsonKey(name: "carton")
  String? carton;
  @JsonKey(name: "inner")
  String? inner;
  @JsonKey(name: "total_quantity")
  String? totalQuantity;
  Items({
    this.cartId,
    this.productId,
    this.name,
    this.model,
    this.shipping,
    this.image,
    this.option,
    this.download,
    this.quantity,
    this.minimum,
    this.subtract,
    this.stock,
    this.price,
    this.total,
    this.reward,
    this.points,
    this.taxClassId,
    this.weight,
    this.weightClassId,
    this.length,
    this.width,
    this.height,
    this.lengthClassId,
    this.recurring,
    this.unitOfSale,
    this.inner,
    this.carton,
    this.miniPack,
    this.discounts,
    this.totalQuantity
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class Option {
  String? name;
  String? value;

  Option({this.name, this.value});
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
/* Option.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }*/

}

@JsonSerializable()
class CartTotal {
  @JsonKey(name: "subtitle")
  String? subtitle;

  @JsonKey(name: "title")
  String? title;

  String? text;

  CartTotal({
   this.subtitle,
    this.title,
    this.text
  });

  factory CartTotal.fromJson(Map<String, dynamic> json) => _$CartTotalFromJson(json);
  Map<String, dynamic> toJson() => _$CartTotalToJson(this);
}


@JsonSerializable()
class Discounts {
  @JsonKey(name: "quantity")
  String? quantity;

  @JsonKey(name: "price")
  String? price;

  Discounts({
    this.quantity,
    this.price,
  });

  factory Discounts.fromJson(Map<String, dynamic> json) => _$DiscountsFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountsToJson(this);
}


// @JsonSerializable()
// class Totals {
//   String? title;
//   String? text;
//
//   Totals({this.title, this.text});
//
//   factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);
// /* Totals.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     text = json['text'];
//   }*/
//
// }
