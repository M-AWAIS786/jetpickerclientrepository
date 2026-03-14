import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'email';
  static const String _phoneKey = 'phone_number';
  static const String _avatarUrlKey = 'avatar_url';
  static const String _countryKey = 'country';
  static const String _activeRoleKey = 'active_role';
  static const String _userRolesKey = 'user_roles';
  // Translation settings keys
  static const String _translationLanguageKey = 'translation_language';
  static const String _autoTranslateMessagesKey = 'auto_translate_messages';
  static const String _showOriginalAndTranslatedKey = 'show_original_and_translated';

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

  static Future<void> saveActiveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRoleKey, role);
  }

  static Future<String?> getActiveRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeRoleKey);
  }

  static Future<void> saveUserRoles(List<String> roles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_userRolesKey, roles);
  }

  static Future<List<String>> getUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_userRolesKey) ?? [];
  }

  static Future<bool> canSwitchRole() async {
    final roles = await getUserRoles();
    return roles.length > 1;
  }

  // ── Translation Settings ──
  static Future<void> saveTranslationLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_translationLanguageKey, language);
  }

  static Future<String?> getTranslationLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_translationLanguageKey);
  }

  static Future<void> saveAutoTranslateMessages(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoTranslateMessagesKey, value);
  }

  static Future<bool?> getAutoTranslateMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoTranslateMessagesKey);
  }

  static Future<void> saveShowOriginalAndTranslated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showOriginalAndTranslatedKey, value);
  }

  static Future<bool?> getShowOriginalAndTranslated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showOriginalAndTranslatedKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
