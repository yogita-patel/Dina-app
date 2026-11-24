// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_payment_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutPaymentAddressModel _$CheckoutPaymentAddressModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutPaymentAddressModel(
      headingTitle: json['heading_title'] as String?,
      shippingRequired: json['shipping_required'] as bool?,
      paymentAddress: json['paymentAddress'] == null
          ? null
          : CheckoutAddressModel.fromJson(
              json['paymentAddress'] as Map<String, dynamic>),
      account: json['account'] as String?,
      logged: json['logged'] as String?,
      cartCount: json['cartCount'],
      currencyCode: json['currency_code'] as String?,
    )
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList()
      ..cartTotal = (json['cart_total'] as List<dynamic>?)
          ?.map((e) => CartTotal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CheckoutPaymentAddressModelToJson(
        CheckoutPaymentAddressModel instance) =>
    <String, dynamic>{
      'heading_title': instance.headingTitle,
      'shipping_required': instance.shippingRequired,
      'paymentAddress': instance.paymentAddress,
      'items': instance.items,
      'account': instance.account,
      'logged': instance.logged,
      'cartCount': instance.cartCount,
      'currency_code': instance.currencyCode,
      'cart_total': instance.cartTotal,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      customerId: json['customer_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'customer_id': instance.customerId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'phone': instance.phone,
    };

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      cartId: json['cart_id'] as String?,
      productId: json['product_id'] as String?,
      name: json['name'] as String?,
      model: json['model'] as String?,
      shipping: json['shipping'] as String?,
      image: json['image'] as String?,
      option: (json['option'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      download: json['download'] as List<dynamic>?,
      quantity: json['quantity'] as String?,
      minimum: json['minimum'] as String?,
      subtract: json['subtract'] as String?,
      stock: json['stock'] as bool?,
      price: json['price'],
      total: json['total'],
      reward: json['reward'],
      points: json['points'],
      taxClassId: json['tax_class_id'] as String?,
      weight: json['weight'],
      weightClassId: json['weight_class_id'] as String?,
      length: json['length'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      lengthClassId: json['length_class_id'] as String?,
      recurring: json['recurring'],
      unitOfSale: json['unit_of_sale'],
      inner: json['inner'] as String?,
      carton: json['carton'] as String?,
      miniPack: json['mini_pack'] as String?,
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((e) => Discounts.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuantity: json['total_quantity'] as String?,
    );

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'cart_id': instance.cartId,
      'product_id': instance.productId,
      'name': instance.name,
      'model': instance.model,
      'shipping': instance.shipping,
      'image': instance.image,
      'option': instance.option,
      'download': instance.download,
      'quantity': instance.quantity,
      'minimum': instance.minimum,
      'subtract': instance.subtract,
      'stock': instance.stock,
      'price': instance.price,
      'total': instance.total,
      'reward': instance.reward,
      'points': instance.points,
      'tax_class_id': instance.taxClassId,
      'weight': instance.weight,
      'weight_class_id': instance.weightClassId,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'length_class_id': instance.lengthClassId,
      'recurring': instance.recurring,
      'unit_of_sale': instance.unitOfSale,
      'discounts': instance.discounts,
      'mini_pack': instance.miniPack,
      'carton': instance.carton,
      'inner': instance.inner,
      'total_quantity': instance.totalQuantity,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

CartTotal _$CartTotalFromJson(Map<String, dynamic> json) => CartTotal(
      subtitle: json['subtitle'] as String?,
      title: json['title'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$CartTotalToJson(CartTotal instance) => <String, dynamic>{
      'subtitle': instance.subtitle,
      'title': instance.title,
      'text': instance.text,
    };

Discounts _$DiscountsFromJson(Map<String, dynamic> json) => Discounts(
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$DiscountsToJson(Discounts instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
    };
