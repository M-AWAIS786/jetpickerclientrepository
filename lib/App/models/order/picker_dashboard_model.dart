import 'picker_order_model.dart';

class PickerDashboardResponse {
  final PickerDashboardData data;

  PickerDashboardResponse({required this.data});

  factory PickerDashboardResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json;
    return PickerDashboardResponse(
      data: PickerDashboardData.fromJson(rawData),
    );
  }
}

class PickerDashboardData {
  final AvailableOrdersData availableOrders;
  final List<TravelJourneyModel> travelJourneys;
  final DashboardStatistics statistics;

  PickerDashboardData({
    required this.availableOrders,
    required this.travelJourneys,
    required this.statistics,
  });

  factory PickerDashboardData.fromJson(Map<String, dynamic> json) {
    return PickerDashboardData(
      availableOrders: AvailableOrdersData.fromJson(
        json['available_orders'] ?? {'data': [], 'pagination': {}},
      ),
      travelJourneys: (json['travel_journeys'] as List<dynamic>?)
              ?.map((e) => TravelJourneyModel.fromJson(e))
              .toList() ??
          [],
      statistics: DashboardStatistics.fromJson(json['statistics'] ?? {}),
    );
  }
}

class AvailableOrdersData {
  final List<DashboardOrderModel> data;
  final PaginationModel pagination;

  AvailableOrdersData({required this.data, required this.pagination});

  factory AvailableOrdersData.fromJson(Map<String, dynamic> json) {
    return AvailableOrdersData(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DashboardOrderModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class DashboardOrderModel {
  final String id;
  final OrderUserModel orderer;
  final String? originCity;
  final String? destinationCity;
  final String? earliestDeliveryDate;
  final int itemsCount;
  final double itemsCost;
  final double rewardAmount;
  final String? currency;
  final List<String> itemsImages;

  DashboardOrderModel({
    required this.id,
    required this.orderer,
    this.originCity,
    this.destinationCity,
    this.earliestDeliveryDate,
    required this.itemsCount,
    required this.itemsCost,
    required this.rewardAmount,
    this.currency,
    required this.itemsImages,
  });

  factory DashboardOrderModel.fromJson(Map<String, dynamic> json) {
    return DashboardOrderModel(
      id: json['id'] ?? '',
      orderer: OrderUserModel.fromJson(json['orderer'] ?? {}),
      originCity: json['origin_city'],
      destinationCity: json['destination_city'],
      earliestDeliveryDate: json['earliest_delivery_date'],
      itemsCount: json['items_count'] ?? 0,
      itemsCost: _toDouble(json['items_cost']),
      rewardAmount: _toDouble(json['reward_amount']),
      currency: json['currency'],
      itemsImages: (json['items_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

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

  /// Total cost calculation matching the web frontend:
  /// subtotal = itemsCost + rewardAmount
  /// jetPickerFee = subtotal * 0.065
  /// paymentFee = subtotal * 0.04
  /// total = subtotal + jetPickerFee + paymentFee
  double get totalCost {
    final subtotal = itemsCost + rewardAmount;
    final jetPickerFee = subtotal * 0.065;
    final paymentFee = subtotal * 0.04;
    return subtotal + jetPickerFee + paymentFee;
  }
}

class TravelJourneyModel {
  final String id;
  final String? departureCity;
  final String? departureCountry;
  final String? arrivalCity;
  final String? arrivalCountry;
  final String? arrivalDate;

  TravelJourneyModel({
    required this.id,
    this.departureCity,
    this.departureCountry,
    this.arrivalCity,
    this.arrivalCountry,
    this.arrivalDate,
  });

  factory TravelJourneyModel.fromJson(Map<String, dynamic> json) {
    return TravelJourneyModel(
      id: json['id'] ?? '',
      departureCity: json['departure_city'],
      departureCountry: json['departure_country'],
      arrivalCity: json['arrival_city'],
      arrivalCountry: json['arrival_country'],
      arrivalDate: json['arrival_date'],
    );
  }

  String get routeLabel =>
      '${departureCountry ?? '?'} → ${arrivalCountry ?? '?'}';

  String get formattedArrivalDate {
    if (arrivalDate == null) return '';
    try {
      final date = DateTime.parse(arrivalDate!);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return arrivalDate!;
    }
  }
}

class DashboardStatistics {
  final int totalAvailableOrders;
  final int activeJourneys;
  final int completedDeliveries;

  DashboardStatistics({
    required this.totalAvailableOrders,
    required this.activeJourneys,
    required this.completedDeliveries,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalAvailableOrders: json['total_available_orders'] ?? 0,
      activeJourneys: json['active_journeys'] ?? 0,
      completedDeliveries: json['completed_deliveries'] ?? 0,
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
