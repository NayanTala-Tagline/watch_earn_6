import 'package:daily_cash/gen/fonts.gen.dart';
import 'package:daily_cash/res/theme_colors.dart';
import 'package:daily_cash/res/theme_text_colors.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

final _darkThemeData = ThemeData.dark(useMaterial3: true);

/// Theme colors from Figma design
const _themeColors = ThemeColors(
  // Background: #080A1B
  backgroundColor: Color(0xFFF6F6FF),
  surfaceColor: Color(0xFFFFFFFF),

  // Primary Gradients (Card backgrounds): #120F2C -> #122077
  primaryGradient1: Color(0xFF8868FF),
  primaryGradient2: Color(0xFF6C3BF6),

  // Secondary Gradients (Main highlight): #9467FF -> #424EFE -> #3345FF -> #45C1FD
  secondaryGradient1: Color(0xFFB5C4FF),
  secondaryGradient2: Color(0xFFFFE3E3),
  secondaryGradient3: Color(0xFFC5FFED),
  secondaryGradient4: Color(0xFFFFF5CD),
  secondaryGradient5: Color(0xFFFFE8DB),

  secondaryButtonColor: Color(0xFFE7E8EB),

  primary: Color(0xFF8868FF),
);

final _themeTextColors = ThemeTextColors(
  textColor: Colors.black,
  secondaryTextColor: Color(0xFFFFFFFF),
  descriptionColor: Color(0xFF5B5B5B),
  blueTextColor: Color(0xFF190061),
  greenTextColor: Color(0xFF02CC7A),
);

final TextTheme _textTheme = _darkThemeData.textTheme.copyWith(
  // Display styles
  displayLarge: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp34,
    height: 1.17,
  ),

  // Title styles
  titleLarge: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp20,
    height: 1.17,
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp16,
    height: 1.17,
  ),
  titleSmall: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.descriptionColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp14,
    height: 1.17,
  ),

  // Body styles
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp15,
    letterSpacing: 1.0,
    height: 1.17,
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp14,
    height: 1.17,
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.descriptionColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp13,
    height: 1.17,
  ),

  // Label styles
  labelLarge: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.textColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp14,
    height: 1.17,
  ),
  labelMedium: TextStyle(
    fontWeight: FontWeight.w700,
    color: _themeTextColors.descriptionColor,
    fontFamily: FontFamily.sora,
    fontSize: AppDimens.sp12,
    height: 1.17,
  ),
);

/// Application Dark Theme (from Figma design)
final ThemeData darkTheme = _darkThemeData.copyWith(
  colorScheme: ColorScheme.dark(
    primary: _themeColors.backgroundColor,
    surface: _themeColors.backgroundColor,
    secondary: _themeColors.secondaryGradient2,
  ),
  scaffoldBackgroundColor: _themeColors.backgroundColor,
  textTheme: _textTheme,
  extensions: <ThemeExtension<dynamic>>[_themeColors, _themeTextColors],
  appBarTheme: AppBarTheme(
    backgroundColor: _themeColors.backgroundColor,
    centerTitle: true,
    scrolledUnderElevation: 0,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.sora,
      color: _themeTextColors.textColor,
      fontSize: AppDimens.sp16,
    ),
  ),
);
