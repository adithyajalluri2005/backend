import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/components/section_header.dart';
import 'package:vendor_app/shared/models/shop.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class ShopProfileScreen extends ConsumerWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final shop = shopState.shop;

    if (shopState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (shop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shop Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No shop profile found', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Create your shop profile to start selling on Local Vyapari.',
                style: AppTextStyles.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                text: 'Create Shop Profile',
                onPressed: () => context.push(AppRoutes.createShop),
              ),
              TextButton(
                onPressed: () => ref.read(shopProvider.notifier).loadMerchantShop(),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Profile'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: AppSpacing.formBottomSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: AppSpacing.bannerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.splashGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        shop.name,
                        style: AppTextStyles.headline.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: InkWell(
                        onTap: () => _showEditProfileSheet(context, ref, shop),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.textPrimary,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(shop.name, style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.xs),
              Text(shop.description ?? 'Local Vendor', style: AppTextStyles.bodyMuted),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  const Icon(Icons.location_on_outlined, size: AppSpacing.iconSm, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(shop.address, style: AppTextStyles.caption)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              StatusBadge(
                text: shop.isActive ? 'Active' : 'Inactive',
                tone: shop.isActive ? StatusBadgeTone.success : StatusBadgeTone.neutral,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Shop Information',
                actionLabel: 'Edit',
                onAction: () => _showEditProfileSheet(context, ref, shop),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: <Widget>[
                      _InfoRow(icon: Icons.call_outlined, label: 'Contact number', value: shop.phoneNumber),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(icon: Icons.storefront_outlined, label: 'Owner ID', value: shop.ownerId),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(icon: Icons.verified_user_outlined, label: 'Verification', value: shop.verificationStatus ?? 'Pending'),
                      const SizedBox(height: AppSpacing.lg),
                      _InfoRow(icon: Icons.access_time_outlined, label: 'Created At', value: shop.createdAt != null ? DateTime.parse(shop.createdAt!).toString().split(' ')[0] : 'N/A'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Storefront Ready'),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Banner preset', style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.xs),
                      Text(shop.imageUrl ?? 'No banner set', style: AppTextStyles.body),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Complete your profile with details that help customers find and trust your shop.',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                text: 'Edit Profile',
                onPressed: () => _showEditProfileSheet(context, ref, shop),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    Shop shop,
  ) async {
    final formKey = GlobalKey<FormState>();
    final shopNameController = TextEditingController(text: shop.name);
    final addressController = TextEditingController(text: shop.address);
    final descriptionController = TextEditingController(text: shop.description ?? '');
    final contactController = TextEditingController(text: shop.phoneNumber);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Edit Vendor Profile', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.lg),
                      _SheetLabel(text: 'Shop name'),
                      TextFormField(
                        controller: shopNameController,
                        validator: (String? value) => value == null || value.trim().isEmpty ? 'Enter a shop name' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SheetLabel(text: 'Address'),
                      TextFormField(
                        controller: addressController,
                        maxLines: 2,
                        validator: (String? value) => value == null || value.trim().isEmpty ? 'Enter an address' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SheetLabel(text: 'Description'),
                      TextFormField(
                        controller: descriptionController,
                        validator: (String? value) => value == null || value.trim().isEmpty ? 'Enter a description' : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SheetLabel(text: 'Contact number'),
                      TextFormField(
                        controller: contactController,
                        validator: (String? value) => value == null || value.trim().isEmpty ? 'Enter contact number' : null,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      PrimaryButton(
                        text: 'Save Profile',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          final response = await ref.read(shopProvider.notifier).updateShop({
                            'name': shopNameController.text.trim(),
                            'address': addressController.text.trim(),
                            'description': descriptionController.text.trim(),
                            'phoneNumber': contactController.text.trim(),
                          });
                          
                          if (context.mounted) {
                            if (response.success) {
                              Navigator.of(context).pop(true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.message)),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    shopNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    contactController.dispose();

    if (!context.mounted || saved != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop profile updated successfully')),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: AppColors.textSecondary, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xs),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}
