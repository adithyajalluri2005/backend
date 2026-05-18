import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';

@freezed
class Shop with _$Shop {
  const factory Shop({
    required String id,
    required String ownerId,
    @JsonKey(name: 'shop_name') required String name,
    String? description,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    required String address,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'shop_image_url') String? imageUrl,
    @JsonKey(name: 'verification_status') String? verificationStatus,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    String? createdAt,
    String? updatedAt,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}
