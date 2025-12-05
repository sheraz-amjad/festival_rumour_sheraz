import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/phone_auth_service.dart';
import '../../../../core/viewmodels/base_view_model.dart';
import '../../../../core/constants/app_strings.dart';

class SignupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = AuthService();
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  /// 🔹 Controllers
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  /// 🔹 Country Code Selection
  CountryCode _selectedCountryCode = CountryCode(
    name: 'Indonesia',
    code: 'ID',
    dialCode: '+62',
  );

  /// 🔹 Validation error
  String? phoneNumberError;

  /// 🔹 Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 🔹 Firebase Auth state
  String? _verificationId;
  String? _phoneNumber;
  String? _errorMessage;

  /// Focus node getter
  FocusNode get phoneFocus => _phoneFocus;
  
  /// Country code getter
  CountryCode get selectedCountryCode => _selectedCountryCode;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Focus management methods
  void focusPhone() {
    if (isDisposed) return;
    
    try {
      _phoneFocus.requestFocus();
    } catch (e) {
      if (kDebugMode) print('Error focusing phone field: $e');
    }
  }

  void unfocusPhone() {
    if (isDisposed) return;
    
    try {
      _phoneFocus.unfocus();
    } catch (e) {
      if (kDebugMode) print('Error unfocusing phone field: $e');
    }
  }

  /// Handle country code selection
  void onCountryChanged(CountryCode countryCode) {
    _selectedCountryCode = countryCode;
    if (kDebugMode) {
      print('Country selected: ${countryCode.name} (${countryCode.dialCode})');
    }
    notifyListeners();
  }

  @override
  void init() {
    super.init();
    // Auto-focus phone field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed) {
        focusPhone();
      }
    });
  }

  /// 🔹 Validate phone number
  bool validatePhone() {
    final phone = phoneNumberController.text.trim();

    if (phone.isEmpty) {
      phoneNumberError = "*Phone number is required";
    } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(phone)) {
      phoneNumberError = "Enter a valid phone number";
    } else {
      phoneNumberError = null;
    }

    notifyListeners();
    return phoneNumberError == null;
  }

  /// 🔹 Continue to OTP screen with Firebase Auth
  Future<void> goToOtp() async {
    if (!validatePhone()) return; // Stop if invalid

    // Dismiss keyboard when continue is clicked
    unfocusPhone();

    setLoading(true);
    _errorMessage = null;

    try {
      // Format phone number with selected country code
      String phoneText = phoneNumberController.text.trim();
      
      // Remove any existing + or country code
      if (phoneText.startsWith('+')) {
        phoneText = phoneText.substring(1);
      }
      
      // Use selected country code
      String countryCode = _selectedCountryCode.dialCode!;
      String phoneNumber;
      
      // Handle different input formats
      if (phoneText.startsWith(countryCode.substring(1))) {
        // Already has country code
        phoneNumber = '+$phoneText';
      } else if (phoneText.startsWith('0')) {
        // Local number starting with 0 (remove 0 and add country code)
        phoneNumber = '$countryCode${phoneText.substring(1)}';
      } else {
        // Direct number (add country code)
        phoneNumber = '$countryCode$phoneText';
      }
      
      _phoneNumber = phoneNumber;
      
      // Store phone data in shared service immediately
      _phoneAuthService.setPhoneData(phoneNumber, '');
      
      if (kDebugMode) {
        print('Formatted phone number: $phoneNumber');
        print('Original input: ${phoneNumberController.text.trim()}');
        print('Phone data stored in service');
      }

      // Send verification code
      final result = await _authService.signInWithPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
      );

      if (result.isSuccess) {
        // Navigate to OTP screen with verification ID
        _navigationService.navigateTo(AppRoutes.otp);
      } else {
        _errorMessage = result.errorMessage;
        _showErrorSnackBar();
      }
    } catch (e) {
      if (kDebugMode) print('Error sending verification code: $e');
      _errorMessage = 'Failed to send verification code. Please try again.';
      _showErrorSnackBar();
    } finally {
      setLoading(false);
    }
  }

  /// 🔹 Firebase Auth callbacks
  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    try {
      final result = await _authService.verifyPhoneNumber(
        verificationId: _verificationId ?? '',
        smsCode: credential.smsCode ?? '',
      );

      if (result.isSuccess) {
        _navigationService.navigateTo(AppRoutes.home);
      } else {
        _errorMessage = result.errorMessage;
        _showErrorSnackBar();
      }
    } catch (e) {
      if (kDebugMode) print('Error during auto-verification: $e');
    }
  }

  void _onVerificationFailed(FirebaseAuthException e) {
    if (kDebugMode) print('Verification failed: ${e.message}');
    _errorMessage = 'Verification failed: ${e.message}';
    _showErrorSnackBar();
  }

  void _onCodeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    
    // Update verification ID in shared service
    if (_phoneNumber != null) {
      _phoneAuthService.setPhoneData(_phoneNumber!, verificationId);
    }
    
    if (kDebugMode) {
      print('Verification code sent to $_phoneNumber');
      print('Verification ID: $verificationId');
    }
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
    if (kDebugMode) print('Code auto-retrieval timeout');
  }

  /// 🔹 Verify OTP code
  Future<bool> verifyOtpCode(String smsCode) async {
    if (_verificationId == null) {
      _errorMessage = 'No verification ID available. Please try again.';
      return false;
    }

    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _authService.verifyPhoneNumber(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      if (result.isSuccess) {
        _navigationService.navigateTo(AppRoutes.home);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _showErrorSnackBar();
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('Error verifying OTP: $e');
      _errorMessage = 'Failed to verify code. Please try again.';
      _showErrorSnackBar();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// 🔹 Show error message
  void _showErrorSnackBar() {
    if (_errorMessage != null) {
      // You can implement a snackbar or dialog here
      if (kDebugMode) print('Error: $_errorMessage');
    }
  }

  /// 🔹 Get verification ID for OTP screen
  String? get verificationId => _verificationId;

  /// 🔹 Get phone number for OTP screen
  String? get phoneNumber => _phoneNumber;

  /// 🔹 Get error message
  String? get errorMessage => _errorMessage;

  @override
  void onDispose() {
    phoneNumberController.dispose();
    _phoneFocus.dispose();
    super.onDispose();
  }
}
