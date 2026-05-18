import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/empty_state_widget.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productId));

    if (product == null) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.inventory_2_outlined,
          title: 'Product not found',
          message: 'This product may have been removed from the catalog.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Preview'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push(AppRoutes.editProduct(product.id)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: AppColors.overlayBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: AppSpacing.productImage,
                      width: AppSpacing.productImage,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Icon(
                        Icons.fastfood_outlined,
                        color: AppColors.primaryGreen,
                        size: AppSpacing.iconXl,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(product.name, style: AppTextStyles.sectionTitle),
                          const SizedBox(height: AppSpacing.xs),
                          Text(product.categoryId ?? 'Uncategorized', style: AppTextStyles.bodyMuted),
                          const SizedBox(height: AppSpacing.sm),
                          StatusBadge(
                            text: product.isActive ? 'Active' : 'Inactive',
                            tone: product.isActive ? StatusBadgeTone.success : StatusBadgeTone.neutral,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Pricing', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppFormatters.currency(product.discountPrice ?? product.price),
                        style: AppTextStyles.headline.copyWith(color: AppColors.textPrimary),
                      ),
                      if (product.discountPrice != null) ...<Widget>[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          AppFormatters.currency(product.price),
                          style: AppTextStyles.bodyMuted.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        product.isOutOfStock ? 'Currently out of stock' : '${product.stock} units available',
                        style: AppTextStyles.bodyMuted.copyWith(
                          color: product.isOutOfStock ? AppColors.danger : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Description', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(product.description ?? 'No description provided.', style: AppTextStyles.body),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Metadata', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _MetaRow(label: 'Created', value: product.createdAt != null ? AppFormatters.date(DateTime.parse(product.createdAt!)) : 'N/A'),
                      const SizedBox(height: AppSpacing.md),
                      _MetaRow(label: 'Catalog status', value: product.isActive ? 'Active' : 'Inactive'),
                      const SizedBox(height: AppSpacing.md),
                      _MetaRow(
                        label: 'Promotional pricing',
                        value: product.discountPrice == null ? 'Not running' : 'Live',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.formBottomSpacing),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: PrimaryButton(
                  text: 'Edit Product',
                  onPressed: () => context.push(AppRoutes.editProduct(product.id)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  text: product.isActive ? 'Deactivate' : 'Activate',
                  isOutlined: true,
                  onPressed: () {
                    ref.read(productCatalogProvider.notifier).toggleStatus(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Catalog status updated')),
                    );
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label, style: AppTextStyles.caption)),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
