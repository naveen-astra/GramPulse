import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'api_service.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // Session configuration
  static const int _sessionTimeoutMinutes = 30; // 30 minutes default
  static const int _extendedSessionTimeoutMinutes = 120; // 2 hours for "remember me"
  static const String _lastActivityKey = 'last_activity';
  static const String _sessionTimeoutKey = 'session_timeout';
  static const String _rememberMeKey = 'remember_me';
  static const String _userDataKey = 'user_data';
  static const String _tokenKey = 'token';
  static const String _userRoleKey = 'userRole';

  Timer? _sessionTimer;
  VoidCallback? _onSessionExpired;
  bool _isSessionActive = false;

  // Session state getters
  bool get isSessionActive => _isSessionActive;

  /// Initialize session manager with callback for session expiration
  void initialize({VoidCallback? onSessionExpired}) {
    _onSessionExpired = onSessionExpired;
    _startSessionMonitoring();
  }

  /// Start a new session with authentication data
  Future<void> startSession({
    required String token,
    required String userRole,
    required Map<String, dynamic> userData,
    bool rememberMe = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Store authentication data
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userRoleKey, userRole);
      await prefs.setString(_userDataKey, jsonEncode(userData));
      await prefs.setBool(_rememberMeKey, rememberMe);
      
      // Set session timeout based on remember me preference
      final timeoutMinutes = rememberMe ? _extendedSessionTimeoutMinutes : _sessionTimeoutMinutes;
      final expiryTime = DateTime.now().add(Duration(minutes: timeoutMinutes));
      await prefs.setString(_sessionTimeoutKey, expiryTime.toIso8601String());
      
      // Update last activity
      await _updateLastActivity();
      
      _isSessionActive = true;
      _startSessionTimer();
      
      debugPrint('🟢 SESSION: Started new session for role: $userRole (Remember: $rememberMe)');
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Failed to start session: $e');
      throw Exception('Failed to start session: $e');
    }
  }

  /// Update last activity timestamp
  Future<void> updateActivity() async {
    if (_isSessionActive) {
      await _updateLastActivity();
    }
  }

  /// Check if current session is valid
  Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if we have required data
      final token = prefs.getString(_tokenKey);
      if (token == null) return false;
      
      // Check JWT token expiration
      if (JwtDecoder.isExpired(token)) {
        debugPrint('🔴 SESSION: JWT token expired');
        await endSession();
        return false;
      }
      
      // Check session timeout
      final sessionTimeoutString = prefs.getString(_sessionTimeoutKey);
      if (sessionTimeoutString != null) {
        final sessionTimeout = DateTime.parse(sessionTimeoutString);
        if (DateTime.now().isAfter(sessionTimeout)) {
          debugPrint('🔴 SESSION: Session timeout reached');
          await endSession();
          return false;
        }
      }
      
      // Check last activity (for inactive sessions)
      final lastActivityString = prefs.getString(_lastActivityKey);
      if (lastActivityString != null) {
        final lastActivity = DateTime.parse(lastActivityString);
        final inactivityLimit = DateTime.now().subtract(const Duration(minutes: 15)); // 15 min inactivity
        
        if (lastActivity.isBefore(inactivityLimit)) {
          debugPrint('🔴 SESSION: Inactive session timeout');
          await endSession();
          return false;
        }
      }
      
      _isSessionActive = true;
      return true;
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Session validation failed: $e');
      await endSession();
      return false;
    }
  }

  /// Extend current session (refresh timeout)
  Future<void> extendSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      
      final timeoutMinutes = rememberMe ? _extendedSessionTimeoutMinutes : _sessionTimeoutMinutes;
      final newExpiryTime = DateTime.now().add(Duration(minutes: timeoutMinutes));
      
      await prefs.setString(_sessionTimeoutKey, newExpiryTime.toIso8601String());
      await _updateLastActivity();
      
      debugPrint('🟡 SESSION: Extended session until ${newExpiryTime.toString()}');
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Failed to extend session: $e');
    }
  }

  /// End current session and clear all data
  Future<void> endSession({bool userInitiated = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear authentication data
      await prefs.remove(_tokenKey);
      await prefs.remove(_userRoleKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_lastActivityKey);
      await prefs.remove(_sessionTimeoutKey);
      await prefs.remove(_rememberMeKey);
      
      // Clear API service token
      final apiService = ApiService();
      await apiService.clearToken();
      
      _isSessionActive = false;
      _sessionTimer?.cancel();
      
      final reason = userInitiated ? 'User logout' : 'Session expired';
      debugPrint('🔴 SESSION: Ended session - Reason: $reason');
      
      // Trigger callback if session expired (not user logout)
      if (!userInitiated && _onSessionExpired != null) {
        _onSessionExpired!();
      }
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Failed to end session: $e');
    }
  }

  /// Get current session data
  Future<SessionData?> getSessionData() async {
    try {
      if (!await isSessionValid()) return null;
      
      final prefs = await SharedPreferences.getInstance();
      
      final token = prefs.getString(_tokenKey);
      final userRole = prefs.getString(_userRoleKey);
      final userDataString = prefs.getString(_userDataKey);
      
      if (token == null || userRole == null || userDataString == null) {
        return null;
      }
      
      final userData = jsonDecode(userDataString) as Map<String, dynamic>;
      
      return SessionData(
        token: token,
        userRole: userRole,
        userData: userData,
        isActive: _isSessionActive,
      );
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Failed to get session data: $e');
      return null;
    }
  }

  /// Force logout with optional callback
  Future<void> logout() async {
    await endSession(userInitiated: true);
  }

  // Private helper methods
  Future<void> _updateLastActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastActivityKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('🔴 SESSION ERROR: Failed to update last activity: $e');
    }
  }

  void _startSessionMonitoring() {
    // Check session validity every minute
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (_isSessionActive) {
        final isValid = await isSessionValid();
        if (!isValid) {
          timer.cancel();
        }
      }
    });
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    
    // Check session every 5 minutes
    _sessionTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      final isValid = await isSessionValid();
      if (!isValid) {
        timer.cancel();
      }
    });
  }

  /// Dispose session manager
  void dispose() {
    _sessionTimer?.cancel();
    _onSessionExpired = null;
    _isSessionActive = false;
  }
}

/// Session data model
class SessionData {
  final String token;
  final String userRole;
  final Map<String, dynamic> userData;
  final bool isActive;

  const SessionData({
    required this.token,
    required this.userRole,
    required this.userData,
    required this.isActive,
  });

  @override
  String toString() {
    return 'SessionData(role: $userRole, active: $isActive, userData: ${userData.keys.toList()})';
  }
}

/// Session configuration
class SessionConfig {
  static const int defaultTimeout = 30; // minutes
  static const int extendedTimeout = 120; // minutes
  static const int inactivityTimeout = 15; // minutes
  static const int checkInterval = 5; // minutes
}
