import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/repo/facebook_auth_repository.dart';

/// Facebook authentication state matching web's Auth.tsx flow
class FacebookAuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool? isNewUser;

  const FacebookAuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser,
  });

  FacebookAuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isNewUser,
    bool clearError = false,
    bool clearNewUser = false,
  }) {
    return FacebookAuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isNewUser: clearNewUser ? null : isNewUser ?? this.isNewUser,
    );
  }
}

/// Facebook auth view model matching web's handleFacebookLogin flow
class FacebookAuthViewModel extends Notifier<FacebookAuthState> {
  late final FacebookAuthRepository _repo;

  @override
  FacebookAuthState build() {
    _repo = FacebookAuthRepository();
    return const FacebookAuthState();
  }

  /// Sign in with Facebook - matches web's handleFacebookLogin
  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, clearError: true, clearNewUser: true);

    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken?.tokenString;
        
        if (accessToken == null) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to get Facebook access token',
          );
          return;
        }

        if (kDebugMode) {
          debugPrint('🔵 [Facebook] Got access token, sending to backend...');
        }

        // Send to backend - matches web's facebookAuthApi.login
        final response = await _repo.login(accessToken: accessToken);

        if (kDebugMode) {
          debugPrint('🟢 [Facebook] Backend response: $response');
        }

        // Extract data from response
        final data = response['data'] ?? response;
        final token = data['token'] as String?;
        final user = data['user'] as Map<String, dynamic>?;
        final isNewUser = data['isNewUser'] as bool? ?? false;

        if (token != null && user != null) {
          // Store auth data - matches web's storage.set calls
          await UserPreferences.saveToken(token);
          await UserPreferences.saveUser(
            id: user['id']?.toString() ?? '',
            fullName: user['full_name']?.toString() ?? '',
            email: user['email']?.toString() ?? '',
            phoneNumber: user['phone_number']?.toString() ?? '',
            avatarUrl: user['avatar_url']?.toString(),
            country: user['country']?.toString(),
          );

          // Save roles and active role
          final roles = (user['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? ['ORDERER'];
          await UserPreferences.saveUserRoles(roles);
          await UserPreferences.saveActiveRole(
            roles.contains('ORDERER') ? 'ORDERER' : roles.first,
          );

          state = state.copyWith(
            isLoading: false,
            isNewUser: isNewUser,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid response from server',
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Facebook login was cancelled',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message ?? 'Facebook login failed',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔴 [Facebook] Error: $e');
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Reset state after navigation
  void resetState() {
    state = const FacebookAuthState();
  }
}

/// Provider for Facebook auth
final facebookAuthProvider =
    NotifierProvider<FacebookAuthViewModel, FacebookAuthState>(
  FacebookAuthViewModel.new,
);
