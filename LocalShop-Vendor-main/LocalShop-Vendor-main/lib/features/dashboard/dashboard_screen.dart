import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/analytics/analytics_provider.dart';
import 'package:vendor_app/features/dashboard/dashboard_provider.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/components/section_header.dart';
import 'package:vendor_app/shared/widgets/dashboard_metric_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final shop = shopState.shop;
    final dashboard = ref.watch(dashboardAnalyticsProvider);
    final analytics = ref.watch(analyticsSnapshotProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              if (dashboard.unreadNotifications > 0)
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: Text(
                      dashboard.unreadNotifications.toString(),
                      style: AppTextStyles.micro.copyWith(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (shop == null)
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.storefront_outlined, color: Colors.white, size: AppSpacing.iconHuge),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Complete Your Profile',
                              style: AppTextStyles.title.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Set up your shop to start receiving inquiries and adding products.',
                              style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: () => context.push(AppRoutes.createShop),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryGreen,
                        ),
                        child: const Text('Set Up'),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: AppSpacing.borderThin,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: AppSpacing.giant,
                        width: AppSpacing.giant,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: const Icon(Icons.store, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(shop.name, style: AppTextStyles.title),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              shop.address,
                              style: AppTextStyles.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.profile),
                        child: Text(
                          'View Shop',
                          style: AppTextStyles.caption.copyWith(color: AppColors.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Today\'s Overview',
                subtitle: AppFormatters.date(DateTime.now()),
                actionLabel: 'Analytics',
                onAction: () => context.push(AppRoutes.analytics),
              ),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final isWide = constraints.maxWidth >= 680;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 2,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: isWide ? 1.34 : 1.02,
                    ),
                    itemCount: dashboard.performanceCards.length,
                    itemBuilder: (BuildContext context, int index) {
                      final metric = dashboard.performanceCards[index];
                      return GestureDetector(
                        onTap: () => context.push(AppRoutes.analytics),
                        child: DashboardMetricCard(
                          title: metric.title,
                          value: metric.value,
                          changeLabel: metric.changeLabel,
                          isPositive: metric.isPositive,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  _QuickActionButton(
                    icon: Icons.add_box_outlined,
                    label: 'Add Product',
                    onTap: () => context.push(AppRoutes.addProduct),
                  ),
                  _QuickActionButton(
                    icon: Icons.local_offer_outlined,
                    label: 'Add Offer',
                    onTap: () => context.push(AppRoutes.addOffer),
                  ),
                  _QuickActionButton(
                    icon: Icons.show_chart_outlined,
                    label: 'Analytics',
                    onTap: () => context.push(AppRoutes.analytics),
                  ),
                  _QuickActionButton(
                    icon: Icons.storefront_outlined,
                    label: 'Profile',
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  gradient: AppColors.infoGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Boost Your Visibility',
                            style: AppTextStyles.title.copyWith(color: const Color(0xFF1E3A8A)),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Feature your shop and turn more visits into inquiries this week.',
                            style: AppTextStyles.caption.copyWith(color: AppColors.info),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Boost tools are coming soon')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                            child: Text(
                              'Upgrade Now',
                              style: AppTextStyles.caption.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Icon(
                      Icons.rocket_launch_outlined,
                      size: AppSpacing.iconHuge,
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Weekly Analytics',
                subtitle: '${dashboard.productCount} products live, ${dashboard.activeOffers} offers active',
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: <Widget>[
                      _StatRow(label: 'Product count', value: dashboard.productCount.toString()),
                      const SizedBox(height: AppSpacing.md),
                      _StatRow(label: 'Total inquiries', value: dashboard.totalInquiries.toString()),
                      const SizedBox(height: AppSpacing.md),
                      _StatRow(label: 'Active offers', value: dashboard.activeOffers.toString()),
                      const SizedBox(height: AppSpacing.md),
                      _StatRow(
                        label: 'Product views',
                        value: AppFormatters.compactNumber(dashboard.productViews),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _StatRow(label: 'Weekly sales', value: AppFormatters.currency(dashboard.weeklySales)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Top Performing Products'),
              const SizedBox(height: AppSpacing.lg),
              ...analytics.productPerformance.take(3).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: AppSpacing.giant,
                            width: AppSpacing.giant,
                            decoration: BoxDecoration(
                              color: AppColors.overlayBackground,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: const Icon(
                              Icons.fastfood_outlined,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item.productName, style: AppTextStyles.titleMedium),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${item.views} views - ${AppFormatters.percent(item.conversionRate)} conversion',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Container(
              height: AppSpacing.giant,
              width: AppSpacing.giant,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: AppTextStyles.bodyMuted)),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}
