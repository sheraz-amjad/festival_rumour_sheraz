import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/utils/backbutton.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/responsive_widget.dart';
import '../../../shared/extensions/context_extensions.dart';
import 'interests_view_model.dart';

class InterestsView extends BaseView<InterestsViewModel> {
  const InterestsView({super.key});

  @override
  InterestsViewModel createViewModel() => InterestsViewModel();

  @override
  Widget buildView(BuildContext context, InterestsViewModel viewModel) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveContainer(
            mobileMaxWidth: double.infinity,
            tabletMaxWidth: double.infinity,
            desktopMaxWidth: double.infinity,
            child: Container(
              padding:
                  context.isLargeScreen
                      ? const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                        vertical: AppDimensions.paddingL,
                      )
                      : context.isMediumScreen
                      ? const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingM,
                      )
                      : const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingM,
                        vertical: AppDimensions.paddingM,
                      ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.interestback),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(onTap: () => context.pop()),
                  const SizedBox(height: AppDimensions.spaceM),
                  ResponsiveText(
                    AppStrings.yourFestivalInterests,
                    style: const TextStyle(
                    //letterSpacing: 0.5,
                      color: AppColors.accent,
                      fontSize: AppDimensions.textXXL, // custom scaling
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  ResponsiveText(
                    AppStrings.habitsMatch,

                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppDimensions.textM,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  ResponsiveText(
                    AppStrings.chooseCategories,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: AppDimensions.textL + 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  Expanded(child: _buildInterestsGrid(context, viewModel)),
                  const SizedBox(height: AppDimensions.spaceM),
                  _buildActionButtons(context, viewModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsGrid(
    BuildContext context,
    InterestsViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: AppDimensions.spaceXS,
        runSpacing: AppDimensions.spaceXS,
        children:
            viewModel.categories.map((cat) {
              final selected = viewModel.isSelected(cat);
              return _buildInterestChip(cat, selected, viewModel);
            }).toList(),
      ),
    );
  }

  Widget _buildInterestChip(
    String category,
    bool selected,
    InterestsViewModel viewModel,
  ) {
    return ChoiceChip(
      showCheckmark: false,
      label: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingS,
        ),
        child: ResponsiveTextWidget(
          category,
          textType: TextType.body,
          color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
      selected: selected,
      onSelected: (_) => viewModel.toggle(category),
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: BorderSide(
          color: selected ? AppColors.onPrimary : AppColors.onSurface,
          width: selected ? 2 : 1,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    InterestsViewModel viewModel,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: context.getConditionalButtonSize(),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
              padding: context.responsivePadding,
            ),
            onPressed:
                viewModel.hasSelection && !viewModel.isLoading
                    ? () {
                      FocusScope.of(context).unfocus();
                      viewModel.saveInterests();
                    }
                    : null,
            child:
                viewModel.isLoading
                    ? SizedBox(
                      width: context.getConditionalIconSize(),
                      height: context.getConditionalIconSize(),
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
                      ),
                    )
                    : ResponsiveTextWidget(
                      AppStrings.next,
                      style: TextStyle(
                        fontSize: context.getConditionalButtonfont(),
                        color: AppColors.onPrimary,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
      ],
    );
  }
}
