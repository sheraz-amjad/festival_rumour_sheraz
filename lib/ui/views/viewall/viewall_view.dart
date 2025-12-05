import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/backbutton.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../event/event_view.dart';
import '../performance/performance_view.dart';
import '../news/news_view_model.dart';
import 'viewall_view_model.dart';

class ViewAllView extends BaseView<ViewAllViewModel> {
  final VoidCallback? onBack;
  final int? initialTab;
  const ViewAllView({super.key, this.onBack, this.initialTab});

  @override
  ViewAllViewModel createViewModel() =>
      ViewAllViewModel(initialTab: initialTab);

  @override
  Widget buildView(BuildContext context, ViewAllViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        if (onBack != null) {
          onBack!();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            /// 🔹 Background image
            Positioned.fill(
              child: Image.asset(
                AppAssets.bottomsheet,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.grey50, AppColors.white],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, viewModel),
                  if (viewModel.showTabSelector) ...[
                    const SizedBox(height: AppDimensions.spaceM),
                    _buildTabSelector(context, viewModel),
                    const SizedBox(height: AppDimensions.spaceM),
                  ] else
                    const SizedBox(height: AppDimensions.spaceM),
                  Expanded(child: _buildContent(context, viewModel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ViewAllViewModel viewModel) {
    String title=AppStrings.events;
    if (viewModel.selectedTab == 0) {
      title = ' ${AppStrings.events}';
    } else if (viewModel.selectedTab == 1) {
      title = '${AppStrings.lunaNews}';
    } else if (viewModel.selectedTab == 2) {
      title = '${AppStrings.performance}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          GestureDetector(onTap: onBack ?? () => Navigator.pop(context),
        child: Container(
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.eventGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_back,
        color: AppColors.white,
        size: AppDimensions.iconM,
      ),
    ),
    ),
          const SizedBox(width: AppDimensions.spaceM),
          ResponsiveTextWidget(
            title,
            textType: TextType.title,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context, ViewAllViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingXS),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              context,
              AppStrings.events,
              0,
              viewModel.selectedTab == 0,
              AppColors.eventGreen,
              () => viewModel.setSelectedTab(0),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXS),
          Expanded(
            child: _buildTabButton(
              context,
              AppStrings.lunaNews,
              1,
              viewModel.selectedTab == 1,
              AppColors.newsGreen,
              () => viewModel.setSelectedTab(1),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXS),
          Expanded(
            child: _buildTabButton(
              context,
              AppStrings.performance,
              2,
              viewModel.selectedTab == 2,
              AppColors.performanceGreen,
              () => viewModel.setSelectedTab(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label,
    int index,
    bool isSelected,
    Color selectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingS,
          horizontal: AppDimensions.paddingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Center(
          child: ResponsiveTextWidget(
            label,
            textType: TextType.caption,
            color: isSelected ? AppColors.white : AppColors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ViewAllViewModel viewModel) {
    switch (viewModel.selectedTab) {
      case 0:
        return _buildEventsList(context, viewModel);
      case 1:
        return _buildNewsList(context, viewModel);
      case 2:
        return _buildPerformancesList(context, viewModel);
      default:
        return _buildEventsList(context, viewModel);
    }
  }

  Widget _buildEventsList(BuildContext context, ViewAllViewModel viewModel) {
    if (viewModel.events.isEmpty) {
      return Center(
        child: ResponsiveTextWidget(
          AppStrings.noEvents,
          textType: TextType.body,
          color: AppColors.grey600,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      itemCount: viewModel.events.length,
      itemBuilder: (context, index) {
        final event = viewModel.events[index];
        return _buildEventCard(context, event, index);
      },
    );
  }

  Widget _buildEventCard(BuildContext context, EventCategory event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: index == 1 ? AppColors.eventGreen : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.eventGreen,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppAssets.assignmentIcon,
              width: AppDimensions.iconL,
              height: AppDimensions.iconL,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveTextWidget(
                  event.name,
                  textType: TextType.body,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                ResponsiveTextWidget(
                  event.description,
                  textType: TextType.caption,
                  color: AppColors.grey600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(BuildContext context, ViewAllViewModel viewModel) {
    if (viewModel.news.isEmpty) {
      return Center(
        child: ResponsiveTextWidget(
          AppStrings.noNews,
          textType: TextType.body,
          color: AppColors.grey600,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      itemCount: viewModel.news.length,
      itemBuilder: (context, index) {
        final newsItem = viewModel.news[index];
        return _buildNewsCard(context, newsItem);
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, FestivalItem newsItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.newsGreen,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppAssets.news,
              width: AppDimensions.iconL,
              height: AppDimensions.iconL,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveTextWidget(
                  newsItem.name,
                  textType: TextType.body,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                ResponsiveTextWidget(
                  newsItem.description,
                  textType: TextType.caption,
                  color: AppColors.grey600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformancesList(
    BuildContext context,
    ViewAllViewModel viewModel,
  ) {
    if (viewModel.performances.isEmpty) {
      return Center(
        child: ResponsiveTextWidget(
          AppStrings.noData,
          textType: TextType.body,
          color: AppColors.grey600,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      itemCount: viewModel.performances.length,
      itemBuilder: (context, index) {
        final performance = viewModel.performances[index];
        return _buildPerformanceCard(context, performance);
      },
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    PerformanceCategory performance,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.performanceLightBlue,
          width: AppDimensions.borderWidthS,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.performanceGreen,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppAssets.performance,
              width: AppDimensions.iconL,
              height: AppDimensions.iconL,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveTextWidget(
                  performance.name,
                  textType: TextType.body,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                ResponsiveTextWidget(
                  performance.description,
                  textType: TextType.caption,
                  color: AppColors.grey600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
