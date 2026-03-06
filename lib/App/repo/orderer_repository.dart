import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/orderer_discovery/orderer_discovery_model.dart';

class OrdererRepository {
    final NetworkApiServices networkApiServices
    = NetworkApiServices();


    Future<OrdererDiscvoeryResponse> fetchOrdererDiscovery({required String token}) async {
      try {
        final response = await networkApiServices.getApi(AppUrls.ordererDashboardUrl,token);
        return OrdererDiscvoeryResponse.fromJson(response);
      } catch (e) {
        rethrow;
      }
    }
}