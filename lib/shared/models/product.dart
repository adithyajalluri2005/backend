import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String shopId,
    @JsonKey(name: 'categoryId') dynamic categoryId,
    @JsonKey(name: 'product_name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'actual_price') required dynamic actualPrice,
    @JsonKey(name: 'offer_price') dynamic offerPrice,
    @JsonKey(name: 'stock_quantity') int? stockQuantity,
    @JsonKey(name: 'imageUrl') dynamic imageUrl,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    String? createdAt,
    String? updatedAt,
  }) = _Product;

  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  double get price {
    if (actualPrice == null) return 0.0;
    if (actualPrice is num) return (actualPrice as num).toDouble();
    if (actualPrice is String) return double.tryParse(actualPrice) ?? 0.0;
    if (actualPrice is Map && actualPrice['value'] != null) {
      return (actualPrice['value'] as num).toDouble();
    }
    return 0.0;
  }

  double? get discountPrice {
    if (offerPrice == null) return null;
    if (offerPrice is num) return (offerPrice as num).toDouble();
    if (offerPrice is String) return double.tryParse(offerPrice);
    if (offerPrice is Map && offerPrice['value'] != null) {
      return (offerPrice['value'] as num).toDouble();
    }
    return null;
  }
  int get stock => stockQuantity ?? 0;

  bool get isOutOfStock => stock <= 0;

  int get discountPercent {
    final dPrice = discountPrice;
    if (dPrice == null || dPrice >= price || price == 0) {
      return 0;
    }
    return (((price - dPrice) / price) * 100).round();
  }
}
