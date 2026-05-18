import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/shared/models/inquiry.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class InquiryTile extends StatelessWidget {
  const InquiryTile({
    super.key,
    required this.inquiry,
    required this.onTap,
    required this.onReply,
  });

  final Inquiry inquiry;
  final VoidCallback onTap;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final isPending = inquiry.isPending;

    return Card(
      color: isPending ? AppColors.warning.withOpacity(0.05) : Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: AppSpacing.avatar / 2,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
                child: Text(
                  inquiry.customerName.substring(0, 1),
                  style: AppTextStyles.title.copyWith(color: AppColors.primaryGreen),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(inquiry.customerName, style: AppTextStyles.titleMedium),
                        ),
                        Text(AppFormatters.timeAgo(inquiry.date), style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(inquiry.productName, style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: <Widget>[
                        StatusBadge(
                          text: inquiry.status,
                          tone: isPending ? StatusBadgeTone.warning : StatusBadgeTone.success,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text('${inquiry.quantity} items', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: onReply,
                icon: const Icon(
                  Icons.reply_outlined,
                  size: AppSpacing.iconMd,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
