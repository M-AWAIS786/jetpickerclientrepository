import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jet_picks_app/App/models/stripe/stripe_models.dart';
import 'package:jet_picks_app/App/repo/stripe_repository.dart';

// ─────────────────────────────────────────────────────────────
// Payment State
// ─────────────────────────────────────────────────────────────
enum PaymentStatus { idle, loading, success, error }

class PaymentState {
  final PaymentStatus status;
  final String? clientSecret;
  final String? paymentIntentId;
  final String? errorMessage;
  final int? amount;
  final String? currency;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.clientSecret,
    this.paymentIntentId,
    this.errorMessage,
    this.amount,
    this.currency,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? clientSecret,
    String? paymentIntentId,
    String? errorMessage,
    int? amount,
    String? currency,
    bool clearError = false,
  }) {
    return PaymentState(
      status: status ?? this.status,
      clientSecret: clientSecret ?? this.clientSecret,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Payment ViewModel
// ─────────────────────────────────────────────────────────────
class PaymentViewModel extends Notifier<PaymentState> {
  late final StripeRepository _repo;

  @override
  PaymentState build() {
    _repo = StripeRepository();
    return const PaymentState();
  }

  /// Create a payment intent and get client secret
  /// Matches web's createPaymentIntent function
  Future<bool> createPaymentIntent({
    required int amount, // in cents
    required String currency,
    String? description,
    String? customerEmail,
    Map<String, dynamic>? metadata,
    String? orderId,
  }) async {
    state = state.copyWith(status: PaymentStatus.loading, clearError: true);

    if (kDebugMode) {
      debugPrint('🔵 [Payment] Creating payment intent: amount=$amount, currency=$currency, orderId=$orderId');
    }

    try {
      final response = await _repo.createPaymentIntent(
        CreatePaymentIntentRequest(
          amount: amount,
          currency: currency,
          description: description,
          customerEmail: customerEmail,
          metadata: metadata,
          orderId: orderId,
        ),
      );

      if (kDebugMode) {
        debugPrint('🟢 [Payment] Response received: success=${response.success}, clientSecret=${response.clientSecret.isNotEmpty ? "present" : "empty"}');
      }

      if (response.success && response.clientSecret.isNotEmpty) {
        state = state.copyWith(
          status: PaymentStatus.idle,
          clientSecret: response.clientSecret,
          paymentIntentId: response.paymentIntentId,
          amount: response.amount,
          currency: response.currency,
        );
        if (kDebugMode) {
          debugPrint('🟢 [Payment] Payment intent created successfully');
        }
        return true;
      } else {
        final errorMsg = 'Failed to initialize payment. success=${response.success}, hasClientSecret=${response.clientSecret.isNotEmpty}';
        if (kDebugMode) {
          debugPrint('🔴 [Payment] $errorMsg');
        }
        state = state.copyWith(
          status: PaymentStatus.error,
          errorMessage: 'Failed to initialize payment',
        );
        return false;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('🔴 [Payment] Exception: $e');
        debugPrint('🔴 [Payment] StackTrace: $stackTrace');
      }
      state = state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Present the Stripe Payment Sheet and process payment
  Future<bool> presentPaymentSheet() async {
    if (state.clientSecret == null) {
      state = state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Payment not initialized',
      );
      return false;
    }

    state = state.copyWith(status: PaymentStatus.loading);

    try {
      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: state.clientSecret!,
          merchantDisplayName: 'JetPicks',
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFFFFDF57), // Yellow theme matching web
            ),
          ),
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Payment succeeded - confirm with backend
      if (state.paymentIntentId != null) {
        try {
          await _repo.confirmPayment(
            ConfirmPaymentRequest(paymentIntentId: state.paymentIntentId!),
          );
        } catch (e) {
          // Don't fail the payment, just log the error
          debugPrint('Failed to confirm payment with backend: $e');
        }
      }

      state = state.copyWith(status: PaymentStatus.success);
      return true;
    } on StripeException catch (e) {
      final errorMsg = e.error.localizedMessage ?? 'Payment failed';
      
      // Check if user cancelled
      if (e.error.code == FailureCode.Canceled) {
        state = state.copyWith(
          status: PaymentStatus.idle,
          errorMessage: 'Payment cancelled',
        );
        return false;
      }

      state = state.copyWith(
        status: PaymentStatus.error,
        errorMessage: errorMsg,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  /// Check order payment status
  Future<CheckOrderPaymentResponse?> checkOrderPaymentStatus(String orderId) async {
    try {
      return await _repo.checkOrderPaymentStatus(
        CheckOrderPaymentRequest(orderId: orderId),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  /// Reset state
  void reset() {
    state = const PaymentState();
  }
}

// ─────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────
final paymentProvider = NotifierProvider<PaymentViewModel, PaymentState>(
  PaymentViewModel.new,
);
