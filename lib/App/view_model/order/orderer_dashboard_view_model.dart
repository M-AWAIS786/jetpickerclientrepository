import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/repo/order_repository.dart';

class AvailablePicker {
  final String id;
  final String pickerId;
  final String pickerName;
  final String? pickerAvatarUrl;
  final double pickerRating;
  final int completedDeliveries;
  final String departureCountry;
  final String departureCity;
  final String departureDate;
  final String arrivalCountry;
  final String arrivalCity;
  final String arrivalDate;
  final double luggageWeightCapacity;

  AvailablePicker({
    required this.id,
    required this.pickerId,
    required this.pickerName,
    this.pickerAvatarUrl,
    required this.pickerRating,
    required this.completedDeliveries,
    required this.departureCountry,
    required this.departureCity,
    required this.departureDate,
    required this.arrivalCountry,
    required this.arrivalCity,
    required this.arrivalDate,
    required this.luggageWeightCapacity,
  });

  factory AvailablePicker.fromJson(Map<String, dynamic> json) {
    final picker = json['picker'] as Map<String, dynamic>? ?? {};
    return AvailablePicker(
      id: json['id']?.toString() ?? '',
      pickerId: picker['id']?.toString() ?? '',
      pickerName: picker['full_name']?.toString() ?? 'Unknown',
      pickerAvatarUrl: picker['avatar_url']?.toString(),
      pickerRating: _toDouble(picker['rating']),
      completedDeliveries: picker['completed_deliveries'] as int? ?? 0,
      departureCountry: json['departure_country']?.toString() ?? '',
      departureCity: json['departure_city']?.toString() ?? '',
      departureDate: json['departure_date']?.toString() ?? '',
      arrivalCountry: json['arrival_country']?.toString() ?? '',
      arrivalCity: json['arrival_city']?.toString() ?? '',
      arrivalDate: json['arrival_date']?.toString() ?? '',
      luggageWeightCapacity: _toDouble(json['luggage_weight_capacity']),
    );
  }

  String get initials {
    if (pickerName.isEmpty) return '?';
    final parts = pickerName.split(' ');
    if (parts.length > 1) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return pickerName[0].toUpperCase();
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class OrdererDashboardState {
  final bool isLoading;
  final String? errorMessage;
  final List<AvailablePicker> pickers;

  const OrdererDashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.pickers = const [],
  });

  OrdererDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AvailablePicker>? pickers,
    bool clearError = false,
  }) {
    return OrdererDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      pickers: pickers ?? this.pickers,
    );
  }
}

class OrdererDashboardViewModel extends Notifier<OrdererDashboardState> {
  late final OrderRepository _repo;

  @override
  OrdererDashboardState build() {
    _repo = OrderRepository();
    return const OrdererDashboardState();
  }

  Future<void> fetchDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await _repo.getOrdererDashboard(token: token);
      final data = response['data'] ?? response;
      final pickersRaw =
          data['available_pickers']?['data'] ?? data['available_pickers'] ?? [];

      final pickers = (pickersRaw as List)
          .map((e) => AvailablePicker.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(isLoading: false, pickers: pickers);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() => fetchDashboard();
}

final ordererDashboardProvider =
    NotifierProvider<OrdererDashboardViewModel, OrdererDashboardState>(
  OrdererDashboardViewModel.new,
);
