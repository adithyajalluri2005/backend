import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_response.dart';
import '../../shared/models/shop.dart';
import '../dashboard/merchant_repository.dart';
import 'shop_repository.dart';

class ShopState {
  const ShopState({
    this.shop,
    this.isLoading = false,
    this.error,
  });

  final Shop? shop;
  final bool isLoading;
  final String? error;

  ShopState copyWith({
    Shop? shop,
    bool? isLoading,
    String? error,
  }) {
    return ShopState(
      shop: shop ?? this.shop,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  final ShopRepository _shopRepository;
  final MerchantRepository _merchantRepository;

  ShopNotifier(this._shopRepository, this._merchantRepository) : super(const ShopState()) {
    loadMerchantShop();
  }

  Future<void> loadMerchantShop() async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _merchantRepository.getDashboardStats();
    if (response.success && response.data != null) {
      final shops = response.data!['shops'] as List?;
      if (shops != null && shops.isNotEmpty) {
        // For simplicity, take the first shop. In a real app, you might have multiple.
        final shopId = shops.first['id'];
        final shopResponse = await _shopRepository.getShopDetails(shopId);
        if (shopResponse.success) {
          state = state.copyWith(shop: shopResponse.data, isLoading: false);
          return;
        }
      }
    }
    state = state.copyWith(isLoading: false);
  }

  Future<ApiResponse<Shop>> updateShop(Map<String, dynamic> data) async {
    if (state.shop == null) return ApiResponse(success: false, message: 'No shop loaded');
    
    final response = await _shopRepository.updateShop(state.shop!.id, data);
    if (response.success && response.data != null) {
      state = state.copyWith(shop: response.data);
    }
    return response;
  }

  Future<ApiResponse<Shop>> createShop(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _shopRepository.createShop(data);
    if (response.success && response.data != null) {
      state = state.copyWith(shop: response.data, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false, error: response.message);
    }
    return response;
  }
}

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  final shopRepo = ref.watch(shopRepositoryProvider);
  final merchantRepo = ref.watch(merchantRepositoryProvider);
  return ShopNotifier(shopRepo, merchantRepo);
});
