// OTP Authentication Setup Validation Script
// Run this after enabling Phone Authentication in Firebase Console

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

void main() async {
  print('🔥 GramPulse Firebase Phone Auth Setup Validator');
  print('================================================');
  
  try {
    // Check Firebase Auth instance
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth instance created successfully');
    print('📱 Current user: ${auth.currentUser?.uid ?? 'Not signed in'}');
    
    // Test phone number formatting
    const testPhoneNumber = '9363350131';
    final formattedNumber = formatPhoneNumber(testPhoneNumber);
    print('📞 Test phone format: $testPhoneNumber → $formattedNumber');
    
    print('\n🔧 Next Steps:');
    print('1. Go to Firebase Console (https://console.firebase.google.com/)');
    print('2. Select your "grampulse" project');
    print('3. Navigate to Authentication > Sign-in method');
    print('4. Enable "Phone" as a sign-in provider');
    print('5. Add test phone numbers if needed');
    print('6. Run your app again to test OTP');
    
  } catch (e) {
    print('❌ Setup validation failed: $e');
  }
}

String formatPhoneNumber(String phoneNumber) {
  String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  
  if (!cleaned.startsWith('+91') && !cleaned.startsWith('91')) {
    cleaned = '+91$cleaned';
  } else if (cleaned.startsWith('91') && !cleaned.startsWith('+91')) {
    cleaned = '+$cleaned';
  }
  
  return cleaned;
}
