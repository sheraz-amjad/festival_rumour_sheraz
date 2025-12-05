import 'package:festival_rumour/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import 'festivals_job_view_model.dart';


class FestivalsJobView extends BaseView<FestivalsJobViewModel> {
  const FestivalsJobView({super.key});

  @override
  FestivalsJobViewModel createViewModel() => FestivalsJobViewModel();

  @override
  Widget buildView(BuildContext context, FestivalsJobViewModel viewModel) {
    return Scaffold(
      extendBodyBehindAppBar: true,
     // backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const ResponsiveTextWidget(
          AppStrings.festivalGizzaJob,
          textType: TextType.body, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.bottomsheet, // replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: viewModel.jobs.length,
          itemBuilder: (context, index) {
            final job = viewModel.jobs[index];
            return _JobCard(job: job);
          },
        ),
      ),
    ]
    ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent, width: AppDimensions.borderWidthS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveTextWidget(
            job.title,
            textType: TextType.title,
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: AppDimensions.spaceS),
          ResponsiveTextWidget(
            job.description,
            textType: TextType.caption,
            color: Colors.white,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimensions.spaceS),
          Align(
            alignment: Alignment.bottomRight,
            child: ResponsiveTextWidget(
              AppStrings.more,
              textType: TextType.caption,
              color: Colors.yellow.shade600,
            ),
            ),
        ],
      ),
    );
  }
}
