import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/models/location/country_model.dart';
import 'package:jet_picks_app/App/repo/location_repository.dart';

class LocationState {
  final List<CountryModel> countries;
  final List<String> departureCities;
  final List<String> arrivalCities;
  final bool loadingCountries;
  final bool loadingDepartureCities;
  final bool loadingArrivalCities;
  final String? error;

  const LocationState({
    this.countries = const [],
    this.departureCities = const [],
    this.arrivalCities = const [],
    this.loadingCountries = false,
    this.loadingDepartureCities = false,
    this.loadingArrivalCities = false,
    this.error,
  });

  LocationState copyWith({
    List<CountryModel>? countries,
    List<String>? departureCities,
    List<String>? arrivalCities,
    bool? loadingCountries,
    bool? loadingDepartureCities,
    bool? loadingArrivalCities,
    String? error,
    bool clearError = false,
  }) {
    return LocationState(
      countries: countries ?? this.countries,
      departureCities: departureCities ?? this.departureCities,
      arrivalCities: arrivalCities ?? this.arrivalCities,
      loadingCountries: loadingCountries ?? this.loadingCountries,
      loadingDepartureCities:
          loadingDepartureCities ?? this.loadingDepartureCities,
      loadingArrivalCities: loadingArrivalCities ?? this.loadingArrivalCities,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class LocationViewModel extends Notifier<LocationState> {
  late final LocationRepository _repo;

  @override
  LocationState build() {
    _repo = LocationRepository();
    Future.microtask(() => fetchCountries());
    return const LocationState();
  }

  Future<void> fetchCountries() async {
    state = state.copyWith(loadingCountries: true, clearError: true);
    try {
      final response = await _repo.getCountries();
      state = state.copyWith(countries: response.data, loadingCountries: false);
    } catch (e) {
      state = state.copyWith(
          loadingCountries: false, error: e.toString());
    }
  }

  Future<void> fetchDepartureCities(String countryName) async {
    state = state.copyWith(
        loadingDepartureCities: true, departureCities: [], clearError: true);
    try {
      final response = await _repo.getCities(countryName);
      state = state.copyWith(
          departureCities: response.data, loadingDepartureCities: false);
    } catch (e) {
      state = state.copyWith(
          loadingDepartureCities: false, error: e.toString());
    }
  }

  Future<void> fetchArrivalCities(String countryName) async {
    state = state.copyWith(
        loadingArrivalCities: true, arrivalCities: [], clearError: true);
    try {
      final response = await _repo.getCities(countryName);
      state = state.copyWith(
          arrivalCities: response.data, loadingArrivalCities: false);
    } catch (e) {
      state = state.copyWith(
          loadingArrivalCities: false, error: e.toString());
    }
  }
}

final locationViewModelProvider =
    NotifierProvider<LocationViewModel, LocationState>(LocationViewModel.new);
