import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';

class UploadPhotosViewModel extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  final NavigationService _navigationService = locator<NavigationService>();

  dynamic selectedImage; // Use dynamic to support both File (mobile) and XFile (web)

  /// Getter to check if image is picked
  bool get hasImage => selectedImage != null;

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    await handleAsync(() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImage = kIsWeb ? pickedFile : File(pickedFile.path);
        notifyListeners();
      }
    }, 
    errorMessage: AppStrings.failtouploadimage,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
}

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    await handleAsync(() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        selectedImage = kIsWeb ? pickedFile : File(pickedFile.path);
        notifyListeners();
      }
    }, 
    errorMessage: AppStrings.failedtotakephoto,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }

  /// Reset image
  void clearImage() {
    selectedImage = null;
    notifyListeners();
  }

  /// Continue to next screen
  Future<void> continueToNext() async {
    await handleAsync(() async {
      // Simulate uploading image
      await Future.delayed(AppDurations.apiCallDuration);

      // Navigate to next screen
      _navigationService.navigateTo(AppRoutes.interest);
    }, 
    errorMessage: AppStrings.faildtocontiue,
    minimumLoadingDuration: AppDurations.apiCallDuration);
  }

  /// Skip photo upload
  Future<void> skipPhotoUpload() async {
    await handleAsync(() async {
      // Navigate to next screen without uploading
      _navigationService.navigateTo(AppRoutes.interest);
    }, 
    errorMessage: AppStrings.faildtocontiue,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }
}
