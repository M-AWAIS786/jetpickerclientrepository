import 'dart:io';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/models/order/picker_dashboard_model.dart';

class OrderRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// GET /api/dashboard/picker?page=&limit=
  Future<PickerDashboardData> getPickerDashboard({
    required String token,
    int page = 1,
    int limit = 20,
  }) async {
    final url = '${AppUrls.pickerDashboardUrl}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);
    return PickerDashboardResponse.fromJson(response).data;
  }

  /// GET /api/orders/picker/history?status=&page=&limit=
  Future<PickerOrdersResponse> getPickerOrders({
    required String token,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    String url = '${AppUrls.pickerOrdersUrl}?page=$page&limit=$limit';
    if (status != null && status.isNotEmpty) {
      url += '&status=$status';
    }
    final response = await _apiServices.getApi(url, token);
    return PickerOrdersResponse.fromJson(response);
  }

  /// GET /api/orders/{orderId}
  Future<OrderDetailModel> getOrderDetail({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.orderDetailUrl(orderId);
    final response = await _apiServices.getApi(url, token);
    return OrderDetailResponse.fromJson(response).data;
  }

  /// PUT /api/orders/{orderId}/accept
  Future<Map<String, dynamic>> acceptOrder({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.acceptOrderUrl(orderId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }

  /// PUT /api/orders/{orderId}/mark-delivered (multipart with proof file)
  Future<Map<String, dynamic>> markDelivered({
    required String token,
    required String orderId,
    required File proofFile,
  }) async {
    final url = AppUrls.markDeliveredUrl(orderId);
    final response = await _apiServices.putApi(
      {},
      url,
      token,
      isJson: false,
      files: [proofFile],
      fileFields: ['proof_of_delivery'],
    );
    return response;
  }

  /// GET /api/orders/{orderId}/offers?page=&limit=
  Future<Map<String, dynamic>> getOfferHistory({
    required String token,
    required String orderId,
    int page = 1,
    int limit = 100,
  }) async {
    final url = '${AppUrls.offerHistoryUrl(orderId)}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);
    return response;
  }

  /// POST /api/offers  { order_id, offer_amount, parent_offer_id }
  Future<Map<String, dynamic>> sendCounterOffer({
    required String token,
    required String orderId,
    required double offerAmount,
    String? parentOfferId,
  }) async {
    final data = <String, dynamic>{
      'order_id': orderId,
      'offer_amount': offerAmount,
    };
    if (parentOfferId != null) {
      data['parent_offer_id'] = parentOfferId;
    }
    final response = await _apiServices.postApi(
      data,
      AppUrls.createOfferUrl,
      token,
    );
    return response;
  }
}
