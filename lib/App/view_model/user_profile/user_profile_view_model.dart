import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/user_profile/user_profile_model.dart';
import 'package:jet_picks_app/App/repo/user_profile_repository.dart';

// ── State ────────────────────────────────────────────────────────
class UserProfileState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploadingAvatar;
  final String? errorMessage;
  final String? successMessage;
  final UserProfileModel? profile;

  const UserProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
    this.successMessage,
    this.profile,
  });

  UserProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isUploadingAvatar,
    String? errorMessage,
    String? successMessage,
    UserProfileModel? profile,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      profile: profile ?? this.profile,
    );
  }
}

// ── ViewModel ────────────────────────────────────────────────────
class UserProfileViewModel extends Notifier<UserProfileState> {
  late final UserProfileRepository _repository;

  @override
  UserProfileState build() {
    _repository = UserProfileRepository();
    return const UserProfileState();
  }

  // GET /user/profile
  Future<void> getMyProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'Not authenticated. Please log in.');
        return;
      }
      final response = await _repository.getMyProfile(token);
      // Persist latest user data locally
      await UserPreferences.saveUser(
        id: response.user.id,
        fullName: response.user.fullName,
        email: response.user.email,
        phoneNumber: response.user.phoneNumber,
        avatarUrl: response.user.avatarUrl,
        country: response.user.country,
      );
      state = state.copyWith(isLoading: false, profile: response.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // POST /user/profile (multipart)
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
    List<String>? languages,
    File? image,
    String? newPassword,
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true, clearSuccess: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(isUpdating: false, errorMessage: 'Not authenticated. Please log in.');
        return;
      }
      final request = UpdateProfileRequestModel(
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
        languages: languages,
        newPassword: newPassword,
      );
      final response = await _repository.updateProfile(request, token, image: image);
      // Persist updated data
      await UserPreferences.saveUser(
        id: response.user.id,
        fullName: response.user.fullName,
        email: response.user.email,
        phoneNumber: response.user.phoneNumber,
        avatarUrl: response.user.avatarUrl,
        country: response.user.country,
      );
      state = state.copyWith(
        isUpdating: false,
        profile: response.user,
        successMessage: response.message,
      );
    } catch (e) {
      state = state.copyWith(isUpdating: false, errorMessage: e.toString());
    }
  }

  // POST /user/avatar (multipart)
  Future<void> updateAvatar(File image) async {
    state = state.copyWith(isUploadingAvatar: true, clearError: true, clearSuccess: true);
    try {
      final token = await UserPreferences.getToken();
      if (token == null) {
        state = state.copyWith(isUploadingAvatar: false, errorMessage: 'Not authenticated. Please log in.');
        return;
      }
      final response = await _repository.updateAvatar(image, token);
      // Persist new avatar URL and refresh profile
      if (response.avatarUrl != null && state.profile != null) {
        final updatedProfile = UserProfileModel(
          id: state.profile!.id,
          fullName: state.profile!.fullName,
          email: state.profile!.email,
          phoneNumber: state.profile!.phoneNumber,
          country: state.profile!.country,
          roles: state.profile!.roles,
          avatarUrl: response.avatarUrl,
          languages: state.profile!.languages,
          createdAt: state.profile!.createdAt,
          updatedAt: state.profile!.updatedAt,
        );
        await UserPreferences.saveUser(
          id: updatedProfile.id,
          fullName: updatedProfile.fullName,
          email: updatedProfile.email,
          phoneNumber: updatedProfile.phoneNumber,
          avatarUrl: updatedProfile.avatarUrl,
          country: updatedProfile.country,
        );
        state = state.copyWith(
          isUploadingAvatar: false,
          profile: updatedProfile,
          successMessage: response.message,
        );
      } else {
        state = state.copyWith(
          isUploadingAvatar: false,
          successMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isUploadingAvatar: false, errorMessage: e.toString());
    }
  }

  void resetMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

// ── Provider ─────────────────────────────────────────────────────
final userProfileViewModelProvider =
    NotifierProvider<UserProfileViewModel, UserProfileState>(
  UserProfileViewModel.new,
);
