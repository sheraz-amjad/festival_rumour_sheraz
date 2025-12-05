import 'package:festival_rumour/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/base_view.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'edit_account_view_model.dart';

class EditAccountView extends BaseView<EditAccountViewModel> {
  const EditAccountView({super.key});

  @override
  EditAccountViewModel createViewModel() => EditAccountViewModel();

  @override
  Widget buildView(BuildContext context, EditAccountViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: viewModel.goBack,
        ),
        title: const ResponsiveTextWidget(
          AppStrings.editAccountDetails,
          textType: TextType.title,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: ElevatedButton.icon(
              onPressed: viewModel.saveChanges,
              icon: const Icon(Icons.save, size: 18),
              label: const ResponsiveTextWidget(
                AppStrings.save,
                textType: TextType.caption,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const LoadingWidget(message: AppStrings.loading)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    _buildPersonalInfoSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    _buildContactInfoSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    _buildPasswordSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    _buildPreferencesSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    _buildDangerZoneSection(context, viewModel),
                    const SizedBox(height: AppDimensions.paddingXL),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              const Expanded(
                child: ResponsiveTextWidget(
                  "Profile Information",
                  textType: TextType.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Profile Image with professional styling
          Stack(
            children: [
              GestureDetector(
                onTap: viewModel.pickProfileImage,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey100,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: viewModel.profileImagePath != null
                      ? ClipOval(
                          child: Image.asset(
                            viewModel.profileImagePath!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 70,
                          color: AppColors.grey500,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          const ResponsiveTextWidget(
            AppStrings.tapToUploadImage,
            textType: TextType.caption,
            color: AppColors.grey600,
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          
          const ResponsiveTextWidget(
            "Recommended: 400x400px, Max 5MB",
            textType: TextType.caption,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              const Expanded(
                child: ResponsiveTextWidget(
                  "Personal Information",
                  textType: TextType.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Name Field
          _buildTextField(
            controller: viewModel.nameController,
            label: "Full Name",
            hint: "Enter your full name",
            validator: viewModel.validateName,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Bio Field
          _buildTextField(
            controller: viewModel.bioController,
            label: "Bio",
            hint: "Tell us about yourself",
            validator: viewModel.validateBio,
            icon: Icons.description_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.contact_mail_outlined,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              const Expanded(
                child: ResponsiveTextWidget(
                  "Contact Information",
                  textType: TextType.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Email Field
          _buildTextField(
            controller: viewModel.emailController,
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            validator: viewModel.validateEmail,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Phone Field
          _buildTextField(
            controller: viewModel.phoneController,
            label: AppStrings.phoneNumber,
            hint: AppStrings.phoneHint,
            validator: viewModel.validatePhone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Website Field
          _buildTextField(
            controller: viewModel.websiteController,
            label: "Website",
            hint: "https://yourwebsite.com",
            validator: viewModel.validateWebsite,
            icon: Icons.language_outlined,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveTextWidget(
            AppStrings.changePassword,
            textType: TextType.title,
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimary,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Current Password
          _buildPasswordField(
            controller: viewModel.currentPasswordController,
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            validator: viewModel.validateCurrentPassword,
            isVisible: viewModel.isPasswordVisible,
            onToggleVisibility: viewModel.togglePasswordVisibility,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // New Password
          _buildPasswordField(
            controller: viewModel.newPasswordController,
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            validator: viewModel.validateNewPassword,
            isVisible: viewModel.isNewPasswordVisible,
            onToggleVisibility: viewModel.toggleNewPasswordVisibility,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Confirm Password
          _buildPasswordField(
            controller: viewModel.confirmPasswordController,
            label: AppStrings.confirmPasswordLabel,
            hint: AppStrings.confirmPasswordHint,
            validator: viewModel.validateConfirmPassword,
            isVisible: viewModel.isConfirmPasswordVisible,
            onToggleVisibility: viewModel.toggleConfirmPasswordVisibility,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Change Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: viewModel.changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: const ResponsiveTextWidget(
                AppStrings.changePassword,
                textType: TextType.body,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              const Expanded(
                child: ResponsiveTextWidget(
                  "Preferences",
                  textType: TextType.title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Language Preference
          _buildDropdownField(
            label: "Language",
            value: viewModel.selectedLanguage,
            items: const ["English", "Spanish", "French", "German"],
            onChanged: viewModel.setLanguage,
            icon: Icons.language_outlined,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Timezone Preference
          _buildDropdownField(
            label: "Timezone",
            value: viewModel.selectedTimezone,
            items: const ["UTC", "EST", "PST", "GMT"],
            onChanged: viewModel.setTimezone,
            icon: Icons.schedule_outlined,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          // Notification Preferences
          _buildSwitchTile(
            title: "Email Notifications",
            subtitle: "Receive updates via email",
            value: viewModel.emailNotifications,
            onChanged: viewModel.setEmailNotifications,
            icon: Icons.email_outlined,
          ),
          _buildSwitchTile(
            title: "Push Notifications",
            subtitle: "Receive push notifications",
            value: viewModel.pushNotifications,
            onChanged: viewModel.setPushNotifications,
            icon: Icons.notifications_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneSection(BuildContext context, EditAccountViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(
        context.isSmallScreen 
            ? AppDimensions.paddingM
            : context.isMediumScreen 
                ? AppDimensions.paddingL
                : AppDimensions.paddingXL
      ),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveTextWidget(
            AppStrings.dangerZone,
            textType: TextType.title,
            fontWeight: FontWeight.bold,
            color: AppColors.red,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          
          const ResponsiveTextWidget(
            AppStrings.deleteAccountWarning,
            textType: TextType.caption,
            color: AppColors.red,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: viewModel.isDeletingAccount ? null : () => _showDeleteAccountDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: viewModel.isDeletingAccount
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const ResponsiveTextWidget(
                      AppStrings.delete,
                      textType: TextType.body,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: AppColors.grey600,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const ResponsiveTextWidget(
            "Delete Account",
            textType: TextType.title,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: const ResponsiveTextWidget(
            "Are you sure you want to delete your account? This action cannot be undone.",
            textType: TextType.body,
            color: AppColors.onPrimary,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const ResponsiveTextWidget(
                AppStrings.cancel,
                textType: TextType.body,
                color: AppColors.grey600,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete account logic
              },
              child: const ResponsiveTextWidget(
                AppStrings.delete,
                textType: TextType.body,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveTextWidget(
          label,
          textType: TextType.body,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimary,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey600, size: 20),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveTextWidget(
                  title,
                  textType: TextType.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onPrimary,
                ),
                ResponsiveTextWidget(
                  subtitle,
                  textType: TextType.caption,
                  color: AppColors.grey600,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
