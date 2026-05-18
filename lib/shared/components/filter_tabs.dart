import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';

class FilterTabs extends StatelessWidget {
  const FilterTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: List<Widget>.generate(labels.length, (int index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                labels[index],
                style: (isSelected ? AppTextStyles.caption : AppTextStyles.caption)
                    .copyWith(color: isSelected ? Colors.white : AppColors.textSecondary),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(index),
              showCheckmark: false,
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Theme.of(context).cardColor,
              side: BorderSide(
                color: isSelected ? AppColors.primaryGreen : AppColors.borderColor,
                width: AppSpacing.borderThin,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
            ),
          );
        }),
      ),
    );
  }
}
