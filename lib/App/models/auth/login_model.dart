import 'package:jet_picks_app/App/models/auth/signup_model.dart';

class LoginRequestModel {
  final String username;
  final String password;

  LoginRequestModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponseModel {
  final String message;
  final SignupUserModel user;
  final String token;

  LoginResponseModel({required this.message, required this.user, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      user: SignupUserModel.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
    );
  }
}
