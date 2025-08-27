import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  String? _verificationId;
  int? _resendToken;

  /// Send OTP to the provided phone number
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    Function(PhoneAuthCredential credential)? onAutoVerificationCompleted,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          if (onAutoVerificationCompleted != null) {
            onAutoVerificationCompleted(credential);
          } else {
            await _signInWithCredential(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Phone verification failed: ${e.message}');
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      onError('Failed to send OTP: $e');
    }
  }

  /// Verify the OTP code
  Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      return await _signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      rethrow;
    }
  }

  /// Sign in with phone credential
  Future<UserCredential> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      debugPrint('Error signing in with credential: $e');
      rethrow;
    }
  }

  /// Resend OTP
  Future<void> resendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
