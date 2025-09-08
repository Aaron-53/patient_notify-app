import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // Backend API base URL - loaded from .env file
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String verifyTokenEndpoint = '/auth/verify';
  static const String treatmentPlansCreateEndpoint = '/treatment-plans/create';
  static const String treatmentPlansSummaryEndpoint =
      '/treatment-plans/summary';

  // Storage keys
  static const String tokenKey = 'jwt_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }
}
