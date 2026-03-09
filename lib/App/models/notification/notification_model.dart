/// Notification model matching the web frontend's notification structure.
/// Maps to: GET /api/notifications
class AppNotification {
  final String id;
  final String type;
  final String entityId;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? readAt;
  final String? notificationShownAt;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.entityId,
    required this.title,
    required this.message,
    this.data,
    required this.isRead,
    this.readAt,
    this.notificationShownAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
      isRead: json['is_read'] == true,
      readAt: json['read_at']?.toString(),
      notificationShownAt: json['notification_shown_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  int get timestamp {
    try {
      return DateTime.parse(createdAt).millisecondsSinceEpoch;
    } catch (_) {
      return 0;
    }
  }
}

class NotificationsResponse {
  final List<AppNotification> data;
  final NotificationPagination pagination;

  NotificationsResponse({required this.data, required this.pagination});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination:
          NotificationPagination.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class NotificationPagination {
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  NotificationPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      hasMore: json['has_more'] == true,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Typed notification models (matching web frontend)
// ─────────────────────────────────────────────────────────────

/// Picker: NEW_ORDER_AVAILABLE
class NewOrderNotification {
  final String id;
  final String orderId;
  final String ordererName;
  final String originCity;
  final String originCountry;
  final String destinationCity;
  final String destinationCountry;
  final double rewardAmount;
  final bool isRead;
  final int timestamp;

  NewOrderNotification({
    required this.id,
    required this.orderId,
    required this.ordererName,
    required this.originCity,
    required this.originCountry,
    required this.destinationCity,
    required this.destinationCountry,
    required this.rewardAmount,
    required this.isRead,
    required this.timestamp,
  });

  factory NewOrderNotification.fromNotification(AppNotification n) {
    return NewOrderNotification(
      id: n.id,
      orderId: n.entityId,
      ordererName: n.data?['orderer_name']?.toString() ?? 'Unknown',
      originCity: n.data?['origin_city']?.toString() ?? '',
      originCountry: n.data?['origin_country']?.toString() ?? '',
      destinationCity: n.data?['destination_city']?.toString() ?? '',
      destinationCountry: n.data?['destination_country']?.toString() ?? '',
      rewardAmount: _toDouble(n.data?['reward_amount']),
      isRead: n.isRead,
      timestamp: n.timestamp,
    );
  }
}

/// Orderer: ORDER_ACCEPTED
class AcceptedOrderNotification {
  final String id;
  final String pickerName;
  final String orderId;
  final bool isRead;
  final int timestamp;

  AcceptedOrderNotification({
    required this.id,
    required this.pickerName,
    required this.orderId,
    required this.isRead,
    required this.timestamp,
  });

  factory AcceptedOrderNotification.fromNotification(AppNotification n) {
    return AcceptedOrderNotification(
      id: n.id,
      pickerName: n.data?['picker_name']?.toString() ?? n.message,
      orderId: n.entityId,
      isRead: n.isRead,
      timestamp: n.timestamp,
    );
  }
}

/// Orderer: COUNTER_OFFER_RECEIVED
class CounterOfferNotification {
  final String id;
  final String pickerName;
  final String orderId;
  final String offerId;
  final bool isRead;
  final int timestamp;

  CounterOfferNotification({
    required this.id,
    required this.pickerName,
    required this.orderId,
    required this.offerId,
    required this.isRead,
    required this.timestamp,
  });

  factory CounterOfferNotification.fromNotification(AppNotification n) {
    return CounterOfferNotification(
      id: n.id,
      pickerName: n.data?['picker_name']?.toString() ?? n.message,
      orderId: n.data?['order_id']?.toString() ?? '',
      offerId: n.entityId,
      isRead: n.isRead,
      timestamp: n.timestamp,
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
