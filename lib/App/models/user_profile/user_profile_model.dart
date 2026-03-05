import 'package:jet_picks_app/App/constants/app_urls.dart';

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? country;
  final List<String> roles;
  final String? avatarUrl;
  final List<String> languages;
  final String createdAt;
  final String updatedAt;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.country,
    required this.roles,
    this.avatarUrl,
    required this.languages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      country: json['country'],
      roles: List<String>.from(json['roles'] ?? []),
      avatarUrl: AppUrls.resolveUrl(json['avatar_url']),
      languages: (json['languages'] as List<dynamic>? ?? []).map((e) {
        // API returns either a plain string OR an object {id, language_name}
        if (e is String) return e;
        return (e as Map<String, dynamic>)['language_name']?.toString() ?? '';
      }).where((e) => e.isNotEmpty).toList(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// ── Get My Profile ──────────────────────────────────────────────
class GetProfileResponseModel {
  final String message;
  final UserProfileModel user;

  GetProfileResponseModel({required this.message, required this.user});

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
      message: json['message'] ?? '',
      user: UserProfileModel.fromJson(json['data']),
    );
  }
}

// ── Update Profile ──────────────────────────────────────────────
class UpdateProfileRequestModel {
  final String? fullName;
  final String? phoneNumber;
  final String? country;
  final List<String>? languages;
  final String? newPassword;

  UpdateProfileRequestModel({
    this.fullName,
    this.phoneNumber,
    this.country,
    this.languages,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fullName != null) map['full_name'] = fullName;
    if (phoneNumber != null) map['phone_number'] = phoneNumber;
    if (country != null) map['country'] = country;
    if (newPassword != null && newPassword!.isNotEmpty) {
      map['new_password'] = newPassword;
      map['new_password_confirmation'] = newPassword;
    }
    if (languages != null) {
      for (int i = 0; i < languages!.length; i++) {
        map['languages[$i]'] = languages![i];
      }
    }
    return map;
  }
}

class UpdateProfileResponseModel {
  final String message;
  final UserProfileModel user;

  UpdateProfileResponseModel({required this.message, required this.user});

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      message: json['message'] ?? '',
      user: UserProfileModel.fromJson(json['data']),
    );
  }
}

// ── Update Avatar ───────────────────────────────────────────────
class UpdateAvatarResponseModel {
  final String message;
  final String? avatarUrl;

  UpdateAvatarResponseModel({required this.message, this.avatarUrl});

  factory UpdateAvatarResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateAvatarResponseModel(
      message: json['message'] ?? '',
      avatarUrl: AppUrls.resolveUrl(json['data']?['avatar_url']),
    );
  }
}
