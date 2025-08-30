import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/performance_utils.dart';
import 'models/department.dart';

class OfficerApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:5000/api',
  );

  // Headers with token
  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    
    return headers;
  }

  // Request OTP for Officer
  Future<ApiResponse<Map<String, dynamic>>> requestOTPForOfficer(String phone) async {
    try {
      print('📱 OFFICER API: Requesting OTP for $phone');
      
      final response = await http.post(
        Uri.parse('$baseUrl/officer-auth/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );

      print('📱 OFFICER API RESPONSE: ${response.statusCode}');
      print('📱 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Verify OTP for Officer
  Future<ApiResponse<Map<String, dynamic>>> verifyOTPForOfficer(String phone, String otp) async {
    try {
      print('🔐 OFFICER API: Verifying OTP for $phone');
      
      final response = await http.post(
        Uri.parse('$baseUrl/officer-auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phone,
          'otp': otp,
        }),
      );

      print('🔐 OFFICER API RESPONSE: ${response.statusCode}');
      print('🔐 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      if (responseData['success'] == true && responseData['data']?['token'] != null) {
        // Store token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['data']['token']);
        await prefs.setString('userRole', 'officer');
        print('💾 TOKEN STORED FOR OFFICER');
      }

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Get Current Officer Profile
  Future<ApiResponse<Map<String, dynamic>>> getCurrentOfficer() async {
    try {
      print('👤 OFFICER API: Getting current officer profile');
      
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer-auth/me'),
        headers: headers,
      );

      print('👤 OFFICER API RESPONSE: ${response.statusCode}');
      print('👤 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Get Officer Dashboard
  Future<ApiResponse<Map<String, dynamic>>> getOfficerDashboard() async {
    try {
      print('📊 OFFICER API: Getting dashboard');
      
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/dashboard'),
        headers: headers,
      );

      print('📊 OFFICER API RESPONSE: ${response.statusCode}');
      print('📊 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Get Officer Incidents
  Future<ApiResponse<Map<String, dynamic>>> getOfficerIncidents({
    String? category,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('📋 OFFICER API: Getting incidents (category: $category, status: $status)');
      
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (status != null) 'status': status,
      };

      final uri = Uri.parse('$baseUrl/officer/incidents').replace(queryParameters: queryParams);
      final headers = await _getHeaders();
      
      final response = await http.get(uri, headers: headers);

      print('📋 OFFICER API RESPONSE: ${response.statusCode}');
      print('📋 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Update Assignment Status
  Future<ApiResponse<Map<String, dynamic>>> updateAssignmentStatus(
    String assignmentId,
    String status, {
    String? notes,
  }) async {
    try {
      print('🔄 OFFICER API: Updating assignment $assignmentId to $status');
      
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/officer/assignments/$assignmentId/status'),
        headers: headers,
        body: json.encode({
          'status': status,
          if (notes != null) 'notes': notes,
        }),
      );

      print('🔄 OFFICER API RESPONSE: ${response.statusCode}');
      print('🔄 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      return ApiResponse<Map<String, dynamic>>(
        success: responseData['success'] ?? false,
        message: responseData['message'] ?? 'Unknown error',
        data: responseData['data'],
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Get All Departments
  Future<ApiResponse<List<Department>>> getDepartments() async {
    try {
      print('🏢 OFFICER API: Getting departments');
      
      final response = await http.get(
        Uri.parse('$baseUrl/departments'),
        headers: {'Content-Type': 'application/json'},
      );

      print('🏢 OFFICER API RESPONSE: ${response.statusCode}');
      print('🏢 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      if (responseData['success'] == true && responseData['data'] != null) {
        final departments = (responseData['data'] as List)
            .map((json) => Department.fromJson(json))
            .toList();

        return ApiResponse<List<Department>>(
          success: true,
          message: responseData['message'],
          data: departments,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<Department>>(
        success: false,
        message: responseData['message'] ?? 'Unknown error',
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<List<Department>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Get Officer Categories
  Future<ApiResponse<List<Map<String, dynamic>>>> getOfficerCategories() async {
    try {
      print('📂 OFFICER API: Getting categories');
      
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/categories'),
        headers: headers,
      );

      print('📂 OFFICER API RESPONSE: ${response.statusCode}');
      print('📂 OFFICER API BODY: ${response.body}');

      final responseData = await ApiPerformanceUtils.parseJsonInIsolate(response.body);

      if (responseData['success'] == true && responseData['data'] != null) {
        final categories = List<Map<String, dynamic>>.from(responseData['data']);

        return ApiResponse<List<Map<String, dynamic>>>(
          success: true,
          message: responseData['message'],
          data: categories,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        message: responseData['message'] ?? 'Unknown error',
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OFFICER API ERROR: $e');
      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }
}
