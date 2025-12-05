import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

/// Auth result class for handling authentication responses
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult._(this.isSuccess, this.errorMessage);

  factory AuthResult.success() => AuthResult._(true, null);
  factory AuthResult.failure(String error) => AuthResult._(false, error);
}

/// Authentication service handling Google and Apple sign-in
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      return userCredential;
    } catch (e) {
      print("Apple Sign-In Error: $e");
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  /// Generate a random nonce for Apple Sign-In security
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if Apple Sign-In is available (iOS 13+)
  bool get isAppleSignInAvailable {
    if (Platform.isIOS) {
      return true; // Apple Sign-In is available on iOS 13+
    }
    return false;
  }

  /// Check if Google Sign-In is available
  bool get isGoogleSignInAvailable {
    return true; // Google Sign-In is available on both platforms
  }

  /// Get user display name
  String? get userDisplayName => currentUser?.displayName;

  /// Get user email
  String? get userEmail => currentUser?.email;

  /// Get user photo URL
  String? get userPhotoUrl => currentUser?.photoURL;

  /// Get user UID
  String? get userUid => currentUser?.uid;

  /// Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      return userCredential;
    } catch (e) {
      print('Email Sign-Up Error: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Email Sign-In Error: $e');
      rethrow;
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      print('Send email verification error: $e');
      rethrow;
    }
  }

  /// Reload user data
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      print('Reload user error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success();
    } catch (e) {
      print('Password reset email error: $e');
      return AuthResult.failure(_getPasswordResetErrorMessage(e));
    }
  }

  /// Get user-friendly error message for password reset
  String _getPasswordResetErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'Failed to send password reset email. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Sign in with phone number
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
      return AuthResult.success();
    } catch (e) {
      print('Phone Sign-In Error: $e');
      return AuthResult.failure(e.toString());
    }
  }

  /// Verify phone number with OTP
  Future<AuthResult> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      return AuthResult.success();
    } catch (e) {
      print('Phone Verification Error: $e');
      return AuthResult.failure(e.toString());
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await reloadUser();
    } catch (e) {
      print('Update display name error: $e');
      rethrow;
    }
  }

  /// Upload profile photo to Firebase Storage
  Future<String?> uploadProfilePhoto(File imageFile) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user logged in');

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Upload profile photo error: $e');
      rethrow;
    }
  }

  /// Update user profile photo URL
  Future<void> updateProfilePhoto(String photoUrl) async {
    try {
      await currentUser?.updatePhotoURL(photoUrl);
      await reloadUser();
    } catch (e) {
      print('Update profile photo error: $e');
      rethrow;
    }
  }
}
