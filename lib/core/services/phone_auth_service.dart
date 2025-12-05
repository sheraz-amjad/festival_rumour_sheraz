import 'package:flutter/foundation.dart';

class PhoneAuthService {
  static final PhoneAuthService _instance = PhoneAuthService._internal();
  factory PhoneAuthService() => _instance;
  PhoneAuthService._internal();

  String? _phoneNumber;
  String? _verificationId;

  String? get phoneNumber => _phoneNumber;
  String? get verificationId => _verificationId;

  void setPhoneData(String phoneNumber, String verificationId) {
    _phoneNumber = phoneNumber;
    _verificationId = verificationId;
    
    if (kDebugMode) {
      print('Phone data stored: $phoneNumber, $verificationId');
    }
  }

  void clearPhoneData() {
    _phoneNumber = null;
    _verificationId = null;
    
    if (kDebugMode) {
      print('Phone data cleared');
    }
  }

  bool get hasPhoneData => _phoneNumber != null && _verificationId != null;
}
