import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/features/offers/offer_provider.dart';
import 'package:vendor_app/shared/components/filter_tabs.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/empty_state_widget.dart';
import 'package:vendor_app/shared/widgets/offer_card.dart';

class OffersDiscountsScreen extends ConsumerWidget {
  const OffersDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offerProvider);
    final notifier = ref.read(offerProvider.notifier);
    final offers = state.visibleItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Discounts'),
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
                    'Active (${state.activeCount})',
                    'Upcoming (${state.upcomingCount})',
                    'Expired (${state.expiredCount})',
                  ],
                  selectedIndex: state.filter.index,
                  onSelected: (int index) => notifier.setFilter(OfferFilter.values[index]),
                ),
                const SizedBox(height: AppSpacing.md),
                if (offers.isEmpty)
                  const SizedBox(
                    height: AppSpacing.bannerHeight + AppSpacing.bannerCompact,
                    child: EmptyStateWidget(
                      icon: Icons.local_offer_outlined,
                      title: 'No offers in this filter',
                      message: 'Create a promo to increase product visibility and inquiry volume.',
                    ),
                  )
                else
                  Column(
                    children: offers
                        .map(
                          (offer) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: OfferCard(
                              offer: offer,
                              onEdit: () => context.push(AppRoutes.editOffer(offer.id)),
                              onToggle: () {
                                notifier.toggleStatus(offer.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${offer.title} status updated')),
                                );
                              },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addOffer),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'Create New Offer',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
