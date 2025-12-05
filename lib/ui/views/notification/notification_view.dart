import 'package:flutter/material.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/backbutton.dart';
import '../../../core/utils/snackbar_util.dart';
import 'notification_view_model.dart';

class NotificationView extends BaseView<NotificationViewModel> {
  final VoidCallback? onBack;
  const NotificationView({super.key, this.onBack});

  @override
  NotificationViewModel createViewModel() => NotificationViewModel();

  @override
  Widget buildView(BuildContext context, NotificationViewModel viewModel) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          /// Background - Same as discover screen
          Positioned.fill(
            child: Image.asset(
              AppAssets.bottomsheet,
              fit: BoxFit.cover,
            ),
          ),
          
          /// Content
          SafeArea(
            child: Column(
              children: [
                /// Header
                _buildHeader(context, viewModel),
                
                /// Notifications List
                Expanded(
                  child: _buildNotificationsList(context, viewModel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Back Button
          CustomBackButton(
            onTap: () {
              if (onBack != null) {
                onBack!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          
          /// Title
          const ResponsiveTextWidget(
            AppStrings.notifications,
            textType: TextType.body, 
              color: AppColors.white,
              fontSize: AppDimensions.textL,
              fontWeight: FontWeight.bold,
            ),
          
          /// Mark All Read Button
          if (viewModel.unreadCount > 0)
            GestureDetector(
            onTap: () {
              viewModel.markAllAsRead();
              SnackbarUtil.showSuccessSnackBar(
                context,
                '✅ All notifications marked as read',
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: ResponsiveTextWidget(
                AppStrings.markAllRead,
                textType: TextType.body, 
                  color: AppColors.black,
                  fontSize: AppDimensions.textS,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, NotificationViewModel viewModel) {
    if (viewModel.notifications.isEmpty) {
      return  Center(
        child: ResponsiveTextWidget(
          AppStrings.noNotifications,
          textType: TextType.body, 
            color: AppColors.white,
            fontSize: AppDimensions.textL,
          ),
        );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      itemCount: viewModel.notifications.length,
      itemBuilder: (context, index) {
        final notification = viewModel.notifications[index];
        return _buildNotificationCard(context, notification, viewModel);
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
    NotificationViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: notification.isRead 
          ? AppColors.white.withOpacity(0.1)
          : AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: notification.isRead 
          ? null 
          : Border.all(color: AppColors.accent, width: AppDimensions.borderWidthS),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              viewModel.markAsRead(notification.id);
              SnackbarUtil.showInfoSnackBar(
                context,
                '📱 Notification marked as read',
              );
            }
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Icon
                Container(
                  width: AppDimensions.imageM,
                  height: AppDimensions.imageM,
                  decoration: BoxDecoration(
                    color: Color(notification.iconColor).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(
                    notification.icon,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spaceM),
                
                /// Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      ResponsiveTextWidget(
                        notification.title,
                        textType: TextType.body,
                          color: AppColors.white,
                          fontSize: AppDimensions.textL,
                          fontWeight: notification.isRead 
                            ? FontWeight.w500 
                            : FontWeight.bold,
                        ),
                      SizedBox(height: AppDimensions.spaceXS),
                      
                      /// Message
                      ResponsiveTextWidget(
                        notification.message,
                        textType: TextType.body,
                          color: AppColors.white.withOpacity(0.8),
                          fontSize: AppDimensions.textM,
                        ),

                      SizedBox(height: AppDimensions.spaceS),
                      
                      /// Time and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ResponsiveTextWidget(
                            notification.time,
                            textType: TextType.body, 
                              color: AppColors.white.withOpacity(0.6),
                              fontSize: AppDimensions.textS,
                            ),
                          if (!notification.isRead)
                            Container(
                              width: AppDimensions.spaceS,
                              height: AppDimensions.spaceS,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


