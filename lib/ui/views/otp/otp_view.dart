import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/base_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/utils/backbutton.dart';
import '../../../shared/widgets/responsive_text_widget.dart';
import '../../../shared/widgets/responsive_widget.dart';
import '../../../shared/extensions/context_extensions.dart';
import 'opt_view_model.dart';


class OtpView extends BaseView<OtpViewModel> {
  const OtpView({super.key});

  @override
  OtpViewModel createViewModel() => OtpViewModel();

  @override
  Widget buildView(BuildContext context, OtpViewModel viewModel) {
    // Listen for error messages and show snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorText != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorText!),
            backgroundColor: AppColors.accent,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: AppColors.onPrimary,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });

    // Set status bar style for dark background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ allows background to move when keyboard opens
        body: Stack(
          children: [
            Positioned.fill(
              child: ResponsiveContainer(
                mobileMaxWidth: double.infinity,
                tabletMaxWidth: double.infinity,
                desktopMaxWidth: double.infinity,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.isSmallScreen 
                        ? AppDimensions.paddingM
                        : context.isMediumScreen 
                            ? AppDimensions.paddingL
                            : AppDimensions.paddingXL,
                    vertical: context.isSmallScreen 
                        ? AppDimensions.paddingM
                        : context.isMediumScreen 
                            ? AppDimensions.paddingL
                            : AppDimensions.paddingXL
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.bottomsheet),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.spaceXXL),
                        const ResponsiveTextWidget(
                          AppStrings.enterCode,
                          textType: TextType.body, 
                            fontSize: AppDimensions.textXL,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        const SizedBox(height: AppDimensions.spaceS),
                        ResponsiveTextWidget(
                          viewModel.phoneNumber != null 
                            ? "${AppStrings.enterOtpDescription}\n${viewModel.displayPhoneNumber}"
                            : "${AppStrings.enterOtpDescription}\nPlease check your phone for the verification code.",
                          textType: TextType.body, color: AppColors.primary, fontSize: AppDimensions.textM),

                        const SizedBox(height: AppDimensions.paddingL),
                        _buildOtpInput(context, viewModel),

                        if (viewModel.errorText != null) ...[
                          const SizedBox(height: AppDimensions.paddingS),
                          ResponsiveTextWidget(
                            viewModel.errorText!,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: AppDimensions.textM,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        const SizedBox(height: AppDimensions.paddingXL),
                        _buildSignupButton(context, viewModel),
                        const SizedBox(height: AppDimensions.spaceM),
                        _buildResendButton(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppDimensions.paddingM,
              top: AppDimensions.spaceXL,
              child: CustomBackButton(onTap: () => context.pop()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInput(BuildContext context, OtpViewModel viewModel) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      focusNode: viewModel.otpFocus,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        fieldHeight: context.isSmallScreen 
            ? AppDimensions.buttonHeightL
            : context.isMediumScreen 
                ? AppDimensions.buttonHeightXL
                : AppDimensions.buttonHeightXL * 1.2,
        fieldWidth: context.isSmallScreen 
            ? AppDimensions.buttonHeightL
            : context.isMediumScreen 
                ? AppDimensions.buttonHeightXL
                : AppDimensions.buttonHeightXL * 1.2,
        inactiveFillColor: AppColors.onPrimary,
        activeFillColor: AppColors.onPrimary,
        selectedFillColor: AppColors.onPrimary,
        inactiveColor: AppColors.white, // ✅ white border
        selectedColor: AppColors.primary,
        activeColor: AppColors.primary,
      ),
      textStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: AppDimensions.textXXL,
        fontWeight: FontWeight.bold,
      ),
      cursorColor: AppColors.primary,
      animationDuration: AppDurations.otpAnimationDuration,
      enableActiveFill: true,
      onChanged: viewModel.onCodeChanged,
      onCompleted: (_) {
        // Dismiss keyboard when OTP is completed
        viewModel.unfocusOtpField();
        viewModel.verifyCode();
      },
    );
  }

  Widget _buildSignupButton(BuildContext context, OtpViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: context.isSmallScreen 
          ? AppDimensions.buttonHeightL
          : context.isMediumScreen 
              ? AppDimensions.buttonHeightXL
              : AppDimensions.buttonHeightXL * 1.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
        ),
        onPressed: (viewModel.isOtpValid && !viewModel.isLoading)
            ? () {
                // Dismiss keyboard when continue is clicked
                viewModel.unfocusOtpField();
                viewModel.verifyCode();
              }
            : null,
        child: viewModel.isLoading
            ? const SizedBox(
          width: AppDimensions.iconS,
          height: AppDimensions.iconS,
          child: CircularProgressIndicator(
            color: AppColors.accent,
            strokeWidth: AppDimensions.borderWidthS,
          ),
        )
            : const ResponsiveTextWidget(
          AppStrings.signUp,
          textType: TextType.body, 
            color: AppColors.onPrimary,
            fontSize: AppDimensions.textXL,
          ),
        ),
    );
  }

  Widget _buildResendButton(BuildContext context, OtpViewModel viewModel) {
    return Center(
      child: TextButton(
        onPressed: viewModel.isLoading ? null : viewModel.resendCode,
        child: const ResponsiveTextWidget(
          AppStrings.resendCode,
          textType: TextType.body, 
            color: AppColors.primary,
            fontSize: AppDimensions.textM,
            fontWeight: FontWeight.w500,
          ),
        ),
    );
  }
}
