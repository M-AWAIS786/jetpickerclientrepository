import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jet_picks_app/App/models/auth/login_model.dart';
import 'package:jet_picks_app/App/repo/auth_repository.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final LoginResponseModel? response;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.response,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    LoginResponseModel? response,
    bool clearError = false,
    bool clearResponse = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      response: clearResponse ? null : response ?? this.response,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  late final AuthRepository _authRepository;

  @override
  LoginState build() {
    _authRepository = AuthRepository();
    return const LoginState();
  }

  Future<void> login({required String username, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearResponse: true);
    try {
      final request = LoginRequestModel(username: username, password: password);
      final response = await _authRepository.login(request);
      state = state.copyWith(isLoading: false, response: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void resetState() {
    state = const LoginState();
  }
}

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);
