import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env.dart';
import '../models/auth_models.dart';

// Token verification result
enum TokenVerificationResult { valid, invalid, networkError, noToken }

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: Environment.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {'Content-Type': 'application/json'},
        ),
      ),
      _storage = const FlutterSecureStorage();

  // Login user
  Future<UserResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        Environment.loginEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final userResponse = UserResponse.fromJson(response.data);
        await _saveUserData(userResponse);
        return userResponse;
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Sign up user
  Future<UserResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(
        Environment.signupEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final userResponse = UserResponse.fromJson(response.data);
        await _saveUserData(userResponse);
        return userResponse;
      } else {
        throw Exception('Signup failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Email already registered');
      } else {
        throw Exception('Signup failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // Verify JWT token with detailed result
  Future<TokenVerificationResult> verifyToken() async {
    print("verifyToken called");
    print(Environment.baseUrl);
    try {
      final token = await _storage.read(key: Environment.tokenKey);
      if (token == null || token.isEmpty) {
        return TokenVerificationResult.noToken;
      }

      final response = await _dio.get(
        Environment.verifyTokenEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['valid'] == true) {
        return TokenVerificationResult.valid;
      } else {
        return TokenVerificationResult.invalid;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token is invalid or expired, clear it
        await logout();
        return TokenVerificationResult.invalid;
      } else {
        // Network error or other server error
        // print('Token verification network error: ${e.message}');
        return TokenVerificationResult.networkError;
      }
    } catch (e) {
      // print('Token verification error: $e');
      return TokenVerificationResult.networkError;
    }
  }

  // Legacy method for backward compatibility
  Future<bool> verifyTokenSimple() async {
    final result = await verifyToken();
    return result == TokenVerificationResult.valid;
  }

  // Get stored user data
  Future<User?> getCurrentUser() async {
    try {
      final userId = await _storage.read(key: Environment.userIdKey);
      final userEmail = await _storage.read(key: Environment.userEmailKey);

      if (userId != null && userEmail != null) {
        return User(id: userId, email: userEmail);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: Environment.tokenKey);
    } catch (e) {
      return null;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _storage.delete(key: Environment.tokenKey);
      await _storage.delete(key: Environment.userIdKey);
      await _storage.delete(key: Environment.userEmailKey);
    } catch (e) {
      // Handle error if needed
    }
  }

  // Save user data to secure storage
  Future<void> _saveUserData(UserResponse userResponse) async {
    await _storage.write(
      key: Environment.tokenKey,
      value: userResponse.accessToken,
    );
    await _storage.write(key: Environment.userIdKey, value: userResponse.id);
    await _storage.write(
      key: Environment.userEmailKey,
      value: userResponse.email,
    );
  }
}
