import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../core/services/storage_service.dart';
import '../../shared/models/user.dart';

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(apiClient, storageService);
});

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data['user']),
      );

      final data = response.data['data'];
      final token = data != null ? data['accessToken'] : null;

      if (apiResponse.success && token != null) {
        await _storageService.saveToken(token);
      } else if (apiResponse.success) {
        return ApiResponse<User>(
          success: false,
          message: 'Authentication failed: Missing session token',
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Login failed'},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = 'customer',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': role,
        },
      );

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data['user']),
      );

      final data = response.data['data'];
      final token = data != null ? data['accessToken'] : null;

      if (apiResponse.success && token != null) {
        await _storageService.saveToken(token);
      } else if (apiResponse.success) {
        return ApiResponse<User>(
          success: false,
          message: 'Registration successful but missing session token',
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Registration failed'},
        (data) => null as dynamic,
      );
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }
}
