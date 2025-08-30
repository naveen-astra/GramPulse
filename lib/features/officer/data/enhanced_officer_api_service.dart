import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';

class EnhancedOfficerApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('officer_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Enhanced Dashboard with Priority Queue
  Future<ApiResponse> getEnhancedDashboard() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/enhanced-dashboard'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Success',
          data: data['data'],
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Failed to load enhanced dashboard',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  // Priority Queue Management
  Future<ApiResponse> getPriorityQueue({
    String? department,
    String? urgencyLevel,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (department != null) queryParams['department'] = department;
      if (urgencyLevel != null) queryParams['urgencyLevel'] = urgencyLevel;
      
      final uri = Uri.parse('$baseUrl/officer/priority-queue').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load priority queue');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Escalation Management
  Future<ApiResponse> getEscalationPaths(String incidentId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/escalation/$incidentId/paths'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load escalation paths');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> escalateIncident({
    required String incidentId,
    required String targetOfficerId,
    required String escalationType,
    required String reason,
    String? attemptedSolutions,
    String? urgencyJustification,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'targetOfficerId': targetOfficerId,
        'escalationType': escalationType,
        'reason': reason,
        if (attemptedSolutions != null) 'attemptedSolutions': attemptedSolutions,
        if (urgencyJustification != null) 'urgencyJustification': urgencyJustification,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/officer/escalation/$incidentId/escalate'),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data'], data['message']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to escalate incident');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> getEscalationHistory(String incidentId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/escalation/$incidentId/history'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load escalation history');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> getPendingEscalations({
    String? department,
    String? urgency,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (department != null) queryParams['department'] = department;
      if (urgency != null) queryParams['urgency'] = urgency;
      
      final uri = Uri.parse('$baseUrl/officer/escalation/pending-assignments').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load pending escalations');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Government Structure Management
  Future<ApiResponse> getGovernmentStructure() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/government/structure'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load government structure');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> getJurisdictionIncidents({
    String? jurisdictionLevel,
    String? department,
    bool includeCrossDept = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'includeCrossDept': includeCrossDept.toString(),
      };
      
      if (jurisdictionLevel != null) queryParams['jurisdictionLevel'] = jurisdictionLevel;
      if (department != null) queryParams['department'] = department;
      
      final uri = Uri.parse('$baseUrl/officer/government/jurisdiction-incidents').replace(
        queryParameters: queryParams,
      );
      
      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load jurisdiction incidents');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> coordinateWithDepartments({
    required String incidentId,
    required List<String> targetDepartments,
    required String coordinationType,
    required String message,
    String urgencyLevel = 'MEDIUM',
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'incidentId': incidentId,
        'targetDepartments': targetDepartments,
        'coordinationType': coordinationType,
        'message': message,
        'urgencyLevel': urgencyLevel,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/officer/government/coordinate'),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data'], data['message']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to coordinate with departments');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> getCoordinationStatus(String incidentId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/officer/government/coordination/$incidentId'),
        headers: headers,
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to load coordination status');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Priority Management
  Future<ApiResponse> updateIncidentPriority({
    required String incidentId,
    required int newSeverity,
    required String reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'newSeverity': newSeverity,
        'reason': reason,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/officer/incidents/$incidentId/priority'),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return ApiResponse.success(data['data'], data['message']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to update incident priority');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Utility method to refresh all enhanced data
  Future<Map<String, ApiResponse>> refreshAllEnhancedData() async {
    final results = <String, ApiResponse>{};
    
    try {
      // Run multiple API calls concurrently
      final futures = await Future.wait([
        getEnhancedDashboard(),
        getPriorityQueue(),
        getGovernmentStructure(),
        getPendingEscalations(),
      ]);
      
      results['dashboard'] = futures[0];
      results['priorityQueue'] = futures[1];
      results['government'] = futures[2];
      results['escalations'] = futures[3];
      
    } catch (e) {
      // Handle partial failures
      results['error'] = ApiResponse.error('Failed to refresh some data: $e');
    }
    
    return results;
  }
}
