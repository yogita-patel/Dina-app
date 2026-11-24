// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_datum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistDatumAdapter extends TypeAdapter<WishlistDatum> {
  @override
  final int typeId = 34;

  @override
  WishlistDatum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistDatum(
      productId: fields[1] as String?,
      isAr: fields[2] as bool?,
      thumb: fields[3] as String?,
      dominantColor: fields[4] as String?,
      name: fields[5] as String?,
      model: fields[6] as String?,
      stock: fields[7] as String?,
      price: fields[8] as String?,
      formattedSpecial: fields[9] as String?,
      hasOption: fields[10] as bool?,
      quantity: fields[23] as String?,
      expected: fields[26] as String?,
    )
      ..fault = fields[201] as int?
      ..message = fields[202] as String?
      ..error = fields[203] as int?
      ..redirect = fields[204] as String?
      ..newsletter = fields[205] as dynamic
      ..cartTotal = fields[206] as dynamic;
  }

  @override
  void write(BinaryWriter writer, WishlistDatum obj) {
    writer
      ..writeByte(18)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.isAr)
      ..writeByte(3)
      ..write(obj.thumb)
      ..writeByte(4)
      ..write(obj.dominantColor)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.model)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(23)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.formattedSpecial)
      ..writeByte(10)
      ..write(obj.hasOption)
      ..writeByte(26)
      ..write(obj.expected)
      ..writeByte(201)
      ..write(obj.fault)
      ..writeByte(202)
      ..write(obj.message)
      ..writeByte(203)
      ..write(obj.error)
      ..writeByte(204)
      ..write(obj.redirect)
      ..writeByte(205)
      ..write(obj.newsletter)
      ..writeByte(206)
      ..write(obj.cartTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistDatumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistDatum _$WishlistDatumFromJson(Map<String, dynamic> json) =>
    WishlistDatum(
      productId: json['product_id'] as String?,
      isAr: json['is_ar'] as bool?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominant_color'] as String?,
      name: json['name'] as String?,
      model: json['model'] as String?,
      stock: json['stock'] as String?,
      price: json['price'] as String?,
      formattedSpecial: json['formatted_special'] as String?,
      hasOption: json['hasOption'] as bool?,
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((e) => Discounts.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as String?,
      UnitofSalenew: json['UnitofSalenew'],
      expected: json['expected'] as String?,
    )
      ..fault = (json['fault'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..error = (json['error'] as num?)?.toInt()
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$WishlistDatumToJson(WishlistDatum instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'product_id': instance.productId,
      'is_ar': instance.isAr,
      'thumb': instance.thumb,
      'dominant_color': instance.dominantColor,
      'name': instance.name,
      'model': instance.model,
      'stock': instance.stock,
      'price': instance.price,
      'quantity': instance.quantity,
      'formatted_special': instance.formattedSpecial,
      'hasOption': instance.hasOption,
      'discounts': instance.discounts,
      'UnitofSalenew': instance.UnitofSalenew,
      'expected': instance.expected,
    };

Discounts _$DiscountsFromJson(Map<String, dynamic> json) => Discounts(
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$DiscountsToJson(Discounts instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
    };
