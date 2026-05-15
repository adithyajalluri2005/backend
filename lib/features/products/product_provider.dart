import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/network/api_response.dart';
import 'package:vendor_app/features/products/product_repository.dart';
import 'package:vendor_app/shared/models/product.dart';

class ProductCatalogState {
  const ProductCatalogState({
    required this.items,
    required this.searchQuery,
    required this.filter,
    required this.isRefreshing,
    required this.lastSyncedAt,
  });

  final List<Product> items;
  final String searchQuery;
  final ProductFilter filter;
  final bool isRefreshing;
  final DateTime lastSyncedAt;

  List<Product> get visibleItems {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final sorted = [...items]
      ..sort((Product a, Product b) {
        final dateA = a.createdAt != null ? DateTime.parse(a.createdAt!) : DateTime(0);
        final dateB = b.createdAt != null ? DateTime.parse(b.createdAt!) : DateTime(0);
        return dateB.compareTo(dateA);
      });

    return sorted.where((Product product) {
      final matchesFilter = switch (filter) {
        ProductFilter.all => true,
        ProductFilter.active => product.isActive,
        ProductFilter.inactive => !product.isActive,
        ProductFilter.outOfStock => product.isOutOfStock,
      };

      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery);

      return matchesFilter && matchesQuery;
    }).toList(growable: false);
  }

  int get activeCount => items.where((Product product) => product.isActive).length;
  int get inactiveCount => items.where((Product product) => !product.isActive).length;
  int get outOfStockCount => items.where((Product product) => product.isOutOfStock).length;

  ProductCatalogState copyWith({
    List<Product>? items,
    String? searchQuery,
    ProductFilter? filter,
    bool? isRefreshing,
    DateTime? lastSyncedAt,
  }) {
    return ProductCatalogState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductCatalogState> {
  final ProductRepository _repository;

  ProductNotifier(this._repository)
      : super(
          ProductCatalogState(
            items: [],
            searchQuery: '',
            filter: ProductFilter.all,
            isRefreshing: false,
            lastSyncedAt: DateTime.now(),
          ),
        ) {
    loadProducts();
  }

  Future<void> loadProducts({String? shopId}) async {
    state = state.copyWith(isRefreshing: true);
    final response = await _repository.getProducts(shopId: shopId);
    if (response.success) {
      state = state.copyWith(
        items: response.data ?? [],
        isRefreshing: false,
        lastSyncedAt: DateTime.now(),
      );
    } else {
      state = state.copyWith(isRefreshing: false);
    }
  }

  Future<void> refreshCatalog({String? shopId}) async {
    await loadProducts(shopId: shopId);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setFilter(ProductFilter value) {
    state = state.copyWith(filter: value);
  }

  Future<ApiResponse<Product>> addProduct(Map<String, dynamic> data) async {
    final response = await _repository.createProduct(data);
    if (response.success && response.data != null) {
      state = state.copyWith(
        items: <Product>[response.data!, ...state.items],
        lastSyncedAt: DateTime.now(),
      );
    }
    return response;
  }

  Future<ApiResponse<Product>> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await _repository.updateProduct(id, data);
    if (response.success && response.data != null) {
      state = state.copyWith(
        items: state.items
            .map((Product product) => product.id == id ? response.data! : product)
            .toList(growable: false),
        lastSyncedAt: DateTime.now(),
      );
    }
    return response;
  }

  Future<ApiResponse<void>> deleteProduct(String productId) async {
    final response = await _repository.deleteProduct(productId);
    if (response.success) {
      state = state.copyWith(
        items: state.items.where((Product product) => product.id != productId).toList(growable: false),
        lastSyncedAt: DateTime.now(),
      );
    }
    return response;
  }

  Future<void> toggleStatus(String productId) async {
    final product = state.items.firstWhere((p) => p.id == productId);
    final response = await _repository.updateProduct(productId, {
      'isActive': !product.isActive,
    });
    if (response.success && response.data != null) {
      state = state.copyWith(
        items: state.items.map<Product>((Product p) {
          return p.id == productId ? response.data! : p;
        }).toList(growable: false),
        lastSyncedAt: DateTime.now(),
      );
    }
  }
}

final productCatalogProvider =
    StateNotifierProvider<ProductNotifier, ProductCatalogState>(
  (ref) {
    final repository = ref.watch(productRepositoryProvider);
    return ProductNotifier(repository);
  },
);

final productByIdProvider = Provider.family<Product?, String>(
  (ref, productId) {
    final items = ref.watch(productCatalogProvider.select((ProductCatalogState state) => state.items));
    for (final Product product in items) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  },
);
