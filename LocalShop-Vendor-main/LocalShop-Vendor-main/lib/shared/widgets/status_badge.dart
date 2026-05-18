import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';

enum StatusBadgeTone { success, warning, danger, neutral, info }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.text,
    this.tone = StatusBadgeTone.success,
  });

  final String text;
  final StatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      StatusBadgeTone.success => <Color>[
          AppColors.success.withOpacity(0.12),
          AppColors.success,
        ],
      StatusBadgeTone.warning => <Color>[
          AppColors.warning.withOpacity(0.12),
          AppColors.warning,
        ],
      StatusBadgeTone.danger => <Color>[
          AppColors.danger.withOpacity(0.12),
          AppColors.danger,
        ],
      StatusBadgeTone.info => <Color>[
          AppColors.info.withOpacity(0.12),
          AppColors.info,
        ],
      StatusBadgeTone.neutral => <Color>[
          AppColors.borderColor,
          AppColors.textSecondary,
        ],
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.first,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        text,
        style: AppTextStyles.badge.copyWith(color: colors.last),
      ),
    );
  }
}
