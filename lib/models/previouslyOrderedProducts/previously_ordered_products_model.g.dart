// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previously_ordered_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviousOrderResponse _$PreviousOrderResponseFromJson(
        Map<String, dynamic> json) =>
    PreviousOrderResponse(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt(),
      limit: json['limit'] as String?,
      byDefultSelected: json['byDefult_selected'] as String?,
    )
      ..fault = (json['fault'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..error = (json['error'] as num?)?.toInt()
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$PreviousOrderResponseToJson(
        PreviousOrderResponse instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'products': instance.products,
      'page': instance.page,
      'limit': instance.limit,
      'byDefult_selected': instance.byDefultSelected,
    };

ProductOrder _$ProductOrderFromJson(Map<String, dynamic> json) => ProductOrder(
      product_id: json['product_id'] as String?,
      thumb: json['thumb'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'],
      special: json['special'],
      tax: json['tax'] as String?,
      minimum: json['minimum'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      location: json['location'] as String?,
      isbn: json['isbn'] as String?,
      mpn: json['mpn'] as String?,
      minipack: json['minipack'] as String?,
      stock_quantity: json['stock_quantity'] as String?,
      carton: json['carton'] as String?,
      inner: json['inner'] as String?,
      stock: json['stock'] as String?,
      stock_status: json['stock_status'] as String?,
      stock_class: json['stock_class'] as String?,
      discounts_new: (json['discounts_new'] as List<dynamic>?)
          ?.map((e) => DiscountNew.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock_status_id: json['stock_status_id'] as String?,
      new_price: json['new_price'],
      model: json['model'] as String?,
      stock_status_id_new: json['stock_status_id_new'],
      is_cart_added: json['is_cart_added'] as bool?,
      order_id: json['order_id'] as String?,
      customer_name: json['customer_name'] as String?,
      status: json['status'] as String?,
      date_added: json['date_added'] as String?,
      total: json['total'] as String?,
      view: json['view'] as String?,
    );

Map<String, dynamic> _$ProductOrderToJson(ProductOrder instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'thumb': instance.thumb,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'special': instance.special,
      'tax': instance.tax,
      'minimum': instance.minimum,
      'rating': instance.rating,
      'location': instance.location,
      'isbn': instance.isbn,
      'mpn': instance.mpn,
      'minipack': instance.minipack,
      'stock_quantity': instance.stock_quantity,
      'carton': instance.carton,
      'inner': instance.inner,
      'stock': instance.stock,
      'stock_status': instance.stock_status,
      'stock_class': instance.stock_class,
      'discounts_new': instance.discounts_new,
      'stock_status_id': instance.stock_status_id,
      'new_price': instance.new_price,
      'model': instance.model,
      'stock_status_id_new': instance.stock_status_id_new,
      'is_cart_added': instance.is_cart_added,
      'order_id': instance.order_id,
      'customer_name': instance.customer_name,
      'status': instance.status,
      'date_added': instance.date_added,
      'total': instance.total,
      'view': instance.view,
    };

DiscountNew _$DiscountNewFromJson(Map<String, dynamic> json) => DiscountNew(
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$DiscountNewToJson(DiscountNew instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
    };
