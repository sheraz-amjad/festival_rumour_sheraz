import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if Firebase is initialized
  bool get isFirebaseInitialized {
    try {
      return _auth.app != null;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Sign up with email and password
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Check if Firebase is initialized
      if (!isFirebaseInitialized) {
        return AuthResult.failure('Firebase is not initialized. Please restart the app.');
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      return AuthResult.success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during sign up: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Sign in with email and password
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthResult.success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during sign in: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Sign in with phone number
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      // Check if Firebase is initialized
      if (!isFirebaseInitialized) {
        return AuthResult.failure('Firebase is not initialized. Please restart the app.');
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      return AuthResult.success(null); // Phone verification initiated
    } catch (e) {
      if (kDebugMode) print('Error during phone verification: $e');
      return AuthResult.failure('Failed to send verification code. Please try again.');
    }
  }

  // Verify phone number with SMS code
  Future<AuthResult> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return AuthResult.success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during phone verification: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Send password reset email
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during password reset: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Update user profile
  Future<AuthResult> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in.');
      }

      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      await user.reload();

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during profile update: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Error during sign out: $e');
    }
  }

  // Delete user account
  Future<AuthResult> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResult.failure('No user is currently signed in.');
      }

      await user.delete();
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      if (kDebugMode) print('Unexpected error during account deletion: $e');
      return AuthResult.failure('An unexpected error occurred. Please try again.');
    }
  }

  // Get error message from Firebase Auth Exception
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address. Please enter a valid email.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please try again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different account.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      default:
        return e.message ?? 'An authentication error occurred. Please try again.';
    }
  }
}

// Auth result class
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(User? user) => AuthResult._(
        isSuccess: true,
        user: user,
      );

  factory AuthResult.failure(String errorMessage) => AuthResult._(
        isSuccess: false,
        errorMessage: errorMessage,
      );
}
