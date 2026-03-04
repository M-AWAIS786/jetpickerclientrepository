import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/auth/signup_model.dart';

class AuthRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.signupUrl,
      null,
    );
    return SignupResponseModel.fromJson(response);
  }
}
