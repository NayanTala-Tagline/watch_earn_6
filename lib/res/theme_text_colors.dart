import 'package:flutter/material.dart';

/// Text colors from Figma design
class ThemeTextColors extends ThemeExtension<ThemeTextColors> {
  final Color textColor;
  final Color secondaryTextColor;
  final Color descriptionColor;
  final Color greenTextColor;
  final Color blueTextColor;

  const ThemeTextColors({
    required this.textColor,
    required this.secondaryTextColor,
    required this.descriptionColor,
    required this.greenTextColor,
    required this.blueTextColor,
  });

  @override
  ThemeExtension<ThemeTextColors> copyWith({
    Color? textColor,
    Color? secondaryTextColor,
    Color? descriptionColor,
    Color? yellowTextColor,
    Color? accentTextColor,
    Color? blueTextColor,
  }) {
    return ThemeTextColors(
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      greenTextColor: yellowTextColor ?? this.greenTextColor,
      blueTextColor: blueTextColor ?? this.blueTextColor,
    );
  }

  @override
  ThemeExtension<ThemeTextColors> lerp(
    covariant ThemeExtension<ThemeTextColors>? other,
    double t,
  ) {
    if (other is! ThemeTextColors) {
      return this;
    }
    return ThemeTextColors(
      textColor: Color.lerp(textColor, other.textColor, t)!,
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      descriptionColor: Color.lerp(
        descriptionColor,
        other.descriptionColor,
        t,
      )!,
      greenTextColor: Color.lerp(greenTextColor, other.greenTextColor, t)!,
      blueTextColor: Color.lerp(blueTextColor, other.blueTextColor, t)!,
    );
  }
}
