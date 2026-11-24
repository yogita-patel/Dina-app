// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_confirm_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutConfirmOrderModel _$CheckoutConfirmOrderModelFromJson(
        Map<String, dynamic> json) =>
    CheckoutConfirmOrderModel(
      success: json['success'] == null
          ? null
          : Success.fromJson(json['success'] as Map<String, dynamic>),
      error: (json['error'] as num?)?.toInt(),
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      shippingAddress: json['shipping_address'] == null
          ? null
          : ShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>),
      date: json['date'] as String?,
      paypalId: json['paypal_order_id'],
      status: json['status'] as String?,
      redirectUrl: json['url'] as String?,
      successUrl: json['success_url'] as String?,
      failureUrl: json['cancel'] as String?,
    );

Map<String, dynamic> _$CheckoutConfirmOrderModelToJson(
        CheckoutConfirmOrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'success': instance.success,
      'shipping_address': instance.shippingAddress,
      'date': instance.date,
      'error': instance.error,
      'paypal_order_id': instance.paypalId,
      'status': instance.status,
      'url': instance.redirectUrl,
      'success_url': instance.successUrl,
      'cancel': instance.failureUrl,
    };

Success _$SuccessFromJson(Map<String, dynamic> json) => Success(
      headingTitle: json['heading_title'] as String?,
      textMessage: json['text_message'] as String?,
      buttonContinue: json['button_continue'] as String?,
    );

Map<String, dynamic> _$SuccessToJson(Success instance) => <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_message': instance.textMessage,
      'button_continue': instance.buttonContinue,
    };

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      addressId: json['address_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      company: json['company'] as String?,
      address1: json['address_1'] as String?,
      address2: json['address_2'] as String?,
      postcode: json['postcode'] as String?,
      city: json['city'] as String?,
      zoneId: json['zone_id'] as String?,
      zone: json['zone'] as String?,
      zoneCode: json['zone_code'] as String?,
      countryId: json['country_id'] as String?,
      country: json['country'] as String?,
      isoCode2: json['iso_code_2'] as String?,
      isoCode3: json['iso_code_3'] as String?,
      addressFormat: json['address_format'] as String?,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'address_id': instance.addressId,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'company': instance.company,
      'address_1': instance.address1,
      'address_2': instance.address2,
      'postcode': instance.postcode,
      'city': instance.city,
      'zone_id': instance.zoneId,
      'zone': instance.zone,
      'zone_code': instance.zoneCode,
      'country_id': instance.countryId,
      'country': instance.country,
      'iso_code_2': instance.isoCode2,
      'iso_code_3': instance.isoCode3,
      'address_format': instance.addressFormat,
    };
