import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';

class CreateShopScreen extends ConsumerStatefulWidget {
  const CreateShopScreen({super.key});

  @override
  ConsumerState<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends ConsumerState<CreateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final shopData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'description': _descriptionController.text.trim(),
      'latitude': 0.0,
      'longitude': 0.0,
    };

    final response = await ref.read(shopProvider.notifier).createShop(shopData);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop profile created successfully!')),
      );
      context.pop();
    } else {
      debugPrint('Shop Creation Error: ${response.fullMessage}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Shop Profile'),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set up your shop to start adding products and receiving inquiries.',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: AppSpacing.xl),
                _Label(text: 'Shop Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Rahul General Store',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter shop name' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Label(text: 'Phone Number'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +91 9876543210',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter phone number' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Label(text: 'Address'),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Full shop address with landmarks',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter address' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                _Label(text: 'Description (Optional)'),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Briefly describe what your shop offers',
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: 'Create Profile',
                  isBusy: _isSaving,
                  onPressed: _handleCreate,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}
