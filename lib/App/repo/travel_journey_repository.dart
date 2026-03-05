import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/travel/travel_journey_model.dart';

class TravelJourneyRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<TravelJourneysResponseModel> getTravelJourneys(String token) async {
    final response =
        await _apiServices.getApi(AppUrls.travelJourneysUrl, token);
    return TravelJourneysResponseModel.fromJson(response);
  }

  Future<TravelJourneyModel> createTravelJourney(
      Map<String, dynamic> data, String token) async {
    final response = await _apiServices.postApi(
      data,
      AppUrls.travelJourneysUrl,
      token,
    );
    return TravelJourneyModel.fromJson(response['data']);
  }

  Future<TravelJourneyModel> updateTravelJourney(
      String id, Map<String, dynamic> data, String token) async {
    final response = await _apiServices.putApi(
      data,
      '${AppUrls.travelJourneysUrl}/$id',
      token,
    );
    return TravelJourneyModel.fromJson(response['data']);
  }
}
