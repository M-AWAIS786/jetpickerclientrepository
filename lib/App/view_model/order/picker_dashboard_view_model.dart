import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/order/picker_dashboard_model.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';

class PickerDashboardState {
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final PickerDashboardData? dashboardData;

  const PickerDashboardState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.dashboardData,
  });

  PickerDashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    PickerDashboardData? dashboardData,
    bool clearError = false,
  }) {
    return PickerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  bool get hasOrders =>
      dashboardData?.availableOrders.data.isNotEmpty ?? false;

  bool get hasJourneys =>
      dashboardData?.travelJourneys.isNotEmpty ?? false;
}

class PickerDashboardViewModel extends Notifier<PickerDashboardState> {
  late final OrderRepository _orderRepository;
  Timer? _pollingTimer;

  @override
  PickerDashboardState build() {
    _orderRepository = OrderRepository();

    // Start polling every 30 seconds (matching web frontend)
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchDashboard(silent: true),
    );

    // Cancel polling when provider is disposed
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });

    return const PickerDashboardState();
  }

  Future<void> fetchDashboard({bool silent = false}) async {
    if (state.isLoading) return;

    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      state = state.copyWith(isRefreshing: true, clearError: true);
    }

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final data = await _orderRepository.getPickerDashboard(token: token);

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        dashboardData: data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: silent ? null : e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final data = await _orderRepository.getPickerDashboard(token: token);

      state = state.copyWith(
        isRefreshing: false,
        dashboardData: data,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final pickerDashboardProvider =
    NotifierProvider<PickerDashboardViewModel, PickerDashboardState>(
  PickerDashboardViewModel.new,
);
