import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/extensions/context_extensions.dart';
import 'comment_viewmodel.dart';

class CommentView extends BaseView<CommentViewModel> {
  const CommentView({super.key});

  @override
  CommentViewModel createViewModel() => CommentViewModel();

  @override
  Widget buildView(BuildContext context, CommentViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Fullscreen background image
          Positioned.fill(
            child: Image.asset(
              AppAssets.bottomsheet,
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 Dark overlay for readability
          Positioned.fill(
            child: Container(color: AppColors.black.withOpacity(0.35)),
          ),

          /// 🔹 Main content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, viewModel),
                Expanded(
                  child: Column(
                    children: [
          // Comment input area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TextField(
                controller: viewModel.commentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: AppStrings.commentHint,
                  hintStyle: TextStyle(color: AppColors.grey600),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppDimensions.textL,
                ),
              ),
            ),
          ),
          
          // Emoji bar
          Container(
            height: AppDimensions.buttonHeightXL,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.spaceS),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.3),
              border: Border(
                top: BorderSide(color: AppColors.grey700, width: AppDimensions.dividerThickness),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => viewModel.insertEmoji(viewModel.emojis[index]),
                  child: Container(
                    margin: EdgeInsets.only(right: AppDimensions.spaceM),
                    child: ResponsiveTextWidget(
                      viewModel.emojis[index],
                      textType: TextType.body,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Keyboard toolbar
          // Container(
          //   height: 50,
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   decoration: const BoxDecoration(
          //     color: AppColors.grey800,
          //     border: Border(
          //       top: BorderSide(color: AppColors.grey700, width: 0.5),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       _buildToolbarIcon(Icons.grid_on, () {}),
          //       const SizedBox(width: 16),
          //       _buildToolbarIcon(Icons.attach_file, () {}),
          //       const SizedBox(width: 16),
          //       _buildToolbarText("GIF", () {}),
          //       const SizedBox(width: 16),
          //       _buildToolbarIcon(Icons.emoji_emotions, () {}),
          //       const SizedBox(width: 16),
          //       _buildToolbarIcon(Icons.photo_library, () {}),
          //       const SizedBox(width: 16),
          //       _buildToolbarIcon(Icons.mic, () {}),
          //     ],
          //   ),
          // ),
          
          // Bottom input bar
          // Container(
          //   height: 60,
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   decoration: const BoxDecoration(
          //     color: AppColors.grey800,
          //     border: Border(
          //       top: BorderSide(color: AppColors.grey700, width: 0.5),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       _buildBottomButton("!?123", () {}),
          //       const SizedBox(width: 8),
          //       _buildBottomButton("😊", () {}),
          //       const SizedBox(width: 8),
          //       Expanded(
          //         child: Container(
          //           height: 40,
          //           padding: const EdgeInsets.symmetric(horizontal: 12),
          //           decoration: BoxDecoration(
          //             color: AppColors.grey700,
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: TextField(
          //             controller: viewModel.commentController,
          //             decoration: const InputDecoration(
          //               hintText: "Type a message...",
          //               hintStyle: TextStyle(color: AppColors.grey600), color: AppColors.grey600),
          //               border: InputBorder.none,
          //             ),
          //             style: const TextStyle(color: AppColors.white),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       _buildBottomButton("@", () {}),
          //       const SizedBox(width: 8),
          //       _buildBottomButton("-", () {}),
          //       const SizedBox(width: 8),
          //       GestureDetector(
          //         onTap: viewModel.postComment,
          //         child: Container(
          //           width: 40,
          //           height: 40,
          //           decoration: const BoxDecoration(
          //             color: AppColors.accent,
          //             shape: BoxShape.circle,
          //           ),
          //           child: const Icon(
          //             Icons.arrow_forward,
          //             color: AppColors.black,
          //             size: 20,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CommentViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.spaceS),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.white, size: 24),
            onPressed: viewModel.closeCommentView,
          ),
          Expanded(
            child: ResponsiveTextWidget(
              AppStrings.comments,
              textAlign: TextAlign.center,
              textType: TextType.title,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: viewModel.postComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.black,
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.spaceS),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const ResponsiveTextWidget(
                AppStrings.post,
                textType: TextType.caption,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToolbarIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: AppColors.grey600,
        size: 24,
      ),
    );
  }

  Widget _buildToolbarText(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ResponsiveTextWidget(
        text,
        textType: TextType.body,
        color: AppColors.grey600,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildBottomButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM, vertical: AppDimensions.spaceS),
        decoration: BoxDecoration(
          color: AppColors.grey700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ResponsiveTextWidget(
          text,
          textType: TextType.body,
          color: AppColors.white,
        ),
      ),
    );
  }
}
