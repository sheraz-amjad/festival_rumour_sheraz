import 'package:festival_rumour/core/constants/app_assets.dart';
import 'package:festival_rumour/core/constants/app_colors.dart';
import 'package:festival_rumour/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import 'festivals_job_post_view_model.dart';


class FestivalsJobPostView extends BaseView<FestivalsJobPostViewModel> {
  const FestivalsJobPostView({super.key});

  @override
  FestivalsJobPostViewModel createViewModel() => FestivalsJobPostViewModel();

  @override
  Widget buildView(BuildContext context, FestivalsJobPostViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        viewModel.unfocusAllFields();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const ResponsiveTextWidget(
            AppStrings.postJob,
            textType: TextType.body, color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                AppAssets.bottomsheet,
                fit: BoxFit.cover,
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.paddingL),
                      
                      // Job Post Form
                      _buildJobPostForm(context, viewModel),
                      
                      const SizedBox(height: AppDimensions.paddingL),
                      
                      // Post Job Button
                      _buildPostButton(context, viewModel),
                      
                      const SizedBox(height: AppDimensions.paddingL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobPostForm(BuildContext context, FestivalsJobPostViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.yellow, width: AppDimensions.borderWidthS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const ResponsiveTextWidget(
            AppStrings.jobDetails,
            textType: TextType.body, 
              color: AppColors.yellow,
              fontSize: AppDimensions.textL,
              fontWeight: FontWeight.bold,
            ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Job Title Field
          _buildTextField(
            controller: viewModel.jobTitleController,
            focusNode: viewModel.jobTitleFocusNode,
            label: AppStrings.jobTitle,
            hint: AppStrings.jobTitleHint,
            icon: Icons.work,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Company/Organization Field
          _buildTextField(
            controller: viewModel.companyController,
            focusNode: viewModel.companyFocusNode,
            label: AppStrings.company,
            hint: AppStrings.companyHint,
            icon: Icons.business,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Location Field
          _buildTextField(
            controller: viewModel.locationController,
            focusNode: viewModel.locationFocusNode,
            label: AppStrings.location,
            hint: AppStrings.locationHint,
            icon: Icons.location_on,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Job Type Dropdown
          _buildDropdownField(
            value: viewModel.selectedJobType,
            label: AppStrings.jobType,
            icon: Icons.category,
            items: viewModel.jobTypes,
            onChanged: (value) => viewModel.setJobType(value!),
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Salary Field
          _buildTextField(
            controller: viewModel.salaryController,
            focusNode: viewModel.salaryFocusNode,
            label: AppStrings.salary,
            hint: AppStrings.salaryHint,
            icon: Icons.attach_money,
            keyboardType: TextInputType.text,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Job Description
          _buildTextAreaField(
            controller: viewModel.descriptionController,
            focusNode: viewModel.descriptionFocusNode,
            label: AppStrings.jobDescription,
            hint: AppStrings.jobDescriptionHint,
            icon: Icons.description,
            maxLines: 5,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Requirements
          _buildTextAreaField(
            controller: viewModel.requirementsController,
            focusNode: viewModel.requirementsFocusNode,
            label: AppStrings.requirements,
            hint: AppStrings.requirementsHint,
            icon: Icons.checklist,
            maxLines: 3,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Contact Information
          _buildTextField(
            controller: viewModel.contactController,
            focusNode: viewModel.contactFocusNode,
            label: AppStrings.contactInfo,
            hint: AppStrings.contactInfoHint,
            icon: Icons.contact_mail,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: AppDimensions.paddingM),
          
          // Festival Date
          _buildTextField(
            controller: viewModel.festivalDateController,
            focusNode: viewModel.festivalDateFocusNode,
            label: AppStrings.festivalDate,
            hint: AppStrings.festivalDateHint,
            icon: Icons.calendar_today,
          ),
      ]
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.yellow, size: 20),
            const SizedBox(width: AppDimensions.spaceS),
            ResponsiveTextWidget(
              label,
              textType: TextType.body,
              color: AppColors.yellow,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.black.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.yellow.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.yellow.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.yellow, width: AppDimensions.borderWidthS),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM, vertical: AppDimensions.spaceM),
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 3,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.yellow, size: 20),
            const SizedBox(width: AppDimensions.spaceS),
            ResponsiveTextWidget(
              label,
              textType: TextType.body,
              color: AppColors.yellow,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.black.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.yellow.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.yellow.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.yellow, width: AppDimensions.borderWidthS),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM, vertical: AppDimensions.spaceM),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.yellow, size: 20),
            const SizedBox(width: AppDimensions.spaceS),
            ResponsiveTextWidget(
              label,
              textType: TextType.body,
              color: AppColors.yellow,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.black.withOpacity(0.9),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.yellow),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: ResponsiveTextWidget(
                    item,
                    textType: TextType.body,
                    color: AppColors.white,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostButton(BuildContext context, FestivalsJobPostViewModel viewModel) {
    return Container(
      height: AppDimensions.buttonHeightXL,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.yellow, AppColors.orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: viewModel.isLoading ? null : () => viewModel.postJob(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: viewModel.isLoading
            ? const SizedBox(
                height: AppDimensions.iconS,
                width: AppDimensions.iconS,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, color: Colors.white),
                  SizedBox(width: AppDimensions.spaceS),
                  ResponsiveTextWidget(
                    AppStrings.postJob,
                    textType: TextType.body, 
                      color: AppColors.white,
                      fontSize: AppDimensions.textL,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
      ),
    );
  }
}
