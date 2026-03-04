class SignupRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final List<String> roles;

  SignupRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.roles,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'confirm_password': confirmPassword,
      'roles': roles,
    };
  }
}

class SignupUserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? country;
  final List<String> roles;
  final String? avatarUrl;
  final String createdAt;
  final String updatedAt;

  SignupUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.country,
    required this.roles,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignupUserModel.fromJson(Map<String, dynamic> json) {
    return SignupUserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      country: json['country'],
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class SignupResponseModel {
  final String message;
  final SignupUserModel user;
  final String token;

  SignupResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      message: json['message'] ?? '',
      user: SignupUserModel.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
    );
  }
}
