import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/shared/models/inquiry.dart';

class InquiryState {
  const InquiryState({
    required this.items,
    required this.filter,
  });

  final List<Inquiry> items;
  final InquiryFilter filter;

  List<Inquiry> get visibleItems {
    final sorted = <Inquiry>[...items]
      ..sort((Inquiry a, Inquiry b) => b.date.compareTo(a.date));

    return sorted.where((Inquiry inquiry) {
      return switch (filter) {
        InquiryFilter.all => true,
        InquiryFilter.pending => inquiry.isPending,
        InquiryFilter.responded => !inquiry.isPending,
      };
    }).toList(growable: false);
  }

  int get pendingCount => items.where((Inquiry inquiry) => inquiry.isPending).length;
  int get respondedCount => items.where((Inquiry inquiry) => !inquiry.isPending).length;

  InquiryState copyWith({
    List<Inquiry>? items,
    InquiryFilter? filter,
  }) {
    return InquiryState(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

class InquiryNotifier extends StateNotifier<InquiryState> {
  InquiryNotifier()
      : super(
          const InquiryState(
            items: [],
            filter: InquiryFilter.all,
          ),
        );

  void setFilter(InquiryFilter value) {
    state = state.copyWith(filter: value);
  }

  void markAsResponded(String inquiryId) {
    state = state.copyWith(
      items: state.items.map((Inquiry inquiry) {
        if (inquiry.id != inquiryId) {
          return inquiry;
        }
        return inquiry.copyWith(status: 'Responded');
      }).toList(growable: false),
    );
  }
}

final inquiryProvider = StateNotifierProvider<InquiryNotifier, InquiryState>(
  (ref) => InquiryNotifier(),
);

final inquiryByIdProvider = Provider.family<Inquiry?, String>(
  (ref, inquiryId) {
    final items = ref.watch(inquiryProvider.select((InquiryState state) => state.items));
    for (final Inquiry inquiry in items) {
      if (inquiry.id == inquiryId) {
        return inquiry;
      }
    }
    return null;
  },
);
