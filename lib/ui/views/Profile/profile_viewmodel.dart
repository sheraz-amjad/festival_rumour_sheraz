
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/router/app_router.dart';

class ProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  // Tabs: 0 = Followers, 1 = Following, 2 = Festivals
  int currentTab = 0;

  // In-profile subview state to keep navbar visible
  bool showingList = false;
  int listInitialTab = 0;

  // Mock data for lists
  final List<Map<String, String>> followers = [
    {
      'name': 'Alice Johnson',
      'username': '@alice',
      'avatar': 'https://i.pravatar.cc/100?img=1',
    },
    {
      'name': 'Bob Smith',
      'username': '@bob',
      'avatar': 'https://i.pravatar.cc/100?img=2',
    },
  ];

  final List<Map<String, String>> following = [
    {
      'name': 'Carol Lee',
      'username': '@carol',
      'avatar': 'https://i.pravatar.cc/100?img=3',
    },
  ];

  final List<Map<String, String>> festivals = [
    {
      'title': 'Summer Beats Festival',
    },
    {
      'title': 'Night Lights Carnival',
    },
  ];

  void setTab(int index) {
    if (index == currentTab) return;
    currentTab = index;
    notifyListeners();
  }

  List<Map<String, String>> getCurrentList() {
    if (currentTab == 0) return followers;
    if (currentTab == 1) return following;
    return festivals;
  }

  Future<void> loadData() async {
    await handleAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    });
  }

  void unfollowUser(Map<String, String> user) {
    following.removeWhere((u) => u['username'] == user['username']);
    notifyListeners();
  }

  void openProfileList(int initialTab) {
    listInitialTab = initialTab;
    showingList = true;
    notifyListeners();
  }

  void closeProfileList() {
    showingList = false;
    notifyListeners();
  }

  List<String> posts = [
    AppAssets.proback,
    AppAssets.proback,
    AppAssets.proback,
    AppAssets.proback,
  ];

  void onBottomNavTap(int index) {
    // Handle navigation
  }

  // Navigation actions (used elsewhere)
  Future<void> goToFollowers() async {}

  Future<void> goToFollowing() async {
    // await _navigationService.navigateTo(AppRoutes.following);
  }

  Future<void> goToFestivals() async {
    await _navigationService.navigateTo(AppRoutes.festivals);
  }

  Future<void> goToNotifications() async {
    // Using news route as notifications screen placeholder
    await _navigationService.navigateTo(AppRoutes.notification);
  }

  Future<void> onPostTap(int index) async {
    // No dedicated post detail; open gallery for now
  }
}
