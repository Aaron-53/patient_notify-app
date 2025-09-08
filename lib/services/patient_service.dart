import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env.dart';
import '../models/treatment_plan_models.dart';

class TreatmentPlanService {
  static const _storage = FlutterSecureStorage();
  static final Dio _dio = Dio();

  static Future<String?> _getAuthToken() async {
    return await _storage.read(key: Environment.tokenKey);
  }

  static Future<Options> _getOptions() async {
    final token = await _getAuthToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<List<PatientTreatmentSummary>>
  getTreatmentPlansSummary() async {
    try {
      final options = await _getOptions();
      final response = await _dio.get(
        '${Environment.baseUrl}${Environment.treatmentPlansSummaryEndpoint}',
        options: options,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList
            .map((json) => PatientTreatmentSummary.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load treatment plans');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<PatientWithTreatmentResponse> createPatientWithTreatment(
    PatientWithTreatmentCreate data,
  ) async {
    try {
      final options = await _getOptions();
      final response = await _dio.post(
        '${Environment.baseUrl}${Environment.treatmentPlansCreateEndpoint}',
        data: data.toJson(),
        options: options,
      );

      if (response.statusCode == 201) {
        return PatientWithTreatmentResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to create treatment plan');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed');
      } else if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['detail'] ?? 'Invalid data provided';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
