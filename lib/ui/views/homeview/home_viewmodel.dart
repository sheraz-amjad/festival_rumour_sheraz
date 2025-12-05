import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_numbers.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_durations.dart';
import 'post_model.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  List<PostModel> posts = [];
  List<PostModel> allPosts = []; // Store all posts
  String selectedFilter = AppStrings.allPosts; // Default filter - show live posts
  String get currentFilter => selectedFilter;
  String searchQuery = ''; // Search query
  late FocusNode searchFocusNode; // Search field focus node
  final TextEditingController searchController = TextEditingController();
  HomeViewModel() {
    searchFocusNode = FocusNode();
    // Listen to search controller changes
    searchController.addListener(() {
      if (searchController.text != searchQuery) {
        setSearchQuery(searchController.text);
      }
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPosts() async {
    await handleAsync(() async {
      await Future.delayed(AppDurations.apiCallDuration);

      // Load initial posts only if list is empty (first load)
      if (allPosts.isEmpty) {
        allPosts = [
          // 🔴 LIVE POSTS
          PostModel(
            username: AppStrings.mockUserName7,
            timeAgo: "30 minutes ago",
            content: "🔴 LIVE: Main stage performance happening RIGHT NOW! The crowd is going wild! 🎵🔥",
            imagePath: AppAssets.post,
            likes: 256,
            comments: 45,
            status: AppStrings.live,
          ),
          PostModel(
            username: AppStrings.mockUserName8,
            timeAgo: "1 hour ago",
            content: "🔴 LIVE: Amazing DJ set at the electronic stage! The bass is shaking the ground! 🎧⚡",
            imagePath: AppAssets.post1,
            likes: 189,
            comments: 32,
            status: AppStrings.live,
          ),
          PostModel(
            username: AppStrings.mockUserName9,
            timeAgo: "2 hours ago",
            content: "🔴 LIVE: Acoustic session at the intimate stage - pure magic happening! 🎸✨",
            imagePath: AppAssets.post2,
            likes: 134,
            comments: 28,
            status: AppStrings.live,
          ),
          
          // ⏰ UPCOMING POSTS
          PostModel(
            username: AppStrings.mockUserName10,
            timeAgo: "3 hours ago",
            content: "⏰ UPCOMING: Tomorrow's headliner is going to be EPIC! Can't wait! 🎤🎪",
            imagePath: AppAssets.post3,
            likes: 234,
            comments: 45,
            status: AppStrings.upcoming,
          ),
          PostModel(
            username: AppStrings.mockUserName11,
            timeAgo: "5 hours ago",
            content: "⏰ UPCOMING: Next week's lineup is INSANE! Who else is counting down? 🎪⏳",
            imagePath: AppAssets.post5,
            likes: 178,
            comments: 34,
            status: AppStrings.upcoming,
          ),
          PostModel(
            username: AppStrings.mockUserName12,
            timeAgo: "6 hours ago",
            content: "⏰ UPCOMING: Special surprise performance announced for tonight! 🤫🎭",
            imagePath: AppAssets.post,
            likes: 156,
            comments: 29,
            status: AppStrings.upcoming,
          ),
          
          // 📸 PAST POSTS
          PostModel(
            username: AppStrings.mockUserName13,
            timeAgo: "1 day ago",
            content: "📸 PAST: Yesterday's performance was LEGENDARY! What a night! 🌟🎉",
            imagePath: AppAssets.post1,
            likes: 267,
            comments: 18,
            status: AppStrings.past,
          ),
          PostModel(
            username: AppStrings.mockUserName14,
            timeAgo: "2 days ago",
            content: "📸 PAST: Last weekend's festival was one for the books! Already planning next year! 📸🎪",
            imagePath: AppAssets.post2,
            likes: 145,
            comments: 19,
            status: AppStrings.past,
          ),
          PostModel(
            username: AppStrings.mockUserName15,
            timeAgo: "3 days ago",
            content: "📸 PAST: That sunset performance was absolutely magical! Golden hour vibes! 🌅🎵",
            imagePath: AppAssets.post3,
            likes: 98,
            comments: 12,
            status: AppStrings.past,
          ),
        ];
      }
      
      // Apply initial filter
      _applyFilter();
    }, 
    errorMessage: AppStrings.failedToLoadPosts,
    minimumLoadingDuration: AppDurations.minimumLoadingDuration);
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  void likePost(int index) {
    if (index < posts.length) {
      posts[index] = posts[index].copyWith(
        likes: posts[index].likes + 1,
      );
      notifyListeners();
    }
  }

  void addComment(int index) {
    if (index < posts.length) {
      posts[index] = posts[index].copyWith(
        comments: posts[index].comments + 1,
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
      allPosts.insert(0, createdPost);
      _applyFilter(); // Reapply filter to update displayed posts
      notifyListeners();
    }
  }

  // Filter methods
  void setFilter(String filter) {
    selectedFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    List<PostModel> filteredPosts = allPosts;

    // Apply status filter
    if (selectedFilter == AppStrings.live) {
      filteredPosts = filteredPosts.where((post) => post.status == AppStrings.live).toList();
    } else if (selectedFilter == AppStrings.upcoming) {
      filteredPosts = filteredPosts.where((post) => post.status == AppStrings.upcoming).toList();
    } else if (selectedFilter == AppStrings.past) {
      filteredPosts = filteredPosts.where((post) => post.status == AppStrings.past).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredPosts = filteredPosts.where((post) {
        return post.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
               post.content.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    posts = filteredPosts;
  }

  // Search methods
  void setSearchQuery(String query) {
    searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    searchController.clear();
    _applyFilter();
    notifyListeners();
  }

  void unfocusSearch() {
    if (isDisposed) return;
    
    try {
      searchFocusNode.unfocus();
    } catch (e) {
      if (kDebugMode) print('Error unfocusing search: $e');
    }
  }



  String get currentSearchQuery => searchQuery;
}
