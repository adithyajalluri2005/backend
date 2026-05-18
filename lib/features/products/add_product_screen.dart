import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/network/api_response.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/models/product.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({
    super.key,
    this.productId,
  });

  final String? productId;

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late String _selectedCategory;
  bool _isSaving = false;

  Product? get _existingProduct {
    final productId = widget.productId;
    if (productId == null) {
      return null;
    }
    return ref.read(productByIdProvider(productId));
  }

  @override
  void initState() {
    super.initState();
    final product = _existingProduct;
    
    // Ensure the selected category is in the list of available categories
    final productCategory = product?.categoryId;
    if (productCategory != null && AppConstants.productCategories.contains(productCategory)) {
      _selectedCategory = productCategory;
    } else {
      _selectedCategory = AppConstants.productCategories.first;
    }

    _nameController.text = product?.name ?? '';
    _priceController.text = product?.actualPrice ?? '';
    _offerPriceController.text = product?.offerPrice ?? '';
    _stockController.text = product?.stockQuantity?.toString() ?? '';
    _descriptionController.text = product?.description ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingProduct != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageContainer(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Product Image', style: AppTextStyles.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    height: AppSpacing.bannerCompact,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: AppSpacing.borderThin,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.primaryGreen,
                          size: AppSpacing.iconXl,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Upload product image',
                          style: AppTextStyles.body.copyWith(color: AppColors.primaryGreen),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Wire this to backend storage later',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Product Name'),
                  TextFormField(
                    controller: _nameController,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a product name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Enter product name'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Category'),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: AppConstants.productCategories
                        .map(
                          (String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _selectedCategory = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Price'),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null || price <= 0) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Enter price'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Offer Price'),
                  TextFormField(
                    controller: _offerPriceController,
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if ((value ?? '').trim().isEmpty) {
                        return null;
                      }
                      final offerPrice = double.tryParse(value!);
                      final price = double.tryParse(_priceController.text);
                      if (offerPrice == null || offerPrice <= 0) {
                        return 'Enter a valid offer price';
                      }
                      if (price != null && offerPrice >= price) {
                        return 'Offer price should be lower than price';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Optional promotional price'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Stock Quantity'),
                  TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      final stock = int.tryParse(value ?? '');
                      if (stock == null || stock < 0) {
                        return 'Enter available stock';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Enter stock quantity'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel(text: 'Description'),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Add a short product description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Describe your product'),
                  ),
                  const SizedBox(height: AppSpacing.formBottomSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: PrimaryButton(
            text: isEditing ? 'Update Product' : 'Save Product',
            isBusy: _isSaving,
            onPressed: _saveProduct,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final shop = ref.read(shopProvider).shop;
    if (shop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No shop profile found. Please create a shop first.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final productData = {
      'shopId': shop.id,
      'name': _nameController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
      'description': _descriptionController.text.trim(),
      'stock': int.parse(_stockController.text.trim()),
    };

    final existing = _existingProduct;
    final offerPriceText = _offerPriceController.text.trim();
    if (offerPriceText.isNotEmpty && existing != null) {
      productData['offerPrice'] = double.parse(offerPriceText);
    }

    final ApiResponse<Product> response;

    if (existing == null) {
      response = await ref.read(productCatalogProvider.notifier).addProduct(productData);
    } else {
      response = await ref.read(productCatalogProvider.notifier).updateProduct(existing.id, productData);
    }

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existing == null ? 'Product added successfully' : 'Product updated successfully'),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.fullMessage)),
      );
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}
