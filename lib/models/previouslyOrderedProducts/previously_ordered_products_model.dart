import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

part 'previously_ordered_products_model.g.dart';

@JsonSerializable()
class PreviousOrderResponse  extends BaseModel {
 List<ProductOrder>? products;
 int? page;
 String? limit;
 @JsonKey(name: "byDefult_selected")
 String? byDefultSelected;
  PreviousOrderResponse({
     this.products,
     this.page,
     this.limit,
    this.byDefultSelected
  });

  factory PreviousOrderResponse.fromJson(Map<String, dynamic> json) => _$PreviousOrderResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PreviousOrderResponseToJson(this);
}

@JsonSerializable()
class ProductOrder {
  String? product_id;
  String? thumb;
  String? name;
  String? description;
  dynamic? price;
  dynamic? special;
  String? tax;
  String? minimum;
  int? rating;
  String? location;
  String? isbn;
  String? mpn;
  String? minipack;
  String? stock_quantity;
  String? carton;
  String? inner;
  String? stock;
  String? stock_status;
  String? stock_class;
  List<DiscountNew>? discounts_new;
  String? stock_status_id;
  dynamic? new_price;
  String? model;
  dynamic? stock_status_id_new;
  bool? is_cart_added;
  String? order_id;
  String? customer_name;
  String? status;
  String? date_added;
  String? total;
  String? view;

  ProductOrder({
     this.product_id,
     this.thumb,
     this.name,
     this.description,
     this.price,
     this.special,
     this.tax,
     this.minimum,
     this.rating,
     this.location,
     this.isbn,
     this.mpn,
     this.minipack,
     this.stock_quantity,
     this.carton,
     this.inner,
     this.stock,
     this.stock_status,
     this.stock_class,
     this.discounts_new,
     this.stock_status_id,
     this.new_price,
     this.model,
     this.stock_status_id_new,
     this.is_cart_added,
     this.order_id,
     this.customer_name,
    this.status,
     this.date_added,
     this.total,
     this.view,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) => _$ProductOrderFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);
}

@JsonSerializable()
class DiscountNew {
   String? quantity;
   String? price;

  DiscountNew({
     this.quantity,
     this.price,
  });

  factory DiscountNew.fromJson(Map<String, dynamic> json) => _$DiscountNewFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountNewToJson(this);
}
