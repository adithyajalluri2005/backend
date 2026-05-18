class AnalyticsSeriesPoint {
  const AnalyticsSeriesPoint({
    required this.label,
    required this.sales,
    required this.inquiries,
    required this.views,
  });

  final String label;
  final double sales;
  final int inquiries;
  final int views;

  factory AnalyticsSeriesPoint.fromJson(Map<String, dynamic> json) {
    return AnalyticsSeriesPoint(
      label: json['label'] as String,
      sales: (json['sales'] as num).toDouble(),
      inquiries: json['inquiries'] as int,
      views: json['views'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'label': label,
      'sales': sales,
      'inquiries': inquiries,
      'views': views,
    };
  }
}

class ProductPerformanceData {
  const ProductPerformanceData({
    required this.productId,
    required this.productName,
    required this.views,
    required this.inquiries,
    required this.conversionRate,
  });

  final String productId;
  final String productName;
  final int views;
  final int inquiries;
  final double conversionRate;

  factory ProductPerformanceData.fromJson(Map<String, dynamic> json) {
    return ProductPerformanceData(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      views: json['views'] as int,
      inquiries: json['inquiries'] as int,
      conversionRate: (json['conversionRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'views': views,
      'inquiries': inquiries,
      'conversionRate': conversionRate,
    };
  }
}

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.productViews,
    required this.totalSales,
    required this.totalInquiries,
    required this.offerClicks,
    required this.weeklySeries,
    required this.monthlySeries,
    required this.productPerformance,
  });

  final int productViews;
  final double totalSales;
  final int totalInquiries;
  final int offerClicks;
  final List<AnalyticsSeriesPoint> weeklySeries;
  final List<AnalyticsSeriesPoint> monthlySeries;
  final List<ProductPerformanceData> productPerformance;

  factory AnalyticsSnapshot.fromJson(Map<String, dynamic> json) {
    return AnalyticsSnapshot(
      productViews: json['productViews'] as int,
      totalSales: (json['totalSales'] as num).toDouble(),
      totalInquiries: json['totalInquiries'] as int,
      offerClicks: json['offerClicks'] as int,
      weeklySeries: (json['weeklySeries'] as List<dynamic>)
          .map((dynamic item) => AnalyticsSeriesPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      monthlySeries: (json['monthlySeries'] as List<dynamic>)
          .map((dynamic item) => AnalyticsSeriesPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      productPerformance: (json['productPerformance'] as List<dynamic>)
          .map((dynamic item) => ProductPerformanceData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
