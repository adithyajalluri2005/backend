import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/shared/models/product.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ProductImagePlaceholder(
                icon: _categoryIcon(product.categoryId?.toString() ?? ''),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
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
                              Text(product.name, style: AppTextStyles.title),
                              const SizedBox(height: AppSpacing.xs),
                              Text(product.categoryId?.toString() ?? 'Uncategorized', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: product.isActive ? 'Active' : 'Inactive',
                          tone: product.isActive ? StatusBadgeTone.success : StatusBadgeTone.neutral,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          AppFormatters.currency(product.discountPrice ?? product.price),
                          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
                        ),
                        if (product.discountPrice != null)
                          Text(
                            AppFormatters.currency(product.price),
                            style: AppTextStyles.caption.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (product.discountPercent > 0)
                          StatusBadge(
                            text: '${product.discountPercent}% OFF',
                            tone: StatusBadgeTone.danger,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      product.isOutOfStock ? 'Out of stock' : '${product.stock} units in stock',
                      style: AppTextStyles.caption.copyWith(
                        color: product.isOutOfStock ? AppColors.danger : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        IconButton(
                          tooltip: 'Edit product',
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: AppSpacing.iconMd),
                        ),
                        IconButton(
                          tooltip: product.isActive ? 'Deactivate product' : 'Activate product',
                          onPressed: onToggleStatus,
                          icon: Icon(
                            product.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                            size: AppSpacing.iconMd,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete product',
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: AppSpacing.iconMd,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    if (category.contains('Electronics')) return Icons.devices_outlined;
    if (category.contains('Food')) return Icons.fastfood_outlined;
    if (category.contains('Fashion')) return Icons.checkroom_outlined;
    return Icons.inventory_2_outlined;
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.productImage,
      width: AppSpacing.productImage,
      decoration: BoxDecoration(
        color: AppColors.overlayBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(icon, size: AppSpacing.iconXl, color: AppColors.primaryGreen),
    );
  }
}
