import 'package:json_annotation/json_annotation.dart';

part 'checkout_confirm_order_model.g.dart';

@JsonSerializable()
class CheckoutConfirmOrderModel {
  @JsonKey(name: "order_id",defaultValue: 0)
  int? orderId;
  Success? success;
  @JsonKey(name: "shipping_address")
  ShippingAddress? shippingAddress;
  String? date;
  int? error;
  @JsonKey(name: "paypal_order_id")
  dynamic? paypalId;
  String? status;
  @JsonKey(name: "url")
  String? redirectUrl;
  @JsonKey(name: "success_url")
  String? successUrl;
  @JsonKey(name: "cancel")
  String? failureUrl;

  CheckoutConfirmOrderModel({this.success, this.error,this.orderId,this.shippingAddress,this.date,this.paypalId,this.status,this.redirectUrl,this.successUrl,this.failureUrl});

  factory CheckoutConfirmOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutConfirmOrderModelFromJson(json);


}
@JsonSerializable()
class Success {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_message")
  String? textMessage;
  @JsonKey(name: "button_continue")
  String? buttonContinue;
  Success({this.headingTitle, this.textMessage, this.buttonContinue});

  factory Success.fromJson(Map<String, dynamic> json) =>
      _$SuccessFromJson(json);

}
@JsonSerializable()
class ShippingAddress {
  @JsonKey(name: "address_id")
  String? addressId;
  @JsonKey(name: "firstname")
  String? firstname;
  @JsonKey(name: "lastname")
  String? lastname;
  @JsonKey(name: "company")
  String? company;
  @JsonKey(name: "address_1")
  String? address1;
  @JsonKey(name: "address_2")
  String? address2;
  @JsonKey(name: "postcode")
  String? postcode;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "zone_id")
  String? zoneId;
  @JsonKey(name: "zone")
  String? zone;
  @JsonKey(name: "zone_code")
  String? zoneCode;
  @JsonKey(name: "country_id")
  String? countryId;
  @JsonKey(name: "country")
  String? country;
  @JsonKey(name: "iso_code_2")
  String? isoCode2;
  @JsonKey(name: "iso_code_3")
  String? isoCode3;
  @JsonKey(name: "address_format")
  String? addressFormat;


  ShippingAddress(
      {this.addressId,
        this.firstname,
        this.lastname,
        this.company,
        this.address1,
        this.address2,
        this.postcode,
        this.city,
        this.zoneId,
        this.zone,
        this.zoneCode,
        this.countryId,
        this.country,
        this.isoCode2,
        this.isoCode3,
        this.addressFormat,
        });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);



}