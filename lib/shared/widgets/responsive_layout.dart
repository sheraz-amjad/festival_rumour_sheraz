import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';
import '../../core/constants/app_sizes.dart';

/// Responsive layout system for consistent design across all screen sizes
class ResponsiveLayout {
  /// Get responsive spacing based on screen size
  static double getSpacing(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive spacing
      if (context.isHighResolutionPhone) return AppDimensions.spaceL;
      if (context.isLargeScreen) return AppDimensions.spaceXL;
      if (context.isMediumScreen) return AppDimensions.spaceM;
      return AppDimensions.spaceS;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getPadding(BuildContext context, {
    EdgeInsets? small,
    EdgeInsets? medium,
    EdgeInsets? large,
    EdgeInsets? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive padding
      if (context.isHighResolutionPhone) return const EdgeInsets.all(AppDimensions.paddingL);
      if (context.isLargeScreen) return const EdgeInsets.all(AppDimensions.paddingXL);
      if (context.isMediumScreen) return const EdgeInsets.all(AppDimensions.paddingM);
      return const EdgeInsets.all(AppDimensions.paddingS);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getMargin(BuildContext context, {
    EdgeInsets? small,
    EdgeInsets? medium,
    EdgeInsets? large,
    EdgeInsets? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive margin
      if (context.isHighResolutionPhone) return const EdgeInsets.all(AppDimensions.spaceM);
      if (context.isLargeScreen) return const EdgeInsets.all(AppDimensions.spaceL);
      if (context.isMediumScreen) return const EdgeInsets.all(AppDimensions.spaceS);
      return const EdgeInsets.all(AppDimensions.spaceXS);
    }
  }

  /// Get responsive border radius based on screen size
  static double getBorderRadius(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive border radius
      if (context.isHighResolutionPhone) return AppDimensions.radiusL;
      if (context.isLargeScreen) return AppDimensions.radiusXL;
      if (context.isMediumScreen) return AppDimensions.radiusM;
      return AppDimensions.radiusS;
    }
  }

  /// Get responsive icon size based on screen size
  static double getIconSize(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive icon sizes
      if (context.isHighResolutionPhone) return AppDimensions.iconL;
      if (context.isLargeScreen) return AppDimensions.iconXL;
      if (context.isMediumScreen) return AppDimensions.iconM;
      return AppDimensions.iconS;
    }
  }

  /// Get responsive font size based on screen size
  static double getFontSize(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive font sizes
      if (context.isHighResolutionPhone) return AppDimensions.textM;
      if (context.isLargeScreen) return AppDimensions.textL;
      if (context.isMediumScreen) return AppDimensions.textS;
      return AppDimensions.textXS;
    }
  }

  /// Get responsive elevation based on screen size
  static double getElevation(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive elevations
      if (context.isHighResolutionPhone) return AppDimensions.elevationM;
      if (context.isLargeScreen) return AppDimensions.elevationL;
      if (context.isMediumScreen) return AppDimensions.elevationS;
      return AppDimensions.elevationXS;
    }
  }

  /// Get responsive width based on screen size
  static double getWidth(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive widths
      if (context.isHighResolutionPhone) return context.screenWidth * 0.9;
      if (context.isLargeScreen) return context.screenWidth * 0.8;
      if (context.isMediumScreen) return context.screenWidth * 0.85;
      return context.screenWidth * 0.95;
    }
  }

  /// Get responsive height based on screen size
  static double getHeight(BuildContext context, {
    double? small,
    double? medium,
    double? large,
    double? highRes,
  }) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes;
    } else if (context.isLargeScreen && large != null) {
      return large;
    } else if (context.isMediumScreen && medium != null) {
      return medium;
    } else if (small != null) {
      return small;
    } else {
      // Default responsive heights
      if (context.isHighResolutionPhone) return context.screenHeight * 0.1;
      if (context.isLargeScreen) return context.screenHeight * 0.12;
      if (context.isMediumScreen) return context.screenHeight * 0.11;
      return context.screenHeight * 0.09;
    }
  }
}

/// Responsive breakpoint widget that shows different content based on screen size
class ResponsiveBreakpoint extends StatelessWidget {
  final Widget? small;
  final Widget? medium;
  final Widget? large;
  final Widget? highRes;
  final Widget fallback;

  const ResponsiveBreakpoint({
    Key? key,
    this.small,
    this.medium,
    this.large,
    this.highRes,
    required this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isHighResolutionPhone && highRes != null) {
      return highRes!;
    } else if (context.isLargeScreen && large != null) {
      return large!;
    } else if (context.isMediumScreen && medium != null) {
      return medium!;
    } else if (small != null) {
      return small!;
    } else {
      return fallback;
    }
  }
}

/// Responsive column that adapts cross axis count based on screen size
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? smallColumns;
  final int? mediumColumns;
  final int? largeColumns;
  final int? highResColumns;

  const ResponsiveColumn({
    Key? key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.smallColumns,
    this.mediumColumns,
    this.largeColumns,
    this.highResColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int columns = _getColumns(context);
    
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        return SizedBox(
          width: (context.screenWidth - (spacing * (columns - 1))) / columns,
          child: child,
        );
      }).toList(),
    );
  }

  int _getColumns(BuildContext context) {
    if (context.isHighResolutionPhone && highResColumns != null) {
      return highResColumns!;
    } else if (context.isLargeScreen && largeColumns != null) {
      return largeColumns!;
    } else if (context.isMediumScreen && mediumColumns != null) {
      return mediumColumns!;
    } else if (smallColumns != null) {
      return smallColumns!;
    } else {
      // Default responsive columns
      if (context.isHighResolutionPhone) return 2;
      if (context.isLargeScreen) return 4;
      if (context.isMediumScreen) return 3;
      return 1;
    }
  }
}

/// Responsive aspect ratio that adapts based on screen size
class ResponsiveAspectRatio extends StatelessWidget {
  final Widget child;
  final double? smallRatio;
  final double? mediumRatio;
  final double? largeRatio;
  final double? highResRatio;

  const ResponsiveAspectRatio({
    Key? key,
    required this.child,
    this.smallRatio,
    this.mediumRatio,
    this.largeRatio,
    this.highResRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratio = _getRatio(context);
    return AspectRatio(
      aspectRatio: ratio,
      child: child,
    );
  }

  double _getRatio(BuildContext context) {
    if (context.isHighResolutionPhone && highResRatio != null) {
      return highResRatio!;
    } else if (context.isLargeScreen && largeRatio != null) {
      return largeRatio!;
    } else if (context.isMediumScreen && mediumRatio != null) {
      return mediumRatio!;
    } else if (smallRatio != null) {
      return smallRatio!;
    } else {
      // Default responsive aspect ratios
      if (context.isHighResolutionPhone) return 16 / 9;
      if (context.isLargeScreen) return 21 / 9;
      if (context.isMediumScreen) return 18 / 9;
      return 4 / 3;
    }
  }
}
