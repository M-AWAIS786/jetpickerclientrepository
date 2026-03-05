import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/location/city_model.dart';
import 'package:jet_picks_app/App/models/location/country_model.dart';

class LocationRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<CountriesResponseModel> getCountries() async {
    final response = await _apiServices.getApi(AppUrls.countriesUrl, null);
    return CountriesResponseModel.fromJson(response);
  }

  Future<CitiesResponseModel> getCities(String countryName) async {
    final response = await _apiServices.postApi(
      {'country': countryName},
      AppUrls.citiesUrl,
      null,
    );
    return CitiesResponseModel.fromJson(response);
  }
}
