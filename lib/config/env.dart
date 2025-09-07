class Environment {
  // Backend API base URL - update this to match your backend server
  static const String baseUrl = 'http://192.168.0.102:8000';

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String verifyTokenEndpoint = '/auth/verify';

  // Storage keys
  static const String tokenKey = 'jwt_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
}
