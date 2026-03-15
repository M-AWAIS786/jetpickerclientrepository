import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jet_picks_app/App/data/user_preferences.dart';
import 'package:jet_picks_app/App/repo/auth_repository.dart';

// ─────────────────────────────────────────────────────────────
// YOUR Google Web Client ID from Google Cloud Console
// (APIs & Services → Credentials → OAuth 2.0 Client IDs → Web)
// This is also used as serverClientId so Android returns a token
// that your backend can verify.
// ─────────────────────────────────────────────────────────────
const _kServerClientId =
    '209213820784-4ig0cj17teovdl4e859domr9i70b9clc.apps.googleusercontent.com';

// ─────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────
class GoogleAuthState {
  final bool isLoading;
  final String? errorMessage;

  /// null  = idle
  /// true  = success, new user  → go to profile setup
  /// false = success, returning → go to dashboard
  final bool? isNewUser;

  const GoogleAuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isNewUser,
  });

  GoogleAuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isNewUser,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return GoogleAuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isNewUser: clearResult ? null : isNewUser ?? this.isNewUser,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ViewModel — uses google_sign_in v7 stream-based API
// ─────────────────────────────────────────────────────────────
class GoogleAuthViewModel extends Notifier<GoogleAuthState> {
  late final AuthRepository _repo;

  // v7: always use the singleton instance
  static final _gsi = GoogleSignIn.instance;

  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;
  bool _initialized = false;

  @override
  GoogleAuthState build() {
    _repo = AuthRepository();

    // Cancel subscription when provider is disposed
    ref.onDispose(() {
      _authSub?.cancel();
    });

    // Initialize once — does NOT trigger sign-in, just sets up the SDK
    _ensureInitialized();

    return const GoogleAuthState();
  }

  // ── Initialize the SDK (idempotent) ─────────────────────────
  void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    unawaited(
      _gsi
          .initialize(
        // serverClientId tells the Android SDK which server to
        // issue the auth code / token for — must be your Web client ID
        serverClientId: _kServerClientId,
      )
          .then((_) {
        _authSub = _gsi.authenticationEvents.listen(_onAuthEvent)
          ..onError(_onAuthError);

        // Removed attemptLightweightAuthentication() to prevent
        // automatic sign-in when navigating to signup/login screens.
        // Silent authentication should only happen on app startup
        // if you want to restore a session, not on every screen.
      }).catchError((e) {
        // Initialization failed — surface the error gracefully
        state = state.copyWith(
          errorMessage: 'Google Sign-In init failed: $e',
        );
      }),
    );
  }

  // ── Triggered by authenticate() or attemptLightweightAuthentication() ──
  Future<void> _onAuthEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final account = event.user;
      await _sendToBackend(account);
    }
    // SignOut events are ignored here — we only care about sign-in
  }

  void _onAuthError(Object error) {
    final msg = error is GoogleSignInException
        ? _messageFromException(error)
        : error.toString();
    state = state.copyWith(isLoading: false, errorMessage: msg);
  }

  // ── Public: called by the button ────────────────────────────
  Future<void> signInWithGoogle() async {
    // Already loading — don't double-trigger
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearResult: true,
    );

    try {
      if (!_gsi.supportsAuthenticate()) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Google Sign-In is not supported on this platform.',
        );
        return;
      }

      // v7 explicit sign-in — triggers the account-chooser dialog
      // The result comes back via the authenticationEvents stream (_onAuthEvent)
      await _gsi.authenticate();
    } on GoogleSignInException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _messageFromException(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // ── Send the Google access token to the JetPicks backend ────
  Future<void> _sendToBackend(GoogleSignInAccount account) async {
    try {
      // v7: get access token via authorizationClient
      // We only need the basic 'email' + 'profile' scopes — no extra scopes needed
      final authorization = await account.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      if (accessToken == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not obtain Google access token. Please try again.',
        );
        return;
      }

      // POST /auth/google-login — matches the web's googleAuthApi.login
      final response = await _repo.googleLogin(accessToken: accessToken);

      // Persist token + user (same as regular login)
      await UserPreferences.saveToken(response.token);
      await UserPreferences.saveUser(
        id: response.user.id,
        fullName: response.user.fullName,
        email: response.user.email,
        phoneNumber: response.user.phoneNumber,
        avatarUrl: response.user.avatarUrl,
        country: response.user.country,
      );

      // Default active role = ORDERER (matches web)
      await UserPreferences.saveUserRoles(response.user.roles);
      await UserPreferences.saveActiveRole(
        response.user.roles.contains('ORDERER')
            ? 'ORDERER'
            : response.user.roles.first,
      );

      // Signal the UI — isNewUser drives navigation
      state = state.copyWith(isLoading: false, isNewUser: response.isNewUser);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // ── Helpers ─────────────────────────────────────────────────
  String _messageFromException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in was cancelled.',
      _ => 'Google Sign-In failed: ${e.description ?? e.code.toString()}',
    };
  }

  void resetState() => state = const GoogleAuthState();
}

// ─────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────
final googleAuthProvider =
    NotifierProvider<GoogleAuthViewModel, GoogleAuthState>(
  GoogleAuthViewModel.new,
);
