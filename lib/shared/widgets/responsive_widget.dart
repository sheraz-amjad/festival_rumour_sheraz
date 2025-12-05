import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';
import '../../core/constants/app_sizes.dart';

/// Responsive widget that adapts its layout based on screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isLargeScreen && desktop != null) {
      return desktop!;
    } else if (context.isMediumScreen && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Responsive builder that provides different widgets based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

/// Responsive grid that adapts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
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
    if (context.isLargeScreen && desktopColumns != null) {
      return desktopColumns!;
    } else if (context.isMediumScreen && tabletColumns != null) {
      return tabletColumns!;
    } else if (mobileColumns != null) {
      return mobileColumns!;
    } else {
      // Default responsive columns
      if (context.isLargeScreen) return 4;
      if (context.isMediumScreen) return 3;
      return 2;
    }
  }
}

/// Responsive padding that adapts based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    Key? key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = _getPadding(context);
    return Padding(
      padding: padding,
      child: child,
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (context.isHighResolutionPhone && mobilePadding != null) {
      return mobilePadding!;
    } else if (context.isLargeScreen && desktopPadding != null) {
      return desktopPadding!;
    } else if (context.isMediumScreen && tabletPadding != null) {
      return tabletPadding!;
    } else if (mobilePadding != null) {
      return mobilePadding!;
    } else {
      // Default responsive padding - optimized for high-res phones
      if (context.isHighResolutionPhone) {
        return const EdgeInsets.all(AppDimensions.paddingL); // 24px for high-res phones
      } else if (context.isLargeScreen) {
        return const EdgeInsets.all(AppDimensions.paddingXL); // 32px for desktop
      } else if (context.isMediumScreen) {
        return const EdgeInsets.all(AppDimensions.paddingL); // 24px for tablets
      } else {
        return const EdgeInsets.all(AppDimensions.paddingM); // 16px for small phones
      }
    }
  }
}

/// Responsive text that adapts font size based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scaleFactor = _getScaleFactor(context);
    
    TextStyle? responsiveStyle = style?.copyWith(
      fontSize: (style?.fontSize ?? 14) * scaleFactor,
    );

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  double _getScaleFactor(BuildContext context) {
    if (context.isHighResolutionPhone) return 1.15; // Slightly larger for high-res phones
    if (context.isLargeScreen) return 1.3; // Larger for desktop
    if (context.isMediumScreen) return 1.2; // Medium for tablets
    return 1.0; // Base for small phones
  }
}

/// Responsive container that adapts its constraints based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;
  final EdgeInsets? padding;
  final Color? color;
  final Decoration? decoration;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth,
    this.desktopMaxWidth,
    this.padding,
    this.color,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = _getMaxWidth(context);
    
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: padding,
      color: color,
      decoration: decoration,
      child: child,
    );
  }

  double _getMaxWidth(BuildContext context) {
    if (context.isLargeScreen && desktopMaxWidth != null) {
      return desktopMaxWidth!;
    } else if (context.isMediumScreen && tabletMaxWidth != null) {
      return tabletMaxWidth!;
    } else if (mobileMaxWidth != null) {
      return mobileMaxWidth!;
    } else {
      // Default responsive max widths - optimized for high-res phones
      if (context.isLargeScreen) return 1200;
      if (context.isMediumScreen) return 800;
      if (context.isHighResolutionPhone) return 600; // Better for high-res phones
      return double.infinity;
    }
  }
}

/// Responsive button that adapts size and padding based on screen size
class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  const ResponsiveButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(context),
      padding: _getPadding(context),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: foregroundColor,
                fontSize: _getFontSize(context),
                fontWeight: FontWeight.w600,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  double _getHeight(BuildContext context) {
    if (context.isHighResolutionPhone && mobileHeight != null) {
      return mobileHeight!;
    } else if (context.isLargeScreen && desktopHeight != null) {
      return desktopHeight!;
    } else if (context.isMediumScreen && tabletHeight != null) {
      return tabletHeight!;
    } else {
      // Default responsive heights
      if (context.isHighResolutionPhone) return 56;
      if (context.isLargeScreen) return 64;
      if (context.isMediumScreen) return 52;
      return 48;
    }
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (context.isHighResolutionPhone && mobilePadding != null) {
      return mobilePadding!;
    } else if (context.isLargeScreen && desktopPadding != null) {
      return desktopPadding!;
    } else if (context.isMediumScreen && tabletPadding != null) {
      return tabletPadding!;
    } else {
      // Default responsive padding
      if (context.isHighResolutionPhone) return EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingM);
      if (context.isLargeScreen) return EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL, vertical: AppDimensions.paddingL);
      if (context.isMediumScreen) return EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingM);
      return EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.spaceM);
    }
  }

  double _getFontSize(BuildContext context) {
    if (context.isHighResolutionPhone) return AppDimensions.textL;
    if (context.isLargeScreen) return AppDimensions.textXL;
    if (context.isMediumScreen) return AppDimensions.textL;
    return AppDimensions.textM;
  }
}

/// Responsive card that adapts padding and elevation based on screen size
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final double? mobileElevation;
  final double? tabletElevation;
  final double? desktopElevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.mobileElevation,
    this.tabletElevation,
    this.desktopElevation,
    this.color,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _getElevation(context),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(_getBorderRadius(context)),
        side: border is Border ? (border as Border).top : BorderSide.none,
      ),
      child: Padding(
        padding: _getPadding(context),
        child: child,
      ),
    );
  }

  double _getElevation(BuildContext context) {
    if (context.isHighResolutionPhone && mobileElevation != null) {
      return mobileElevation!;
    } else if (context.isLargeScreen && desktopElevation != null) {
      return desktopElevation!;
    } else if (context.isMediumScreen && tabletElevation != null) {
      return tabletElevation!;
    } else {
      // Default responsive elevations
      if (context.isHighResolutionPhone) return 4;
      if (context.isLargeScreen) return 6;
      if (context.isMediumScreen) return 3;
      return 2;
    }
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (context.isHighResolutionPhone && mobilePadding != null) {
      return mobilePadding!;
    } else if (context.isLargeScreen && desktopPadding != null) {
      return desktopPadding!;
    } else if (context.isMediumScreen && tabletPadding != null) {
      return tabletPadding!;
    } else {
      // Default responsive padding
      if (context.isHighResolutionPhone) return EdgeInsets.all(AppDimensions.paddingL);
      if (context.isLargeScreen) return EdgeInsets.all(AppDimensions.paddingXL);
      if (context.isMediumScreen) return EdgeInsets.all(AppDimensions.paddingL);
      return EdgeInsets.all(AppDimensions.paddingM);
    }
  }

  double _getBorderRadius(BuildContext context) {
    if (context.isHighResolutionPhone) return AppDimensions.radiusM;
    if (context.isLargeScreen) return AppDimensions.radiusL;
    if (context.isMediumScreen) return AppDimensions.radiusM;
    return AppDimensions.radiusS;
  }
}
