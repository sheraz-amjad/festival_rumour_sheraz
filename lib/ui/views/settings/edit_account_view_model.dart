import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/locator.dart';
import '../../../core/constants/app_strings.dart';

class EditAccountViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // UI state
  bool isPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isDeletingAccount = false;

  // Profile image
  String? profileImagePath;

  // Preferences
  String selectedLanguage = "English";
  String selectedTimezone = "UTC";
  bool emailNotifications = true;
  bool pushNotifications = true;

  EditAccountViewModel() {
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // TODO: Load user data from service/repository
    // For now, using mock data
    nameController.text = AppStrings.mockUserName1;
    bioController.text = AppStrings.mockBio;
    emailController.text = AppStrings.mockEmail;
    phoneController.text = AppStrings.mockPhone;
    websiteController.text = AppStrings.mockWebsite;
    profileImagePath = null; // No profile image set
  }

  // Form validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 2) {
      return AppStrings.usernameMinLength;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return AppStrings.usernameInvalid;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
      return AppStrings.mustBePhone;
    }
    return null;
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value != newPasswordController.text) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value != null && value.length > 500) {
      return AppStrings.bioTooLong;
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^https?://').hasMatch(value)) {
        return AppStrings.websiteInvalidFormat;
      }
    }
    return null;
  }

  // UI state methods
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  // Action methods
  Future<void> pickProfileImage() async {
    // TODO: Implement image picker
    // For now, just show a message
    if (kDebugMode) {
      print('Profile image picker not implemented yet');
    }
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await handleAsync(() async {
      // TODO: Implement save changes logic
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock save operation
      if (kDebugMode) {
        print('Saving changes...');
        print('Name: ${nameController.text}');
        print('Email: ${emailController.text}');
        print('Phone: ${phoneController.text}');
      }
    }, errorMessage: AppStrings.errorOccurred);
  }

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty || 
        newPasswordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      return;
    }

    await handleAsync(() async {
      // TODO: Implement password change logic
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock password change operation
      if (kDebugMode) {
        print('Changing password...');
      }
    }, errorMessage: AppStrings.errorOccurred);
  }

  Future<void> deleteAccount() async {
    isDeletingAccount = true;
    notifyListeners();

    await handleAsync(() async {
      // TODO: Implement account deletion logic
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock account deletion operation
      if (kDebugMode) {
        print('Deleting account...');
      }
      
      // Navigate to welcome screen after deletion
      _navigationService.navigateTo(AppRoutes.welcome);
    }, errorMessage: AppStrings.errorOccurred);

    isDeletingAccount = false;
    notifyListeners();
  }

  void goBack() {
    _navigationService.pop();
  }

  // Preference methods
  void setLanguage(String? language) {
    if (language != null) {
      selectedLanguage = language;
      notifyListeners();
    }
  }

  void setTimezone(String? timezone) {
    if (timezone != null) {
      selectedTimezone = timezone;
      notifyListeners();
    }
  }

  void setEmailNotifications(bool value) {
    emailNotifications = value;
    notifyListeners();
  }

  void setPushNotifications(bool value) {
    pushNotifications = value;
    notifyListeners();
  }
}
