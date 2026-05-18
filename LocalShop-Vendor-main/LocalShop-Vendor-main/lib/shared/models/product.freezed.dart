// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoryId')
  dynamic get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_price')
  dynamic get actualPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'offer_price')
  dynamic get offerPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  int? get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrl')
  dynamic get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String shopId,
      @JsonKey(name: 'categoryId') dynamic categoryId,
      @JsonKey(name: 'product_name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'actual_price') dynamic actualPrice,
      @JsonKey(name: 'offer_price') dynamic offerPrice,
      @JsonKey(name: 'stock_quantity') int? stockQuantity,
      @JsonKey(name: 'imageUrl') dynamic imageUrl,
      @JsonKey(name: 'isActive') bool isActive,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? categoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? actualPrice = freezed,
    Object? offerPrice = freezed,
    Object? stockQuantity = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      actualPrice: freezed == actualPrice
          ? _value.actualPrice
          : actualPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      offerPrice: freezed == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shopId,
      @JsonKey(name: 'categoryId') dynamic categoryId,
      @JsonKey(name: 'product_name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'actual_price') dynamic actualPrice,
      @JsonKey(name: 'offer_price') dynamic offerPrice,
      @JsonKey(name: 'stock_quantity') int? stockQuantity,
      @JsonKey(name: 'imageUrl') dynamic imageUrl,
      @JsonKey(name: 'isActive') bool isActive,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? categoryId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? actualPrice = freezed,
    Object? offerPrice = freezed,
    Object? stockQuantity = freezed,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      actualPrice: freezed == actualPrice
          ? _value.actualPrice
          : actualPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      offerPrice: freezed == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl extends _Product {
  const _$ProductImpl(
      {required this.id,
      required this.shopId,
      @JsonKey(name: 'categoryId') this.categoryId,
      @JsonKey(name: 'product_name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'actual_price') required this.actualPrice,
      @JsonKey(name: 'offer_price') this.offerPrice,
      @JsonKey(name: 'stock_quantity') this.stockQuantity,
      @JsonKey(name: 'imageUrl') this.imageUrl,
      @JsonKey(name: 'isActive') this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String shopId;
  @override
  @JsonKey(name: 'categoryId')
  final dynamic categoryId;
  @override
  @JsonKey(name: 'product_name')
  final String name;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'actual_price')
  final dynamic actualPrice;
  @override
  @JsonKey(name: 'offer_price')
  final dynamic offerPrice;
  @override
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @override
  @JsonKey(name: 'imageUrl')
  final dynamic imageUrl;
  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'Product(id: $id, shopId: $shopId, categoryId: $categoryId, name: $name, description: $description, actualPrice: $actualPrice, offerPrice: $offerPrice, stockQuantity: $stockQuantity, imageUrl: $imageUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            const DeepCollectionEquality()
                .equals(other.categoryId, categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.actualPrice, actualPrice) &&
            const DeepCollectionEquality()
                .equals(other.offerPrice, offerPrice) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      const DeepCollectionEquality().hash(categoryId),
      name,
      description,
      const DeepCollectionEquality().hash(actualPrice),
      const DeepCollectionEquality().hash(offerPrice),
      stockQuantity,
      const DeepCollectionEquality().hash(imageUrl),
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product extends Product {
  const factory _Product(
      {required final String id,
      required final String shopId,
      @JsonKey(name: 'categoryId') final dynamic categoryId,
      @JsonKey(name: 'product_name') required final String name,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'actual_price') required final dynamic actualPrice,
      @JsonKey(name: 'offer_price') final dynamic offerPrice,
      @JsonKey(name: 'stock_quantity') final int? stockQuantity,
      @JsonKey(name: 'imageUrl') final dynamic imageUrl,
      @JsonKey(name: 'isActive') final bool isActive,
      final String? createdAt,
      final String? updatedAt}) = _$ProductImpl;
  const _Product._() : super._();

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get shopId;
  @override
  @JsonKey(name: 'categoryId')
  dynamic get categoryId;
  @override
  @JsonKey(name: 'product_name')
  String get name;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'actual_price')
  dynamic get actualPrice;
  @override
  @JsonKey(name: 'offer_price')
  dynamic get offerPrice;
  @override
  @JsonKey(name: 'stock_quantity')
  int? get stockQuantity;
  @override
  @JsonKey(name: 'imageUrl')
  dynamic get imageUrl;
  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
