/// Stripe payment models matching the web frontend API
/// 
/// Matches: frontend/src/services/stripe.ts

// ─────────────────────────────────────────────────────────────
// Create Payment Intent
// ─────────────────────────────────────────────────────────────
class CreatePaymentIntentRequest {
  final int amount; // Amount in cents (e.g., 5000 = $50.00)
  final String currency;
  final String? description;
  final String? customerEmail;
  final Map<String, dynamic>? metadata;
  final String? orderId;

  CreatePaymentIntentRequest({
    required this.amount,
    required this.currency,
    this.description,
    this.customerEmail,
    this.metadata,
    this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      if (description != null) 'description': description,
      if (customerEmail != null) 'customer_email': customerEmail,
      if (metadata != null) 'metadata': metadata,
      if (orderId != null) 'order_id': orderId,
    };
  }
}

class CreatePaymentIntentResponse {
  final bool success;
  final String clientSecret;
  final String paymentIntentId;
  final int amount;
  final String currency;
  final String status;

  CreatePaymentIntentResponse({
    required this.success,
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory CreatePaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentIntentResponse(
      success: json['success'] ?? false,
      clientSecret: json['clientSecret'] ?? '',
      paymentIntentId: json['paymentIntentId'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
      status: json['status'] ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Confirm Payment
// ─────────────────────────────────────────────────────────────
class ConfirmPaymentRequest {
  final String paymentIntentId;

  ConfirmPaymentRequest({required this.paymentIntentId});

  Map<String, dynamic> toJson() {
    return {'paymentIntentId': paymentIntentId};
  }
}

class ConfirmPaymentResponse {
  final bool success;
  final String status;
  final String paymentIntentId;
  final int amount;
  final String currency;

  ConfirmPaymentResponse({
    required this.success,
    required this.status,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
  });

  factory ConfirmPaymentResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmPaymentResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? '',
      paymentIntentId: json['paymentIntentId'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Check Order Payment Status
// ─────────────────────────────────────────────────────────────
class CheckOrderPaymentRequest {
  final String orderId;

  CheckOrderPaymentRequest({required this.orderId});

  Map<String, dynamic> toJson() {
    return {'order_id': orderId};
  }
}

class LatestPayment {
  final String id;
  final String status;
  final String amount;
  final String currency;
  final String? paidAt;

  LatestPayment({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    this.paidAt,
  });

  factory LatestPayment.fromJson(Map<String, dynamic> json) {
    return LatestPayment(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'] ?? '0',
      currency: json['currency'] ?? 'usd',
      paidAt: json['paid_at'],
    );
  }
}

class CheckOrderPaymentResponse {
  final bool success;
  final String orderId;
  final String paymentStatus; // 'PENDING' | 'PAID' | 'FAILED' | 'REFUNDED'
  final bool isPaid;
  final String? paymentCompletedAt;
  final String? stripePaymentIntentId;
  final String orderStatus;
  final LatestPayment? latestPayment;

  CheckOrderPaymentResponse({
    required this.success,
    required this.orderId,
    required this.paymentStatus,
    required this.isPaid,
    this.paymentCompletedAt,
    this.stripePaymentIntentId,
    required this.orderStatus,
    this.latestPayment,
  });

  factory CheckOrderPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CheckOrderPaymentResponse(
      success: json['success'] ?? false,
      orderId: json['order_id'] ?? '',
      paymentStatus: json['payment_status'] ?? 'PENDING',
      isPaid: json['is_paid'] ?? false,
      paymentCompletedAt: json['payment_completed_at'],
      stripePaymentIntentId: json['stripe_payment_intent_id'],
      orderStatus: json['order_status'] ?? '',
      latestPayment: json['latest_payment'] != null
          ? LatestPayment.fromJson(json['latest_payment'])
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helper Functions (matching web frontend)
// ─────────────────────────────────────────────────────────────

/// Convert dollars to cents (e.g., 50.00 → 5000)
int formatAmountToCents(double amount) {
  return (amount * 100).round();
}

/// Convert cents to formatted string (e.g., 5000 → "50.00")
String formatAmountFromCents(int amount) {
  return (amount / 100).toStringAsFixed(2);
}
