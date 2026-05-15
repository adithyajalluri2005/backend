import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../services/storage_service.dart';
import 'api_endpoints.dart';
import 'auth_event_bus.dart';

final logger = Logger();

final apiClientProvider = Provider((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiClient(storageService);
});

class ApiClient {
  late final Dio _dio;
  final StorageService _storageService;

  ApiClient(this._storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          logger.e('API Error: ${e.message}', error: e, stackTrace: e.stackTrace);
          if (e.response?.statusCode == 401) {
            _storageService.deleteToken();
            AuthEventBus.instance.logout();
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          logger.i('API Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Helper methods for common HTTP verbs
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> postMultipart(String path, FormData formData) async {
    return await _dio.post(
      path,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
