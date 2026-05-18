import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/components/filter_tabs.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/custom_search_bar.dart';
import 'package:vendor_app/shared/widgets/empty_state_widget.dart';
import 'package:vendor_app/shared/widgets/product_card.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productCatalogProvider);
    final notifier = ref.read(productCatalogProvider.notifier);
    final products = state.visibleItems;
    final shop = ref.watch(shopProvider).shop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push(AppRoutes.addProduct),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshCatalog(shopId: shop?.id),
        color: AppColors.primaryGreen,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            PageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomSearchBar(
                    hintText: 'Search products...',
                    onChanged: notifier.setSearchQuery,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilterTabs(
                    labels: <String>[
                      'All (${state.items.length})',
                      'Active (${state.activeCount})',
                      'Inactive (${state.inactiveCount})',
                      'Stockout (${state.outOfStockCount})',
                    ],
                    selectedIndex: state.filter.index,
                    onSelected: (int index) => notifier.setFilter(ProductFilter.values[index]),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Last updated ${AppFormatters.timeAgo(state.lastSyncedAt)}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (products.isEmpty)
                    const SizedBox(
                      height: AppSpacing.bannerHeight + AppSpacing.bannerCompact,
                      child: EmptyStateWidget(
                        icon: Icons.inventory_2_outlined,
                        title: 'No products found',
                        message: 'Try another search or add a fresh catalog item to keep your storefront active.',
                      ),
                    )
                  else
                    Column(
                      children: products
                          .map(
                            (product) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: ProductCard(
                                product: product,
                                onTap: () => context.push(AppRoutes.productDetail(product.id)),
                                onEdit: () => context.push(AppRoutes.editProduct(product.id)),
                                onToggleStatus: () async {
                                  await notifier.toggleStatus(product.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          product.isActive
                                              ? '${product.name} deactivated'
                                              : '${product.name} activated',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                onDelete: () => _confirmDelete(context, ref, product.id, product.name),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  const SizedBox(height: AppSpacing.formBottomSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addProduct),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Add New Product', style: AppTextStyles.body.copyWith(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String productId,
    String productName,
  ) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete product?'),
              content: Text(
                'Are you sure you want to delete $productName? This action cannot be undone.',
                style: AppTextStyles.bodyMuted,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Delete',
                    style: AppTextStyles.body.copyWith(color: AppColors.danger),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!context.mounted || !confirmed) {
      return;
    }

    final response = await ref.read(productCatalogProvider.notifier).deleteProduct(productId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }
}
