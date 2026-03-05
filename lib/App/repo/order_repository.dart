import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';

class OrderRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

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

  /// PUT /api/orders/{orderId}/mark-delivered
  Future<Map<String, dynamic>> markDelivered({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.markDeliveredUrl(orderId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }
}
