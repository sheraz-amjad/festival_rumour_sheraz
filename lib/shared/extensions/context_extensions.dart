import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/responsive_text_service.dart';

/// Extension methods for BuildContext to provide easy access to common properties
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query data
  MediaQueryData? get mediaQuery => MediaQuery.maybeOf(this);

  /// Get screen size
  Size get screenSize => mediaQuery?.size ?? const Size(0, 0);

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery?.devicePixelRatio ?? 1.0;

  /// Get status bar height
  double get statusBarHeight => mediaQuery?.padding.top ?? 0.0;

  /// Get bottom safe area height
  double get bottomSafeArea => mediaQuery?.padding.bottom ?? 0.0;

  /// Get keyboard height
  double get keyboardHeight => mediaQuery?.viewInsets.bottom ?? 0.0;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery?.orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => mediaQuery?.orientation == Orientation.portrait;

  /// Check if device is a tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  /// Check if device is a phone
  bool get isPhone => !isTablet;

  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if device is in light mode
  bool get isLightMode => theme.brightness == Brightness.light;

  /// Get responsive width based on percentage
  double widthPercent(double percent) => screenWidth * (percent / 100);

  /// Get responsive height based on percentage
  double heightPercent(double percent) => screenHeight * (percent / 100);

  /// Get responsive size (minimum of width and height percentage)
  double sizePercent(double percent) {
    final w = widthPercent(percent);
    final h = heightPercent(percent);
    return w < h ? w : h;
  }



  /// Show a snackbar
  void showSnackBar(
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color? backgroundColor,
        Color? textColor,
        SnackBarAction? action,
      }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textColor != null ? TextStyle(color: textColor) : null,
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
    );
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.warning,
      textColor: AppColors.white,
    );
  }

  /// Show info snackbar
  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.info,
      textColor: AppColors.white,
    );
  }

  /// Navigate to a new screen
  Future<T?> pushNamed<T extends Object?>(
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navigate to a new screen and replace current
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        Object? arguments,
        TO? result,
      }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate to a new screen and clear stack
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName,
      bool Function(Route<dynamic>) predicate, {
        Object? arguments,
      }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Pop current screen
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pop until specific route
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Show loading dialog
  void showLoadingDialog({String? message}) {
    showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              SizedBox(height: AppDimensions.paddingM),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  /// Show confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = AppStrings.confirm,
    String cancelText = AppStrings.cancel,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show alert dialog
  Future<void> showAlertDialog({
    required String title,
    required String message,
    String buttonText = AppStrings.ok,
  }) {
    return showDialog<void>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show bottom sheet
  Future<T?> showCustomBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
    );
  }

  /// Get localization
  // Localizations get localizations => Localizations.of(this);

  /// Focus/unfocus
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Check if specific focus node has focus
  bool hasFocus(FocusNode focusNode) {
    return FocusScope.of(this).focusedChild == focusNode;
  }

  /// Get primary focus
  FocusNode? get primaryFocus => FocusScope.of(this).focusedChild;

  /// Responsive breakpoints - optimized for high-resolution phones
  bool get isSmallScreen => screenWidth < 400;
  bool get isHighResPhone => screenWidth >= 400 && screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  /// Check if device is a high-resolution phone (like Pixel 6 Pro, iPhone Pro models)
  bool get isHighResolutionPhone => (screenWidth >= 400 && screenWidth < 600) || devicePixelRatio >= 3.0;

  /// Get responsive padding
  EdgeInsets get responsivePadding {
    if (isSmallScreen) {
      return const EdgeInsets.all(5);
    } else if (isMediumScreen) {
      return const EdgeInsets.all(8);
    }
      else if (isHighResolutionPhone){
        return const EdgeInsets.all(8);
    } else {
      return const EdgeInsets.all(10);
    }
  }

  /// Get responsive margin
  EdgeInsets get responsiveMargin {
    if (isSmallScreen) {
      return const EdgeInsets.all(1);
    } else if (isMediumScreen) {
      return const EdgeInsets.all(2);
    }
    else if (isHighResolutionPhone) {
      return const EdgeInsets.all(3);
    }
    else{
      return const EdgeInsets.all(4);
    }
  }

  /// Get app bar height
  double get appBarHeight => AppBar().preferredSize.height;

  /// Get total app bar height (including status bar)
  double get totalAppBarHeight => appBarHeight + statusBarHeight;

  /// Get available screen height (excluding app bar and status bar)
  double get availableScreenHeight => screenHeight - totalAppBarHeight;

  /// Get safe area height
  double get safeAreaHeight => screenHeight - statusBarHeight - bottomSafeArea;

  /// Responsive text size getters - these should be replaced with ResponsiveTextService
  @deprecated
  double get responsiveTextSize => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textM);

  @deprecated
  double get responsiveTextXS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textXS);

  @deprecated
  double get responsiveTextS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textS);

  @deprecated
  double get responsiveTextM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textM);

  @deprecated
  double get responsiveTextL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textL);

  @deprecated
  double get responsiveTextXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textXL);

  @deprecated
  double get responsiveTextXXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.textXXL);

  /// Responsive space getters
  double get responsiveSpaceXS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceXS);

  double get responsiveSpaceS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceS);

  double get responsiveSpaceM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceM);

  double get responsiveSpaceL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceL);

  double get responsiveSpaceXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceXL);

  /// Responsive icon size getters - automatically scale based on screen size
  double get responsiveIconXS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconXS);

  double get responsiveIconS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconS);

  double get responsiveIconM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconM);

  double get responsiveIconL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconL);

  double get responsiveIconXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconXL);

  double get responsiveIconXXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.iconXXL);

  /// Responsive padding getters - conditional based on screen size
  EdgeInsets get responsivePaddingXS => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingXS));

  EdgeInsets get responsivePaddingS => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingS));

  EdgeInsets get responsivePaddingM => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingM));

  EdgeInsets get responsivePaddingL => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingL));

  EdgeInsets get responsivePaddingXL => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingXL));

  EdgeInsets get responsivePaddingXXL => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingXXL));

  /// Responsive margin getters - conditional based on screen size
  EdgeInsets get responsiveMarginXS => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceXS));

  EdgeInsets get responsiveMarginS => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceS));

  EdgeInsets get responsiveMarginM => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceM));

  EdgeInsets get responsiveMarginL => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceL));

  EdgeInsets get responsiveMarginXL => EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.spaceXL));

  /// Responsive border radius getters
  double get responsiveRadiusXS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusXS);

  double get responsiveRadiusS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusS);

  double get responsiveRadiusM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusM);

  double get responsiveRadiusL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusL);

  double get responsiveRadiusXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusXL);

  double get responsiveRadiusXXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.radiusXXL);

  /// Responsive avatar size getters
  double get responsiveAvatarS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.avatarS);

  double get responsiveAvatarM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.avatarM);

  double get responsiveAvatarL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.avatarL);

  double get responsiveAvatarXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.avatarXL);

  double get responsiveAvatarProfile => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.avatarProfile);

  /// Responsive image size getters
  double get responsiveImageXS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageXS);

  double get responsiveImageS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageS);

  double get responsiveImageM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageM);

  double get responsiveImageL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageL);

  double get responsiveImageXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageXL);

  double get responsiveImageXXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.imageXXL);

  /// Responsive button height getters
  double get responsiveButtonHeightS => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.buttonHeightS);

  double get responsiveButtonHeightM => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.buttonHeightM);

  double get responsiveButtonHeightL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.buttonHeightL);

  double get responsiveButtonHeightXL => ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.buttonHeightXL);

  /// Conditional responsive methods - return different values based on screen size
  double getConditionalIconSize({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.iconS);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.iconS);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.iconS);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.iconM);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.iconM);
    }
  }

  double getConditionalMainIcon({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.iconM);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.iconL);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.iconXL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.iconXXL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.iconXXL);
    }
  }

  double getConditionalButtonSize({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.buttonHeightM);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.buttonHeightL);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.buttonHeightL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.buttonHeightXL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.buttonHeightXXL);
    }
  }

  double getConditionalButtonfont({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.textM);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textL);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.textXL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.textXXL);
    }
  }

  double getConditionalLogoSize({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.logoM);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.logoM);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.logoM);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.logoL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.logoL);
    }
  }

  /// Conditional responsive padding
  EdgeInsets getConditionalPadding({
    EdgeInsets? small,
    EdgeInsets? medium,
    EdgeInsets? large,
    EdgeInsets? extraLarge,
  }) {
    if (isSmallScreen) {
      return small ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingXS));
    } else if (isMediumScreen) {
      return medium ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingS));
    } else if(isHighResolutionPhone){
      return large ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingM));
    }
    else if (isLargeScreen) {
      return large ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingL));
    } else {
      return extraLarge ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.paddingXL));
    }
  }

  /// Conditional responsive margin
  EdgeInsets getConditionalMargin({
    EdgeInsets? small,
    EdgeInsets? medium,
    EdgeInsets? large,
    EdgeInsets? extraLarge,
  }) {
    if (isSmallScreen) {
      return small ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.marginXS));
    } else if (isMediumScreen) {
      return medium ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.marginS));
    } else if (isHighResolutionPhone) {
  return medium ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.marginM));
  }
    else if (isLargeScreen) {
      return large ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.marginL));
    } else {
      return extraLarge ?? EdgeInsets.all(ResponsiveTextService.instance.getResponsiveFontSize(this, AppDimensions.marginXL));
    }
  }

  /// Conditional responsive spacing
  double getConditionalSpacing({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.spaceS);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.spaceM);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.spaceL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.spaceL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.spaceXL);
    }
  }

  double getConditionalFont({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.size10);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.size12);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.size12);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.size14);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.size18);
    }
  }


  double getConditionalMainFont({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.textM);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textL);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.textXL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.textXXL);
    }
  }

  double getConditionalSubFont({
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    if (isSmallScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, small ?? AppDimensions.textS);
    } else if (isMediumScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textM);
    } else if (isHighResolutionPhone) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, medium ?? AppDimensions.textL);
    }
    else if (isLargeScreen) {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, large ?? AppDimensions.textXL);
    } else {
      return ResponsiveTextService.instance.getResponsiveFontSize(this, extraLarge ?? AppDimensions.textXXL);
    }
  }
}