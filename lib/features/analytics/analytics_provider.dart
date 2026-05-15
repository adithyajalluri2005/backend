import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/features/inquiries/inquiry_provider.dart';
import 'package:vendor_app/features/offers/offer_provider.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/shared/models/analytics_snapshot.dart';

final analyticsRangeProvider = StateProvider<DashboardRange>(
  (ref) => DashboardRange.weekly,
);

final analyticsSnapshotProvider = Provider<AnalyticsSnapshot>(
  (ref) {
    final productState = ref.watch(productCatalogProvider);
    final offerState = ref.watch(offerProvider);
    final inquiryState = ref.watch(inquiryProvider);

    final performance = productState.items.map((product) {
      final views = (product.stock * 2);
      final inquiries = math.max(0, product.stock ~/ 4);
      final conversion = math.min(
            32,
            10 + ((product.discountPrice != null ? 8 : 0) + (product.isActive ? 6 : 2)).toDouble(),
          );

      return ProductPerformanceData(
        productId: product.id,
        productName: product.name,
        views: views,
        inquiries: inquiries,
        conversionRate: conversion.toDouble(),
      );
    }).toList()
      ..sort((ProductPerformanceData a, ProductPerformanceData b) => b.views.compareTo(a.views));

    return AnalyticsSnapshot(
      productViews: productState.items.length * 10,
      totalSales: 0.0,
      totalInquiries: inquiryState.items.length,
      offerClicks: offerState.activeCount * 5,
      weeklySeries: [],
      monthlySeries: [],
      productPerformance: performance,
    );
  },
);

final selectedAnalyticsSeriesProvider = Provider<List<AnalyticsSeriesPoint>>(
  (ref) {
    final range = ref.watch(analyticsRangeProvider);
    final analytics = ref.watch(analyticsSnapshotProvider);
    return range == DashboardRange.weekly ? analytics.weeklySeries : analytics.monthlySeries;
  },
);
