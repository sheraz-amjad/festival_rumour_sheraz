class PostModel {
  final String username;
  final String timeAgo;
  final String content;
  final String imagePath; // For backward compatibility - use first media item if multiple
  final int likes;
  final int comments;
  final String status; // 'live', 'past', 'upcoming'
  final bool isVideo; // Whether the first media is a video (for backward compatibility)
  final List<String>? mediaPaths; // List of all media paths (images and videos)
  final List<bool>? isVideoList; // List indicating which items are videos

  PostModel({
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.status,
    this.isVideo = false, // Default to false for backward compatibility
    this.mediaPaths,
    this.isVideoList,
  });

  // Helper getter to check if post has multiple media items
  bool get hasMultipleMedia {
    if (mediaPaths != null && mediaPaths!.isNotEmpty) {
      return mediaPaths!.length > 1;
    }
    return false; // Old posts have single media
  }

  // Helper getter to get all media items (for backward compatibility, returns single item list)
  List<String> get allMediaPaths {
    if (mediaPaths != null && mediaPaths!.isNotEmpty) {
      return mediaPaths!;
    }
    return [imagePath]; // Fallback to single imagePath for old posts
  }

  // Helper getter to check if item at index is video
  bool isVideoAtIndex(int index) {
    if (isVideoList != null && index < isVideoList!.length) {
      return isVideoList![index];
    }
    // Fallback for old posts with single item
    return index == 0 && isVideo;
  }

  PostModel copyWith({
    String? username,
    String? timeAgo,
    String? content,
    String? imagePath,
    int? likes,
    int? comments,
    String? status,
    bool? isVideo,
    List<String>? mediaPaths,
    List<bool>? isVideoList,
  }) {
    return PostModel(
      username: username ?? this.username,
      timeAgo: timeAgo ?? this.timeAgo,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      isVideo: isVideo ?? this.isVideo,
      mediaPaths: mediaPaths ?? this.mediaPaths,
      isVideoList: isVideoList ?? this.isVideoList,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel &&
        other.username == username &&
        other.timeAgo == timeAgo &&
        other.content == content &&
        other.imagePath == imagePath &&
        other.likes == likes &&
        other.comments == comments &&
        other.status == status &&
        other.isVideo == isVideo &&
        other.mediaPaths == mediaPaths &&
        other.isVideoList == isVideoList;
  }

  @override
  int get hashCode {
    return username.hashCode ^
    timeAgo.hashCode ^
    content.hashCode ^
    imagePath.hashCode ^
    likes.hashCode ^
    comments.hashCode ^
    status.hashCode ^
    isVideo.hashCode ^
    (mediaPaths?.hashCode ?? 0) ^
    (isVideoList?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'PostModel(username: $username, timeAgo: $timeAgo, content: $content, imagePath: $imagePath, likes: $likes, comments: $comments, status: $status, isVideo: $isVideo, mediaCount: ${mediaPaths?.length ?? 1})';
  }
}
