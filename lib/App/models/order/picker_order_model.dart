class PickerOrdersResponse {
  final List<PickerOrderModel> orders;
  final PaginationModel pagination;

  PickerOrdersResponse({required this.orders, required this.pagination});

  factory PickerOrdersResponse.fromJson(Map<String, dynamic> json) {
    return PickerOrdersResponse(
      orders: (json['data'] as List<dynamic>?)
              ?.map((e) => PickerOrderModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class PickerOrderModel {
  final String id;
  final String? ordererId;
  final OrderUserModel? orderer;
  final String? originCity;
  final String? originCountry;
  final String? destinationCity;
  final String? destinationCountry;
  final String status;
  final int itemsCount;
  final double itemsCost;
  final double rewardAmount;
  final String? currency;
  final List<OrderItemBrief> items;
  final String? createdAt;

  PickerOrderModel({
    required this.id,
    this.ordererId,
    this.orderer,
    this.originCity,
    this.originCountry,
    this.destinationCity,
    this.destinationCountry,
    required this.status,
    required this.itemsCount,
    required this.itemsCost,
    required this.rewardAmount,
    this.currency,
    required this.items,
    this.createdAt,
  });

  factory PickerOrderModel.fromJson(Map<String, dynamic> json) {
    return PickerOrderModel(
      id: json['id'] ?? '',
      ordererId: json['orderer_id'],
      orderer: json['orderer'] != null
          ? OrderUserModel.fromJson(json['orderer'])
          : null,
      originCity: json['origin_city'],
      originCountry: json['origin_country'],
      destinationCity: json['destination_city'],
      destinationCountry: json['destination_country'],
      status: json['status'] ?? 'PENDING',
      itemsCount: json['items_count'] ?? 0,
      itemsCost: _toDouble(json['items_cost']),
      rewardAmount: _toDouble(json['reward_amount']),
      currency: json['currency'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemBrief.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at'],
    );
  }

  String get routeLabel =>
      '${originCity ?? originCountry ?? '?'} → ${destinationCity ?? destinationCountry ?? '?'}';

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
}

class OrderUserModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final double rating;

  OrderUserModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.rating = 0.0,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      rating: _toDouble(json['rating']),
    );
  }

  String get initials {
    if (fullName == null || fullName!.isEmpty) return '?';
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName![0].toUpperCase();
  }
}

class OrderItemBrief {
  final String id;
  final String? itemName;
  final List<String>? productImages;

  OrderItemBrief({
    required this.id,
    this.itemName,
    this.productImages,
  });

  factory OrderItemBrief.fromJson(Map<String, dynamic> json) {
    return OrderItemBrief(
      id: json['id'] ?? '',
      itemName: json['item_name'],
      productImages: (json['product_images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
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
