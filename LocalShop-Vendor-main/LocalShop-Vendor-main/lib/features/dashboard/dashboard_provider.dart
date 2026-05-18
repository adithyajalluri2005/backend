import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/features/analytics/analytics_provider.dart';
import 'package:vendor_app/features/inquiries/inquiry_provider.dart';
import 'package:vendor_app/features/offers/offer_provider.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/shared/models/notification_item.dart';

class DashboardPerformanceMetric {
  const DashboardPerformanceMetric({
    required this.title,
    required this.value,
    required this.changeLabel,
    required this.isPositive,
  });

  final String title;
  final String value;
  final String changeLabel;
  final bool isPositive;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.productCount,
    required this.totalInquiries,
    required this.activeOffers,
    required this.productViews,
    required this.weeklySales,
    required this.pendingInquiries,
    required this.unreadNotifications,
    required this.performanceCards,
  });

  final int productCount;
  final int totalInquiries;
  final int activeOffers;
  final int productViews;
  final double weeklySales;
  final int pendingInquiries;
  final int unreadNotifications;
  final List<DashboardPerformanceMetric> performanceCards;
}

final notificationsProvider = Provider<List<NotificationItem>>(
  (ref) => [],
);

final dashboardAnalyticsProvider = Provider<DashboardSnapshot>(
  (ref) {
    final products = ref.watch(productCatalogProvider);
    final offers = ref.watch(offerProvider);
    final inquiries = ref.watch(inquiryProvider);
    final analytics = ref.watch(analyticsSnapshotProvider);
    final notifications = ref.watch(notificationsProvider);
    final weeklySales = analytics.weeklySeries.fold<double>(
      0,
      (double total, series) => total + series.sales,
    );

    return DashboardSnapshot(
      productCount: products.items.length,
      totalInquiries: inquiries.items.length,
      activeOffers: offers.activeCount,
      productViews: analytics.productViews,
      weeklySales: weeklySales,
      pendingInquiries: inquiries.pendingCount,
      unreadNotifications: notifications.where((NotificationItem item) => !item.isRead).length,
      performanceCards: <DashboardPerformanceMetric>[
        DashboardPerformanceMetric(
          title: 'Product Views',
          value: analytics.productViews.toString(),
          changeLabel: '0%',
          isPositive: true,
        ),
        DashboardPerformanceMetric(
          title: 'Customer Inquiries',
          value: inquiries.items.length.toString(),
          changeLabel: '0%',
          isPositive: true,
        ),
        DashboardPerformanceMetric(
          title: 'Active Offers',
          value: offers.activeCount.toString(),
          changeLabel: '0%',
          isPositive: true,
        ),
        DashboardPerformanceMetric(
          title: 'Pending Replies',
          value: inquiries.pendingCount.toString(),
          changeLabel: inquiries.pendingCount > 0 ? 'Needs focus' : 'All clear',
          isPositive: inquiries.pendingCount == 0,
        ),
      ],
    );
  },
);
