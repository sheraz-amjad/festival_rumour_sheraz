import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_assets.dart';

class PostsViewModel extends BaseViewModel {
  // Mock posts data - replace with actual data from repositories
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'Sufyan Ch',
      'userImage': AppAssets.profile,
      'image': AppAssets.post,
      'likes': 1100,
      'comments': 12,
      'upvotes': 250,
      'timeAgo': '2 hours ago',
      'description': 'Find out what PrinceWilliam and 112 others like this post.',
    },
    {
      'username': 'Sufyan Ch',
      'userImage': AppAssets.profile,
      'image': AppAssets.post1,
      'likes': 850,
      'comments': 8,
      'upvotes': 180,
      'timeAgo': '4 hours ago',
      'description': 'Amazing festival experience!',
    },
    {
      'username': 'Sufyan Ch',
      'userImage': AppAssets.profile,
      'image': AppAssets.post2,
      'likes': 2100,
      'comments': 25,
      'upvotes': 420,
      'timeAgo': '6 hours ago',
      'description': 'Best night ever at the concert!',
    },
    {
      'username': 'Sufyan Ch',
      'userImage': AppAssets.profile,
      'image': AppAssets.post3,
      'likes': 750,
      'comments': 6,
      'upvotes': 150,
      'timeAgo': '1 day ago',
      'description': 'Great time with friends!',
    },
    {
      'username': 'Sufyan Ch',
      'userImage': AppAssets.profile,
      'image': AppAssets.post5,
      'likes': 3200,
      'comments': 45,
      'upvotes': 680,
      'timeAgo': '2 days ago',
      'description': 'Incredible performance tonight!',
    },
  ];

  List<Map<String, dynamic>> get posts => _posts;

  void likePost(int index) {
    _posts[index]['likes'] = (_posts[index]['likes'] ?? 0) + 1;
    notifyListeners();
  }

  void upvotePost(int index) {
    _posts[index]['upvotes'] = (_posts[index]['upvotes'] ?? 0) + 1;
    notifyListeners();
  }

  void addComment(int index) {
    _posts[index]['comments'] = (_posts[index]['comments'] ?? 0) + 1;
    notifyListeners();
  }

  void sharePost(int index) {
    // Handle share functionality
    print('Sharing post at index $index');
  }

  void bookmarkPost(int index) {
    // Handle bookmark functionality
    print('Bookmarking post at index $index');
  }
}
