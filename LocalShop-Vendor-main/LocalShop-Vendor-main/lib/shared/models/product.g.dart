// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      categoryId: json['categoryId'],
      name: json['product_name'] as String,
      description: json['description'] as String?,
      actualPrice: json['actual_price'],
      offerPrice: json['offer_price'],
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'categoryId': instance.categoryId,
      'product_name': instance.name,
      'description': instance.description,
      'actual_price': instance.actualPrice,
      'offer_price': instance.offerPrice,
      'stock_quantity': instance.stockQuantity,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
