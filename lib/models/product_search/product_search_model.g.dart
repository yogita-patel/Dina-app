// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductSearchModelAdapter extends TypeAdapter<ProductSearchModel> {
  @override
  final int typeId = 44;

  @override
  ProductSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSearchModel(
      byDefultSelected: fields[2] as String?,
      headingTitle: fields[3] as String?,
      textEmpty: fields[4] as String?,
      textQuantity: fields[5] as String?,
      textManufacturer: fields[6] as String?,
      textModel: fields[7] as String?,
      textPrice: fields[8] as String?,
      textTax: fields[9] as String?,
      textPoints: fields[10] as String?,
      textCompare: fields[11] as String?,
      textSort: fields[12] as String?,
      textLimit: fields[13] as String?,
      buttonCart: fields[14] as String?,
      buttonWishlist: fields[27] as String?,
      buttonCompare: fields[15] as String?,
      buttonContinue: fields[16] as String?,
      buttonList: fields[17] as String?,
      buttonGrid: fields[18] as String?,
      products: (fields[19] as List?)?.cast<Product>(),
      sorts: (fields[20] as List?)?.cast<Sort>(),
      productTotal: fields[21] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ProductSearchModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(2)
      ..write(obj.byDefultSelected)
      ..writeByte(3)
      ..write(obj.headingTitle)
      ..writeByte(4)
      ..write(obj.textEmpty)
      ..writeByte(5)
      ..write(obj.textQuantity)
      ..writeByte(6)
      ..write(obj.textManufacturer)
      ..writeByte(7)
      ..write(obj.textModel)
      ..writeByte(8)
      ..write(obj.textPrice)
      ..writeByte(9)
      ..write(obj.textTax)
      ..writeByte(10)
      ..write(obj.textPoints)
      ..writeByte(11)
      ..write(obj.textCompare)
      ..writeByte(12)
      ..write(obj.textSort)
      ..writeByte(13)
      ..write(obj.textLimit)
      ..writeByte(14)
      ..write(obj.buttonCart)
      ..writeByte(27)
      ..write(obj.buttonWishlist)
      ..writeByte(15)
      ..write(obj.buttonCompare)
      ..writeByte(16)
      ..write(obj.buttonContinue)
      ..writeByte(17)
      ..write(obj.buttonList)
      ..writeByte(18)
      ..write(obj.buttonGrid)
      ..writeByte(19)
      ..write(obj.products)
      ..writeByte(20)
      ..write(obj.sorts)
      ..writeByte(21)
      ..write(obj.productTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchModel _$ProductSearchModelFromJson(Map<String, dynamic> json) =>
    ProductSearchModel(
      byDefultSelected: json['byDefult_selected'] as String?,
      headingTitle: json['heading_title'] as String?,
      textEmpty: json['text_empty'] as String?,
      textQuantity: json['text_quantity'] as String?,
      textManufacturer: json['text_manufacturer'] as String?,
      textModel: json['text_model'] as String?,
      textPrice: json['text_price'] as String?,
      textTax: json['text_tax'] as String?,
      textPoints: json['text_points'] as String?,
      textCompare: json['text_compare'] as String?,
      textSort: json['text_sort'] as String?,
      textLimit: json['text_limit'] as String?,
      buttonCart: json['button_cart'] as String?,
      buttonWishlist: json['button_wishlist'] as String?,
      buttonCompare: json['button_compare'] as String?,
      buttonContinue: json['button_continue'] as String?,
      buttonList: json['button_list'] as String?,
      buttonGrid: json['button_grid'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => Sort.fromJson(e as Map<String, dynamic>))
          .toList(),
      productTotal: json['product_total'],
    )..filterGroups = (json['filter_groups'] as List<dynamic>?)
        ?.map((e) => FilterGroup.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ProductSearchModelToJson(ProductSearchModel instance) =>
    <String, dynamic>{
      'byDefult_selected': instance.byDefultSelected,
      'heading_title': instance.headingTitle,
      'text_empty': instance.textEmpty,
      'text_quantity': instance.textQuantity,
      'text_manufacturer': instance.textManufacturer,
      'text_model': instance.textModel,
      'text_price': instance.textPrice,
      'text_tax': instance.textTax,
      'text_points': instance.textPoints,
      'text_compare': instance.textCompare,
      'text_sort': instance.textSort,
      'text_limit': instance.textLimit,
      'button_cart': instance.buttonCart,
      'button_wishlist': instance.buttonWishlist,
      'button_compare': instance.buttonCompare,
      'button_continue': instance.buttonContinue,
      'button_list': instance.buttonList,
      'button_grid': instance.buttonGrid,
      'products': instance.products,
      'sorts': instance.sorts,
      'product_total': instance.productTotal,
      'filter_groups': instance.filterGroups,
    };
