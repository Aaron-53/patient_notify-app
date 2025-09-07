import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../models/auth_models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    on<AuthStarted>(_onAuthTokenVerificationRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignupRequested>(_onAuthSignupRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthTokenVerificationRequested>(_onAuthTokenVerificationRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userResponse = await _authService.login(
        LoginRequest(email: event.email, password: event.password),
      );

      final user = User(id: userResponse.id, email: userResponse.email);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onAuthSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final userResponse = await _authService.signup(
        SignupRequest(email: event.email, password: event.password),
      );

      final user = User(id: userResponse.id, email: userResponse.email);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthTokenVerificationRequested(
    AuthTokenVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    print("Verifying token...");
    try {
      final verificationResult = await _authService.verifyToken();

      switch (verificationResult) {
        case TokenVerificationResult.valid:
          final user = await _authService.getCurrentUser();
          if (user != null) {
            emit(AuthAuthenticated(user: user));
          } else {
            emit(AuthUnauthenticated());
          }
          break;
        case TokenVerificationResult.invalid:
        case TokenVerificationResult.noToken:
          emit(AuthUnauthenticated());
          break;
        case TokenVerificationResult.networkError:
          emit(
            AuthNetworkError(
              message:
                  'Network error occurred. Please check your connection and try again.',
            ),
          );
          break;
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
