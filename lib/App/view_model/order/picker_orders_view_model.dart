import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/picker_order_model.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';

class PickerOrdersState {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<PickerOrderModel> orders;
  final PaginationModel? pagination;
  final String selectedTab;

  const PickerOrdersState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.orders = const [],
    this.pagination,
    this.selectedTab = 'All',
  });

  PickerOrdersState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    List<PickerOrderModel>? orders,
    PaginationModel? pagination,
    String? selectedTab,
    bool clearError = false,
  }) {
    return PickerOrdersState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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

class PickerOrdersViewModel extends Notifier<PickerOrdersState> {
  late final OrderRepository _orderRepository;

  @override
  PickerOrdersState build() {
    _orderRepository = OrderRepository();
    return const PickerOrdersState();
  }

  Future<void> fetchOrders({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await _orderRepository.getPickerOrders(
        token: token,
        status: state.apiStatus,
        page: 1,
      );

      state = state.copyWith(
        isLoading: false,
        orders: response.orders,
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
      final response = await _orderRepository.getPickerOrders(
        token: token,
        status: state.apiStatus,
        page: nextPage,
      );

      state = state.copyWith(
        isLoadingMore: false,
        orders: [...state.orders, ...response.orders],
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

  Future<void> acceptOrder(String orderId) async {
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      await _orderRepository.acceptOrder(token: token, orderId: orderId);
      await fetchOrders(refresh: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final pickerOrdersProvider =
    NotifierProvider<PickerOrdersViewModel, PickerOrdersState>(
  PickerOrdersViewModel.new,
);
