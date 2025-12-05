import 'package:flutter/cupertino.dart';

import '../../../core/constants/app_numbers.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../homeview/post_model.dart';

class RumorsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  List<PostModel> rumors = [];

  Future<void> loadRumors() async {
    await handleAsync(() async {
      await Future.delayed(const Duration(seconds: 1));

      rumors = [
        PostModel(
          username: "RumorMaster",
          timeAgo: "2 hours ago",
          content: "Heard that the main stage will have a surprise performance tonight! 🤫",
          imagePath: AppAssets.performance1,
          likes: 156,
          comments: 23,
          status: AppStrings.live,
        ),
        PostModel(
          username: "FestivalInsider",
          timeAgo: "4 hours ago",
          content: "Rumor has it that the food trucks are bringing in special midnight snacks! 🌮",
          imagePath: AppAssets.post,
          likes: 89,
          comments: 12,
          status: AppStrings.live,
        ),
        PostModel(
          username: "BackstageBuzz",
          timeAgo: "6 hours ago",
          content: "Someone spotted a famous DJ backstage... could this be the surprise guest? 🎧",
          imagePath: AppAssets.post2,
          likes: 234,
          comments: 45,
          status: AppStrings.live,
        ),
        PostModel(
          username: "FestivalGossip",
          timeAgo: "8 hours ago",
          content: "Word on the street is that there's a secret after-party location! 🎉",
          imagePath: AppAssets.post3,
          likes: 178,
          comments: 34,
          status: AppStrings.live,
        ),
        PostModel(
          username: "StageWhisper",
          timeAgo: "10 hours ago",
          content: "Rumor alert: The sound system is getting an upgrade for tonight's show! 🔊",
          imagePath: AppAssets.performance1,
          likes: 67,
          comments: 8,
          status: AppStrings.live,
        ),
      ];
    }, errorMessage: AppStrings.failedToLoadPosts);
  }

  Future<void> refreshRumors() async {
    await loadRumors();
  }

  void likeRumor(int index) {
    if (index < rumors.length) {
      rumors[index] = rumors[index].copyWith(
        likes: rumors[index].likes + 1,
      );
      notifyListeners();
    }
  }

  void addComment(int index) {
    if (index < rumors.length) {
      rumors[index] = rumors[index].copyWith(
        comments: rumors[index].comments + 1,
      );
      notifyListeners();
    }
  }

  void goToSubscription() {
    _navigationService.navigateTo(AppRoutes.subscription);
  }

  Future<void> goToCreatePost() async {
    final createdPost = await _navigationService.navigateTo<PostModel>(AppRoutes.createPost);
    // If a post was created, add it to the beginning of the list
    if (createdPost != null) {
      rumors.insert(0, createdPost);
      notifyListeners();
    }
  }

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
