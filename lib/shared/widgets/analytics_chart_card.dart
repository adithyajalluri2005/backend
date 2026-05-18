import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';

class AnalyticsChartCard extends StatelessWidget {
  const AnalyticsChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.xs),
                      Text(subtitle, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}
