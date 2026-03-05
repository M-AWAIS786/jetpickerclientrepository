import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'email';
  static const String _phoneKey = 'phone_number';
  static const String _avatarUrlKey = 'avatar_url';
  static const String _countryKey = 'country';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUser({
    required String id,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? avatarUrl,
    String? country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phoneNumber);
    if (avatarUrl != null) await prefs.setString(_avatarUrlKey, avatarUrl);
    if (country != null) await prefs.setString(_countryKey, country);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarUrlKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
