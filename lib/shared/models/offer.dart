import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    @Default('') String productId,
    required String title,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'discountPercentage') required dynamic discount,
    @JsonKey(name: 'start_time') required DateTime startDate,
    @JsonKey(name: 'end_time') required DateTime endDate,
    @Default(true) bool activeStatus,
  }) = _Offer;

  const Offer._();

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isActive => !isUpcoming && !isExpired && activeStatus;

  String get statusLabel {
    if (isExpired) return 'Expired';
    if (isUpcoming) return 'Upcoming';
    return activeStatus ? 'Active' : 'Paused';
  }
}
