// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return _Shop.fromJson(json);
}

/// @nodoc
mixin _$Shop {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_name')
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'verification_status')
  String? get verificationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopCopyWith<Shop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCopyWith<$Res> {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) then) =
      _$ShopCopyWithImpl<$Res, Shop>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      @JsonKey(name: 'shop_name') String name,
      String? description,
      @JsonKey(name: 'phone_number') String phoneNumber,
      String address,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'shop_image_url') String? imageUrl,
      @JsonKey(name: 'verification_status') String? verificationStatus,
      @JsonKey(name: 'isActive') bool isActive,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$ShopCopyWithImpl<$Res, $Val extends Shop>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = freezed,
    Object? phoneNumber = null,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? imageUrl = freezed,
    Object? verificationStatus = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ShopImplCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$$ShopImplCopyWith(
          _$ShopImpl value, $Res Function(_$ShopImpl) then) =
      __$$ShopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      @JsonKey(name: 'shop_name') String name,
      String? description,
      @JsonKey(name: 'phone_number') String phoneNumber,
      String address,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'shop_image_url') String? imageUrl,
      @JsonKey(name: 'verification_status') String? verificationStatus,
      @JsonKey(name: 'isActive') bool isActive,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$ShopImplCopyWithImpl<$Res>
    extends _$ShopCopyWithImpl<$Res, _$ShopImpl>
    implements _$$ShopImplCopyWith<$Res> {
  __$$ShopImplCopyWithImpl(_$ShopImpl _value, $Res Function(_$ShopImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = freezed,
    Object? phoneNumber = null,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? imageUrl = freezed,
    Object? verificationStatus = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ShopImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ShopImpl implements _Shop {
  const _$ShopImpl(
      {required this.id,
      required this.ownerId,
      @JsonKey(name: 'shop_name') required this.name,
      this.description,
      @JsonKey(name: 'phone_number') required this.phoneNumber,
      required this.address,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'shop_image_url') this.imageUrl,
      @JsonKey(name: 'verification_status') this.verificationStatus,
      @JsonKey(name: 'isActive') this.isActive = true,
      this.createdAt,
      this.updatedAt});

  factory _$ShopImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  @JsonKey(name: 'shop_name')
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @override
  final String address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'shop_image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'verification_status')
  final String? verificationStatus;
  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'Shop(id: $id, ownerId: $ownerId, name: $name, description: $description, phoneNumber: $phoneNumber, address: $address, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, verificationStatus: $verificationStatus, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
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
      ownerId,
      name,
      description,
      phoneNumber,
      address,
      latitude,
      longitude,
      imageUrl,
      verificationStatus,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      __$$ShopImplCopyWithImpl<_$ShopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopImplToJson(
      this,
    );
  }
}

abstract class _Shop implements Shop {
  const factory _Shop(
      {required final String id,
      required final String ownerId,
      @JsonKey(name: 'shop_name') required final String name,
      final String? description,
      @JsonKey(name: 'phone_number') required final String phoneNumber,
      required final String address,
      final double? latitude,
      final double? longitude,
      @JsonKey(name: 'shop_image_url') final String? imageUrl,
      @JsonKey(name: 'verification_status') final String? verificationStatus,
      @JsonKey(name: 'isActive') final bool isActive,
      final String? createdAt,
      final String? updatedAt}) = _$ShopImpl;

  factory _Shop.fromJson(Map<String, dynamic> json) = _$ShopImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  @JsonKey(name: 'shop_name')
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  String get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'shop_image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'verification_status')
  String? get verificationStatus;
  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
