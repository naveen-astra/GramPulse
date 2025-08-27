# Firebase Phone Authentication Troubleshooting Guide

## Issues Fixed in the Code:

### 1. Phone Number Format
- **Issue**: Phone numbers were not formatted correctly for Firebase
- **Fix**: Automatically prepend +91 to 10-digit Indian phone numbers
- **File**: `phone_auth_bloc.dart` and `otp_verification_bloc.dart`

### 2. Android Package Configuration
- **Issue**: Mismatch between namespace and Firebase config
- **Fix**: Updated namespace to match `com.grampulse.app`
- **File**: `android/app/build.gradle.kts`

### 3. Error Handling & Debugging
- **Issue**: Limited error messages and debugging info
- **Fix**: Added comprehensive logging and specific error messages
- **Files**: `auth_service.dart`, `phone_auth_bloc.dart`, `phone_auth_screen.dart`

### 4. Timeout Handling
- **Issue**: App could hang indefinitely waiting for Firebase response
- **Fix**: Added 30-second timeout with proper error handling
- **File**: `phone_auth_bloc.dart`

## Firebase Console Configuration Checklist:

### 1. Phone Authentication Setup
- Go to Firebase Console → Authentication → Sign-in method
- Enable "Phone" as a sign-in provider
- Ensure no additional restrictions are set

### 2. Android App Configuration
- Verify the package name is `com.grampulse.app`
- Download and replace `google-services.json` if package name was changed
- Ensure SHA certificates are properly configured for release builds

### 3. Test Phone Numbers (Optional)
- For testing without real SMS, add test phone numbers in Firebase Console
- Format: +91xxxxxxxxxx with a 6-digit verification code

## Common Issues and Solutions:

### Issue: "Operation not allowed"
- **Cause**: Phone authentication not enabled in Firebase Console
- **Solution**: Enable Phone authentication in Firebase Console

### Issue: "Invalid phone number"
- **Cause**: Phone number format is incorrect
- **Solution**: Ensure number starts with +91 (fixed in code)

### Issue: "Too many requests"
- **Cause**: Firebase rate limiting due to multiple requests
- **Solution**: Wait a few minutes before trying again

### Issue: "Network error"
- **Cause**: No internet connection or Firebase services down
- **Solution**: Check internet connection and Firebase status

## Testing Steps:

1. **Check Debug Logs**: Look for messages starting with "DEBUG:" in the console
2. **Test with Known Phone Number**: Use your own phone number for testing
3. **Check Firebase Console**: Monitor the Authentication section for sign-in attempts
4. **Verify Network**: Ensure stable internet connection
5. **Check SMS Reception**: Ensure the phone can receive SMS messages

## Additional Configuration:

### Android Permissions (Already Added)
- `INTERNET`: For network requests
- `RECEIVE_SMS`: For auto-reading OTP
- `READ_SMS`: For auto-reading OTP

### Firebase Dependencies (Already Added)
- `firebase_core`: Core Firebase functionality
- `firebase_auth`: Firebase Authentication

## Debug Commands:

To see detailed Firebase logs during development:
```bash
flutter run --verbose
```

To check Firebase project configuration:
```bash
firebase projects:list
firebase use --project your-project-id
```

## If Issues Persist:

1. Check Firebase project status at https://status.firebase.google.com/
2. Verify billing is enabled for the Firebase project (required for phone auth)
3. Check quotas and limits in Firebase Console
4. Review Firebase Auth usage in the Firebase Console
5. Try with a different phone number to rule out number-specific issues

## Contact Points for Further Help:

- Firebase Support: https://firebase.google.com/support
- Flutter Firebase Documentation: https://firebase.flutter.dev/docs/auth/phone/
- Firebase Console: https://console.firebase.google.com/
