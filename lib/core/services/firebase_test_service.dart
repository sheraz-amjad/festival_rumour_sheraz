import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseTestService {
  static Future<FirebaseTestResult> testFirebaseConnection() async {
    try {
      // Test 1: Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase is not initialized',
          details: 'No Firebase apps found',
        );
      }

      // Test 2: Check Firebase Auth instance
      final auth = FirebaseAuth.instance;
      if (auth.app == null) {
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase Auth is not available',
          details: 'Firebase Auth instance is null',
        );
      }

      // Test 3: Check current user (should be null for new app)
      final currentUser = auth.currentUser;
      final userStatus = currentUser != null ? 'User is signed in' : 'No user signed in';

      // Test 4: Check auth state changes stream
      final authStateStream = auth.authStateChanges();
      if (authStateStream == null) {
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase Auth state stream is not available',
          details: 'Auth state changes stream is null',
        );
      }

      // Test 5: Check Firebase project configuration
      final app = auth.app;
      final projectId = app?.options.projectId;
      final apiKey = app?.options.apiKey;

      if (projectId == null || projectId.isEmpty) {
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase project ID is not configured',
          details: 'Project ID is null or empty',
        );
      }

      if (apiKey == null || apiKey.isEmpty) {
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase API key is not configured',
          details: 'API key is null or empty',
        );
      }

      // All tests passed
      return FirebaseTestResult(
        isSuccess: true,
        message: 'Firebase is working correctly!',
        details: '''
✅ Firebase Core: Initialized
✅ Firebase Auth: Available
✅ Project ID: $projectId
✅ API Key: ${apiKey.substring(0, 10)}...
✅ User Status: $userStatus
✅ Auth Stream: Available
        ''',
      );

    } catch (e) {
      return FirebaseTestResult(
        isSuccess: false,
        message: 'Firebase test failed',
        details: 'Error: $e',
      );
    }
  }

  static Future<FirebaseTestResult> testFirebaseAuth() async {
    try {
      final auth = FirebaseAuth.instance;
      
      // Test email validation
      final testEmail = 'test@example.com';
      final testPassword = 'testpassword123';
      
      // Test 1: Check if we can create a user (this will fail if email exists, but that's expected)
      try {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );
        
        // If successful, delete the test user
        await userCredential.user?.delete();
        
        return FirebaseTestResult(
          isSuccess: true,
          message: 'Firebase Auth is working!',
          details: 'Successfully created and deleted test user',
        );
      } catch (e) {
        // Check if it's an expected error (email already exists)
        if (e.toString().contains('email-already-in-use')) {
          return FirebaseTestResult(
            isSuccess: true,
            message: 'Firebase Auth is working!',
            details: 'Email already exists (expected behavior)',
          );
        }
        
        // Other errors
        return FirebaseTestResult(
          isSuccess: false,
          message: 'Firebase Auth test failed',
          details: 'Error: $e',
        );
      }
    } catch (e) {
      return FirebaseTestResult(
        isSuccess: false,
        message: 'Firebase Auth test failed',
        details: 'Error: $e',
      );
    }
  }
}

class FirebaseTestResult {
  final bool isSuccess;
  final String message;
  final String details;

  FirebaseTestResult({
    required this.isSuccess,
    required this.message,
    required this.details,
  });

  @override
  String toString() {
    return '''
Firebase Test Result:
Success: $isSuccess
Message: $message
Details: $details
    ''';
  }
}
