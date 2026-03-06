import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jet_picks_app/App/models/orderer_discovery/orderer_discovery_model.dart';
import 'package:jet_picks_app/App/repo/orderer_repository.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';

// Provider for the repository
final ordererRepositoryProvider = Provider<OrdererRepository>((ref) {
  return OrdererRepository();
});

// Provider for the viewmodel
final ordererDiscoveryViewModelProvider = StateNotifierProvider<OrdererDiscoveryViewModel, OrdererDiscoveryState>((ref) {
  final repository = ref.watch(ordererRepositoryProvider);
  return OrdererDiscoveryViewModel(repository);
});

// State class
class OrdererDiscoveryState {
  final OrdererDiscvoeryResponse? response;
  final List<OrderDiscovery>? orderers;
  final bool isLoading;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;
  final String? searchQuery;

  const OrdererDiscoveryState({
    this.response,
    this.orderers,
    this.isLoading = false,
    this.errorMessage,
    this.hasMore = false,
    this.currentPage = 1,
    this.searchQuery,
  });

  OrdererDiscoveryState copyWith({
    OrdererDiscvoeryResponse? response,
    List<OrderDiscovery>? orderers,
    bool? isLoading,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
  }) {
    return OrdererDiscoveryState(
      response: response ?? this.response,
      orderers: orderers ?? this.orderers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Helper getters
  bool get hasError => errorMessage != null;
  bool get isEmpty => !isLoading && (orderers == null || orderers!.isEmpty);
  int get itemCount => orderers?.length ?? 0;
}

// ViewModel
class OrdererDiscoveryViewModel extends StateNotifier<OrdererDiscoveryState> {
  final OrdererRepository _repository;

  OrdererDiscoveryViewModel(this._repository) : super(const OrdererDiscoveryState());

  Future<void> fetchOrdererDiscovery({bool refresh = false}) async {
    // If refreshing, reset to page 1
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        orderers: [],
        currentPage: 1,
      );
    } else {
      // Don't show full screen loader for pagination
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      // Get token from saved preferences and validate
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Not authenticated. Please log in.',
        );
        return;
      }

      final response = await _repository.fetchOrdererDiscovery(token: token);
      
      List<OrderDiscovery> updatedOrderers;
      
      if (refresh) {
        updatedOrderers = response.data;
      } else {
        // Append new data to existing list for pagination
        updatedOrderers = [
          ...?state.orderers,
          ...response.data,
        ];
      }

      state = state.copyWith(
        response: response,
        orderers: updatedOrderers,
        isLoading: false,
        hasMore: response.pagination.hasMore,
        currentPage: response.pagination.page,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Method to refresh data
  Future<void> refreshOrderers() async {
    await fetchOrdererDiscovery(refresh: true);
  }

  // Method to load more data (pagination)
  Future<void> loadMoreOrderers() async {
    if (!state.hasMore || state.isLoading) return;
    
    // You would typically increment the page number here
    // and pass it to your API
    await fetchOrdererDiscovery();
  }

  // Method to search orderers
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    
    if (query.isEmpty) {
      // Reset to original list
      state = state.copyWith(
        orderers: state.response?.data,
      );
    } else {
      // Filter based on search query
      final filteredOrderers = (state.response?.data ?? []).where((orderer) {
        final fullName = orderer.orderer.fullName.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
      
      state = state.copyWith(
        orderers: filteredOrderers,
      );
    }
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}