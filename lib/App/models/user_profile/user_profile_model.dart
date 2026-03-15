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

class UserSettingsModel {
  final bool pushNotificationsEnabled;
  final bool inAppNotificationsEnabled;
  final bool messageNotificationsEnabled;
  final bool locationServicesEnabled;
  final String translationLanguage;
  final bool autoTranslateMessages;
  final bool showOriginalAndTranslated;

  const UserSettingsModel({
    this.pushNotificationsEnabled = false,
    this.inAppNotificationsEnabled = true,
    this.messageNotificationsEnabled = true,
    this.locationServicesEnabled = true,
    this.translationLanguage = 'English',
    this.autoTranslateMessages = false,
    this.showOriginalAndTranslated = true,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      pushNotificationsEnabled:
          _toBool(json['push_notifications_enabled'], false),
      inAppNotificationsEnabled:
          _toBool(json['in_app_notifications_enabled'], true),
      messageNotificationsEnabled:
          _toBool(json['message_notifications_enabled'], true),
      locationServicesEnabled:
          _toBool(json['location_services_enabled'], true),
      translationLanguage:
          json['translation_language']?.toString().trim().isNotEmpty == true
              ? json['translation_language'].toString().trim()
              : 'English',
      autoTranslateMessages: _toBool(json['auto_translate_messages'], false),
      showOriginalAndTranslated:
          _toBool(json['show_original_and_translated'], true),
    );
  }

  UserSettingsModel copyWith({
    bool? pushNotificationsEnabled,
    bool? inAppNotificationsEnabled,
    bool? messageNotificationsEnabled,
    bool? locationServicesEnabled,
    String? translationLanguage,
    bool? autoTranslateMessages,
    bool? showOriginalAndTranslated,
  }) {
    return UserSettingsModel(
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      inAppNotificationsEnabled:
          inAppNotificationsEnabled ?? this.inAppNotificationsEnabled,
      messageNotificationsEnabled:
          messageNotificationsEnabled ?? this.messageNotificationsEnabled,
      locationServicesEnabled:
          locationServicesEnabled ?? this.locationServicesEnabled,
      translationLanguage: translationLanguage ?? this.translationLanguage,
      autoTranslateMessages:
          autoTranslateMessages ?? this.autoTranslateMessages,
      showOriginalAndTranslated:
          showOriginalAndTranslated ?? this.showOriginalAndTranslated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_notifications_enabled': pushNotificationsEnabled,
      'in_app_notifications_enabled': inAppNotificationsEnabled,
      'message_notifications_enabled': messageNotificationsEnabled,
      'location_services_enabled': locationServicesEnabled,
      'translation_language': translationLanguage,
      'auto_translate_messages': autoTranslateMessages,
      'show_original_and_translated': showOriginalAndTranslated,
    };
  }
}

class UserSettingsResponseModel {
  final String message;
  final UserSettingsModel settings;

  UserSettingsResponseModel({required this.message, required this.settings});

  factory UserSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserSettingsResponseModel(
      message: json['message']?.toString() ?? '',
      settings: UserSettingsModel.fromJson(data),
    );
  }
}

bool _toBool(dynamic value, bool fallback) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return fallback;
}
