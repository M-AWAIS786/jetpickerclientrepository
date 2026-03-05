class TravelJourneyModel {
  final String id;
  final String userId;
  final String departureCountry;
  final String departureCity;
  final DateTime departureDate;
  final String arrivalCountry;
  final String arrivalCity;
  final DateTime arrivalDate;
  final String luggageWeightCapacity;
  final bool isActive;
  final String createdAt;

  const TravelJourneyModel({
    required this.id,
    required this.userId,
    required this.departureCountry,
    required this.departureCity,
    required this.departureDate,
    required this.arrivalCountry,
    required this.arrivalCity,
    required this.arrivalDate,
    required this.luggageWeightCapacity,
    required this.isActive,
    required this.createdAt,
  });

  factory TravelJourneyModel.fromJson(Map<String, dynamic> json) {
    return TravelJourneyModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      departureCountry: json['departure_country'] ?? '',
      departureCity: json['departure_city'] ?? '',
      departureDate: DateTime.parse(json['departure_date']),
      arrivalCountry: json['arrival_country'] ?? '',
      arrivalCity: json['arrival_city'] ?? '',
      arrivalDate: DateTime.parse(json['arrival_date']),
      luggageWeightCapacity: json['luggage_weight_capacity']?.toString() ?? '',
      isActive: (json['is_active'] == 1 || json['is_active'] == true),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class TravelJourneysResponseModel {
  final List<TravelJourneyModel> data;

  const TravelJourneysResponseModel({required this.data});

  factory TravelJourneysResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => TravelJourneyModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return TravelJourneysResponseModel(data: list);
  }
}
