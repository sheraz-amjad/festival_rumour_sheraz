class DummyService {
  List<Map<String, String>> getFollowers() => List.generate(
    8,
        (i) => {
      'name': 'Follower ${i + 1}',
      'username': '@follower${i + 1}',
      'avatar': 'https://i.pravatar.cc/150?img=${i + 1}'
    },
  );

  List<Map<String, String>> getFollowing() => List.generate(
    6,
        (i) => {
      'name': 'Following ${i + 1}',
      'username': '@following${i + 1}',
      'avatar': 'https://i.pravatar.cc/150?img=${i + 10}'
    },
  );

  List<Map<String, String>> getFestivals() => [
    {'title': 'Reading & Leeds Festival'},
    {'title': 'Edinburgh Festival Fringe'},
    {'title': 'Diwali Festival'},
  ];

  List<Map<String, dynamic>> getLeaderboard() => [
    {'name': 'Patrick', 'points': 240, 'rank': 1},
    {'name': 'James', 'points': 210, 'rank': 2},
    {'name': 'Michael', 'points': 190, 'rank': 3},
  ];
}
