import 'package:festival_rumour/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/utils/custom_navbar.dart';
import '../Profile/profile_view.dart';
import '../homeview/home_view.dart';
import '../discover/discover_view.dart';
import '../detail/detail_view.dart';
import '../chat/chat_view.dart';
import '../map/map_view.dart';
import '../news/news_view.dart';
import '../posts/posts_view.dart';
import '../Profile/profilelist/profile_list_view.dart';
import '../toilet/toilet_view.dart';
import 'navbaar_view_model.dart';

class NavBaar extends BaseView<NavBaarViewModel> {
  const NavBaar({super.key});

  @override
  NavBaarViewModel createViewModel() => NavBaarViewModel();

  @override
  Widget buildView(BuildContext context, NavBaarViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        // If user is on home screen (index 0), exit the app
        if (viewModel.currentIndex == 0) {
          SystemNavigator.pop();
          return false; // Prevent default back behavior
        }
        // For other screens, allow normal back navigation
        return true;
      },
      child: Scaffold(
        body: _buildBody(viewModel),
        bottomNavigationBar: _shouldHideNavBar(viewModel.subNavigation)
            ? null
            : CustomNavBar(
                currentIndex: viewModel.currentIndex,
                onTap: viewModel.setIndex,
              ),
      ),
    );
  }

  Widget _buildBody(NavBaarViewModel viewModel) {
    // Handle sub-navigation first
    if (viewModel.subNavigation != null) {
      return _buildSubNavigation(viewModel);
    }
    
    // Handle main navigation
    switch (viewModel.currentIndex) {
      case 0:
        return const HomeView();
      case 1:
        return DiscoverView(
          onBack: viewModel.goToHome,
          onNavigateToSub: viewModel.setSubNavigation,
        );
      case 2:
        return ProfileView(
          onBack: viewModel.goToHome,
          onNavigateToSub: viewModel.setSubNavigation,
        );

      default:
        return const HomeView();
    }
  }

  bool _shouldHideNavBar(String? subNavigation) {
    return subNavigation == 'toilets' || 
           subNavigation == 'news' ||
           subNavigation == 'performance' ||
           subNavigation == 'event';
  }

  Widget _buildSubNavigation(NavBaarViewModel viewModel) {
    switch (viewModel.subNavigation) {
      case 'detail':
        return DetailView(
          onBack: () => viewModel.setSubNavigation(null),
          onNavigateToSub: viewModel.setSubNavigation,
        );
      case 'chat':
        return ChatView(onBack: () => viewModel.setSubNavigation(null));
      case 'map':
        return MapView(onBack: () => viewModel.setSubNavigation(null));
      case 'news':
        return NewsView(onBack: () => viewModel.setSubNavigation(null));
      case 'posts':
        return PostsView(onBack: () => viewModel.setSubNavigation(null));
      case 'toilets':
        return ToiletView(onBack: () => viewModel.setSubNavigation(null));
      case 'followers':
        return ProfileListView(
          initialTab: 0,
          Username: AppStrings.name,
          onBack: () => viewModel.setSubNavigation(null),
        );
      case 'following':
        return ProfileListView(
          initialTab: 1,
          Username: AppStrings.name,
          onBack: () => viewModel.setSubNavigation(null),
        );
      case 'festivals':
        return ProfileListView(
          initialTab: 2,
          Username: AppStrings.name,
          onBack: () => viewModel.setSubNavigation(null),
        );
      default:
        return DiscoverView(
          onBack: viewModel.goToHome,
          onNavigateToSub: viewModel.setSubNavigation,
        );
    }
  }
}
