import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/features/offers/offer_repository.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/offers/offer_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/models/offer.dart';
import 'package:vendor_app/features/products/product_provider.dart';
import 'package:vendor_app/features/shops/shop_provider.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';

class OfferEditorScreen extends ConsumerStatefulWidget {
  const OfferEditorScreen({
    super.key,
    this.offerId,
  });

  final String? offerId;

  @override
  ConsumerState<OfferEditorScreen> createState() => _OfferEditorScreenState();
}

class _OfferEditorScreenState extends ConsumerState<OfferEditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  bool _isActive = true;
  bool _isSaving = false;

  Offer? get _existingOffer {
    final offerId = widget.offerId;
    if (offerId == null) {
      return null;
    }
    return ref.read(offerByIdProvider(offerId));
  }

  @override
  void initState() {
    super.initState();
    final offer = _existingOffer;
    _titleController.text = offer?.title ?? '';
    _discountController.text = offer?.discount ?? '';
    _startDate = offer?.startDate ?? DateTime.now();
    _endDate = offer?.endDate ?? DateTime.now().add(const Duration(days: 3));
    _isActive = offer?.activeStatus ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingOffer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Offer' : 'Create Offer'),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Label(text: 'Offer Title'),
                TextFormField(
                  controller: _titleController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter an offer title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Weekend Mega Deal'),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Label(text: 'Discount'),
                TextFormField(
                  controller: _discountController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the offer discount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: '17% OFF or Rs 120 OFF'),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Label(text: 'Schedule'),
                Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      children: <Widget>[
                        _DateRow(
                          label: 'Starts',
                          value: AppFormatters.date(_startDate),
                          onTap: () => _pickDate(isStart: true),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _DateRow(
                          label: 'Ends',
                          value: AppFormatters.date(_endDate),
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SwitchListTile.adaptive(
                  value: _isActive,
                  activeColor: AppColors.primaryGreen,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Offer active', style: AppTextStyles.titleMedium),
                  subtitle: Text('You can still schedule a future offer and keep it paused.', style: AppTextStyles.caption),
                  onChanged: (bool value) => setState(() => _isActive = value),
                ),
                const SizedBox(height: AppSpacing.formBottomSpacing),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: PrimaryButton(
            text: isEditing ? 'Update Offer' : 'Save Offer',
            isBusy: _isSaving,
            onPressed: _saveOffer,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      if (isStart) {
        _startDate = selected;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      } else {
        _endDate = selected.isBefore(_startDate) ? _startDate.add(const Duration(days: 1)) : selected;
      }
    });
  }

  Future<void> _saveOffer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final shop = ref.read(shopProvider).shop;
    if (shop == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No shop profile found')));
      return;
    }

    final products = ref.read(productCatalogProvider).items;
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a product first before creating an offer')));
      return;
    }

    setState(() => _isSaving = true);
    
    final existing = _existingOffer;

    final discountText = _discountController.text.trim();
    final parsedVal = double.tryParse(discountText.replaceAll(RegExp(r'[^0-9.]'), ''));
    
    final offerData = <String, dynamic>{
      'shopId': shop.id,
      'productId': products.first.id,
      'title': _titleController.text.trim(),
      'startsAt': _startDate.toIso8601String(),
      'endsAt': _endDate.toIso8601String(),
    };

    if (parsedVal != null) {
      if (discountText.contains('%')) {
        offerData['discountPercentage'] = parsedVal;
      } else {
        offerData['offerPrice'] = parsedVal;
      }
    }

    final response = await ref.read(offerRepositoryProvider).createOffer(offerData);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);
    
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existing == null ? 'Offer created successfully' : 'Offer updated successfully')),
      );
      // Refresh the offers list
      ref.invalidate(offerProvider);
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label, style: AppTextStyles.body)),
            Text(value, style: AppTextStyles.caption),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.calendar_today_outlined, size: AppSpacing.iconSm),
          ],
        ),
      ),
    );
  }
}
