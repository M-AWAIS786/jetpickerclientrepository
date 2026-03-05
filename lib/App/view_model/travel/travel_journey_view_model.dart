import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/travel/travel_journey_model.dart';
import 'package:jet_picks_app/App/repo/travel_journey_repository.dart';

class TravelJourneyState {
  final bool isLoading;
  final bool isSaving;
  final List<TravelJourneyModel> journeys;
  final String? error;
  final String? successMessage;

  const TravelJourneyState({
    this.isLoading = false,
    this.isSaving = false,
    this.journeys = const [],
    this.error,
    this.successMessage,
  });

  TravelJourneyState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<TravelJourneyModel>? journeys,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return TravelJourneyState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      journeys: journeys ?? this.journeys,
      error: clearError ? null : error ?? this.error,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  /// Returns the first active journey, or null if none.
  TravelJourneyModel? get activeJourney =>
      journeys.where((j) => j.isActive).firstOrNull;
}

class TravelJourneyViewModel extends Notifier<TravelJourneyState> {
  late final TravelJourneyRepository _repo;

  @override
  TravelJourneyState build() {
    _repo = TravelJourneyRepository();
    Future.microtask(() => fetchTravelJourneys());
    return const TravelJourneyState(isLoading: true); // start loading immediately
  }

  Future<void> fetchTravelJourneys() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(
            isLoading: false, error: 'Not authenticated. Please log in.');
        return;
      }
      final response = await _repo.getTravelJourneys(token);
      state = state.copyWith(isLoading: false, journeys: response.data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Creates a new journey or updates the existing active one.
  /// [luggageDisplay] is the display value like "20 kg" — stripped to "20kg" for the API.
  Future<bool> saveJourney({
    required String departureCountry,
    required String departureCity,
    required String departureDate, // "yyyy-MM-dd"
    required String arrivalCountry,
    required String arrivalCity,
    required String arrivalDate,   // "yyyy-MM-dd"
    required String luggageDisplay,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(
            isSaving: false, error: 'Not authenticated. Please log in.');
        return false;
      }

      // API expects "20kg" not "20 kg"
      final luggage = luggageDisplay.replaceAll(' ', '');

      final payload = {
        'departure_country': departureCountry,
        'departure_city': departureCity,
        'departure_date': departureDate,
        'arrival_country': arrivalCountry,
        'arrival_city': arrivalCity,
        'arrival_date': arrivalDate,
        'luggage_weight_capacity': luggage,
      };

      final existing = state.activeJourney;
      TravelJourneyModel saved;

      if (existing != null) {
        // UPDATE existing journey
        saved = await _repo.updateTravelJourney(existing.id, payload, token);
        final updatedList = state.journeys
            .map((j) => j.id == saved.id ? saved : j)
            .toList();
        state = state.copyWith(
          isSaving: false,
          journeys: updatedList,
          successMessage: 'Travel journey updated successfully.',
        );
      } else {
        // CREATE new journey
        saved = await _repo.createTravelJourney(payload, token);
        state = state.copyWith(
          isSaving: false,
          journeys: [...state.journeys, saved],
          successMessage: 'Travel journey saved successfully.',
        );
      }
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  /// Updates ONLY the luggage weight of the active journey.
  Future<bool> updateLuggage(String luggageDisplay) async {
    final existing = state.activeJourney;
    if (existing == null) return false;

    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(isSaving: false, error: 'Not authenticated. Please log in.');
        return false;
      }

      final luggage = luggageDisplay.replaceAll(' ', ''); // "20 kg" → "20kg"
      final saved = await _repo.updateTravelJourney(
        existing.id,
        {'luggage_weight_capacity': luggage},
        token,
      );

      final updatedList =
          state.journeys.map((j) => j.id == saved.id ? saved : j).toList();
      state = state.copyWith(
        isSaving: false,
        journeys: updatedList,
        successMessage: 'Luggage capacity updated.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

final travelJourneyViewModelProvider =
    NotifierProvider<TravelJourneyViewModel, TravelJourneyState>(
  TravelJourneyViewModel.new,
);
