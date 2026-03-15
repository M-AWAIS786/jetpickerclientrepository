import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/models/auth/signup_model.dart';
import 'package:jet_picks_app/App/repo/auth_repository.dart';

// --- State ---
class SignupState {
  final bool isLoading;
  final String? errorMessage;
  final SignupResponseModel? response;

  const SignupState({
    this.isLoading = false,
    this.errorMessage,
    this.response,
  });

  SignupState copyWith({
    bool? isLoading,
    String? errorMessage,
    SignupResponseModel? response,
    bool clearError = false,
    bool clearResponse = false,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      response: clearResponse ? null : response ?? this.response,
    );
  }
}

// --- ViewModel ---
class SignupViewModel extends Notifier<SignupState> {
  late final AuthRepository _authRepository;

  @override
  SignupState build() {
    _authRepository = AuthRepository();
    return const SignupState();
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required List<String> roles,
    required String preferredRole,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearResponse: true);

    try {
      final request = SignupRequestModel(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        roles: roles,
      );

      final response = await _authRepository.signup(request);

      await UserPreferences.saveToken(response.token);
      await UserPreferences.saveUser(
        id: response.user.id,
        fullName: response.user.fullName,
        email: response.user.email,
        phoneNumber: response.user.phoneNumber,
        avatarUrl: response.user.avatarUrl,
        country: response.user.country,
      );

      await UserPreferences.saveUserRoles(response.user.roles);
      final nextRole = response.user.roles.contains(preferredRole)
          ? preferredRole
          : (response.user.roles.isNotEmpty ? response.user.roles.first : 'PICKER');
      await UserPreferences.saveActiveRole(nextRole);

      state = state.copyWith(isLoading: false, response: response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void resetState() {
    state = const SignupState();
  }
}

// --- Provider ---
final signupViewModelProvider =
    NotifierProvider<SignupViewModel, SignupState>(SignupViewModel.new);
