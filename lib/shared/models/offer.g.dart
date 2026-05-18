// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      id: json['id'] as String,
      productId: json['productId'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      discount: json['discountPercentage'],
      startDate: DateTime.parse(json['start_time'] as String),
      endDate: DateTime.parse(json['end_time'] as String),
      activeStatus: json['activeStatus'] as bool? ?? true,
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'title': instance.title,
      'description': instance.description,
      'discountPercentage': instance.discount,
      'start_time': instance.startDate.toIso8601String(),
      'end_time': instance.endDate.toIso8601String(),
      'activeStatus': instance.activeStatus,
    };
