import 'package:flutter/material.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/viewmodels/base_view_model.dart';

class SignupViewEmailModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // Focus node getters
  FocusNode get emailFocus => _emailFocus;
  FocusNode get passwordFocus => _passwordFocus;
  FocusNode get confirmPasswordFocus => _confirmPasswordFocus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ✅ Validate fields
  bool validateFields() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    bool isValid = true;

    // Email validation
    if (email.isEmpty) {
      emailError = "*Email is required";
      isValid = false;
    } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email)) {
      emailError = "Enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    // Password validation
    if (password.isEmpty) {
      passwordError = "*Password is required";
      isValid = false;
    } else if (password.length < 8) {
      passwordError = "*Password must be at least 8 characters";
      isValid = false;
    } else {
      passwordError = null;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      confirmPasswordError = "*Please confirm your password";
      isValid = false;
    } else if (password != confirmPassword) {
      confirmPasswordError = "*Passwords did not match";
      isValid = false;
    } else {
      confirmPasswordError = null;
    }

    notifyListeners();
    return isValid;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Focus management methods
  void focusEmail() {
    _emailFocus.requestFocus();
  }

  void focusPassword() {
    _passwordFocus.requestFocus();
  }

  void focusConfirmPassword() {
    _confirmPasswordFocus.requestFocus();
  }

  void unfocusAll() {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    _confirmPasswordFocus.unfocus();
  }

  /// Handle text input actions
  void handleEmailSubmitted() {
    if (emailController.text.trim().isNotEmpty) {
      focusPassword();
    } else {
      // If email is empty, show error and keep focus
      emailError = "*Email is required";
      notifyListeners();
    }
  }

  void handlePasswordSubmitted() {
    if (passwordController.text.isNotEmpty) {
      focusConfirmPassword();
    } else {
      // If password is empty, show error and keep focus
      passwordError = "*Password is required";
      notifyListeners();
    }
  }

  void handleConfirmPasswordSubmitted() {
    if (confirmPasswordController.text.isNotEmpty) {
      // Validate before submitting
      if (validateFields()) {
        goToOtp();
      } else {
        // If validation fails, focus on the first field with error
        if (emailError != null) {
          focusEmail();
        } else if (passwordError != null) {
          focusPassword();
        } else if (confirmPasswordError != null) {
          focusConfirmPassword();
        }
      }
    } else {
      // If confirm password is empty, show error and keep focus
      confirmPasswordError = "*Please confirm your password";
      notifyListeners();
    }
  }

  /// Enhanced focus management with validation
  void focusNextField() {
    if (emailController.text.trim().isEmpty) {
      focusEmail();
    } else if (passwordController.text.isEmpty) {
      focusPassword();
    } else if (confirmPasswordController.text.isEmpty) {
      focusConfirmPassword();
    } else {
      // All fields have content, validate and submit
      if (validateFields()) {
        goToOtp();
      }
    }
  }

  /// ✅ Navigate if valid with Firebase Auth
  Future<void> goToOtp() async {
    if (!validateFields()) return;

    setLoading(true);

    try {
      // Create user account with Firebase
      final userCredential = await _authService.signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential != null) {
        // User created successfully, navigate to email verification
        _navigationService.navigateTo(AppRoutes.emailVerification);
      } else {
        // Show error message
        _showErrorSnackBar('Failed to create account');
      }
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  /// Show error message
  void _showErrorSnackBar(String message) {
    // This will be handled by the view
    // For now, we'll store the error message
    emailError = message;
    notifyListeners();
  }

  @override
  void onDispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.onDispose();
  }
}
