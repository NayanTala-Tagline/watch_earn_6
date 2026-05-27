import 'package:flutter/material.dart';

/// Theme colors extracted from Figma design
/// Daily Cash - Watch & Earn App
class ThemeColors extends ThemeExtension<ThemeColors> {
  // Background Colors
  final Color backgroundColor;
  final Color surfaceColor;
  final Color secondaryButtonColor;

  // Primary Gradients (Angular gradient for cards)
  final Color primaryGradient1;
  final Color primaryGradient2;

  // Secondary Gradients (Main accent gradient)
  final Color secondaryGradient1;
  final Color secondaryGradient2;
  final Color secondaryGradient3;
  final Color secondaryGradient4;
  final Color secondaryGradient5;

  // Primary Color
  final Color primary;

  const ThemeColors({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.secondaryButtonColor,
    required this.primaryGradient1,
    required this.primaryGradient2,
    required this.secondaryGradient1,
    required this.secondaryGradient2,
    required this.secondaryGradient3,
    required this.secondaryGradient4,
    required this.secondaryGradient5,
    required this.primary,
  });

  @override
  ThemeColors copyWith({
    Color? backgroundColor,
    Color? surfaceColor,
    Color? secondaryButtonColor,
    Color? primaryGradient1,
    Color? primaryGradient2,
    Color? secondaryGradient1,
    Color? secondaryGradient2,
    Color? secondaryGradient3,
    Color? secondaryGradient4,
    Color? secondaryGradient5,
    Color? primary,
  }) {
    return ThemeColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      secondaryButtonColor: secondaryButtonColor ?? this.secondaryButtonColor,
      primaryGradient1: primaryGradient1 ?? this.primaryGradient1,
      primaryGradient2: primaryGradient2 ?? this.primaryGradient2,
      secondaryGradient1: secondaryGradient1 ?? this.secondaryGradient1,
      secondaryGradient2: secondaryGradient2 ?? this.secondaryGradient2,
      secondaryGradient3: secondaryGradient3 ?? this.secondaryGradient3,
      secondaryGradient4: secondaryGradient4 ?? this.secondaryGradient4,
      secondaryGradient5: secondaryGradient5 ?? this.secondaryGradient5,
      primary: primary ?? this.primary,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    covariant ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) return this;
    return ThemeColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      secondaryButtonColor: Color.lerp(secondaryButtonColor, other.secondaryButtonColor, t)!,
      primaryGradient1: Color.lerp(
        primaryGradient1,
        other.primaryGradient1,
        t,
      )!,
      primaryGradient2: Color.lerp(
        primaryGradient2,
        other.primaryGradient2,
        t,
      )!,
      secondaryGradient1: Color.lerp(
        secondaryGradient1,
        other.secondaryGradient1,
        t,
      )!,
      secondaryGradient2: Color.lerp(
        secondaryGradient2,
        other.secondaryGradient2,
        t,
      )!,
      secondaryGradient3: Color.lerp(
        secondaryGradient3,
        other.secondaryGradient3,
        t,
      )!,
      secondaryGradient4: Color.lerp(
        secondaryGradient4,
        other.secondaryGradient4,
        t,
      )!,
      secondaryGradient5: Color.lerp(
        secondaryGradient5,
        other.secondaryGradient5,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
    );
  }

  /// Primary gradient for buttons and active elements
  /// Colors: #9467FF -> #424EFE -> #3345FF -> #45C1FD
  LinearGradient get primaryGradient => LinearGradient(
    colors: [
      secondaryGradient1,
      secondaryGradient2,
      secondaryGradient3,
      secondaryGradient4,
      secondaryGradient5,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Card background gradient (Angular)
  /// Colors: #120F2C -> #122077
  LinearGradient get cardGradient => LinearGradient(
    colors: [primaryGradient1, primaryGradient2],
    begin: Alignment.bottomLeft,
    end: Alignment.bottomRight,
  );

}
