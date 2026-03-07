import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';
import 'package:jet_picks_app/App/models/order/order_detail_model.dart';

/// Represents a single item in the create-order flow
class CreateOrderItem {
  final String id;
  String name;
  String storeLink;
  String weight;
  String weightUnit;
  String price;
  String quantity;
  String notes;
  String currency;
  List<File> images;

  CreateOrderItem({
    required this.id,
    this.name = '',
    this.storeLink = '',
    this.weight = '',
    this.weightUnit = 'kg',
    this.price = '',
    this.quantity = '',
    this.notes = '',
    this.currency = 'USD',
    List<File>? images,
  }) : images = images ?? [];
}

/// State for the create order flow
class CreateOrderState {
  final int currentStep;
  final bool isLoading;
  final String? errorMessage;
  final String? validationError;

  // Step 1: Delivery Route
  final String originCountry;
  final String originCity;
  final String destinationCountry;
  final String destinationCity;

  // Step 2: Order Items
  final List<CreateOrderItem> items;
  final String waitingDays;
  final String currencyCode;
  final String currencySymbol;

  // Step 3: Reward
  final String reward;

  // Step 4: Summary
  final bool termsAgreed;
  final bool lawsAgreed;
  final bool orderPlaced;

  // Backend references
  final String? orderId;
  final String? selectedPickerId;
  final OrderDetailModel? orderDetail;

  // Pre-filled picker route (when coming from picker selection)
  final Map<String, String>? pickerRoute;

  const CreateOrderState({
    this.currentStep = 0,
    this.isLoading = false,
    this.errorMessage,
    this.validationError,
    this.originCountry = '',
    this.originCity = '',
    this.destinationCountry = '',
    this.destinationCity = '',
    this.items = const [],
    this.waitingDays = '',
    this.currencyCode = 'USD',
    this.currencySymbol = '\$',
    this.reward = '',
    this.termsAgreed = false,
    this.lawsAgreed = false,
    this.orderPlaced = false,
    this.orderId,
    this.selectedPickerId,
    this.orderDetail,
    this.pickerRoute,
  });

  CreateOrderState copyWith({
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
    String? validationError,
    String? originCountry,
    String? originCity,
    String? destinationCountry,
    String? destinationCity,
    List<CreateOrderItem>? items,
    String? waitingDays,
    String? currencyCode,
    String? currencySymbol,
    String? reward,
    bool? termsAgreed,
    bool? lawsAgreed,
    bool? orderPlaced,
    String? orderId,
    String? selectedPickerId,
    OrderDetailModel? orderDetail,
    Map<String, String>? pickerRoute,
    bool clearError = false,
    bool clearValidation = false,
    bool clearOrderDetail = false,
  }) {
    return CreateOrderState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      validationError:
          clearValidation ? null : validationError ?? this.validationError,
      originCountry: originCountry ?? this.originCountry,
      originCity: originCity ?? this.originCity,
      destinationCountry: destinationCountry ?? this.destinationCountry,
      destinationCity: destinationCity ?? this.destinationCity,
      items: items ?? this.items,
      waitingDays: waitingDays ?? this.waitingDays,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      reward: reward ?? this.reward,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      lawsAgreed: lawsAgreed ?? this.lawsAgreed,
      orderPlaced: orderPlaced ?? this.orderPlaced,
      orderId: orderId ?? this.orderId,
      selectedPickerId: selectedPickerId ?? this.selectedPickerId,
      orderDetail:
          clearOrderDetail ? null : orderDetail ?? this.orderDetail,
      pickerRoute: pickerRoute ?? this.pickerRoute,
    );
  }

  double get itemsTotal {
    double total = 0;
    if (orderDetail != null) {
      for (final item in orderDetail!.items) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  double get rewardAmount {
    if (orderDetail != null) return orderDetail!.rewardAmount;
    return double.tryParse(reward) ?? 0;
  }

  double get subtotal => itemsTotal + rewardAmount;
  double get jetPickerFee => subtotal * 0.065;
  double get paymentProcessingFee => subtotal * 0.04;
  double get totalCost => subtotal + jetPickerFee + paymentProcessingFee;

  bool get hasPickerRoute => pickerRoute != null;
}

class CreateOrderViewModel extends Notifier<CreateOrderState> {
  late final OrderRepository _repo;

  @override
  CreateOrderState build() {
    _repo = OrderRepository();
    return CreateOrderState(
      items: [
        CreateOrderItem(id: '1'),
      ],
    );
  }

  void reset() {
    state = CreateOrderState(
      items: [CreateOrderItem(id: '1')],
    );
  }

  void initWithPickerRoute(Map<String, String> route, String pickerId) {
    state = state.copyWith(
      originCountry: route['departure_country'] ?? '',
      originCity: route['departure_city'] ?? '',
      destinationCountry: route['arrival_country'] ?? '',
      destinationCity: route['arrival_city'] ?? '',
      selectedPickerId: pickerId,
      pickerRoute: route,
    );
  }

  // ── Step 1 Setters ──
  void setOriginCountry(String value) =>
      state = state.copyWith(originCountry: value, clearValidation: true);
  void setOriginCity(String value) =>
      state = state.copyWith(originCity: value, clearValidation: true);
  void setDestinationCountry(String value) =>
      state = state.copyWith(destinationCountry: value, clearValidation: true);
  void setDestinationCity(String value) =>
      state = state.copyWith(destinationCity: value, clearValidation: true);

  // ── Step 2 Setters ──
  void setWaitingDays(String value) =>
      state = state.copyWith(waitingDays: value, clearValidation: true);

  void setCurrency(String code, String symbol) =>
      state = state.copyWith(currencyCode: code, currencySymbol: symbol);

  void updateItem(String itemId, void Function(CreateOrderItem) updater) {
    final items = List<CreateOrderItem>.from(state.items);
    final index = items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      updater(items[index]);
      state = state.copyWith(items: items, clearValidation: true);
    }
  }

  void addItem() {
    final items = List<CreateOrderItem>.from(state.items);
    items.add(CreateOrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      currency: state.currencyCode,
    ));
    state = state.copyWith(items: items);
  }

  void removeItemImage(String itemId, int imageIndex) {
    final items = List<CreateOrderItem>.from(state.items);
    final index = items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      items[index].images.removeAt(imageIndex);
      state = state.copyWith(items: items);
    }
  }

  void addItemImages(String itemId, List<File> files) {
    final items = List<CreateOrderItem>.from(state.items);
    final index = items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      items[index].images.addAll(files);
      state = state.copyWith(items: items);
    }
  }

  // ── Step 3 Setters ──
  void setReward(String value) =>
      state = state.copyWith(reward: value, clearValidation: true);

  // ── Step 4 Setters ──
  void setTermsAgreed(bool value) => state = state.copyWith(termsAgreed: value);
  void setLawsAgreed(bool value) => state = state.copyWith(lawsAgreed: value);

  // ── Step 1: Create Order on Backend ──
  Future<bool> submitStep1() async {
    if (state.originCountry.isEmpty || state.destinationCountry.isEmpty) {
      state = state.copyWith(
        validationError: 'Please select both origin and destination countries',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearValidation: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final originCity =
          state.originCity.isEmpty ? 'Any City' : state.originCity;
      final destinationCity =
          state.destinationCity.isEmpty ? 'Any City' : state.destinationCity;

      String? orderId = state.orderId;

      if (orderId == null) {
        final response = await _repo.createOrder(
          token: token,
          originCountry: state.originCountry,
          originCity: originCity,
          destinationCountry: state.destinationCountry,
          destinationCity: destinationCity,
          pickerId: state.selectedPickerId,
          status: state.selectedPickerId == null ? 'DRAFT' : null,
        );
        orderId = response['data']?['id'] ?? response['id'];
      }

      state = state.copyWith(
        isLoading: false,
        orderId: orderId,
        originCity: originCity,
        destinationCity: destinationCity,
        currentStep: 1,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        validationError: e.toString(),
      );
      return false;
    }
  }

  // ── Step 2: Save Items to Backend ──
  Future<bool> submitStep2() async {
    // Validate
    for (final item in state.items) {
      if (item.name.trim().isEmpty) {
        state = state.copyWith(
            validationError: 'Please fill in the item name for all items');
        return false;
      }
      if (item.quantity.trim().isEmpty) {
        state = state.copyWith(
            validationError: 'Please fill in the quantity for all items');
        return false;
      }
      if (item.price.trim().isEmpty) {
        state = state.copyWith(
            validationError: 'Please fill in the price for all items');
        return false;
      }
    }

    if (state.waitingDays.trim().isEmpty) {
      state = state.copyWith(
          validationError: 'Please specify how long you can wait for your items');
      return false;
    }

    state = state.copyWith(isLoading: true, clearValidation: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');
      final orderId = state.orderId!;

      // Delete existing items first
      try {
        await _repo.deleteOrderItems(token: token, orderId: orderId);
      } catch (_) {
        // Ignore if no items exist yet
      }

      // Update waiting days
      await _repo.updateOrder(
        token: token,
        orderId: orderId,
        data: {'waiting_days': int.parse(state.waitingDays)},
      );

      // Save each item
      for (final item in state.items) {
        final weight = item.weight.isNotEmpty
            ? '${item.weight} ${item.weightUnit}'
            : '';
        await _repo.addOrderItem(
          token: token,
          orderId: orderId,
          itemName: item.name,
          quantity: int.tryParse(item.quantity) ?? 1,
          price: item.price,
          currency: item.currency.isNotEmpty ? item.currency : state.currencyCode,
          weight: weight,
          specialNotes: item.notes,
          storeLink: item.storeLink,
          productImages: item.images.isNotEmpty ? item.images : null,
        );
      }

      state = state.copyWith(isLoading: false, currentStep: 2);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        validationError: e.toString(),
      );
      return false;
    }
  }

  // ── Step 3: Save Reward to Backend ──
  Future<bool> submitStep3() async {
    if (state.reward.trim().isEmpty) {
      state = state.copyWith(validationError: 'Please enter a reward amount');
      return false;
    }

    state = state.copyWith(isLoading: true, clearValidation: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final rewardAmount = (double.tryParse(state.reward) ?? 0).round();
      await _repo.setReward(
        token: token,
        orderId: state.orderId!,
        rewardAmount: rewardAmount,
      );

      // Fetch order details for the summary
      final detail = await _repo.getOrderDetail(
        token: token,
        orderId: state.orderId!,
      );

      state = state.copyWith(
        isLoading: false,
        orderDetail: detail,
        currentStep: 3,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        validationError: e.toString(),
      );
      return false;
    }
  }

  // ── Step 4: Fetch latest order detail for summary ──
  Future<void> fetchOrderSummary() async {
    if (state.orderId == null) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');
      final detail = await _repo.getOrderDetail(
        token: token,
        orderId: state.orderId!,
      );
      state = state.copyWith(isLoading: false, orderDetail: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ── Step 4: Place Order (Finalize) ──
  Future<bool> placeOrder() async {
    if (!state.termsAgreed || !state.lawsAgreed) {
      state = state.copyWith(
        validationError: 'Please agree to terms and custom laws',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearValidation: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _repo.finalizeOrder(
        token: token,
        orderId: state.orderId!,
      );

      state = state.copyWith(isLoading: false, orderPlaced: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        validationError: e.toString(),
      );
      return false;
    }
  }

  void goBack() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}

final createOrderProvider =
    NotifierProvider<CreateOrderViewModel, CreateOrderState>(
  CreateOrderViewModel.new,
);
