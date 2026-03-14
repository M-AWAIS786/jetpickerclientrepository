import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';

/// Facebook authentication repository matching web's facebookAuth.ts
class FacebookAuthRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  /// Login with Facebook access token
  /// Matches: POST /auth/facebook-login
  Future<Map<String, dynamic>> login({
    required String accessToken,
    String? role,
  }) async {
    final response = await _apiServices.postApi(
      {
        'accessToken': accessToken,
        if (role != null) 'role': role,
      },
      AppUrls.facebookLoginUrl,
      null, // No auth token needed for login
    );

    return response;
  }
}
