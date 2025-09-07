sealed class AuthEvent {}

class AuthTokenVerification extends AuthEvent {}

class AuthStarted extends AuthTokenVerification {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignupRequested({required this.email, required this.password});
}

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenVerificationRequested extends AuthTokenVerification {}
