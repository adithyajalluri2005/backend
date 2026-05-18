class VendorProfile {
  const VendorProfile({
    required this.shopName,
    required this.address,
    required this.category,
    required this.deliveryRadius,
    required this.contactNumber,
    required this.shopBanner,
    required this.openingHours,
  });

  final String shopName;
  final String address;
  final String category;
  final String deliveryRadius;
  final String contactNumber;
  final String shopBanner;
  final String openingHours;

  factory VendorProfile.fromJson(Map<String, dynamic> json) {
    return VendorProfile(
      shopName: json['shopName'] as String,
      address: json['address'] as String,
      category: json['category'] as String,
      deliveryRadius: json['deliveryRadius'] as String,
      contactNumber: json['contactNumber'] as String,
      shopBanner: json['shopBanner'] as String,
      openingHours: json['openingHours'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'shopName': shopName,
      'address': address,
      'category': category,
      'deliveryRadius': deliveryRadius,
      'contactNumber': contactNumber,
      'shopBanner': shopBanner,
      'openingHours': openingHours,
    };
  }

  VendorProfile copyWith({
    String? shopName,
    String? address,
    String? category,
    String? deliveryRadius,
    String? contactNumber,
    String? shopBanner,
    String? openingHours,
  }) {
    return VendorProfile(
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      category: category ?? this.category,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      contactNumber: contactNumber ?? this.contactNumber,
      shopBanner: shopBanner ?? this.shopBanner,
      openingHours: openingHours ?? this.openingHours,
    );
  }
}
