import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';

class UsernameViewModel extends BaseViewModel {
  /// Services
  final FirebaseAuthService _authService = FirebaseAuthService();
  final NavigationService _navigationService = locator<NavigationService>();

  /// Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// State variables
  bool rememberMe = false;
  bool isPasswordVisible = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isFormValid = false;

  /// Error messages
  String? emailError;
  String? passwordError;

  /// Password strength
  String passwordStrength = '';
  Color passwordStrengthColor = AppColors.grey600;

  /// ---------------------------
  /// 🔹 Input Handlers
  /// ---------------------------
  void onUsernameChanged(String value) {
    // Don't validate while typing - only clear previous errors
    if (value.isEmpty) {
      emailError = null;
      isEmailValid = false;
      _updateFormValidity();
      notifyListeners();
    }
  }

  void onPasswordChanged(String value) {
    // Don't validate while typing - only clear previous errors
    if (value.isEmpty) {
      passwordError = null;
      passwordStrength = '';
      passwordStrengthColor = AppColors.grey600;
      isPasswordValid = false;
      _updateFormValidity();
      notifyListeners();
    }
  }

  /// Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  /// Focus handlers
  void onUsernameFocusChange(bool hasFocus) {
    if (!hasFocus) {
      _validateEmail(emailController.text);
      _updateFormValidity();
      notifyListeners();
    }
  }

  void onPasswordFocusChange(bool hasFocus) {
    if (!hasFocus) {
      _validatePassword(passwordController.text);
      _updateFormValidity();
      notifyListeners();
    }
  }

  /// Focus management methods
  void focusEmailField() {
    // This will be called from the view to focus email field
  }

  void focusPasswordField() {
    // This will be called from the view to focus password field
  }

  /// ---------------------------
  /// 🔹 Validation Methods
  /// ---------------------------
  void _validateEmail(String email) {
    if (email.isEmpty) {
      emailError = AppStrings.emailRequired;
      isEmailValid = false;
    } else if (!_isValidEmail(email)) {
      emailError = AppStrings.emailInvalid;
      isEmailValid = false;
    } else {
      emailError = null;
      isEmailValid = true;
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      passwordError = AppStrings.passwordRequired;
      passwordStrength = '';
      passwordStrengthColor = AppColors.grey600;
      isPasswordValid = false;
    } else if (password.length < 6) {
      passwordError = AppStrings.passwordMinLength;
      passwordStrength = AppStrings.passwordWeak;
      passwordStrengthColor = AppColors.error;
      isPasswordValid = false;
    } else if (password.length > 50) {
      passwordError = AppStrings.passwordMaxLength;
      passwordStrength = AppStrings.passwordWeak;
      passwordStrengthColor = AppColors.error;
      isPasswordValid = false;
    } else {
      passwordError = null;
      _calculatePasswordStrength(password);
      isPasswordValid = true;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _calculatePasswordStrength(String password) {
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    if (score <= 2) {
      passwordStrength = AppStrings.passwordWeak;
      passwordStrengthColor = AppColors.error;
    } else if (score <= 4) {
      passwordStrength = AppStrings.passwordMedium;
      passwordStrengthColor = AppColors.warning;
    } else {
      passwordStrength = AppStrings.passwordStrong;
      passwordStrengthColor = AppColors.success;
    }
  }

  void _updateFormValidity() {
    isFormValid = isEmailValid && isPasswordValid;
  }

  /// ---------------------------
  /// 🔹 Validation + Login Logic
  /// ---------------------------
  Future<void> validateAndLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Always validate all fields when login button is clicked
    _validateEmail(email);
    _validatePassword(password);
    _updateFormValidity();
    
    // Notify listeners to update UI with error messages
    notifyListeners();

    // If any error found, show specific error messages
    if (!isFormValid) {
      // Show specific error message based on what's missing
      String errorMessage = '';
      if (email.isEmpty) {
        errorMessage = AppStrings.emailRequired;
      } else if (!_isValidEmail(email)) {
        errorMessage = AppStrings.emailInvalid;
      } else if (password.isEmpty) {
        errorMessage = AppStrings.passwordRequired;
      } else if (password.length < 6) {
        errorMessage = AppStrings.passwordMinLength;
      } else {
        errorMessage = AppStrings.fixErrors;
      }
      
      _showErrorSnackBar(context, errorMessage);
      return;
    }

    await handleAsync(() async {
      // Simulate API delay
      await Future.delayed(AppDurations.loginLoadingDuration);

      // Firebase login validation
      if (await _performLogin(email, password)) {
        _showSuccessSnackBar(context, AppStrings.loginSuccess);
        // Navigate to Home Screen using navigation service
        _navigationService.navigateTo(AppRoutes.navbaar);
      } else {
        _showErrorSnackBar(context, AppStrings.loginFailed);
      }
    }, 
    errorMessage: 'Login failed. Please try again.',
    minimumLoadingDuration: AppDurations.loginLoadingDuration);
  }

  Future<bool> _performLogin(String email, String password) async {
    try {
      // Use Firebase Auth to sign in
      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        // User successfully signed in
        return true;
      } else {
        // Return false and let the calling method handle the error display
        return false;
      }
    } catch (e) {
      // Handle unexpected errors
      return false;
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: AppDimensions.spaceS),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: AppColors.error),
            const SizedBox(width: AppDimensions.spaceS),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.error.withOpacity(0.1),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// ---------------------------
  /// 🔹 Navigate to Sign Up
  /// ---------------------------
  void goToSignUp(BuildContext context) {
    _navigationService.navigateTo(AppRoutes.signupEmail);
  }

  /// ---------------------------
  /// 🔹 Firebase Auth State Management
  /// ---------------------------
  void checkAuthState() {
    // Check if user is already signed in
    if (_authService.isSignedIn) {
      // User is already signed in, navigate to home
      _navigationService.navigateTo(AppRoutes.festivals);
    }
  }

  /// Sign out method
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      // Navigate back to welcome/login screen
      _navigationService.navigateTo(AppRoutes.welcome);
    } catch (e) {
      // Handle sign out error
      print('Sign out error: $e');
    }
  }

  /// ---------------------------
  /// 🔹 Cleanup
  /// ---------------------------
  @override
  void onDispose() {
    emailController.dispose();
    passwordController.dispose();
    super.onDispose();
  }
}
