import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/phone_auth_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';

class OtpViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = AuthService();
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  String _otpCode = "";
  String? _errorText;
  bool _isLoading = false;
  final FocusNode _otpFocus = FocusNode();
  bool _isFocusChanging = false;
  
  // Phone verification state
  String? _phoneNumber;
  String? _verificationId;

  String get otpCode => _otpCode;
  String? get errorText => _errorText;
  bool get isLoading => _isLoading;
  FocusNode get otpFocus => _otpFocus;
  String? get phoneNumber => _phoneNumber;
  String get formattedPhoneNumber {
    if (_phoneNumber == null) return '+1234567890'; // Default fallback
    return _phoneNumber!;
  }
  
  String get displayPhoneNumber {
    if (_phoneNumber == null) return '+1234567890'; // Default fallback
    return _phoneNumber!;
  }

  bool get isOtpValid => _otpCode.length == 4;

  /// Auto-focus OTP field when screen loads
  void focusOtpField() {
    if (isDisposed || _isFocusChanging || _otpFocus.hasFocus) return;
    
    try {
      _isFocusChanging = true;
      _otpFocus.requestFocus();
      Future.delayed(AppDurations.shortDelay, () {
        if (!isDisposed) {
          _isFocusChanging = false;
        }
      });
    } catch (e) {
      if (kDebugMode) print('Error focusing OTP field: $e');
      _isFocusChanging = false;
    }
  }

  /// Unfocus OTP field
  void unfocusOtpField() {
    if (isDisposed || _isFocusChanging || !_otpFocus.hasFocus) return;
    
    try {
      _isFocusChanging = true;
      _otpFocus.unfocus();
      Future.delayed(AppDurations.shortDelay, () {
        if (!isDisposed) {
          _isFocusChanging = false;
        }
      });
    } catch (e) {
      if (kDebugMode) print('Error unfocusing OTP field: $e');
      _isFocusChanging = false;
    }
  }

  @override
  void init() {
    super.init();
    // Get phone number from PhoneAuthService
    _initializePhoneNumber();
    // Auto-focus OTP field when screen loads (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed && !_otpFocus.hasFocus) {
        focusOtpField();
      }
      // Refresh phone data after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isDisposed) {
          _initializePhoneNumber();
          notifyListeners();
        }
      });
    });
  }

  void _initializePhoneNumber() {
    try {
      _phoneNumber = _phoneAuthService.phoneNumber;
      _verificationId = _phoneAuthService.verificationId;
      
      if (kDebugMode) {
        print('=== OTP View Phone Data ===');
        print('Phone number retrieved: $_phoneNumber');
        print('Verification ID retrieved: $_verificationId');
        print('==========================');
      }
    } catch (e) {
      if (kDebugMode) print('Error getting phone number: $e');
    }
  }

  /// 🔹 Called when OTP input changes
  void onCodeChanged(String value) {
    _otpCode = value;
    if (value.length == 4) {
      _errorText = null;
      // Don't change focus here - let onCompleted handle it
    } else {
      _errorText = null; // clear any old error when typing
    }
    notifyListeners();
  }

  /// 🔹 Verify phone OTP with Firebase
  Future<void> verifyCode() async {
    if (!isOtpValid) {
      _errorText = AppStrings.invalidOtpError;
      notifyListeners();
      return;
    }

    await handleAsync(() async {
      // Get verification ID from PhoneAuthService
      _verificationId = _phoneAuthService.verificationId;
      _phoneNumber = _phoneAuthService.phoneNumber;

      if (_verificationId == null) {
        _errorText = 'No verification ID available. Please try again.';
        return;
      }

      // Verify OTP with Firebase
      final result = await _authService.verifyPhoneNumber(
        verificationId: _verificationId!,
        smsCode: _otpCode,
      );

      if (result.isSuccess) {
        _errorText = null;
        // Navigate to name screen
        _navigationService.navigateTo(AppRoutes.name);
      } else {
        _errorText = result.errorMessage ?? AppStrings.otpVerificationError;
      }
    }, 
    errorMessage: AppStrings.otpVerificationError,
    minimumLoadingDuration: AppDurations.otpVerificationDuration);
  }

  /// Refresh phone data
  void refreshPhoneData() {
    _initializePhoneNumber();
    notifyListeners();
  }

  /// 🔹 Resend phone OTP
  Future<void> resendCode() async {
    await handleAsync(() async {
      // Get phone number from PhoneAuthService
      _phoneNumber = _phoneAuthService.phoneNumber;

      if (_phoneNumber == null) {
        _errorText = 'No phone number available. Please start over.';
        return;
      }

      // Resend verification code
      final result = await _authService.signInWithPhone(
        phoneNumber: _phoneNumber!,
        verificationCompleted: (credential) {
          // Auto-verification completed
          if (kDebugMode) print('Auto-verification completed');
        },
        verificationFailed: (e) {
          _errorText = 'Verification failed: ${e.message}';
          notifyListeners();
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _phoneAuthService.setPhoneData(_phoneNumber!, verificationId);
          if (kDebugMode) print('Verification code resent to $_phoneNumber');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );

      if (!result.isSuccess) {
        _errorText = result.errorMessage ?? AppStrings.resendCodeError;
      } else {
        _errorText = null;
      }
    }, 
    errorMessage: AppStrings.resendCodeError,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }

  @override
  void onDispose() {
    _otpFocus.dispose();
    super.onDispose();
  }
}
