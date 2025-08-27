import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Simple utility to test Firebase configuration
class FirebaseDebugTest {
  static Future<void> testFirebaseConfiguration() async {
    try {
      print('DEBUG: Testing Firebase configuration...');
      
      // Check if Firebase is initialized
      print('DEBUG: Firebase apps: ${Firebase.apps.length}');
      if (Firebase.apps.isNotEmpty) {
        print('DEBUG: Firebase default app: ${Firebase.app().name}');
        print('DEBUG: Firebase default app options: ${Firebase.app().options.projectId}');
      }
      
      // Check Firebase Auth instance
      final auth = FirebaseAuth.instance;
      print('DEBUG: Firebase Auth instance created successfully');
      print('DEBUG: Current user: ${auth.currentUser}');
      
      // Test a simple auth operation (get current user)
      final user = auth.currentUser;
      if (user != null) {
        print('DEBUG: User is already signed in: ${user.uid}');
      } else {
        print('DEBUG: No user currently signed in');
      }
      
      print('DEBUG: Firebase configuration test completed successfully');
    } catch (e) {
      print('DEBUG: Firebase configuration test failed: $e');
    }
  }
  
  static Future<void> testPhoneAuth(String phoneNumber) async {
    try {
      print('DEBUG: Testing phone auth with number: $phoneNumber');
      
      final auth = FirebaseAuth.instance;
      
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print('DEBUG: Phone verification completed automatically');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('DEBUG: Phone verification failed: ${e.code} - ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('DEBUG: Code sent successfully with verification ID: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('DEBUG: Auto retrieval timeout for verification ID: $verificationId');
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('DEBUG: Phone auth test failed: $e');
    }
  }
}
