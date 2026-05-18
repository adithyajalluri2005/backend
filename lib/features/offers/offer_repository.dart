import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../../shared/models/offer.dart';

final offerRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OfferRepository(apiClient);
});

class OfferRepository {
  final ApiClient _apiClient;

  OfferRepository(this._apiClient);

  Future<ApiResponse<List<Offer>>> getActiveOffers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.activeOffers);
      return ApiResponse<List<Offer>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => Offer.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to fetch active offers'},
        (data) => [],
      );
    }
  }

  Future<ApiResponse<Offer>> createOffer(Map<String, dynamic> offerData) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.offers, data: offerData);
      return ApiResponse<Offer>.fromJson(
        response.data,
        (data) => Offer.fromJson(data),
      );
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to create offer'},
        (data) => null as dynamic,
      );
    }
  }

  Future<ApiResponse<void>> deactivateOffer(String id) async {
    try {
      await _apiClient.patch(ApiEndpoints.deactivateOffer(id));
      return ApiResponse(success: true, message: 'Offer deactivated');
    } on DioException catch (e) {
      return ApiResponse.fromJson(
        e.response?.data ?? {'success': false, 'message': 'Failed to deactivate offer'},
        (data) => null,
      );
    }
  }
}
