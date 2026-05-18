import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../shared/models/shop.dart';

final shopRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ShopRepository(apiClient);
});

class ShopRepository {
  final ApiClient _apiClient;

  ShopRepository(this._apiClient);

  Future<ApiResponse<List<Shop>>> getNearbyShops({
    required double lat,
    required double lng,
    double? radius,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.nearbyShops,
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          if (radius != null) 'radiusKm': radius,
        },
      );

      return ApiResponse<List<Shop>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => Shop.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to fetch nearby shops'},
        (data) => [],
      );
    }
  }

  Future<ApiResponse<Shop>> getShopDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.shopDetails(id));
      return ApiResponse<Shop>.fromJson(
        response.data,
        (data) => Shop.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to fetch shop details'},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<Shop>> createShop(Map<String, dynamic> shopData) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.shops, data: shopData);
      return ApiResponse<Shop>.fromJson(
        response.data,
        (data) => Shop.fromJson(data),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to create shop';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': message},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<Shop>> updateShop(String id, Map<String, dynamic> shopData) async {
    try {
      final response = await _apiClient.patch(ApiEndpoints.shopDetails(id), data: shopData);
      return ApiResponse<Shop>.fromJson(
        response.data,
        (data) => Shop.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to update shop'},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<Shop>> uploadShopImage(String id, File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });
      final response = await _apiClient.postMultipart(ApiEndpoints.shopImage(id), formData);
      return ApiResponse<Shop>.fromJson(
        response.data,
        (data) => Shop.fromJson(data['shop']),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to upload shop image'},
        (data) => null as dynamic,
      );
    }
  }
}
