import 'package:jet_picks_app/App/constants/app_urls.dart';
import 'package:jet_picks_app/App/data/network_api_services.dart';
import 'package:jet_picks_app/App/models/auth/signup_model.dart';
import 'package:jet_picks_app/App/models/auth/login_model.dart';

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

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _apiServices.postApi(
      request.toJson(),
      AppUrls.loginUrl,
      null,
    );
    return LoginResponseModel.fromJson(response);
  }

  Future<GoogleLoginResponseModel> googleLogin({required String accessToken}) async {
    final response = await _apiServices.postApi(
      {'idToken': accessToken},
      AppUrls.googleLoginUrl,
      null,
    );
    return GoogleLoginResponseModel.fromJson(response);
  }
}

// ─── Google Login Response ───────────────────────────────────
class GoogleLoginResponseModel {
  final String message;
  final SignupUserModel user;
  final String token;
  final bool isNewUser;

  GoogleLoginResponseModel({
    required this.message,
    required this.user,
    required this.token,
    required this.isNewUser,
  });

  factory GoogleLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponseModel(
      message: json['message'] ?? '',
      user: SignupUserModel.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
      isNewUser: json['data']['isNewUser'] ?? false,
    );
  }
}
