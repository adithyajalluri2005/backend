import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/features/inquiries/inquiry_provider.dart';
import 'package:vendor_app/shared/components/filter_tabs.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/empty_state_widget.dart';
import 'package:vendor_app/shared/widgets/inquiry_tile.dart';

class InquiriesScreen extends ConsumerWidget {
  const InquiriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inquiryProvider);
    final notifier = ref.read(inquiryProvider.notifier);
    final inquiries = state.visibleItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
      ),
      body: ListView(
        children: <Widget>[
          PageContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FilterTabs(
                  labels: <String>[
                    'All (${state.items.length})',
                    'Pending (${state.pendingCount})',
                    'Responded (${state.respondedCount})',
                  ],
                  selectedIndex: state.filter.index,
                  onSelected: (int index) => notifier.setFilter(InquiryFilter.values[index]),
                ),
                const SizedBox(height: AppSpacing.md),
                if (inquiries.isEmpty)
                  const SizedBox(
                    height: AppSpacing.bannerHeight + AppSpacing.bannerCompact,
                    child: EmptyStateWidget(
                      icon: Icons.chat_bubble_outline,
                      title: 'No inquiries here',
                      message: 'When customers inquire about your products, they will appear here.',
                    ),
                  )
                else
                  Column(
                    children: inquiries
                        .map(
                          (inquiry) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: InquiryTile(
                              inquiry: inquiry,
                              onTap: () => context.push(AppRoutes.inquiryDetail(inquiry.id)),
                              onReply: () => context.push(AppRoutes.inquiryDetail(inquiry.id)),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
