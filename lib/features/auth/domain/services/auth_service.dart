import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Enum representing the available user roles in the GramPulse app
enum UserRole {
  citizen,
  volunteer,
  officer,
  admin,
  none
}

/// Service class to manage user authentication and role-based navigation
class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  // User authentication state
  bool _isAuthenticated = false;
  bool _isAuthenticationInProgress = false;
  UserRole _userRole = UserRole.none;
  String? _userId;
  String? _userName;
  String? _phoneNumber;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isAuthenticationInProgress => _isAuthenticationInProgress;
  UserRole get userRole => _userRole;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get phoneNumber => _phoneNumber;

  // Firebase Auth specific getters
  String? get verificationId => _verificationId;
  int? get resendToken => _resendToken;

  /// Initialize the authentication state
  Future<void> init() async {
    // Check if user is already signed in
    final user = _auth.currentUser;
    if (user != null) {
      _isAuthenticated = true;
      _userId = user.uid;
      _phoneNumber = user.phoneNumber;
      // TODO: Load user role from Firestore or other storage
    } else {
      _isAuthenticated = false;
      _isAuthenticationInProgress = false;
      _userRole = UserRole.none;
    }
  }

  /// Request phone number verification
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    try {
      print('DEBUG: Attempting to verify phone number: $phoneNumber');
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('DEBUG: Verification completed automatically');
          // Android only: when the SMS code is automatically detected
          final success = await _signInWithCredential(credential);
          if (!success) {
            onError('Failed to sign in with credential');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('DEBUG: Verification failed - Code: ${e.code}, Message: ${e.message}');
          String errorMessage = 'Verification failed';
          
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'Invalid phone number format';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many requests. Please try again later';
              break;
            case 'operation-not-allowed':
              errorMessage = 'Phone authentication is not enabled';
              break;
            default:
              errorMessage = e.message ?? 'Verification failed';
          }
          
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('DEBUG: Code sent successfully - VerificationId: $verificationId');
          _verificationId = verificationId;
          _resendToken = resendToken;
          _phoneNumber = phoneNumber;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('DEBUG: Code auto retrieval timeout - VerificationId: $verificationId');
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('DEBUG: Exception in verifyPhoneNumber: $e');
      onError('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify OTP code
  Future<bool> verifyOTPAndSignIn(String smsCode) async {
    if (_verificationId == null) {
      print('DEBUG: No verification ID available');
      return false;
    }

    try {
      print('DEBUG: Creating credential with verification ID: $_verificationId and SMS code: $smsCode');
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final success = await _signInWithCredential(credential);
      return success;
    } catch (e) {
      print('DEBUG: Error in verifyOTPAndSignIn: $e');
      return false;
    }
  }

  /// Sign in with phone auth credential
  Future<bool> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      print('DEBUG: Attempting to sign in with credential');
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user != null) {
        print('DEBUG: Sign in successful - UID: ${user.uid}');
        _isAuthenticated = true;
        _userId = user.uid;
        _phoneNumber = user.phoneNumber;
        _isAuthenticationInProgress = true;
        return true;
      }
      print('DEBUG: Sign in failed - User is null');
      return false;
    } catch (e) {
      print('DEBUG: Exception in _signInWithCredential: $e');
      return false;
    }
  }

  /// Set the authentication as in progress after OTP verification
  void setAuthenticationInProgress({required String phoneNumber}) {
    _isAuthenticationInProgress = true;
    _phoneNumber = phoneNumber;
    // We don't set _isAuthenticated = true yet because user needs to complete profile setup
    
    // TODO: Save partial auth state to secure storage
  }

  /// Set the user as authenticated with the given role
  void setAuthenticated({
    required UserRole role,
    required String userId,
    required String userName,
    required String phoneNumber,
  }) {
    _isAuthenticated = true;
    _isAuthenticationInProgress = false;
    _userRole = role;
    _userId = userId;
    _userName = userName;
    _phoneNumber = phoneNumber;

    // TODO: Save auth state to secure storage
  }

  /// Log the user out
  void logout() {
    _isAuthenticated = false;
    _isAuthenticationInProgress = false;
    _userRole = UserRole.none;
    _userId = null;
    _userName = null;
    _phoneNumber = null;

    // TODO: Clear auth state from secure storage
  }

  /// Get the home route for the current user role
  String getHomeRoute() {
    switch (_userRole) {
      case UserRole.citizen:
        return '/citizen/home';
      case UserRole.volunteer:
        return '/volunteer/dashboard';
      case UserRole.officer:
        return '/officer/dashboard';
      case UserRole.admin:
        return '/admin/control-room';
      case UserRole.none:
        return '/login';
    }
  }
}

/// Router redirection logic based on authentication state
String? authRedirect(BuildContext context, GoRouterState state) {
  final auth = AuthService();
  
  // Public routes that don't require authentication
  final publicRoutes = [
    '/',
    '/language-selection',
    '/login',
    // '/otp-verification', // Removed as it now uses a path parameter
  ];
  
  // Check if the current path is a public route
  if (publicRoutes.contains(state.matchedLocation) || 
      state.matchedLocation.startsWith('/otp-verification/')) {
    return null; // Allow access to public routes
  }
  
  // Setup routes are semi-protected - only accessible for authenticated users 
  // who haven't completed setup
  final setupRoutes = [
    '/profile-setup',
    '/role-selection',
  ];
  
  if (setupRoutes.contains(state.matchedLocation)) {
    if (!auth.isAuthenticated && !auth.isAuthenticationInProgress) {
      return '/login'; // Redirect to login if not authenticated and not in progress
    }
    return null; // Allow access to setup routes for authenticated users or auth in progress
  }
  
  // For all other routes, check authentication
  if (!auth.isAuthenticated && !auth.isAuthenticationInProgress) {
    return '/login'; // Redirect to login if not authenticated and not in progress
  }
  
  // Role-specific path prefixes
  final roleSpecificPaths = {
    UserRole.citizen: '/citizen/',
    UserRole.volunteer: '/volunteer/',
    UserRole.officer: '/officer/',
    UserRole.admin: '/admin/',
  };
  
  // Check if user is trying to access a route for their role
  final correctPrefix = roleSpecificPaths[auth.userRole];
  if (correctPrefix != null && !state.matchedLocation.startsWith(correctPrefix)) {
    // User is trying to access a route for a different role
    return auth.getHomeRoute(); // Redirect to their role-specific home
  }
  
  return null; // Allow access
}
