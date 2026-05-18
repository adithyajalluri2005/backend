import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/features/offers/offer_repository.dart';
import 'package:vendor_app/shared/models/offer.dart';

class OfferState {
  const OfferState({
    required this.items,
    required this.filter,
  });

  final List<Offer> items;
  final OfferFilter filter;

  List<Offer> get visibleItems {
    final sorted = <Offer>[...items]
      ..sort((Offer a, Offer b) => a.endDate.compareTo(b.endDate));

    return sorted.where((Offer offer) {
      return switch (filter) {
        OfferFilter.all => true,
        OfferFilter.active => !offer.isUpcoming && !offer.isExpired && offer.activeStatus,
        OfferFilter.upcoming => offer.isUpcoming,
        OfferFilter.expired => offer.isExpired,
      };
    }).toList(growable: false);
  }

  int get activeCount =>
      items.where((Offer offer) => !offer.isUpcoming && !offer.isExpired && offer.activeStatus).length;
  int get upcomingCount => items.where((Offer offer) => offer.isUpcoming).length;
  int get expiredCount => items.where((Offer offer) => offer.isExpired).length;

  OfferState copyWith({
    List<Offer>? items,
    OfferFilter? filter,
  }) {
    return OfferState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

class OfferNotifier extends StateNotifier<OfferState> {
  final OfferRepository _repository;

  OfferNotifier(this._repository)
      : super(
          const OfferState(
            items: [],
            filter: OfferFilter.all,
          ),
        ) {
    loadOffers();
  }

  Future<void> loadOffers() async {
    final response = await _repository.getActiveOffers();
    if (response.success) {
      state = state.copyWith(items: response.data ?? []);
    }
  }

  void setFilter(OfferFilter value) {
    state = state.copyWith(filter: value);
  }

  void addOffer(Offer offer) {
    state = state.copyWith(items: <Offer>[offer, ...state.items]);
  }

  void updateOffer(Offer updatedOffer) {
    state = state.copyWith(
      items: state.items
          .map<Offer>((Offer offer) => offer.id == updatedOffer.id ? updatedOffer : offer)
          .toList(growable: false),
    );
  }

  void toggleStatus(String offerId) {
    state = state.copyWith(
      items: state.items.map<Offer>((Offer offer) {
        if (offer.id != offerId) {
          return offer;
        }
        return offer.copyWith(activeStatus: !offer.activeStatus);
      }).toList(growable: false),
    );
  }
}

final offerProvider = StateNotifierProvider<OfferNotifier, OfferState>(
  (ref) {
    final repository = ref.watch(offerRepositoryProvider);
    return OfferNotifier(repository);
  },
);

final offerByIdProvider = Provider.family<Offer?, String>(
  (ref, offerId) {
    final items = ref.watch(offerProvider.select((OfferState state) => state.items));
    for (final Offer offer in items) {
      if (offer.id == offerId) {
        return offer;
      }
    }
    return null;
  },
);
