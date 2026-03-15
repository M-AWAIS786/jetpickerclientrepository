import 'dart:io';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';
import 'package:jet_picks_app/App/models/order/picker_dashboard_model.dart';
import 'package:jet_picks_app/App/models/order/orderer_order_model.dart';

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

  /// GET /api/orders?status=&page=&limit= (Orderer side)
  Future<OrdererOrdersResponse> getOrdererOrders({
    required String token,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    String url = '${AppUrls.ordererOrdersUrl}?page=$page&limit=$limit';
    if (status != null && status.isNotEmpty) {
      url += '&status=$status';
    }
    final response = await _apiServices.getApi(url, token);
    return OrdererOrdersResponse.fromJson(response);
  }

  /// DELETE /api/orders/{orderId} (Cancel order - Orderer side)
  Future<Map<String, dynamic>> cancelOrder({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.cancelOrderUrl(orderId);
    final response = await _apiServices.deleteApi(url, token, null);
    return response;
  }

  /// PUT /api/orders/{orderId}/confirm-delivery (Orderer side)
  Future<Map<String, dynamic>> confirmDeliveryOrderer({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.confirmDeliveryUrl(orderId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }

  /// PUT /api/orders/{orderId}/report-issue (Orderer side)
  Future<Map<String, dynamic>> reportIssue({
    required String token,
    required String orderId,
    required String reason,
  }) async {
    final url = AppUrls.reportIssueUrl(orderId);
    final response = await _apiServices.putApi({
      'reason': reason,
    }, url, token);
    return response;
  }

  /// GET /api/orders/{orderId}/review - Check if order has review
  Future<Map<String, dynamic>?> getOrderReview({
    required String token,
    required String orderId,
  }) async {
    try {
      final url = AppUrls.orderReviewUrl(orderId);
      final response = await _apiServices.getApi(url, token);
      return response is Map<String, dynamic> ? response : (response is Map ? Map<String, dynamic>.from(response) : null);
    } catch (_) {
      return null;
    }
  }

  /// POST /api/reviews  { order_id, rating, comment, reviewee_id }
  Future<Map<String, dynamic>> submitReview({
    required String token,
    required String orderId,
    required int rating,
    required String comment,
    required String revieweeId,
  }) async {
    final data = <String, dynamic>{
      'order_id': orderId,
      'rating': rating,
      'comment': comment,
      'reviewee_id': revieweeId,
    };
    final response = await _apiServices.postApi(data, AppUrls.reviewsUrl, token);
    return response;
  }

  /// POST /api/tips  { order_id, amount }
  Future<Map<String, dynamic>> submitTip({
    required String token,
    required String orderId,
    required double amount,
  }) async {
    final data = <String, dynamic>{
      'order_id': orderId,
      'amount': amount,
    };
    final response = await _apiServices.postApi(data, AppUrls.tipsUrl, token);
    return response;
  }

  /// POST /api/orders  — create a new order (DRAFT or with picker)
  Future<Map<String, dynamic>> createOrder({
    required String token,
    required String originCountry,
    required String originCity,
    required String destinationCountry,
    required String destinationCity,
    String? pickerId,
    String? status,
  }) async {
    final data = <String, dynamic>{
      'origin_country': originCountry,
      'origin_city': originCity,
      'destination_country': destinationCountry,
      'destination_city': destinationCity,
    };
    if (pickerId != null) {
      data['picker_id'] = pickerId;
    }
    if (status != null) {
      data['status'] = status;
    }
    final response = await _apiServices.postApi(
      data,
      AppUrls.createOrderUrl,
      token,
    );
    return response;
  }

  /// PUT /api/orders/{orderId}  — update order fields (e.g. waiting_days)
  Future<Map<String, dynamic>> updateOrder({
    required String token,
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    final url = AppUrls.updateOrderUrl(orderId);
    final response = await _apiServices.putApi(data, url, token);
    return response;
  }

  /// DELETE /api/orders/{orderId}/items  — delete all items for an order
  Future<Map<String, dynamic>> deleteOrderItems({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.deleteOrderItemsUrl(orderId);
    final response = await _apiServices.deleteApi(url, token, null);
    return response;
  }

  /// POST /api/orders/{orderId}/items  — add an item (multipart with images)
  Future<Map<String, dynamic>> addOrderItem({
    required String token,
    required String orderId,
    required String itemName,
    required int quantity,
    required String price,
    required String currency,
    String? weight,
    String? specialNotes,
    String? storeLink,
    List<File>? productImages,
  }) async {
    final url = AppUrls.orderItemsUrl(orderId);
    final data = <String, dynamic>{
      'item_name': itemName,
      'quantity': quantity.toString(),
      'price': price,
      'currency': currency,
    };
    if (weight != null && weight.isNotEmpty) {
      data['weight'] = weight;
    }
    if (specialNotes != null && specialNotes.isNotEmpty) {
      data['special_notes'] = specialNotes;
    }
    if (storeLink != null && storeLink.isNotEmpty) {
      data['store_link'] = storeLink;
    }

    if (productImages != null && productImages.isNotEmpty) {
      final fileFields = List.generate(
        productImages.length,
        (_) => 'product_images[]',
      );
      final response = await _apiServices.postApi(
        data,
        url,
        token,
        isJson: false,
        files: productImages,
        fileFields: fileFields,
      );
      return response;
    } else {
      final response = await _apiServices.postApi(data, url, token);
      return response;
    }
  }

  /// PUT /api/orders/{orderId}/reward  — set reward amount
  Future<Map<String, dynamic>> setReward({
    required String token,
    required String orderId,
    required int rewardAmount,
  }) async {
    final url = AppUrls.setRewardUrl(orderId);
    final response = await _apiServices.putApi(
      {'reward_amount': rewardAmount},
      url,
      token,
    );
    return response;
  }

  /// PUT /api/orders/{orderId}/finalize  — change DRAFT → PENDING
  Future<Map<String, dynamic>> finalizeOrder({
    required String token,
    required String orderId,
  }) async {
    final url = AppUrls.finalizeOrderUrl(orderId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }

  /// GET /api/dashboard/orderer?page=&limit=  — available pickers for orderer dashboard
  Future<Map<String, dynamic>> getOrdererDashboard({
    required String token,
    int page = 1,
    int limit = 20,
  }) async {
    final url = '${AppUrls.ordererDashboardPickersUrl}?page=$page&limit=$limit';
    final response = await _apiServices.getApi(url, token);
    return response;
  }

  /// GET /api/orders?status=DRAFT  — get active draft order
  Future<Map<String, dynamic>> getActiveDraftOrder({
    required String token,
  }) async {
    final response = await _apiServices.getApi(
      AppUrls.activeDraftOrderUrl,
      token,
    );
    return response;
  }

  /// PUT /api/offers/{offerId}/accept
  Future<Map<String, dynamic>> acceptOffer({
    required String token,
    required String offerId,
  }) async {
    final url = AppUrls.acceptOfferUrl(offerId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }

  /// PUT /api/offers/{offerId}/reject
  Future<Map<String, dynamic>> rejectOffer({
    required String token,
    required String offerId,
  }) async {
    final url = AppUrls.rejectOfferUrl(offerId);
    final response = await _apiServices.putApi({}, url, token);
    return response;
  }
}
