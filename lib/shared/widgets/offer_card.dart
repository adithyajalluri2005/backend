import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/shared/models/offer.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.onEdit,
    required this.onToggle,
  });

  final Offer offer;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tone = switch (offer.statusLabel) {
      'Active' => StatusBadgeTone.success,
      'Upcoming' => StatusBadgeTone.info,
      'Expired' => StatusBadgeTone.neutral,
      _ => StatusBadgeTone.warning,
    };

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.22),
          width: AppSpacing.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSpacing.sm,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_offer_outlined,
                  size: AppSpacing.iconLg,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(offer.title, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${offer.discount}% off', style: AppTextStyles.body.copyWith(color: AppColors.warning)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppFormatters.range(offer.startDate, offer.endDate),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              StatusBadge(text: offer.statusLabel, tone: tone),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.schedule_outlined,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppFormatters.countdown(offer.endDate),
                    style: AppTextStyles.caption,
                  ),
                ),
                Switch.adaptive(
                  value: offer.activeStatus,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (_) => onToggle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: AppSpacing.iconSm),
              label: Text(
                'Edit offer',
                style: AppTextStyles.caption.copyWith(color: AppColors.primaryGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
