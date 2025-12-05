import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/di/locator.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/viewmodels/base_view_model.dart';

class EmailVerificationViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _canResend = true;
  bool get canResend => _canResend;

  int _secondsRemaining = 0;
  Timer? _resendTimer;

  String? get userEmail => _authService.userEmail;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🔹 Check if email verified when pressing Continue
  Future<void> checkEmailVerification() async {
    setLoading(true);

    try {
      // Reload user to get latest verification status
      await _authService.reloadUser();

      if (_authService.isEmailVerified) {
        // ✅ Email verified → go to next screen
        _navigationService.navigateTo(AppRoutes.name); // adjust your route
      } else {
        // ❌ Not verified → show message
        _showErrorSnackBar('Please verify your email first.');
      }
    } catch (e) {
      _showErrorSnackBar('Error checking verification status.');
    } finally {
      setLoading(false);
    }
  }

  /// 🔹 Resend verification email (with 30s cooldown)
  Future<void> resendVerificationEmail() async {
    if (!_canResend) return; // prevent spam

    setLoading(true);
    try {
      await _authService.sendEmailVerification();
      _showSuccessSnackBar('Verification email sent! Please check your inbox.');

      _startResendCooldown();
    } catch (e) {
      _showErrorSnackBar('Failed to send verification email.');
    } finally {
      setLoading(false);
    }
  }

  /// 🔹 Start 30-second cooldown for resend button
  void _startResendCooldown() {
    _secondsRemaining = 20;
    _canResend = false;
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (_secondsRemaining <= 0) {
        timer.cancel();
        _canResend = true;
      }
      notifyListeners();
    });
  }

  /// 🔹 Text for button (e.g., “Resend in 25s”)
  String get resendButtonText =>
      _canResend ? "Resend Verification Email" : "Resend in $_secondsRemaining s";

  /// 🔹 Handle success/error messages
  void _showErrorSnackBar(String message) {
    // In production, use your SnackbarService or context-based snackbar
    debugPrint('❌ Error: $message');
    _navigationService.showSnackbar(message, isError: true);
  }

  void _showSuccessSnackBar(String message) {
    debugPrint('✅ Success: $message');
    _navigationService.showSnackbar(message);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
