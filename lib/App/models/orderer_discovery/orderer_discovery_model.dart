import 'package:flutter/foundation.dart';

class OrdererDiscvoeryResponse {
  final List<OrderDiscovery> data;
  final Pagination pagination;

  OrdererDiscvoeryResponse({
    required this.data,
    required this.pagination,
  });

  factory OrdererDiscvoeryResponse.fromJson(Map<String, dynamic> json) {
    return OrdererDiscvoeryResponse(
      data: (json['data'] as List)
          .map((item) => OrderDiscovery.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class OrderDiscovery {
  final String id;
  final Orderer orderer;
  final String originCity;
  final String originCountry;
  final String destinationCity;
  final String destinationCountry;
  final int itemsCount;
  final int itemsCost;
  final List<String> itemsImages;
  final String rewardAmount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime earliestDeliveryDate;

  OrderDiscovery({
    required this.id,
    required this.orderer,
    required this.originCity,
    required this.originCountry,
    required this.destinationCity,
    required this.destinationCountry,
    required this.itemsCount,
    required this.itemsCost,
    required this.itemsImages,
    required this.rewardAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.earliestDeliveryDate,
  });

  factory OrderDiscovery.fromJson(Map<String, dynamic> json) {
    return OrderDiscovery(
      id: json['id'] as String,
      orderer: Orderer.fromJson(json['orderer']),
      originCity: json['origin_city'] as String,
      originCountry: json['origin_country'] as String,
      destinationCity: json['destination_city'] as String,
      destinationCountry: json['destination_country'] as String,
      itemsCount: json['items_count'] as int,
      itemsCost: json['items_cost'] as int,
      itemsImages: (json['items_images'] as List)
          .map((item) => item as String)
          .toList(),
      rewardAmount: json['reward_amount'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      earliestDeliveryDate: DateTime.parse(json['earliest_delivery_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderer': orderer.toJson(),
      'origin_city': originCity,
      'origin_country': originCountry,
      'destination_city': destinationCity,
      'destination_country': destinationCountry,
      'items_count': itemsCount,
      'items_cost': itemsCost,
      'items_images': itemsImages,
      'reward_amount': rewardAmount,
      'currency': currency,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'earliest_delivery_date': earliestDeliveryDate.toIso8601String(),
    };
  }
}

class Orderer {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final int rating;

  Orderer({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.rating,
  });

  factory Orderer.fromJson(Map<String, dynamic> json) {
    return Orderer(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      rating: json['rating'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'rating': rating,
    };
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      hasMore: json['has_more'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'has_more': hasMore,
    };
  }
}