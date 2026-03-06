import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/orderer_order_model.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';

class OrdererOrdersState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isCancelling;
  final String? errorMessage;
  final List<OrdererOrderModel> orders;
  final OrdererPaginationModel? pagination;
  final String selectedTab;

  const OrdererOrdersState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isCancelling = false,
    this.errorMessage,
    this.orders = const [],
    this.pagination,
    this.selectedTab = 'All',
  });

  OrdererOrdersState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isCancelling,
    String? errorMessage,
    List<OrdererOrderModel>? orders,
    OrdererPaginationModel? pagination,
    String? selectedTab,
    bool clearError = false,
  }) {
    return OrdererOrdersState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isCancelling: isCancelling ?? this.isCancelling,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  String? get apiStatus {
    switch (selectedTab) {
      case 'Pending':
        return 'PENDING';
      case 'Accepted':
        return 'ACCEPTED';
      case 'Delivered':
        return 'DELIVERED';
      case 'Cancelled':
        return 'CANCELLED';
      default:
        return null;
    }
  }
}

class OrdererOrdersViewModel extends Notifier<OrdererOrdersState> {
  late final OrderRepository _orderRepository;

  @override
  OrdererOrdersState build() {
    _orderRepository = OrderRepository();
    return const OrdererOrdersState();
  }

  Future<void> fetchOrders({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await _orderRepository.getOrdererOrders(
        token: token,
        status: state.apiStatus,
        page: 1,
      );

      // Filter out DRAFT orders (same as PHP frontend)
      final filteredOrders =
          response.orders.where((o) => !o.isDraft).toList();

      state = state.copyWith(
        isLoading: false,
        orders: filteredOrders,
        pagination: response.pagination,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;
    if (state.pagination == null || !state.pagination!.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final nextPage = state.pagination!.page + 1;
      final response = await _orderRepository.getOrdererOrders(
        token: token,
        status: state.apiStatus,
        page: nextPage,
      );

      final filteredOrders =
          response.orders.where((o) => !o.isDraft).toList();

      state = state.copyWith(
        isLoadingMore: false,
        orders: [...state.orders, ...filteredOrders],
        pagination: response.pagination,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectTab(String tab) {
    if (state.selectedTab == tab) return;
    state = state.copyWith(selectedTab: tab, orders: [], pagination: null);
    fetchOrders();
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      state = state.copyWith(isCancelling: true, clearError: true);

      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.cancelOrder(token: token, orderId: orderId);

      // Refresh the full list after cancellation
      state = state.copyWith(isCancelling: false);
      await fetchOrders(refresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isCancelling: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final ordererOrdersProvider =
    NotifierProvider<OrdererOrdersViewModel, OrdererOrdersState>(
  OrdererOrdersViewModel.new,
);
