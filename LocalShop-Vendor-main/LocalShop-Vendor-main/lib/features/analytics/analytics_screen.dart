import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/analytics/analytics_provider.dart';
import 'package:vendor_app/shared/components/filter_tabs.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/models/analytics_snapshot.dart';
import 'package:vendor_app/shared/widgets/analytics_chart_card.dart';
import 'package:vendor_app/shared/widgets/dashboard_metric_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(analyticsRangeProvider);
    final analytics = ref.watch(analyticsSnapshotProvider);
    final series = ref.watch(selectedAnalyticsSeriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FilterTabs(
                labels: const <String>['This Week', 'This Month'],
                selectedIndex: range.index,
                onSelected: (int index) {
                  ref.read(analyticsRangeProvider.notifier).state = DashboardRange.values[index];
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final crossAxisCount = constraints.maxWidth > 560 ? 3 : 1;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    children: <Widget>[
                      DashboardMetricCard(
                        title: 'Views',
                        value: AppFormatters.compactNumber(analytics.productViews),
                        changeLabel: '22%',
                        isPositive: true,
                      ),
                      DashboardMetricCard(
                        title: 'Inquiries',
                        value: analytics.totalInquiries.toString(),
                        changeLabel: '18%',
                        isPositive: true,
                      ),
                      DashboardMetricCard(
                        title: 'Offer Clicks',
                        value: analytics.offerClicks.toString(),
                        changeLabel: '14%',
                        isPositive: true,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              AnalyticsChartCard(
                title: 'Sales Graph',
                subtitle: 'Performance data aggregated from your live product views and inquiries.',
                child: SizedBox(
                  height: AppSpacing.chartHeight,
                  child: LineChart(_buildSalesChart(series)),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AnalyticsChartCard(
                title: 'Inquiry Graph',
                subtitle: 'Response-ready inquiry volume by selected range.',
                child: SizedBox(
                  height: AppSpacing.chartHeight,
                  child: BarChart(_buildInquiryChart(series)),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AnalyticsChartCard(
                title: 'Product Performance',
                subtitle: 'Top catalog items ranked by views and conversion.',
                child: Column(
                  children: analytics.productPerformance.take(4).map((ProductPerformanceData item) {
                    final maxViews = analytics.productPerformance.isEmpty
                        ? 1
                        : analytics.productPerformance.first.views;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(item.productName, style: AppTextStyles.titleMedium),
                              ),
                              Text('${item.views} views', style: AppTextStyles.caption),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          LinearProgressIndicator(
                            value: item.views / maxViews,
                            backgroundColor: AppColors.borderColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                            minHeight: AppSpacing.xs + AppSpacing.xxs,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${item.inquiries} inquiries - ${AppFormatters.percent(item.conversionRate)} conversion',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    );
                  }).toList(growable: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildSalesChart(List<AnalyticsSeriesPoint> series) {
    final points = List<FlSpot>.generate(
      series.length,
      (int index) => FlSpot(index.toDouble(), series[index].sales),
    );

    return LineChartData(
      minY: 0,
      gridData: FlGridData(
        show: true,
        horizontalInterval: 2000,
        getDrawingHorizontalLine: (double value) => FlLine(
          color: AppColors.borderColor,
          strokeWidth: AppSpacing.borderThin,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppSpacing.huge,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                AppFormatters.compactNumber(value),
                style: AppTextStyles.micro,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index < 0 || index >= series.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(series[index].label, style: AppTextStyles.micro),
              );
            },
          ),
        ),
      ),
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          isCurved: true,
          spots: points,
          color: AppColors.primaryGreen,
          barWidth: AppSpacing.xxs + AppSpacing.xs,
          dotData: FlDotData(
            show: true,
            getDotPainter: (FlSpot spot, double percent, LineChartBarData barData, int index) {
              return FlDotCirclePainter(
                radius: AppSpacing.xs + AppSpacing.xxs,
                color: Colors.white,
                strokeColor: AppColors.primaryGreen,
                strokeWidth: AppSpacing.xxs,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primaryGreen.withOpacity(0.28),
                AppColors.primaryGreen.withOpacity(0.02),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartData _buildInquiryChart(List<AnalyticsSeriesPoint> series) {
    final maxY = series.fold<int>(
      0,
      (int current, AnalyticsSeriesPoint item) => math.max(current, item.inquiries),
    );

    return BarChartData(
      maxY: (maxY + 4).toDouble(),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (double value) => FlLine(
          color: AppColors.borderColor,
          strokeWidth: AppSpacing.borderThin,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppSpacing.xxxl,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(value.toInt().toString(), style: AppTextStyles.micro);
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index < 0 || index >= series.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(series[index].label, style: AppTextStyles.micro),
              );
            },
          ),
        ),
      ),
      barGroups: List<BarChartGroupData>.generate(
        series.length,
        (int index) => BarChartGroupData(
          x: index,
          barRods: <BarChartRodData>[
            BarChartRodData(
              toY: series[index].inquiries.toDouble(),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              color: AppColors.secondaryGreen,
              width: AppSpacing.lg,
            ),
          ],
        ),
      ),
    );
  }
}
