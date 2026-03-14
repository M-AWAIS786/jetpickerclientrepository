import 'package:flutter/foundation.dart';
import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/stripe/stripe_models.dart';

/// Stripe payment repository matching web frontend's stripe.ts service
class StripeRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// Create a payment intent on the backend
  /// Matches: POST /stripe/create-payment-intent
  Future<CreatePaymentIntentResponse> createPaymentIntent(
    CreatePaymentIntentRequest request,
  ) async {
    final token = await UserPreferences.getToken();
    
    if (kDebugMode) {
      debugPrint('🔵 [Stripe] Creating payment intent...');
      debugPrint('🔵 [Stripe] URL: ${AppUrls.stripeCreatePaymentIntentUrl}');
      debugPrint('🔵 [Stripe] Request: ${request.toJson()}');
    }
    
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.stripeCreatePaymentIntentUrl,
      token,
    );
    
    if (kDebugMode) {
      debugPrint('🟢 [Stripe] Response: $response');
    }
    
    // Handle nested response (e.g., { data: { ... } })
    final Map<String, dynamic> data = response is Map<String, dynamic> 
        ? (response['data'] as Map<String, dynamic>?) ?? response
        : response;
    
    return CreatePaymentIntentResponse.fromJson(data);
  }

  /// Confirm payment status with backend
  /// Matches: POST /stripe/confirm-payment
  Future<ConfirmPaymentResponse> confirmPayment(
    ConfirmPaymentRequest request,
  ) async {
    final token = await UserPreferences.getToken();
    
    if (kDebugMode) {
      debugPrint('🔵 [Stripe] Confirming payment...');
      debugPrint('🔵 [Stripe] Request: ${request.toJson()}');
    }
    
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.stripeConfirmPaymentUrl,
      token,
    );
    
    if (kDebugMode) {
      debugPrint('🟢 [Stripe] Confirm Response: $response');
    }
    
    // Handle nested response
    final Map<String, dynamic> data = response is Map<String, dynamic> 
        ? (response['data'] as Map<String, dynamic>?) ?? response
        : response;
    
    return ConfirmPaymentResponse.fromJson(data);
  }

  /// Check order payment status
  /// Matches: POST /stripe/check-order-payment
  Future<CheckOrderPaymentResponse> checkOrderPaymentStatus(
    CheckOrderPaymentRequest request,
  ) async {
    final token = await UserPreferences.getToken();
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.stripeCheckOrderPaymentUrl,
      token,
    );
    
    // Handle nested response
    final Map<String, dynamic> data = response is Map<String, dynamic> 
        ? (response['data'] as Map<String, dynamic>?) ?? response
        : response;
    
    return CheckOrderPaymentResponse.fromJson(data);
  }
}
