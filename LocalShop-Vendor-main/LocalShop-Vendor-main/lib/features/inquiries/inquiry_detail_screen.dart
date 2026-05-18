import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/features/inquiries/inquiry_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/empty_state_widget.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';
import 'package:vendor_app/shared/widgets/status_badge.dart';

class InquiryDetailScreen extends ConsumerStatefulWidget {
  const InquiryDetailScreen({
    super.key,
    required this.inquiryId,
  });

  final String inquiryId;

  @override
  ConsumerState<InquiryDetailScreen> createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends ConsumerState<InquiryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final inquiry = ref.watch(inquiryByIdProvider(widget.inquiryId));

    if (inquiry == null) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.chat_bubble_outline,
          title: 'Inquiry not found',
          message: 'This inquiry may have been removed or updated.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Details'),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StatusBadge(
                    text: inquiry.status,
                    tone: inquiry.isPending ? StatusBadgeTone.warning : StatusBadgeTone.success,
                  ),
                  Text(AppFormatters.timeAgo(inquiry.date), style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
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
                        Text(inquiry.customerName, style: AppTextStyles.sectionTitle),
                        const SizedBox(height: AppSpacing.xs),
                        Text(inquiry.customerPhone, style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _InfoRow(label: 'Product', value: inquiry.productName),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(label: 'Quantity', value: '${inquiry.quantity} items'),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(label: 'Message', value: inquiry.message),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PrimaryButton(
                text: inquiry.isPending ? 'Reply to Customer' : 'Send Follow-up',
                onPressed: () => _showReplySheet(context),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                text: inquiry.isPending ? 'Mark as Responded' : 'Call Customer',
                isOutlined: true,
                onPressed: () {
                  if (inquiry.isPending) {
                    ref.read(inquiryProvider.notifier).markAsResponded(inquiry.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inquiry moved to responded')),
                    );
                    context.pop();
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Call action triggered')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showReplySheet(BuildContext context) async {
    final controller = TextEditingController();
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Send reply', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Type a response for the customer',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Send Reply',
                onPressed: () {
                  Navigator.of(context).pop(controller.text.trim().isNotEmpty);
                },
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();

    if (!mounted || sent != true) {
      return;
    }

    ref.read(inquiryProvider.notifier).markAsResponded(widget.inquiryId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply sent and inquiry marked responded')),
    );
    context.pop();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
