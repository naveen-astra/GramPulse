import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Test Firebase configuration and connectivity
class FirebaseTest {
  static Future<void> testFirebaseSetup() async {
    try {
      print('🔥 FIREBASE TEST: Starting Firebase setup test...');
      
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        print('❌ FIREBASE TEST: Firebase not initialized');
        return;
      }
      
      final app = Firebase.app();
      print('✅ FIREBASE TEST: Firebase app initialized');
      print('   - App name: ${app.name}');
      print('   - Project ID: ${app.options.projectId}');
      
      // Test Firebase Auth
      final auth = FirebaseAuth.instance;
      print('✅ FIREBASE TEST: Firebase Auth instance created');
      print('   - Current user: ${auth.currentUser?.uid ?? 'None'}');
      
      // Test phone auth configuration
      print('🔥 FIREBASE TEST: Testing phone auth configuration...');
      
      // Try to verify a test phone number (this should fail but give us info)
      await auth.verifyPhoneNumber(
        phoneNumber: '+911234567890', // Test number
        verificationCompleted: (PhoneAuthCredential credential) {
          print('✅ FIREBASE TEST: Verification completed callback triggered');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('⚠️ FIREBASE TEST: Verification failed (expected for test)');
          print('   - Code: ${e.code}');
          print('   - Message: ${e.message}');
          
          if (e.code == 'operation-not-allowed') {
            print('❌ FIREBASE TEST: Phone authentication is NOT ENABLED in Firebase Console');
          } else if (e.code == 'app-not-authorized') {
            print('❌ FIREBASE TEST: App not authorized - Check SHA-1 fingerprint');
          } else if (e.code == 'invalid-phone-number') {
            print('✅ FIREBASE TEST: Phone auth is configured (invalid number expected)');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print('✅ FIREBASE TEST: Code sent successfully!');
          print('   - Verification ID: ${verificationId.substring(0, 20)}...');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏰ FIREBASE TEST: Auto retrieval timeout');
        },
        timeout: const Duration(seconds: 5),
      );
      
    } catch (e) {
      print('❌ FIREBASE TEST: Exception occurred: $e');
    }
  }
}
