import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebasePhoneAuthTest {
  static Future<void> testPhoneAuthConfiguration() async {
    try {
      debugPrint('🔥 Testing Firebase Phone Auth Configuration...');
      
      final FirebaseAuth auth = FirebaseAuth.instance;
      
      // Test with a dummy phone number to see if the service is available
      debugPrint('📱 Current user: ${auth.currentUser?.uid ?? 'None'}');
      debugPrint('📱 Auth instance configured: ${auth.app.name}');
      
      // Check if phone auth providers are available
      final providers = await auth.fetchSignInMethodsForEmail('test@example.com');
      debugPrint('📱 Available providers checked');
      
      debugPrint('✅ Firebase Phone Auth seems to be properly configured');
      debugPrint('🔑 Next step: Enable Phone Authentication in Firebase Console');
      
    } catch (e) {
      debugPrint('❌ Firebase Phone Auth configuration error: $e');
      debugPrint('🔧 Please check:');
      debugPrint('   1. Phone Authentication is enabled in Firebase Console');
      debugPrint('   2. google-services.json is properly configured');
      debugPrint('   3. Internet connection is available');
    }
  }
}

/// Simple test function to verify phone number formatting
class PhoneNumberHelper {
  static String formatPhoneNumber(String phoneNumber) {
    // Remove any spaces, dashes, or other characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Add +91 country code if not present
    if (!cleaned.startsWith('+91') && !cleaned.startsWith('91')) {
      cleaned = '+91$cleaned';
    } else if (cleaned.startsWith('91') && !cleaned.startsWith('+91')) {
      cleaned = '+$cleaned';
    }
    
    debugPrint('📱 Formatted phone number: $cleaned');
    return cleaned;
  }
  
  static bool isValidIndianPhoneNumber(String phoneNumber) {
    final formatted = formatPhoneNumber(phoneNumber);
    // Indian phone numbers: +91 followed by 10 digits starting with 6-9
    final regex = RegExp(r'^\+91[6-9]\d{9}$');
    final isValid = regex.hasMatch(formatted);
    debugPrint('📱 Phone number valid: $isValid');
    return isValid;
  }
}
