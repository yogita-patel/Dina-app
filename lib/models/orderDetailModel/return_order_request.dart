import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'return_order_request.g.dart';

@JsonSerializable()
class ReturnOrderRequest extends BaseModel {
  @override
  int? error;
  @JsonKey(name: "order_id")
  String? orderId;

  @JsonKey(name: "date_ordered")
  String? dateOrdered;
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  String? product;
  String? model;
  @JsonKey(name: "return_reasons")
  List<ReturnReasons>? returnReasons;
  String? captcha;
  //String? agree;
  @JsonKey(name: "agree")
  AgreeData? agree;

  ReturnOrderRequest(
      {this.error,
        this.orderId,
        this.dateOrdered,
        this.firstname,
        this.lastname,
        this.email,
        this.telephone,
        this.product,
        this.model,
        this.returnReasons,
        this.captcha,
        this.agree});

  factory ReturnOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReturnOrderRequestToJson(this);
}

@JsonSerializable()
class ReturnReasons {
  @JsonKey(name: "return_reason_id")
  String? returnReasonId;
  String? name;

  ReturnReasons({this.returnReasonId, this.name});

  factory ReturnReasons.fromJson(Map<String, dynamic> json) =>
      _$ReturnReasonsFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnReasonsToJson(this);
}

@JsonSerializable()
  class AgreeData {
  @JsonKey(name: "agree_data_text")
  String? text;
  Data? data;

  AgreeData({this.text, this.data});

  factory AgreeData.fromJson(Map<String, dynamic> json) =>
  _$AgreeDataFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeDataToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "description")
  String? description;
  String? meta_title;
  String? title;


  Data({this.description, this.meta_title,this.title});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
