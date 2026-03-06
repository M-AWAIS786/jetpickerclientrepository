class OrdererOrdersResponse {
  final List<OrdererOrderModel> orders;
  final OrdererPaginationModel pagination;

  OrdererOrdersResponse({required this.orders, required this.pagination});

  factory OrdererOrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdererOrdersResponse(
      orders: (json['data'] as List<dynamic>?)
              ?.map((e) => OrdererOrderModel.fromJson(e))
              .toList() ??
          [],
      pagination: OrdererPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class OrdererOrderModel {
  final String id;
  final String? pickerId;
  final String? originCity;
  final String? originCountry;
  final String? destinationCity;
  final String? destinationCountry;
  final String status;
  final int itemsCount;
  final double itemsCost;
  final double rewardAmount;
  final double? acceptedCounterOfferAmount;
  final String? currency;
  final String? createdAt;

  OrdererOrderModel({
    required this.id,
    this.pickerId,
    this.originCity,
    this.originCountry,
    this.destinationCity,
    this.destinationCountry,
    required this.status,
    required this.itemsCount,
    required this.itemsCost,
    required this.rewardAmount,
    this.acceptedCounterOfferAmount,
    this.currency,
    this.createdAt,
  });

  factory OrdererOrderModel.fromJson(Map<String, dynamic> json) {
    return OrdererOrderModel(
      id: json['id'] ?? '',
      pickerId: json['picker_id'],
      originCity: json['origin_city'],
      originCountry: json['origin_country'],
      destinationCity: json['destination_city'],
      destinationCountry: json['destination_country'],
      status: json['status'] ?? 'PENDING',
      itemsCount: json['items_count'] ?? 0,
      itemsCost: _toDouble(json['items_cost']),
      rewardAmount: _toDouble(json['reward_amount']),
      acceptedCounterOfferAmount:
          json['accepted_counter_offer_amount'] != null
              ? _toDouble(json['accepted_counter_offer_amount'])
              : null,
      currency: json['currency'],
      createdAt: json['created_at'],
    );
  }

  /// e.g. "London → Madrid"
  String get routeLabel =>
      '${originCountry ?? originCity ?? '?'} - ${destinationCountry ?? destinationCity ?? '?'}';

  String get currencySymbol {
    switch (currency?.toUpperCase()) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'USD':
      default:
        return '\$';
    }
  }

  /// Total cost including JetPicker fee (6.5%) and payment processing fee (4%)
  /// Same logic as the PHP/React frontend
  double get totalCost {
    if (acceptedCounterOfferAmount != null &&
        acceptedCounterOfferAmount! > 0) {
      final counterOfferTotal = itemsCost + acceptedCounterOfferAmount!;
      final jetPickerFee = counterOfferTotal * 0.065;
      final paymentFee = counterOfferTotal * 0.04;
      return counterOfferTotal + jetPickerFee + paymentFee;
    }
    final baseAmount = itemsCost + rewardAmount;
    final jetPickerFee = baseAmount * 0.065;
    final paymentFee = baseAmount * 0.04;
    return baseAmount + jetPickerFee + paymentFee;
  }

  String get formattedTotalCost =>
      '$currencySymbol${totalCost.toStringAsFixed(2)}';

  /// Whether this is a DRAFT order (should be filtered out)
  bool get isDraft => status.toUpperCase() == 'DRAFT';

  /// Normalized lowercase status
  String get statusLower => status.toLowerCase();
}

class OrdererPaginationModel {
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  OrdererPaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory OrdererPaginationModel.fromJson(Map<String, dynamic> json) {
    return OrdererPaginationModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      hasMore: json['has_more'] ?? false,
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
