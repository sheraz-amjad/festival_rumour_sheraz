import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/backbutton.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import 'chat_view_model.dart';

class ChatView extends BaseView<ChatViewModel> {
  final VoidCallback? onBack;
  const ChatView({super.key, this.onBack});

  @override
  ChatViewModel createViewModel() => ChatViewModel();

  @override
  Widget buildView(BuildContext context, ChatViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              viewModel.isInChatRoom 
                  ? AppAssets.privatebackground
                  : (viewModel.selectedTab == 0
                      ? AppAssets.publicbackground  // Public
                      : AppAssets.privatebackground), // Private
              fit: BoxFit.cover,
            ),
          ),
          
          // Dark overlay
          Positioned.fill(
            child: Container(color: AppColors.overlayBlack45),
          ),
          
          // Main content
          if (viewModel.isInChatRoom)
            _buildChatRoomView(context, viewModel)
          else
            _buildChatListView(context, viewModel),
        ],
      ),
      floatingActionButton: !viewModel.isInChatRoom && viewModel.selectedTab == 1 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createChatRoom);
              },
              backgroundColor: AppColors.accent,
              child: const Icon(
                Icons.chat,
                color: AppColors.black,
              ),
            )
          : null,
    ),
    );
  }

  Widget _buildChatListView(BuildContext context, ChatViewModel viewModel) {
    return Stack(
      children: [
        // App bar (extends into status bar)
        _buildAppBar(context, viewModel),
        
        // Main content (below app bar)
        Positioned(
          top: MediaQuery.of(context).padding.top + 70, // Status bar + app bar height
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              _buildSegmentedControl(context, viewModel),
              const SizedBox(height: AppDimensions.spaceL),
              Expanded(
                child: _buildChatRooms(context, viewModel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatRoomView(BuildContext context, ChatViewModel viewModel) {
    return SafeArea(
      child: Column(
        children: [
          _buildChatRoomAppBar(context, viewModel),
          Expanded(
            child: _buildChatContent(context, viewModel),
          ),
          _buildInputSection(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ChatViewModel viewModel) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.5),
        ),
        child: Row(
          children: [
            CustomBackButton(
              onTap: onBack ?? () {
                // Navigate back to discover screen using ViewModel
                viewModel.navigateBack(context);
              },
            ),
            Expanded(
              child: ResponsiveTextWidget(
                AppStrings.chatRooms,
                textAlign: TextAlign.center,
                textType: TextType.title,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(BuildContext context, ChatViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setSelectedTab(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS, horizontal: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: viewModel.selectedTab == 0 ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.public,
                      width: AppDimensions.iconS,
                      height: AppDimensions.iconS,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    ResponsiveTextWidget(
                      AppStrings.public,
                      textType: TextType.body,
                      color: viewModel.selectedTab == 0 ? AppColors.black : AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.setSelectedTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS, horizontal: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: viewModel.selectedTab == 1 ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.private,
                      width: AppDimensions.iconS,
                      height: AppDimensions.iconS,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    ResponsiveTextWidget(
                      AppStrings.private,
                      textType: TextType.body,
                      color: viewModel.selectedTab == 1 ? AppColors.black : AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRooms(BuildContext context, ChatViewModel viewModel) {
    if (viewModel.selectedTab == 1) {
      // Private chat rooms
      return _buildPrivateChatList(context, viewModel);
    } else {
      // Public chat rooms - show grid view
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingS),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Adjust height vs width ratio
        ),
        itemCount: viewModel.chatRooms1.length,
        itemBuilder: (context, index) {
          final room = viewModel.chatRooms1[index];
          return GestureDetector(
            onTap: () {
              viewModel.enterChatRoom(room);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                color: AppColors.onPrimary.withOpacity(0.3),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: AppDimensions.dividerThickness,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image section
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        room['image'] ?? AppAssets.post,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // Text section
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spaceS),
                    child: ResponsiveTextWidget(
                      room['name'] ?? AppStrings.lunaCommunityRoom,
                      textAlign: TextAlign.center,
                      textType: TextType.caption,
                      fontSize: AppDimensions.textM,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildPrivateChatList(BuildContext context, ChatViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingS),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 15,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // Adjust height vs width ratio
      ),
      itemCount: viewModel.privateChats.length,
      itemBuilder: (context, index) {
        final chat = viewModel.privateChats[index];
        return _buildPrivateChatItem(context, viewModel, chat);
      },
    );
  }


  Widget _buildPrivateChatItem(BuildContext context, ChatViewModel viewModel, Map<String, dynamic> chat) {
    return GestureDetector(
      onTap: () {
        // Navigate to private chat room
        viewModel.enterChatRoom(chat);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          color: AppColors.onPrimary.withOpacity(0.3),
          border: Border.all(
            color: AppColors.white.withOpacity(0.2),
            width: AppDimensions.dividerThickness,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image section - same as public chat
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  chat['image'] ?? AppAssets.post,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // Text section - same as public chat
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingS),
              child: ResponsiveTextWidget(
                chat['name'] ?? AppStrings.chatName,
                textAlign: TextAlign.center,
                fontSize: AppDimensions.textM,
                textType: TextType.caption,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCommunityCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        children: [
          // Top row - two cards side by side
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  context,
                  AppStrings.lunaNews,
                  AppAssets.news,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.news),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),

        ],
      ),
    ],
      )
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String imagePath, {
        bool isFullWidth = false,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.imageXXL,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),

              // Background layer at the bottom (30% height)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: AppDimensions.imageXXL * 0.3, // 30% of container height
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.6),
                  ),
                ),
              ),

              // Centered text within background layer
              Positioned(
                bottom: AppDimensions.paddingM,
                left: 0,
                right: 0,
                child: Center(
                  child: ResponsiveTextWidget(
                    title,
                    textType: TextType.heading,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatRoomAppBar(BuildContext context, ChatViewModel viewModel) {
    return Container(
      height: AppDimensions.buttonHeightM,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.spaceS),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () {
              // Exit chat room and navigate back to chat list
              viewModel.exitChatRoom();
            },
          ),
          Expanded(
            child: ResponsiveTextWidget(
              viewModel.currentChatRoom?['name'] ?? AppStrings.lunaCommunityRoom,
              textType: TextType.body,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {
              // Handle share action
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.white),
            onPressed: () {
              // Handle favorite action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(BuildContext context, ChatViewModel viewModel) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          // FestivalRumour logo and timestamp
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                Container(
                  width: AppDimensions.imageS,
                  height: AppDimensions.imageS,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: const Center(
                    child: ResponsiveTextWidget(
                      AppStrings.festivalRumourLogo,
                      textType: TextType.body,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                const ResponsiveTextWidget(
                  AppStrings.festivalRumourTimestamp,
                  textType: TextType.caption,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          
          // Welcome message bubble
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResponsiveTextWidget(
                    AppStrings.joinConversation,
                    textType: TextType.body,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  const ResponsiveTextWidget(
                    AppStrings.followTopicDescription,
                    textType: TextType.caption,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  GestureDetector(
                    onTap: () => viewModel.inviteFriends(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: AppDimensions.borderWidthS),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: const Center(
                        child: ResponsiveTextWidget(
                          AppStrings.inviteYourFriends,
                          textType: TextType.caption,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, ChatViewModel viewModel) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          // Input field row
          Row(
            children: [
              Container(
                width: AppDimensions.iconM,
                height: AppDimensions.iconM,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.black,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Container(
                  height: AppDimensions.imageS,
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: TextField(
                    controller: viewModel.messageController,
                    cursorColor: AppColors.primary,
                    decoration: const InputDecoration(
                      hintText: AppStrings.typeSomething,
                      hintStyle: TextStyle(color: AppColors.grey600),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: AppColors.black),
                    onSubmitted: (_) => viewModel.sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingS),
              GestureDetector(
                onTap: () => viewModel.sendMessage(),
                child: Container(
                  width: AppDimensions.iconM,
                  height: AppDimensions.iconM,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


