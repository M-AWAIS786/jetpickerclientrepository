import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/user_profile/user_profile_model.dart';
import 'package:jet_picks_app/App/repo/user_profile_repository.dart';

enum UserSettingsRole { picker, orderer }

class UserSettingsState {
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final String? successMessage;
  final UserSettingsModel settings;

  const UserSettingsState({
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.successMessage,
    this.settings = const UserSettingsModel(),
  });

  UserSettingsState copyWith({
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    String? successMessage,
    UserSettingsModel? settings,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return UserSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
      settings: settings ?? this.settings,
    );
  }
}

class UserSettingsViewModel extends Notifier<UserSettingsState> {
  late final UserProfileRepository _repository;

  @override
  UserSettingsState build() {
    _repository = UserProfileRepository();
    return const UserSettingsState();
  }

  Future<void> loadSettings(UserSettingsRole role) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = role == UserSettingsRole.picker
          ? await _repository.getPickerSettings(token)
          : await _repository.getOrdererSettings(token);

      await _persistTranslationSettings(response.settings);

      state = state.copyWith(
        isLoading: false,
        settings: response.settings,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateSettings(
    UserSettingsRole role,
    Map<String, dynamic> patch,
  ) async {
    final optimisticSettings = state.settings.copyWith(
      pushNotificationsEnabled: patch.containsKey('push_notifications_enabled')
          ? patch['push_notifications_enabled'] as bool
          : null,
      inAppNotificationsEnabled: patch.containsKey('in_app_notifications_enabled')
          ? patch['in_app_notifications_enabled'] as bool
          : null,
      messageNotificationsEnabled: patch.containsKey('message_notifications_enabled')
          ? patch['message_notifications_enabled'] as bool
          : null,
      locationServicesEnabled: patch.containsKey('location_services_enabled')
          ? patch['location_services_enabled'] as bool
          : null,
      translationLanguage: patch['translation_language'] as String?,
      autoTranslateMessages: patch.containsKey('auto_translate_messages')
          ? patch['auto_translate_messages'] as bool
          : null,
      showOriginalAndTranslated: patch.containsKey('show_original_and_translated')
          ? patch['show_original_and_translated'] as bool
          : null,
    );

    final previousSettings = state.settings;
    state = state.copyWith(
      isUpdating: true,
      clearError: true,
      clearSuccess: true,
      settings: optimisticSettings,
    );

    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = role == UserSettingsRole.picker
          ? await _repository.updatePickerSettings(patch, token)
          : await _repository.updateOrdererSettings(patch, token);

      await _persistTranslationSettings(response.settings);

      state = state.copyWith(
        isUpdating: false,
        settings: response.settings,
        successMessage: response.message.isNotEmpty
            ? response.message
            : 'Settings updated successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        settings: previousSettings,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _persistTranslationSettings(UserSettingsModel settings) async {
    await UserPreferences.saveTranslationLanguage(settings.translationLanguage);
    await UserPreferences.saveAutoTranslateMessages(
      settings.autoTranslateMessages,
    );
    await UserPreferences.saveShowOriginalAndTranslated(
      settings.showOriginalAndTranslated,
    );
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final userSettingsProvider =
    NotifierProvider<UserSettingsViewModel, UserSettingsState>(
  UserSettingsViewModel.new,
);