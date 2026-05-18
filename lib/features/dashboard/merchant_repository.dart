import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';

final merchantRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MerchantRepository(apiClient);
});

class MerchantRepository {
  final ApiClient _apiClient;

  MerchantRepository(this._apiClient);

  Future<ApiResponse<Map<String, dynamic>>> getDashboardStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.merchantDashboard);
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to fetch dashboard stats'},
        (data) => {},
      );
    }
  }
}
