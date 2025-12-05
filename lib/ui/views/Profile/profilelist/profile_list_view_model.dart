import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/viewmodels/base_view_model.dart';

/// ViewModel for ProfileListView that manages followers, following, and festivals.
class ProfileListViewModel extends BaseViewModel {
  // --- Private State ---
  int _currentTab = 0;
  bool _showingList = false;

  // Separate search queries per tab
  String _followersSearch = '';
  String _followingSearch = '';
  String _festivalsSearch = '';

  // --- Mock Data (Replace with Repository Data) ---
  final List<Map<String, String>> _allFollowers = [
    {'name': AppStrings.mockUserName1, 'username': 'johndoe', 'image': AppAssets.profile},
    {'name': AppStrings.mockUserName2, 'username': 'janesmith', 'image': AppAssets.profile},
    {'name': AppStrings.mockUserName3, 'username': 'alikhan', 'image': AppAssets.profile},
  ];

  final List<Map<String, String>> _allFollowing = [
    {'name': AppStrings.mockUserName1, 'username': 'mikej', 'image': AppAssets.profile},
    {'name': AppStrings.mockUserName2, 'username': 'sarahw', 'image': AppAssets.profile},
    {'name': AppStrings.mockUserName3, 'username': 'ayeshan', 'image': AppAssets.profile},
  ];

  final List<Map<String, String>> _allFestivals = [
    {'title': AppStrings.mockFestival2, 'location': AppStrings.mockLocation2},
    {'title': AppStrings.mockFestival6, 'location': AppStrings.mockLocation5},
    {'title': AppStrings.mockFestival4, 'location': AppStrings.mockLocation4},
  ];

  // --- Filtered Lists ---
  List<Map<String, String>> _followers = [];
  List<Map<String, String>> _following = [];
  List<Map<String, String>> _festivals = [];

  // --- Getters ---
  int get currentTab => _currentTab;
  bool get showingList => _showingList;

  List<Map<String, String>> get followers => _followers;
  List<Map<String, String>> get following => _following;
  List<Map<String, String>> get festivals => _festivals;

  // --- Public Methods ---

  /// Change active tab and refresh UI
  void setTab(int tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      _applySearchFilter();
      notifyListeners();
    }
  }

  void showProfileList() {
    _showingList = true;
    notifyListeners();
  }

  void closeProfileList() {
    _showingList = false;
    notifyListeners();
  }

  /// Refresh all lists
  void refreshList() {
    _followers = List.from(_allFollowers);
    _following = List.from(_allFollowing);
    _festivals = List.from(_allFestivals);
    notifyListeners();
  }

  /// Search only followers
  void searchFollowers(String query) {
    _followersSearch = query.toLowerCase();
    _followers = _allFollowers
        .where((item) =>
    item['name']!.toLowerCase().contains(_followersSearch) ||
        item['username']!.toLowerCase().contains(_followersSearch))
        .toList();
    notifyListeners();
  }

  /// Search only following
  void searchFollowing(String query) {
    _followingSearch = query.toLowerCase();
    _following = _allFollowing
        .where((item) =>
    item['name']!.toLowerCase().contains(_followingSearch) ||
        item['username']!.toLowerCase().contains(_followingSearch))
        .toList();
    notifyListeners();
  }

  /// Search only festivals
  void searchFestivals(String query) {
    _festivalsSearch = query.toLowerCase();
    _festivals = _allFestivals
        .where((item) =>
    item['title']!.toLowerCase().contains(_festivalsSearch) ||
        item['location']!.toLowerCase().contains(_festivalsSearch))
        .toList();
    notifyListeners();
  }

  /// Unfollow user
  void unfollowUser(Map<String, String> user) {
    _following.removeWhere((item) => item['username'] == user['username']);
    notifyListeners();
  }

  /// Remove follower
  void removeFollower(Map<String, String> follower) {
    _followers.removeWhere((item) => item['username'] == follower['username']);
    _allFollowers.removeWhere((item) => item['username'] == follower['username']);
    notifyListeners();
  }

  /// Return current list based on active tab
  List<Map<String, String>> getCurrentList() {
    switch (_currentTab) {
      case 0:
        return _followers;
      case 1:
        return _following;
      case 2:
        return _festivals;
      default:
        return _followers;
    }
  }

  // --- Private Helpers ---
  void _applySearchFilter() {
    searchFollowers(_followersSearch);
    searchFollowing(_followingSearch);
    searchFestivals(_festivalsSearch);
  }

  @override
  void init() {
    super.init();
    refreshList();
    _showingList = true;
  }
}
