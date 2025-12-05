import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_assets.dart';
import '../homeview/post_model.dart';

class CreatePostViewModel extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController postTextController = TextEditingController();

  // Store selected media files (images and videos)
  List<XFile> selectedMedia = [];
  List<bool> isVideo = []; // Track which items are videos

  /// Getter to check if media is selected
  bool get hasMedia => selectedMedia.isNotEmpty;

  /// Getter to check if post is valid (has text or media)
  bool get canPost => postTextController.text.trim().isNotEmpty || hasMedia;

  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }

  /// Pick images from gallery (multiple selection)
  Future<void> pickImages() async {
    await handleAsync(() async {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        selectedMedia.addAll(pickedFiles);
        isVideo.addAll(List.filled(pickedFiles.length, false));
        notifyListeners();
      }
    }, 
    errorMessage: AppStrings.failtouploadimage,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }

  /// Pick video from gallery
  Future<void> pickVideo() async {
    await handleAsync(() async {
      final XFile? pickedVideo = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedVideo != null) {
        selectedMedia.add(pickedVideo);
        isVideo.add(true);
        notifyListeners();
      }
    }, 
    errorMessage: AppStrings.failedToUploadVideo,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }

  /// Remove media at index
  void removeMedia(int index) {
    if (index >= 0 && index < selectedMedia.length) {
      selectedMedia.removeAt(index);
      isVideo.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear all media
  void clearAllMedia() {
    selectedMedia.clear();
    isVideo.clear();
    notifyListeners();
  }

  /// Upload post and return the created post
  Future<void> uploadPost() async {
    if (!canPost) return;

    await handleAsync(() async {
      // Simulate uploading post with text and media
      await Future.delayed(AppDurations.apiCallDuration);

      // Get post content
      final postContent = postTextController.text.trim();
      
      // Use the selected media file paths
      String imagePath = AppAssets.post; // Default image (for backward compatibility)
      bool isVideoPost = false;
      List<String>? mediaPaths;
      List<bool>? isVideoList;
      
      if (selectedMedia.isNotEmpty) {
        // Store all media paths
        mediaPaths = selectedMedia.map((media) => media.path).toList();
        isVideoList = List<bool>.from(isVideo);
        
        // Use the first selected media file path for backward compatibility
        imagePath = selectedMedia[0].path;
        isVideoPost = isVideo.isNotEmpty && isVideo[0];
      }

      // Create PostModel with the form data
      final newPost = PostModel(
        username: AppStrings.name.trim(), // Use current user name, replace with actual user service
        timeAgo: "Just now",
        content: postContent.isNotEmpty 
            ? postContent 
            : (hasMedia ? (isVideoPost ? "🎥 Shared a video" : "📸 Shared ${selectedMedia.length == 1 ? 'a media' : '${selectedMedia.length} media items'}") : ""),
        imagePath: imagePath,
        likes: 0,
        comments: 0,
        status: AppStrings.live, // Default to live posts
        isVideo: isVideoPost,
        mediaPaths: mediaPaths,
        isVideoList: isVideoList,
      );

      // Clear form after successful upload
      postTextController.clear();
      clearAllMedia();

      // Navigate back with the created post as result
      _navigationService.pop<PostModel>(newPost);
    }, 
    errorMessage: AppStrings.failedToUploadPost,
    minimumLoadingDuration: AppDurations.buttonLoadingDuration);
  }
}

