import 'picker_order_model.dart';

class OrderDetailResponse {
  final OrderDetailModel data;

  OrderDetailResponse({required this.data});

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      data: OrderDetailModel.fromJson(json['data'] ?? json),
    );
  }
}

class OrderDetailModel {
  final String id;
  final String? ordererId;
  final String? assignedPickerId;
  final String? originCountry;
  final String? originCity;
  final String? destinationCountry;
  final String? destinationCity;
  final String? specialNotes;
  final double rewardAmount;
  final double? acceptedCounterOfferAmount;
  final int? waitingDays;
  final String status;
  final String paymentStatus; // PENDING | PAID | FAILED | REFUNDED
  final int itemsCount;
  final double itemsCost;
  final String? currency;
  final String? chatRoomId;
  final List<OrderItemDetail> items;
  final OrderUserModel? orderer;
  final OrderUserModel? picker;
  final List<OrderOfferModel> offers;
  final String? createdAt;

  OrderDetailModel({
    required this.id,
    this.ordererId,
    this.assignedPickerId,
    this.originCountry,
    this.originCity,
    this.destinationCountry,
    this.destinationCity,
    this.specialNotes,
    required this.rewardAmount,
    this.acceptedCounterOfferAmount,
    this.waitingDays,
    required this.status,
    required this.paymentStatus,
    required this.itemsCount,
    required this.itemsCost,
    this.currency,
    this.chatRoomId,
    required this.items,
    this.orderer,
    this.picker,
    required this.offers,
    this.createdAt,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'] ?? '',
      ordererId: json['orderer_id'],
      assignedPickerId: json['assigned_picker_id'],
      originCountry: json['origin_country'],
      originCity: json['origin_city'],
      destinationCountry: json['destination_country'],
      destinationCity: json['destination_city'],
      specialNotes: json['special_notes'],
      rewardAmount: _toDouble(json['reward_amount']),
      acceptedCounterOfferAmount:
          json['accepted_counter_offer_amount'] != null
              ? _toDouble(json['accepted_counter_offer_amount'])
              : null,
      waitingDays: json['waiting_days'],
      status: json['status'] ?? 'PENDING',
      paymentStatus: json['payment_status'] ?? 'PENDING',
      itemsCount: json['items_count'] ?? 0,
      itemsCost: _toDouble(json['items_cost']),
      currency: json['currency'],
      chatRoomId: json['chat_room_id'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDetail.fromJson(e))
              .toList() ??
          [],
      orderer: json['orderer'] != null
          ? OrderUserModel.fromJson(json['orderer'])
          : null,
      picker: json['picker'] != null
          ? OrderUserModel.fromJson(json['picker'])
          : null,
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => OrderOfferModel.fromJson(e))
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

  double get totalCost => itemsCost + rewardAmount;

  double get effectiveReward =>
      acceptedCounterOfferAmount ?? rewardAmount;

  /// Whether payment has been completed
  bool get isPaid => paymentStatus == 'PAID';

  /// Calculate subtotal (items + effective reward)
  double get subtotal => itemsCost + effectiveReward;

  /// JetPicker fee (6.5%)
  double get jetPickerFee => subtotal * 0.065;

  /// Payment processing fee (4%)
  double get paymentProcessingFee => subtotal * 0.04;

  /// Total payable amount including all fees
  double get totalPayable => subtotal + jetPickerFee + paymentProcessingFee;
}

class OrderItemDetail {
  final String id;
  final String? itemName;
  final String? weight;
  final double price;
  final int quantity;
  final String? currency;
  final String? specialNotes;
  final String? storeLink;
  final List<String>? productImages;

  OrderItemDetail({
    required this.id,
    this.itemName,
    this.weight,
    required this.price,
    required this.quantity,
    this.currency,
    this.specialNotes,
    this.storeLink,
    this.productImages,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      id: json['id'] ?? '',
      itemName: json['item_name'],
      weight: json['weight'],
      price: _toDouble(json['price']),
      quantity: json['quantity'] ?? 1,
      currency: json['currency'],
      specialNotes: json['special_notes'],
      storeLink: json['store_link'],
      productImages: (json['product_images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  double get subtotal => price * quantity;
}

class OrderOfferModel {
  final String id;
  final String? offerType;
  final double offerAmount;
  final String? status;
  final String? createdAt;

  OrderOfferModel({
    required this.id,
    this.offerType,
    required this.offerAmount,
    this.status,
    this.createdAt,
  });

  factory OrderOfferModel.fromJson(Map<String, dynamic> json) {
    return OrderOfferModel(
      id: json['id'] ?? '',
      offerType: json['offer_type'],
      offerAmount: _toDouble(json['offer_amount']),
      status: json['status'],
      createdAt: json['created_at'],
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
