import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../post_model.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with AutomaticKeepAliveClientMixin {
  bool _showReactions = false;
  String? _selectedReaction; // stores emoji / icon selected
  Color _reactionColor = AppColors.white; // default Like color
  PageController? _pageController;
  int _currentPage = 0;
  
  // Video controllers for each media item (only initialize when needed)
  Map<int, VideoPlayerController?> _videoControllers = {};
  Map<int, ChewieController?> _chewieControllers = {};
  Map<int, bool> _isVideoInitialized = {};
  Map<int, bool> _isInitializingVideo = {};

  @override
  bool get wantKeepAlive => true; // Keep state alive when scrolled

  @override
  void initState() {
    super.initState();
    final mediaCount = widget.post.allMediaPaths.length;
    if (mediaCount > 1) {
      _pageController = PageController();
    }
  }

  void _initializeVideo(int index) async {
    if ((_isVideoInitialized[index] ?? false) || (_isInitializingVideo[index] ?? false)) return;
    
    setState(() {
      _isInitializingVideo[index] = true;
    });

    try {
      final mediaPaths = widget.post.allMediaPaths;
      if (index >= mediaPaths.length) return;
      
      final videoPath = mediaPaths[index];
      _videoControllers[index] = VideoPlayerController.file(File(videoPath));
      await _videoControllers[index]!.initialize();
      
      if (mounted) {
        _chewieControllers[index] = ChewieController(
          videoPlayerController: _videoControllers[index]!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoControllers[index]!.value.aspectRatio,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primary,
            backgroundColor: AppColors.onSurface.withOpacity(0.3),
            bufferedColor: AppColors.onSurface.withOpacity(0.5),
          ),
        );
        setState(() {
          _isVideoInitialized[index] = true;
          _isInitializingVideo[index] = false;
        });
      }
    } catch (error) {
      debugPrint('Error initializing video at index $index: $error');
      if (mounted) {
        setState(() {
          _isInitializingVideo[index] = false;
        });
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    // Initialize video if current page is a video
    if (widget.post.isVideoAtIndex(index)) {
      _initializeVideo(index);
    }
  }

  void _toggleReactions() {
    setState(() {
      _showReactions = !_showReactions;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    // Dispose all video controllers
    for (var controller in _chewieControllers.values) {
      controller?.dispose();
    }
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }
    _chewieControllers.clear();
    _videoControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final post = widget.post;
    return Container(
      height: context.isLargeScreen 
        ? MediaQuery.of(context).size.height * 0.6
        : context.isMediumScreen 
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.postBackground.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.postBorderRadius),
          topRight: Radius.circular(AppDimensions.postBorderRadius),
        ),        boxShadow: [
          BoxShadow(
            color: AppColors.postShadow.withOpacity(AppDimensions.postBoxShadowOpacity),
            blurRadius: AppDimensions.postBoxShadowBlur,
            offset: const Offset(0, AppDimensions.postBoxShadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: [
//          Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: const AssetImage(AppAssets.profile),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.accent),
            ),
            subtitle: Text(post.timeAgo
                  , style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.primary),
            ),
            trailing: const Icon(Icons.more_horiz),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.postContentPaddingHorizontal,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.content,
                style: const TextStyle(color: AppColors.primary),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.reactionIconSpacing),



          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.postBorderRadius),
              child: Stack(
                children: [
                  // Background Image or Video (single or multiple with slider)
                  Positioned.fill(
                    child: post.hasMultipleMedia
                        ? _buildMediaCarousel()
                        : _buildSingleMedia(),
                  ),

                  // Floating Likes/Comments
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _toggleReactions,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            ),
                            child: Row(
                              children: [
                                _selectedReaction == null
                                    ? Icon(Icons.thumb_up,
                                    color: AppColors.white, 
                                    size: context.isLargeScreen ? 24 : context.isMediumScreen ? 22 : 20)
                                    : Text(
                                  _selectedReaction!,
                                  style: TextStyle(
                                    fontSize: AppDimensions.textL,
                                    color: _reactionColor,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spaceXS),
                                Text("${post.likes}",
                                    style: const TextStyle(color: AppColors.white)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceS),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                          InkWell(
                            onTap: () {
                              // Navigate to comment screen using your app router
                              Navigator.pushNamed(
                                context,
                                AppRoutes.comments, // 👈 Define this route
                                arguments: post,    // optional: pass the post if needed
                              );
                            },
                          child: Row(
                            children: [
                              Icon(Icons.comment_outlined,
                                  color: AppColors.white, 
                                  size: context.isLargeScreen ? 22 : context.isMediumScreen ? 20 : 18),
                              const SizedBox(width: AppDimensions.spaceXS),
                              Text("${post.comments}",
                                  style: const TextStyle(color: AppColors.white)),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),

                  // Reactions Popup
                  if (_showReactions)
                    Positioned(
                      bottom: 88,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.2),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildEmojiReaction(AppStrings.emojiLike, AppStrings.like, AppColors.reactionLike), // blue like
                            _buildEmojiReaction(AppStrings.emojiLove, AppStrings.love),
                            _buildEmojiReaction(AppStrings.emojiHaha, AppStrings.haha),
                            _buildEmojiReaction(AppStrings.emojiWow, AppStrings.wow),
                            _buildEmojiReaction(AppStrings.emojiSad, AppStrings.sad),
                            _buildEmojiReaction(AppStrings.emojiAngry, AppStrings.angry),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Reaction Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite,
                  color: AppColors.reactionLike,
                  size: context.isLargeScreen ? AppDimensions.reactionIconSize + 4 : context.isMediumScreen ? AppDimensions.reactionIconSize + 2 : AppDimensions.reactionIconSize),
              const SizedBox(width: AppDimensions.reactionIconSpacing),
              Icon(Icons.thumb_up,
                  color: AppColors.reactionLove,
                  size: context.isLargeScreen ? AppDimensions.reactionIconSize + 4 : context.isMediumScreen ? AppDimensions.reactionIconSize + 2 : AppDimensions.reactionIconSize),
              const SizedBox(width: AppDimensions.reactionIconSpacing),
              Text("${post.likes}",style: TextStyle(color: AppColors.white),),

               SizedBox(width: context.isLargeScreen 
                 ? context.screenWidth * 0.4
                 : context.isMediumScreen 
                   ? context.screenWidth * 0.35
                   : context.screenWidth * 0.3),

              Text("${post.comments} ",style: TextStyle(color: AppColors.white),),
              const SizedBox(width: AppDimensions.reactionIconSpacing),

              Text("${AppStrings.comments} ",style: TextStyle(color: AppColors.white),),

            ],
          ),





          const SizedBox(height: AppDimensions.reactionIconSpacing),
        ],
      ));
  }

  Widget _buildEmojiReaction(String emoji, String label, [Color color = AppColors.black]) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReaction = emoji;
          _reactionColor = (emoji == AppStrings.emojiLike) ? AppColors.reactionLike : AppColors.black;
          _showReactions = false;
        });
        debugPrint("User reacted with $label");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          emoji,
          style: TextStyle(fontSize: AppDimensions.textXXL, color: (emoji == AppStrings.emojiLike) ? AppColors.reactionLike : null),
        ),
      ),
    );
  }

  /// Check if the path is an asset path (starts with 'assets/') or a file path
  bool _isAssetPath(String path) {
    return path.startsWith('assets/');
  }

  /// Build media carousel for multiple items
  Widget _buildMediaCarousel() {
    final mediaPaths = widget.post.allMediaPaths;
    
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: mediaPaths.length,
          itemBuilder: (context, index) {
            return _buildMediaItem(index);
          },
        ),
        // Page indicators
        if (mediaPaths.length > 1)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: _buildPageIndicators(mediaPaths.length),
          ),
      ],
    );
  }

  /// Build single media item (image or video)
  Widget _buildSingleMedia() {
    // Check if it's a video using the new structure (mediaPaths) or old structure (isVideo)
    final isVideo = widget.post.isVideoAtIndex(0);
    
    if (isVideo) {
      return _buildVideoThumbnailOrPlayer(0);
    } else {
      // Use allMediaPaths to support both old and new formats
      final mediaPaths = widget.post.allMediaPaths;
      final mediaPath = mediaPaths.isNotEmpty ? mediaPaths[0] : widget.post.imagePath;
      
      return _isAssetPath(mediaPath)
          ? Image.asset(
              mediaPath,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : Image.file(
              File(mediaPath),
              fit: BoxFit.cover,
              width: double.infinity,
            );
    }
  }

  /// Build a single media item at given index
  Widget _buildMediaItem(int index) {
    final mediaPaths = widget.post.allMediaPaths;
    final mediaPath = mediaPaths[index];
    final isVideo = widget.post.isVideoAtIndex(index);

    if (isVideo) {
      return _buildVideoThumbnailOrPlayer(index);
    } else {
      return _isAssetPath(mediaPath)
          ? Image.asset(
              mediaPath,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : Image.file(
              File(mediaPath),
              fit: BoxFit.cover,
              width: double.infinity,
            );
    }
  }

  /// Build page indicators (dots)
  Widget _buildPageIndicators(int count) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? AppColors.accent
                : AppColors.primary.withOpacity(0.5),
          ),
        ),
      ),
    ),
    );
  }

  /// Build video thumbnail with play button or video player
  Widget _buildVideoThumbnailOrPlayer(int index) {
    if ((_isVideoInitialized[index] ?? false) && _chewieControllers[index] != null) {
      return Chewie(controller: _chewieControllers[index]!);
    } else {
      // Show thumbnail with play button - lazy load video on tap
      return GestureDetector(
        onTap: () => _initializeVideo(index),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background placeholder/thumbnail
            _buildVideoThumbnail(index),
            // Dark overlay
            Container(
              color: AppColors.black.withOpacity(0.3),
            ),
            // Loading indicator or play button
            Center(
              child: (_isInitializingVideo[index] ?? false)
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : const Icon(
                      Icons.play_circle_filled,
                      color: AppColors.white,
                      size: 64,
                    ),
            ),
          ],
        ),
      );
    }
  }

  /// Build video thumbnail from first frame (if available)
  Widget _buildVideoThumbnail(int index) {
    // Try to get thumbnail from video file
    try {
      final mediaPaths = widget.post.allMediaPaths;
      if (index >= mediaPaths.length) {
        return Container(color: AppColors.black);
      }
      
      final videoFile = File(mediaPaths[index]);
      if (videoFile.existsSync()) {
        // Use a placeholder image for now
        // In production, you could use video_thumbnail package to extract first frame
        return Container(
          color: AppColors.black,
        );
      }
    } catch (e) {
      debugPrint('Error checking video file: $e');
    }
    return Container(
      color: AppColors.black,
    );
  }
}

// class PostWidget extends StatelessWidget {
//   final PostModel post;
//
//   const PostWidget({super.key, required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.5,
//       margin: const EdgeInsets.symmetric(
//         // horizontal: AppDimensions.postMarginHorizontal,
//         // vertical: AppDimensions.postMarginVertical,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.postBackground.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(AppDimensions.postBorderRadius),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.postShadow.withOpacity(AppDimensions.postBoxShadowOpacity),
//             blurRadius: AppDimensions.postBoxShadowBlur,
//             offset: const Offset(0, AppDimensions.postBoxShadowOffsetY),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(post.imagePath),
//             ),
//             title: Text(
//               post.username,
//               style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.accent),
//             ),
//             subtitle: Text(post.timeAgo),
//             trailing: const Icon(Icons.more_horiz),
//           ),
//
//           // Post Content
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppDimensions.postContentPaddingHorizontal,
//             ),
//             child: Text(post.content,style: const TextStyle(color: AppColors.primary), ),
//           ),
//           const SizedBox(height: AppDimensions.reactionIconSpacing),
//
//           // Post Image
//           // Post Image with overlayed likes/comments
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(AppDimensions.postBorderRadius),
//               child: Stack(
//                 children: [
//                   // The actual post image
//                   Positioned.fill(
//                     child: Image.asset(
//                       post.imagePath,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//
//                   // Floating Likes/Comments container
//                   Positioned(
//                     bottom: 12, // distance from bottom
//                     right: 12,  // distance from right
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Like count
//                           Column(
//                             children: [
//                               const Icon(Icons.thumb_up,
//                                   color: AppColors.white, size: 20),
//                               const SizedBox(width: AppDimensions.spaceXS),
//                               Text(
//                                 "${post.likes}",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           // Comment count
//                           Column(
//                             children: [
//                               const Icon(Icons.comment_outlined,
//                                   color: AppColors.white, size: 20),
//                               const SizedBox(width: AppDimensions.spaceXS),
//                               Text(
//                                 "${post.comments}",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//
//
//           const SizedBox(height: AppDimensions.reactionIconSpacing),
//
//           // Reaction Row
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppDimensions.postContentPaddingHorizontal,
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.favorite,
//                     color: AppColors.reactionLike,
//                     size: AppDimensions.reactionIconSize),
//                 const SizedBox(width: AppDimensions.reactionIconSpacing),
//                 const Icon(Icons.thumb_up,
//                     color: AppColors.reactionLove,
//                     size: AppDimensions.reactionIconSize),
//                 const SizedBox(width: AppDimensions.reactionIconSpacing),
//                 Text("${post.likes}"),
//                 const Spacer(),
//                 Text("${post.comments}${AppStrings.comments}"),
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           // Actions Row
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppDimensions.actionRowSpacing,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: const [
//                 Icon(Icons.thumb_up_alt_outlined),
//                 Icon(Icons.comment_outlined),
//                 Icon(Icons.share_outlined),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: AppDimensions.reactionIconSpacing),
//         ],
//       ),
//     );
//   }
// }
