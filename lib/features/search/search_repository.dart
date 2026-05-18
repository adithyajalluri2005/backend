import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../shared/models/product.dart';

final searchRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SearchRepository(apiClient);
});

class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository(this._apiClient);

  Future<ApiResponse<List<Product>>> findProductsNearby({
    required double lat,
    required double lng,
    double? radius,
    String? query,
    String? categoryId,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productsNearby,
        queryParameters: {
          'lat': lat,
          'lng': lng,
          if (radius != null) 'radius': radius,
          if (query != null) 'query': query,
          if (categoryId != null) 'categoryId': categoryId,
        },
      );

      return ApiResponse<List<Product>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => Product.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Search failed',
        error: e.response?.data['error'],
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<List<String>>> getSearchHistory() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.searchHistory);
      return ApiResponse<List<String>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => e as String).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to fetch search history',
        error: e.response?.data['error'],
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<void>> clearSearchHistory() async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.searchHistory);
      return ApiResponse<void>.fromJson(response.data, (_) => null);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to clear search history',
        error: e.response?.data['error'],
        statusCode: e.response?.statusCode,
      );
    }
  }
}
