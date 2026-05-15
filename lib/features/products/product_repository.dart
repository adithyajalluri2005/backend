import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../shared/models/product.dart';

final productRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRepository(apiClient);
});

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<ApiResponse<List<Product>>> getProducts({
    String? shopId,
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: {
          if (shopId != null) 'shopId': shopId,
          if (categoryId != null) 'categoryId': categoryId,
          if (query != null) 'q': query,
          'page': page,
          'limit': limit,
        },
      );

      return ApiResponse<List<Product>>.fromJson(
        response.data,
        (data) => (data['items'] as List).map((e) => Product.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to fetch products';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        {'success': false, 'message': message},
        (data) => [],
      );
    }
  }

  Future<ApiResponse<Product>> getProductDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.productDetails(id));
      return ApiResponse<Product>.fromJson(
        response.data,
        (data) => Product.fromJson(data),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to fetch product details';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        {'success': false, 'message': message},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.products, data: productData);
      return ApiResponse<Product>.fromJson(
        response.data,
        (data) => Product.fromJson(data),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to create product';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        {'success': false, 'message': message},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<Product>> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.patch(ApiEndpoints.productDetails(id), data: productData);
      return ApiResponse<Product>.fromJson(
        response.data,
        (data) => Product.fromJson(data),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to update product';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        {'success': false, 'message': message},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<void>> deleteProduct(String id) async {
    try {
      await _apiClient.delete(ApiEndpoints.productDetails(id));
      return ApiResponse(success: true, message: 'Product deleted successfully');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Failed to delete product';
      if (errorData is Map) {
        final rawMessage = errorData['message'] ?? errorData['error'] ?? message;
        if (rawMessage is List) {
          message = rawMessage.join(', ');
        } else {
          message = rawMessage.toString();
        }
      }
      return ApiResponse.fromJson(
        {'success': false, 'message': message},
        (data) => null,
      );
    }
  }

  Future<ApiResponse<Product>> uploadProductImage(String id, File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });
      final response = await _apiClient.postMultipart(ApiEndpoints.productImage(id), formData);
      return ApiResponse<Product>.fromJson(
        response.data,
        (data) => Product.fromJson(data['product']),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to upload image'},
        (data) => null as dynamic,
      );
    }
  }
}
