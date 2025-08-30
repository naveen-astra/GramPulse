import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Performance utilities for heavy JSON operations
class ApiPerformanceUtils {
  
  /// Parse JSON in isolate to avoid blocking main thread
  static Future<Map<String, dynamic>> parseJsonInIsolate(String jsonString) async {
    if (jsonString.length < 1000) {
      // For small JSON, parse on main thread
      return json.decode(jsonString);
    }
    
    // For large JSON, use compute to run in isolate
    return await compute(_parseJsonStatic, jsonString);
  }
  
  /// Parse large JSON list in isolate
  static Future<List<dynamic>> parseJsonListInIsolate(String jsonString) async {
    if (jsonString.length < 1000) {
      // For small JSON, parse on main thread
      return json.decode(jsonString);
    }
    
    // For large JSON, use compute to run in isolate
    return await compute(_parseJsonListStatic, jsonString);
  }
  
  /// Process large API response data in isolate
  static Future<List<T>> processApiListInIsolate<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (jsonString.length < 2000) {
      // For small responses, process on main thread
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
    }
    
    // For large responses, use compute
    final processFunc = (String data) => _processApiListStatic<T>(data, fromJson);
    return await compute(processFunc, jsonString);
  }
  
  /// Static function for JSON parsing in isolate
  static Map<String, dynamic> _parseJsonStatic(String jsonString) {
    return json.decode(jsonString);
  }
  
  /// Static function for JSON list parsing in isolate
  static List<dynamic> _parseJsonListStatic(String jsonString) {
    return json.decode(jsonString);
  }
  
  /// Static function for API list processing in isolate
  static List<T> _processApiListStatic<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Add performance debugging
  static void logPerformance(String operation, int dataSize, Duration duration) {
    if (kDebugMode) {
      final sizeKB = (dataSize / 1024).toStringAsFixed(1);
      print('🚀 PERFORMANCE: $operation took ${duration.inMilliseconds}ms for ${sizeKB}KB data');
      
      if (duration.inMilliseconds > 16) {
        print('⚠️  PERFORMANCE WARNING: $operation took ${duration.inMilliseconds}ms (>16ms frame budget)');
      }
    }
  }
  
  /// Measure and execute with performance logging
  static Future<T> measureAsync<T>(String operation, Future<T> Function() task) async {
    final stopwatch = Stopwatch()..start();
    final result = await task();
    stopwatch.stop();
    
    if (kDebugMode) {
      print('⏱️ TIMING: $operation completed in ${stopwatch.elapsedMilliseconds}ms');
      
      if (stopwatch.elapsedMilliseconds > 100) {
        print('🐌 SLOW OPERATION: $operation took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
    
    return result;
  }
}
