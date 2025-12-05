import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_strings.dart';
import 'event_view.dart';

class EventViewModel extends BaseViewModel {
  List<EventCategory> _eventCategories = [];
  bool _showEventPreview = false;

  List<EventCategory> get eventCategories => _eventCategories;
  bool get showEventPreview => _showEventPreview;

  @override
  void init() {
    super.init();
    _loadEventCategories();
  }

  void _loadEventCategories() {
    _eventCategories = [
      EventCategory(
        name: AppStrings.workshopsAndTalks,
        description: AppStrings.educationalWorkshopsAndSpeakerSessions,
      ),
      EventCategory(
        name: AppStrings.filmScreenings,
        description: AppStrings.movieAndDocumentaryScreenings,
      ),
      EventCategory(
        name: AppStrings.artInstallations,
        description: AppStrings.interactiveArtDisplaysAndExhibitions,
      ),
      EventCategory(
        name: AppStrings.charityAndCommunityEvents,
        description: AppStrings.communityServiceAndCharityActivities,
      ),
      EventCategory(
        name: AppStrings.musicPerformances,
        description: AppStrings.liveMusicAndEntertainmentShows,
      ),
    ];
    notifyListeners();
  }

  void addEventCategory(EventCategory category) {
    _eventCategories.add(category);
    notifyListeners();
  }

  void removeEventCategory(int index) {
    if (index >= 0 && index < _eventCategories.length) {
      _eventCategories.removeAt(index);
      notifyListeners();
    }
  }

  void set showEventPreview(bool value) {
    _showEventPreview = value;
    notifyListeners();
  }
}
